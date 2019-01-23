unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, 
  Forms, Dialogs, StdCtrls, RemoteStation, ExtCtrls, ComCtrls,
  TeEngine, Series, TeeProcs, Chart, Menus, ActnList, Clipbrd,
  StrUtils, IniFiles;

type
  TRSAnalyzerForm = class(TForm)
    AboutButton: TButton;
    BinaryToClipAction: TAction;
    C1: TMenuItem;
    ChartPopupMenu: TPopupMenu;
    ChartSaveDialog: TSaveDialog;
    ClearCodeAction: TAction;
    CodeListBox: TListBox;
    CodePopupMenu: TPopupMenu;
    CodeToClipAction: TAction;
    COMPortComboBox: TComboBox;
    DeleteCodeAction: TAction;
    DeleteCodeAction2: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    LED1: TMenuItem;
    LEDAction: TAction;
    LEDButton: TButton;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    OpenAction: TAction;
    OpenAtStartUpCheckBox: TCheckBox;
    OpenButton: TButton;
    OutputComboBox: TComboBox;
    Panel1: TPanel;
    Panel2: TPanel;
    ReceiveAction: TAction;
    ReceiveButton: TButton;
    SaveChartAction: TAction;
    Series1: TFastLineSeries;
    StatusBar1: TStatusBar;
    TheActionList: TActionList;
    TheChart: TChart;
    TransmitAction: TAction;
    TransmitButton: TButton;
    UndoZoomAction: TAction;
    Splitter1: TSplitter;
    AboutAction: TAction;
    TableToClipAction: TAction;
    N19: TMenuItem;
    N20: TMenuItem;
    ChartToClipAction: TAction;
    N21: TMenuItem;
    procedure BinaryToClipActionExecute(Sender: TObject);
    procedure ChackConnecting(Sender: TObject);
    procedure ChackEmptyList(Sender: TObject);
    procedure ChackSelectListItem(Sender: TObject);
    procedure ClearCodeActionExecute(Sender: TObject);
    procedure CodeListBoxClick(Sender: TObject);
    procedure CodeToClipActionExecute(Sender: TObject);
    procedure COMPortComboBoxChange(Sender: TObject);
    procedure DeleteCodeActionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LEDActionExecute(Sender: TObject);
    procedure OpenActionExecute(Sender: TObject);
    procedure OpenActionUpdate(Sender: TObject);
    procedure ReceiveActionExecute(Sender: TObject);
    procedure SaveChartActionExecute(Sender: TObject);
    procedure TransmitActionExecute(Sender: TObject);
    procedure TransmitActionUpdate(Sender: TObject);
    procedure UndoZoomActionExecute(Sender: TObject);
    procedure AboutActionExecute(Sender: TObject);
    procedure TableToClipActionExecute(Sender: TObject);
    procedure ChartToClipActionExecute(Sender: TObject);
  private
    { Private 宣言 }
    function CodeToBynary(Code: TRemoconCode): string;
    function CodeToTable(Code: TRemoconCode): string;
    function CodeToHex(Code: TRemoconCode): string;
    procedure HexToCode(h: string; var Code: TRemoconCode); 
    procedure MakeChart(Code: TRemoconCode);
  public
    { Public 宣言 }
    PCOPRS: TPCOPRS1;
    IniFile: TIniFile;
  end;

var
  RSAnalyzerForm: TRSAnalyzerForm;

implementation

{$R *.dfm}

const
  CODE_FILENAME = 'code.txt';

procedure TRSAnalyzerForm.FormCreate(Sender: TObject);
var i: Integer;
begin
  Caption := Application.Title;

  //作成
  PCOPRS := TPCOPRS1.Create;
  IniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));

  //初期設定
  COMPortComboBox.Clear;
  COMPortComboBox.Style := csDropDownList;
  for i := 0 to 255 do begin
    COMPortComboBox.Items.Add('COM' + IntToStr(i));
  end;

  OutputComboBox.Clear;
  OutputComboBox.Style := csDropDownList;
  for i := 0 to 3 do begin
    OutputComboBox.Items.Add(IntToStr(i));
  end;

  //INI
  with IniFile do begin
    //フォーム位置
    Left := ReadInteger('Form', 'Left', Left);
    Top := ReadInteger('Form', 'Top', Top);
    Width := ReadInteger('Form', 'Width', Width);
    Height := ReadInteger('Form', 'Height', Height);
    WindowState := TWindowState(
      ReadInteger('Form', 'WindowState', Ord(WindowState)));
    CodeListBox.Height := ReadInteger('Form',
      'CodeListBox.Height', CodeListBox.Height);
      
    //設定
    COMPortComboBox.ItemIndex := ReadInteger('Config', 'ComPort', 0);
    OutputComboBox.ItemIndex := ReadInteger('Config', 'OutputPort', 0);
    ChartSaveDialog.FilterIndex := ReadInteger('Config', 'FilterIndex', 1);
    OpenAtStartUpCheckBox.Checked :=
      ReadBool('Config', 'OpenAtStartup', False);
  end;
  if OpenAtStartUpCheckBox.Checked then
    OpenAction.Execute;

  //データ読込
  if FileExists(ExtractFilePath(ParamStr(0)) + CODE_FILENAME) then
    CodeListBox.Items.LoadFromFile(
      ExtractFilePath(ParamStr(0)) + CODE_FILENAME);
