object RSAnalyzerForm: TRSAnalyzerForm
  Left = 602
  Top = 143
  Width = 700
  Height = 380
  Caption = 'RSAnalyzerForm'
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 700
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 89
    Height = 307
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      89
      307)
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 56
      Height = 12
      Caption = 'COM'#12509#12540#12488
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 55
      Height = 12
      Caption = #20986#21147#12509#12540#12488
    end
    object OpenButton: TButton
      Left = 8
      Top = 96
      Width = 75
      Height = 25
      Action = OpenAction
      TabOrder = 2
    end
    object COMPortComboBox: TComboBox
      Left = 8
      Top = 24
      Width = 81
      Height = 20
      ItemHeight = 12
      TabOrder = 0
      Text = 'COMPortComboBox'
      OnChange = COMPortComboBoxChange
    end
    object OutputComboBox: TComboBox
      Left = 8
      Top = 64
      Width = 81
      Height = 20
      ItemHeight = 12
      TabOrder = 1
      Text = 'OutputComboBox'
    end
    object LEDButton: TButton
      Left = 8
      Top = 128
      Width = 75
      Height = 25
      Action = LEDAction
      TabOrder = 3
    end
    object ReceiveButton: TButton
      Left = 8
      Top = 160
      Width = 75
      Height = 25
      Action = ReceiveAction
      TabOrder = 4
    end
    object TransmitButton: TButton
      Left = 8
      Top = 192
      Width = 75
      Height = 25
      Action = TransmitAction
      TabOrder = 5
    end
    object AboutButton: TButton
      Left = 8
      Top = 274
      Width = 75
      Height = 25
      Action = AboutAction
      Anchors = [akLeft, akBottom]
      TabOrder = 7
    end
    object OpenAtStartUpCheckBox: TCheckBox
      Left = 8
      Top = 250
      Width = 97
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #36215#21205#26178#25509#32154
      TabOrder = 6
    end
  end
  object Panel2: TPanel
    Left = 89
    Top = 0
    Width = 603
    Height = 307
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 0
      Top = 204
      Width = 603
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object CodeListBox: TListBox
      Left = 0
      Top = 207
      Width = 603
      Height = 100
      Align = alBottom
      Constraints.MinHeight = 100
      ItemHeight = 12
      PopupMenu = CodePopupMenu
      TabOrder = 1
      OnClick = CodeListBoxClick
    end
    object TheChart: TChart
      Left = 0
      Top = 0
      Width = 603
      Height = 204
      Hint = #12510#12454#12473#24038'D&D'#12391#36984#25246#31684#22258#12398#25313#22823#12289#21491'D&D'#12391#12473#12463#12525#12540#12523#12364#12391#12365#12414#12377#12290
      AllowPanning = pmHorizontal
      AnimatedZoom = True
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      Foot.AdjustFrame = False
      Foot.Alignment = taRightJustify
      Foot.Font.Charset = SHIFTJIS_CHARSET
      Foot.Font.Color = clLime
      Foot.Font.Height = -15
      Foot.Font.Name = #65325#65331' '#65328#26126#26397
      Foot.Font.Style = []
      Foot.Text.Strings = (
        'ms')
      Foot.Visible = False
      Title.Color = clBlack
      Title.Font.Charset = SHIFTJIS_CHARSET
      Title.Font.Color = clLime
      Title.Font.Height = -12
      Title.Font.Name = #65325#65331' '#65328#26126#26397
      Title.Font.Style = []
      Title.Frame.Color = clLime
      Title.Text.Strings = (
        #12522#12514#12467#12531#20449#21495)
      BottomAxis.Axis.Color = clMaroon
      BottomAxis.Grid.Color = clMaroon
      BottomAxis.LabelsFont.Charset = SHIFTJIS_CHARSET
      BottomAxis.LabelsFont.Color = clLime
      BottomAxis.LabelsFont.Height = -12
      BottomAxis.LabelsFont.Name = #65325#65331' '#65328#26126#26397
      BottomAxis.LabelsFont.Style = []
      BottomAxis.LabelsOnAxis = False
      BottomAxis.MinorGrid.Color = clMaroon
      BottomAxis.MinorTickCount = 9
      BottomAxis.MinorTickLength = 7
      BottomAxis.MinorTicks.Color = 192
      BottomAxis.Ticks.Color = clMaroon
      BottomAxis.TicksInner.Color = clMaroon
      BottomAxis.Title.Caption = 'msec'
      BottomAxis.Title.Font.Charset = SHIFTJIS_CHARSET
      BottomAxis.Title.Font.Color = clLime
      BottomAxis.Title.Font.Height = -12
      BottomAxis.Title.Font.Name = #65325#65331' '#65328#26126#26397
      BottomAxis.Title.Font.Style = []
      DepthAxis.LabelsFont.Charset = SHIFTJIS_CHARSET
      DepthAxis.LabelsFont.Color = clBlack
      DepthAxis.LabelsFont.Height = -12
      DepthAxis.LabelsFont.Name = #65325#65331' '#65328#26126#26397
      DepthAxis.LabelsFont.Style = []
      DepthAxis.MinorTickCount = 2
      DepthAxis.Title.Font.Charset = SHIFTJIS_CHARSET
      DepthAxis.Title.Font.Color = clBlack
      DepthAxis.Title.Font.Height = -12
      DepthAxis.Title.Font.Name = #65325#65331' '#65328#26126#26397
      DepthAxis.Title.Font.Style = []
      LeftAxis.Automatic = False
      LeftAxis.AutomaticMaximum = False
      LeftAxis.AutomaticMinimum = False
      LeftAxis.Axis.Color = 4210816
      LeftAxis.Grid.Color = clMaroon
      LeftAxis.LabelsFont.Charset = SHIFTJIS_CHARSET
      LeftAxis.LabelsFont.Color = clLime
      LeftAxis.LabelsFont.Height = -12
      LeftAxis.LabelsFont.Name = #65325#65331' '#65328#26126#26397
      LeftAxis.LabelsFont.Style = []
      LeftAxis.LabelsMultiLine = True
      LeftAxis.Maximum = 1.150000000000000000
      LeftAxis.Minimum = -0.150000000000000000
      LeftAxis.MinorGrid.Color = clMaroon
      LeftAxis.MinorGrid.Visible = True
      LeftAxis.MinorTickCount = 0
      LeftAxis.MinorTickLength = 0
      LeftAxis.MinorTicks.Color = clMaroon
      LeftAxis.MinorTicks.Visible = False
      LeftAxis.TickOnLabelsOnly = False
      LeftAxis.Ticks.Color = clMaroon
      LeftAxis.TicksInner.Color = 4210816
      LeftAxis.Title.Font.Charset = SHIFTJIS_CHARSET
      LeftAxis.Title.Font.Color = clBlack
      LeftAxis.Title.Font.Height = -12
      LeftAxis.Title.Font.Name = #65325#65331' '#65328#26126#26397
      LeftAxis.Title.Font.Style = []
      LeftAxis.Visible = False
      Legend.Font.Charset = SHIFTJIS_CHARSET
      Legend.Font.Color = clBlack
      Legend.Font.Height = -12
      Legend.Font.Name = #65325#65331' '#65328#26126#26397
      Legend.Font.Style = []
      Legend.Visible = False
      RightAxis.Grid.Color = clMaroon
      RightAxis.LabelsFont.Charset = SHIFTJIS_CHARSET
      RightAxis.LabelsFont.Color = clBlack
      RightAxis.LabelsFont.Height = -12
      RightAxis.LabelsFont.Name = #65325#65331' '#65328#26126#26397
      RightAxis.LabelsFont.Style = []
      RightAxis.Ticks.Color = clMaroon
      RightAxis.TicksInner.Color = clMaroon
      RightAxis.Title.Font.Charset = SHIFTJIS_CHARSET
      RightAxis.Title.Font.Color = clBlack
      RightAxis.Title.Font.Height = -12
      RightAxis.Title.Font.Name = #65325#65331' '#65328#26126#26397
      RightAxis.Title.Font.Style = []
      TopAxis.Axis.Color = clMaroon
      TopAxis.Grid.Color = clMaroon
      TopAxis.LabelsFont.Charset = SHIFTJIS_CHARSET
      TopAxis.LabelsFont.Color = clLime
      TopAxis.LabelsFont.Height = -12
      TopAxis.LabelsFont.Name = #65325#65331' '#65328#26126#26397
      TopAxis.LabelsFont.Style = []
      TopAxis.MinorTickCount = 9
      TopAxis.MinorTickLength = 5
      TopAxis.MinorTicks.Color = 192
      TopAxis.Ticks.Color = clMaroon
      TopAxis.TicksInner.Color = clMaroon
      TopAxis.Title.Font.Charset = SHIFTJIS_CHARSET
      TopAxis.Title.Font.Color = clBlack
      TopAxis.Title.Font.Height = -12
      TopAxis.Title.Font.Name = #65325#65331' '#65328#26126#26397
      TopAxis.Title.Font.Style = []
      View3D = False
      Align = alClient
      BevelOuter = bvNone
      BevelWidth = 0
      Color = clBlack
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = UndoZoomActionExecute
      object Series1: TFastLineSeries
        HorizAxis = aBothHorizAxis
        Marks.ArrowLength = 8
        Marks.Font.Charset = SHIFTJIS_CHARSET
        Marks.Font.Color = clBlack
        Marks.Font.Height = -12
        Marks.Font.Name = #65325#65331' '#65328#26126#26397
        Marks.Font.Style = []
        Marks.Style = smsXValue
        Marks.Visible = False
        SeriesColor = clLime
        LinePen.Color = clLime
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1.000000000000000000
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1.000000000000000000
        YValues.Order = loNone
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 307
    Width = 692
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object ChartPopupMenu: TPopupMenu
    Left = 629
    Top = 65
    object N3: TMenuItem
      Action = BinaryToClipAction
    end
  end
  object CodePopupMenu: TPopupMenu
    Left = 636
    Top = 288
    object N1: TMenuItem
      Action = CodeToClipAction
    end
    object N2: TMenuItem
      Action = BinaryToClipAction
    end
    object N19: TMenuItem
      Action = TableToClipAction
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object N14: TMenuItem
      Action = ClearCodeAction
    end
    object DeleteCodeAction2: TMenuItem
      Action = DeleteCodeAction
    end
  end
  object TheActionList: TActionList
    Left = 156
    Top = 16
    object CodeToClipAction: TAction
      Category = 'Code'
      Caption = #12467#12540#12489#12434#12467#12500#12540
      Enabled = False
      OnExecute = CodeToClipActionExecute
      OnUpdate = ChackSelectListItem
    end
    object BinaryToClipAction: TAction
      Category = 'Code'
      Caption = #12499#12483#12488#12434#12467#12500#12540
      Enabled = False
      OnExecute = BinaryToClipActionExecute
      OnUpdate = ChackSelectListItem
    end
    object OpenAction: TAction
      Category = 'Operation'
      Caption = #25509#32154
      Enabled = False
      OnExecute = OpenActionExecute
      OnUpdate = OpenActionUpdate
    end
    object LEDAction: TAction
      Category = 'Operation'
      Caption = 'LED'
      Enabled = False
      OnExecute = LEDActionExecute
      OnUpdate = ChackConnecting
    end
    object ReceiveAction: TAction
      Category = 'Operation'
      Caption = #21463#20449
      Enabled = False
      OnExecute = ReceiveActionExecute
      OnUpdate = ChackConnecting
    end
    object TransmitAction: TAction
      Category = 'Operation'
      Caption = #36865#20449
      Enabled = False
      OnExecute = TransmitActionExecute
      OnUpdate = TransmitActionUpdate
    end
    object UndoZoomAction: TAction
      Category = 'Chart'
      Caption = #12474#12540#12512#35299#38500
      Enabled = False
      OnExecute = UndoZoomActionExecute
    end
    object TableToClipAction: TAction
      Category = 'Code'
      Caption = #12486#12540#12502#12523#12434#12467#12500#12540
      OnExecute = TableToClipActionExecute
      OnUpdate = ChackSelectListItem
    end
    object ClearCodeAction: TAction
      Category = 'Code'
      Caption = #12463#12522#12450
      Enabled = False
      OnExecute = ClearCodeActionExecute
      OnUpdate = ChackEmptyList
    end
    object DeleteCodeAction: TAction
      Category = 'Code'
      Caption = #21066#38500
      Enabled = False
      OnExecute = DeleteCodeActionExecute
      OnUpdate = ChackSelectListItem
    end
    object SaveChartAction: TAction
      Category = 'Chart'
      Caption = #12481#12515#12540#12488#12398#20445#23384
      Enabled = False
      OnExecute = SaveChartActionExecute
      OnUpdate = ChackSelectListItem
    end
    object AboutAction: TAction
      Category = 'Help'
      Caption = 'About'
      OnExecute = AboutActionExecute
    end
    object ChartToClipAction: TAction
      Category = 'Chart'
      Caption = #12481#12515#12540#12488#12434#12463#12522#12483#12503#12508#12540#12489#12395#12467#12500#12540
      OnExecute = ChartToClipActionExecute
      OnUpdate = ChackSelectListItem
    end
  end
  object MainMenu: TMainMenu
    Left = 122
    Top = 17
    object N4: TMenuItem
      Caption = #25805#20316'(&O)'
      object N6: TMenuItem
        Action = OpenAction
      end
      object LED1: TMenuItem
        Action = LEDAction
      end
      object N7: TMenuItem
        Action = ReceiveAction
      end
      object N8: TMenuItem
        Action = TransmitAction
      end
    end
    object N5: TMenuItem
      Caption = #12481#12515#12540#12488'(&C)'
      object N16: TMenuItem
        Action = UndoZoomAction
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object N18: TMenuItem
        Action = SaveChartAction
      end
      object N21: TMenuItem
        Action = ChartToClipAction
      end
    end
    object C1: TMenuItem
      Caption = #12467#12540#12489#12522#12473#12488'(&L)'
      object N9: TMenuItem
        Action = CodeToClipAction
      end
      object N15: TMenuItem
        Action = BinaryToClipAction
      end
      object N20: TMenuItem
        Action = TableToClipAction
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object N11: TMenuItem
        Action = ClearCodeAction
      end
      object N12: TMenuItem
        Action = DeleteCodeAction
      end
    end
  end
  object ChartSaveDialog: TSaveDialog
    DefaultExt = 'bmp'
    FileName = 'Chart'
    Filter = #12499#12483#12488#12510#12483#12503'(*.bmp)|*.bmp|'#12513#12479#12501#12449#12452#12523'(*..wmf)|*..wmf'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 194
    Top = 17
  end
end
