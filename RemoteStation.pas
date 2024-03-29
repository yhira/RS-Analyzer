unit RemoteStation;

interface

uses
  Windows, SysUtils, dbg;

const
	DEV_PCOPRS1_RET_OK = 0;
	DEV_PCOPRS1_RET_ERR = 1;
	DEV_PCOPRS1_RET_NOT_OPENED = 2;
	DEV_PCOPRS1_RET_OUT_OF_RANGE = 3;
	DEV_PCOPRS1_RET_TIMEOUT = 4;
	DEV_PCOPRS1_RET_UNKNOWN = 5;

  MODULE_MAJOR_VERSION = 1;
  MODULE_MINOR_VERSION = 2;

  REMOCON_CODE_COUNT = 240;

type
  TRemoconCode = array[0..REMOCON_CODE_COUNT-1] of Char;

  TPCOPRS1 = class
  private
    bOpened: Boolean;
    hComm: THandle;
    FComPort: Integer;
    FReceiving: Boolean;
    function WaitForReplyFromDevice(ExpectedCode: Char;
      CodeGotten: PChar): Integer;
    function SendCommand(cmd: Char): Integer;
    function DataReceiveFromDevice(Buf: PChar; Len: Cardinal): Integer;
    function DataTransmitToDevice(Buf: PChar; Len: Cardinal): Integer;
    function GetConnecting: Boolean;
    procedure ErrorPrevention;
  public
    constructor Create;
    destructor Destroy; override;
    function Open(PortNo: Integer): Integer;
    function Close: Integer;
    function LedFlash: Integer;
    function SetTimeOut(TimeoutTime: Cardinal): Integer;
    function Receive(RemoconCode: PChar): Integer;
    function ModeCancel: Integer;
    function Transmit(Ch: Integer; RemoconCode: PChar): Integer;
//    function GetModuleVersion(var MajorVer: Cardinal; var
//      MinerVer: Cardinal): Integer;
    property Connecting: Boolean read GetConnecting;
    property Receiving: Boolean read FReceiving;
  end;

implementation

{ TPCOPRS1 }

constructor TPCOPRS1.Create;
begin
  bOpened := False;
  FComPort := 0;
  FReceiving := False;
end;

destructor TPCOPRS1.Destroy;
begin
  if bOpened then Close;
  inherited;
end;

function TPCOPRS1.Open(PortNo: Integer): Integer;
var dcb: TDCB; res: LongBool; Errors: DWORD;
  comport_name: string;
begin
  Result := DEV_PCOPRS1_RET_OK;

  if not bOpened then begin
    // Open specified COM port
    comport_name := Format('\\.\COM%d', [PortNo]);
    hComm := CreateFileA(PChar(comport_name),
      GENERIC_READ or GENERIC_WRITE,
			0,
			nil,
			OPEN_EXISTING,
			FILE_ATTRIBUTE_NORMAL,
			0);
    if hComm = INVALID_HANDLE_VALUE then begin
      Result := DEV_PCOPRS1_RET_ERR;
    end else begin
      // Configure the conditions of COM port
      GetCommState(hComm, dcb);
      with dcb do begin
        BaudRate := 115200;
        ByteSize := 8;
        Parity := NOPARITY;
        Flags := Flags or (1 shl 1);
        StopBits := ONESTOPBIT;
        DOut(IntToHex(Flags, 8));
      end;
      res := SetCommState(hComm, dcb);

      FComPort := PortNo;
      bOpened := True;

      if res then begin
        ClearCommError(hComm, Errors, nil);
      end else begin
        Result := DEV_PCOPRS1_RET_ERR;
      end;
    end;
  end else begin
    // Device is already opened so that the retvalue is ERROR.
    Result := DEV_PCOPRS1_RET_ERR;
  end;
end;