end;

procedure TRSAnalyzerForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //データ保存
  CodeListBox.Items.SaveToFile(
    ExtractFilePath(ParamStr(0)) + CODE_FILENAME);

  //INI
  with IniFile do begin
    //フォーム位置                               
      WriteInteger('Form', 'WindowState', Ord(WindowState));
    if WindowState = wsNormal then begin 
      WriteInteger('Form', 'Left', Left);
      WriteInteger('Form', 'Top', Top);
      WriteInteger('Form', 'Width', Width);
      WriteInteger('Form', 'Height', Height);
    end;
    WriteInteger('Form',
      'CodeListBox.Height', CodeListBox.Height);

    //設定
    WriteInteger('Config', 'ComPort', COMPortComboBox.ItemIndex);
    WriteInteger('Config', 'OutputPort', OutputComboBox.ItemIndex);
    WriteInteger('Config', 'FilterIndex', ChartSaveDialog.FilterIndex);
    WriteBool('Config', 'OpenAtStartup', OpenAtStartUpCheckBox.Checked);
  end;
end;

procedure TRSAnalyzerForm.FormDestroy(Sender: TObject);
begin
  PCOPRS.Free;
  IniFile.Free;
end;

function TRSAnalyzerForm.CodeToHex(Code: TRemoconCode): string;
var i: Integer;
begin
  Result := '';
  for i := Low(Code) to High(Code) do begin
    Result := Result + IntToHex(Ord(Code[i]), 2);
  end;
end;

procedure TRSAnalyzerForm.HexToCode(h: string; var Code: TRemoconCode);
var i, len, strIdx: Integer; s: string;
begin
  ZeroMemory(@Code[0], REMOCON_CODE_COUNT);
  len := Length(h);
  for i := 0 to REMOCON_CODE_COUNT-1 do begin
    strIdx := (i*2)+1;
    if (strIdx + 1) > len then Exit;
    s := Copy(h, strIdx, 2);
    Code[i] := Char(StrToInt('$' + s));
  end;
end;

function TRSAnalyzerForm.CodeToBynary(Code: TRemoconCode): string;
var i, j: Integer;
begin
  Result := '';
  for i := 0 to REMOCON_CODE_COUNT-1 do
    for j := 0 to 7 do
      if (Ord(Code[i]) and (1 shl j)) <> 0 then
        Result := Result + '1'
      else
        Result := Result + '0';
end;

procedure TRSAnalyzerForm.MakeChart(Code: TRemoconCode);
var i, l: Integer; binary: string; tmpX, tmpY:Double;
begin
  Series1.Clear;
  binary := CodeToBynary(Code);
  l := Length(binary);
  tmpX := 0;
  for i := 1 to l do begin
    tmpY := StrToInt(binary[i]);
    with Series1 do begin
      AddXY(tmpX, tmpY);
      AddXY(tmpX + 0.1, tmpY);

      tmpX := tmpX + 0.1; //+100μs
    end;
  end;
end;

procedure TRSAnalyzerForm.COMPortComboBoxChange(Sender: TObject);
begin
  OpenAction.Enabled := True;
  PCOPRS.Close;
end;

procedure TRSAnalyzerForm.CodeListBoxClick(Sender: TObject);
var code: TRemoconCode;
begin
  if CodeListBox.ItemIndex = -1 then Exit;
  HexToCode(CodeListBox.Items[CodeListBox.ItemIndex], code);
  MakeChart(code);
end;

procedure TRSAnalyzerForm.CodeToClipActionExecute(Sender: TObject);
begin
  Clipboard.AsText := CodeListBox.Items[CodeListBox.ItemIndex];
end;

procedure TRSAnalyzerForm.BinaryToClipActionExecute(Sender: TObject);
var code: TRemoconCode;
begin
  HexToCode(CodeListBox.Items[CodeListBox.ItemIndex], code);
  Clipboard.AsText := CodeToBynary(code);
end;

procedure TRSAnalyzerForm.TableToClipActionExecute(Sender: TObject);
var code: TRemoconCode;
begin
  HexToCode(CodeListBox.Items[CodeListBox.ItemIndex], code);
  Clipboard.AsText := CodeToTable(code);
