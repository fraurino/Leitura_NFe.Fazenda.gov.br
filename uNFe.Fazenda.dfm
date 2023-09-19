object frmNfeFazenda: TfrmNfeFazenda
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'https://www.nfe.fazenda.gov.br/portal/principal.aspx'
  ClientHeight = 576
  ClientWidth = 885
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 885
    Height = 25
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 881
    object Label1: TLabel
      AlignWithMargins = True
      Left = 686
      Top = 4
      Width = 195
      Height = 17
      Cursor = crHandPoint
      Align = alRight
      Caption = 'Feito por Aurino 98 9 8892-3379'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Century'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = [seClient]
      OnClick = Label1Click
      ExplicitLeft = 689
      ExplicitTop = 1
      ExplicitHeight = 15
    end
    object btnInformes: TButton
      Left = 1
      Top = 1
      Width = 100
      Height = 23
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Informes'
      TabOrder = 0
      OnClick = btnInformesClick
    end
    object btnAvisos: TButton
      Left = 101
      Top = 1
      Width = 100
      Height = 23
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'Avisos'
      TabOrder = 1
      OnClick = btnAvisosClick
    end
    object btnIBPTinforma: TButton
      Left = 201
      Top = 1
      Width = 75
      Height = 23
      Cursor = crHandPoint
      Align = alLeft
      Caption = 'IBPT Informa'
      TabOrder = 2
      OnClick = btnIBPTinformaClick
      ExplicitLeft = 464
      ExplicitHeight = 48
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 557
    Width = 885
    Height = 19
    Panels = <
      item
        Text = 'Not'#237'cia:'
        Width = 50
      end
      item
        Text = 'Mensagem'
        Width = 1024
      end>
    ExplicitTop = 556
    ExplicitWidth = 881
  end
  object pgServicos: TPageControl
    Left = 0
    Top = 25
    Width = 885
    Height = 56
    Cursor = crHandPoint
    ActivePage = tsNFe
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    HotTrack = True
    MultiLine = True
    ParentFont = False
    Style = tsButtons
    TabOrder = 2
    OnChange = pgServicosChange
    OnChanging = pgServicosChanging
    object tsNFe: TTabSheet
      Caption = 'nfe.fazenda.gov.br'
      ImageIndex = 1
    end
    object tsCTe: TTabSheet
      Caption = 'cte.fazenda.gov.br'
      ImageIndex = 1
    end
  end
  object resultado: TMemo
    Left = 0
    Top = 81
    Width = 885
    Height = 152
    Align = alTop
    Color = clInfoBk
    TabOrder = 3
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 877
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 233
    Width = 885
    Height = 324
    Hint = 'Duplo clique para abrir o link da mensagem'
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnDblClick = StringGrid1DblClick
    ExplicitTop = 152
    ExplicitWidth = 873
    ExplicitHeight = 351
  end
end