function TPCOPRS1.Close: Integer;
var res: LongBool;
begin
  Result := DEV_PCOPRS1_RET_OK;

  if bOpened then begin
    res := CloseHandle(hComm);
    if res then begin
      bOpened := False;
    end else begin
      Result :=DEV_PCOPRS1_RET_ERR;
    end;
  end else begin
    Result := DEV_PCOPRS1_RET_NOT_OPENED
  end;
end;

function TPCOPRS1.LedFlash: Integer;
var res: Integer; receivecode: Char;
begin
  Result := DEV_PCOPRS1_RET_OK;

  if bOpened then begin
    SendCommand('i');
    res := WaitForReplyFromDevice('O', @receivecode);

    if res <> DEV_PCOPRS1_RET_OK then begin
      if receivecode = 'Y' then begin
				// If the device internal state was initialized with this
				// command, then the LED is not flash.
				// But the request for this method is to flash LED,
				// so call LedFlash recursively for Flash LED instead.

        LedFlash;
      end else begin
        Result := DEV_PCOPRS1_RET_ERR;
      end;
    end;
  end else begin
    Result := DEV_PCOPRS1_RET_ERR;
  end;
end;

function TPCOPRS1.SetTimeOut(TimeoutTime: Cardinal): Integer;
var tmo: TCommTimeouts;
begin
  Result := DEV_PCOPRS1_RET_OK;

  GetCommTimeouts(hComm, tmo);
  with tmo do begin
    ReadTotalTimeoutConstant := TimeoutTime;
    WriteTotalTimeoutConstant := TimeoutTime;
  end;
  SetCommTimeouts(hComm, tmo);
end;

function TPCOPRS1.Receive(RemoconCode: PChar): Integer;
var res: Integer; 
begin
  Result := DEV_PCOPRS1_RET_OK;

  if bOpened then begin
    ErrorPrevention;
    FReceiving := True;
//    LedFlash;

    SendCommand('r'); //receive mode
    res := WaitForReplyFromDevice('Y', nil);
    if res = DEV_PCOPRS1_RET_OK then begin
      res := WaitForReplyFromDevice('S', nil);
      if res = DEV_PCOPRS1_RET_OK then begin
        Sleep(500); //あまり早く読み込ませすぎると失敗するっぽい
        res := DataReceiveFromDevice(RemoconCode, REMOCON_CODE_COUNT);
        if res = DEV_PCOPRS1_RET_OK then begin
          res := WaitForReplyFromDevice('E', nil);
          if res <> DEV_PCOPRS1_RET_OK then begin
            Result := DEV_PCOPRS1_RET_ERR;
          end;
        end else if res = DEV_PCOPRS1_RET_TIMEOUT then begin
          Result := DEV_PCOPRS1_RET_TIMEOUT;
          ModeCancel;
        end else begin
          Result := DEV_PCOPRS1_RET_ERR;
          ModeCancel;
        end;
      end else begin
        Result := DEV_PCOPRS1_RET_ERR;
        ModeCancel;
      end;
    end;
  end else begin
    Result := DEV_PCOPRS1_RET_NOT_OPENED;
  end;
  FReceiving := False;
end;

function TPCOPRS1.Transmit(Ch: Integer; RemoconCode: PChar): Integer;
var res: Integer; code: TRemoconCode;
begin
  Result := DEV_PCOPRS1_RET_OK;
  CopyMemory(@code[0], RemoconCode, REMOCON_CODE_COUNT);

  if bOpened then begin 
    ErrorPrevention;;
    
    if not (Ch >= 0) and (ch <= 3) then begin
      Result := DEV_PCOPRS1_RET_ERR;
    end else begin
      SendCommand('t');  //transmit mode
      res := WaitForReplyFromDevice('Y', nil);
      if res = DEV_PCOPRS1_RET_OK then begin
        SendCommand(Char(IntToStr(1 + Ch)[1]));
        res := WaitForReplyFromDevice('Y', nil);
        if res = DEV_PCOPRS1_RET_OK then begin
          DataTransmitToDevice(code ,REMOCON_CODE_COUNT);
          res := WaitForReplyFromDevice('E', nil);
          if res <> DEV_PCOPRS1_RET_OK then begin
            Result := DEV_PCOPRS1_RET_ERR;
          end;
        end else if res = DEV_PCOPRS1_RET_TIMEOUT then begin
          Result := DEV_PCOPRS1_RET_TIMEOUT;
          ModeCancel;
        end else begin
          Result := DEV_PCOPRS1_RET_ERR;
          ModeCancel;
        end;
      end else begin
        Result := DEV_PCOPRS1_RET_ERR;
        ModeCancel;
      end;
    end;
  end else begin
    Result := DEV_PCOPRS1_RET_NOT_OPENED;
  end;