end;

function TRSAnalyzerForm.CodeToTable(Code: TRemoconCode): string;
var i: Integer; s: string;
begin
  s := '[TABLE] 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F';
  for i := Low(Code) to High(Code) do begin
    if ((i mod 16) = 0) then s := s + #13#10 + Format(' %.6x', [i]);
    s := s + ' ' + IntToHex(Ord(Code[i]), 2);
  end;
  Result := s;
end;

procedure TRSAnalyzerForm.OpenActionExecute(Sender: TObject);
begin
  if PCOPRS.Open(COMPortComboBox.ItemIndex) = DEV_PCOPRS1_RET_OK then begin
    StatusBar1.SimpleText := '接続成功';
  end else begin
    Beep;
    StatusBar1.SimpleText := '接続失敗';
  end;
  OpenAction.Enabled := not PCOPRS.Connecting;
end;

procedure TRSAnalyzerForm.LEDActionExecute(Sender: TObject);
begin
  if PCOPRS.LedFlash = DEV_PCOPRS1_RET_OK then begin
    StatusBar1.SimpleText := 'LED点灯成功';
  end else begin
    Beep;
    StatusBar1.SimpleText := 'LED点灯失敗';
  end;
end;

procedure TRSAnalyzerForm.ReceiveActionExecute(Sender: TObject);
var ret: Integer; code: TRemoconCode;
  s: string;
begin
  PCOPRS.SetTimeOut(5000); //5sec
  StatusBar1.SimpleText := '受信待機中...';
  ret := PCOPRS.Receive(code);
  if ret = DEV_PCOPRS1_RET_OK then begin
    StatusBar1.SimpleText := '受信成功';

    s := CodeToHex(code);
    MakeChart(code);
    CodeListBox.Items.Insert(0, s);
    CodeListBox.ItemIndex := 0;
  end else if ret = DEV_PCOPRS1_RET_TIMEOUT then begin
    Beep;
    StatusBar1.SimpleText := '受信タイムアウト';
  end else begin
    Beep;
    StatusBar1.SimpleText := '受信失敗';
  end;
end;

procedure TRSAnalyzerForm.TransmitActionExecute(Sender: TObject);
var code: TRemoconCode;
begin
  HexToCode(CodeListBox.Items[CodeListBox.ItemIndex], code);
  if PCOPRS.Transmit(OutputComboBox.ItemIndex, code) = DEV_PCOPRS1_RET_OK then begin
    StatusBar1.SimpleText := '送信成功';
  end else begin
    Beep;
    StatusBar1.SimpleText := '送信失敗';
  end;
end;

procedure TRSAnalyzerForm.ChackSelectListItem(Sender: TObject);
begin
  TAction(Sender).Enabled := CodeListBox.ItemIndex <> -1;
end;

procedure TRSAnalyzerForm.ChackEmptyList(Sender: TObject);
begin
  ClearCodeAction.Enabled := CodeListBox.Items.Count <> 0;
end;

procedure TRSAnalyzerForm.ChackConnecting(Sender: TObject);
begin
  TAction(Sender).Enabled := PCOPRS.Connecting;
end;

procedure TRSAnalyzerForm.OpenActionUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not PCOPRS.Connecting;
end;

procedure TRSAnalyzerForm.TransmitActionUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := PCOPRS.Connecting and
    (CodeListBox.ItemIndex <> -1);
end;

procedure TRSAnalyzerForm.ClearCodeActionExecute(Sender: TObject);
begin
  CodeListBox.Clear;
  Series1.Clear;
end;

procedure TRSAnalyzerForm.DeleteCodeActionExecute(Sender: TObject);
begin
  CodeListBox.Items.Delete(CodeListBox.ItemIndex);
  Series1.Clear;
end;

procedure TRSAnalyzerForm.UndoZoomActionExecute(Sender: TObject);
begin
  TheChart.UndoZoom;
end;

procedure TRSAnalyzerForm.SaveChartActionExecute(Sender: TObject);
begin
with ChartSaveDialog do begin
    if Execute then begin
      if FilterIndex = 1 then begin
        DefaultExt := 'bmp';
        TheChart.SaveToBitmapFile(FileName);
      end else begin
        DefaultExt := 'wmf';
        TheChart.SaveToMetafileEnh(FileName);
      end;
    end;
  end;
end;

procedure TRSAnalyzerForm.ChartToClipActionExecute(Sender: TObject);
begin
  TheChart.CopyToClipboardBitmap;
end;

procedure TRSAnalyzerForm.AboutActionExecute(Sender: TObject);
begin
  MessageDlg(Application.Title + ' v.1.0.0' + #13#10#13#10 +
    'yhira'#13#10 +
    'http://netakiri.net/',
    mtInformation, [mbOK], 0);
end;

end.

