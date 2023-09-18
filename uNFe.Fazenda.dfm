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
        Width = 650
      end
      item
        Text = 'Feito por:'
        Width = 60
      end
      item
        Text = 'Aurino | 98 988923379'
        Width = 50
      end>
    OnClick = StatusBar1Click
    ExplicitTop = 556
    ExplicitWidth = 881
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 25
    Width = 885
    Height = 532
    Cursor = crHandPoint
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 2
    object TabSheet2: TTabSheet
      Caption = 'nfe.fazenda.gov.br'
      ImageIndex = 1
      object resultado: TMemo
        Left = 0
        Top = 0
        Width = 877
        Height = 152
        Align = alTop
        Color = clInfoBk
        TabOrder = 0
        ExplicitWidth = 873
      end
      object StringGrid1: TStringGrid
        Left = 0
        Top = 152
        Width = 877
        Height = 352
        Hint = 'Duplo clique para abrir o link da mensagem'
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnDblClick = StringGrid1DblClick
        ExplicitWidth = 873
        ExplicitHeight = 351
      end
    end
  end
end