end;

//function TPCOPRS1.GetModuleVersion(var MajorVer,
//  MinerVer: Cardinal): Integer;
//begin
//  Result := DEV_PCOPRS1_RET_OK;
//
//	MajorVer := MODULE_MAJOR_VERSION;
//	MinerVer := MODULE_MINOR_VERSION;
//end;

function TPCOPRS1.SendCommand(cmd: Char): Integer;
var writtensize: DWORD;
begin
  Result := DEV_PCOPRS1_RET_OK;

  if bOpened then begin
    WriteFile(hComm, cmd, 1, writtensize, nil);
  end else begin
    Result := DEV_PCOPRS1_RET_NOT_OPENED;
  end;
end;

function TPCOPRS1.WaitForReplyFromDevice(ExpectedCode: Char;
  CodeGotten: PChar): Integer;
var ReadSize: DWORD; buf: array[0..0] of Char;
begin
  Result := DEV_PCOPRS1_RET_OK;

  if bOpened then begin
    buf[0] := ExpectedCode;
    ReadFile(hComm, buf, 1, ReadSize, nil);

    if buf[0] <> ExpectedCode then begin
      Result := DEV_PCOPRS1_RET_ERR;
    end;

    if CodeGotten <> nil then begin
      CodeGotten^ := buf[0];
    end;
    
  end else begin
    Result := DEV_PCOPRS1_RET_NOT_OPENED;
  end;
end;

function TPCOPRS1.DataReceiveFromDevice(Buf: PChar;
  Len: Cardinal): Integer;
var ReadSize: DWORD; b: TRemoconCode;
begin
  Result := DEV_PCOPRS1_RET_OK;

  if bOpened then begin
    ReadFile(hComm, b, Len, ReadSize, nil);
    CopyMemory(@Buf[0], @b[0], REMOCON_CODE_COUNT);
    if ReadSize <> Len then begin
      Result := DEV_PCOPRS1_RET_TIMEOUT;
    end;

  end else begin
    Result := DEV_PCOPRS1_RET_NOT_OPENED;
  end;
end;

function TPCOPRS1.DataTransmitToDevice(Buf: PChar;
  Len: Cardinal): Integer;
var writtensize: DWORD;
begin
  Result := DEV_PCOPRS1_RET_OK;

  if bOpened then begin
    WriteFile(hComm, Buf, Len, writtensize, nil);

    if writtensize <> Len then begin
      Result := DEV_PCOPRS1_RET_TIMEOUT;
    end;

  end else begin
    Result :=DEV_PCOPRS1_RET_NOT_OPENED;
  end;
end;

function TPCOPRS1.GetConnecting: Boolean;
begin
  Result := bOpened;
end;

function TPCOPRS1.ModeCancel: Integer;
var res: Integer;
begin
  Result := DEV_PCOPRS1_RET_OK;

  SendCommand('c');
  res := WaitForReplyFromDevice('Y', nil);
  if res = DEV_PCOPRS1_RET_OK then begin
    Result := DEV_PCOPRS1_RET_OK;
  end;
end;

procedure TPCOPRS1.ErrorPrevention;
begin
  if bOpened then begin
    Close;
    Open(FComPort);
  end;
end;

end.
