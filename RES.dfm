object Form1: TForm1
  Left = 140
  Top = 227
  Width = 668
  Height = 454
  Caption = 'RES - v0.7.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 468
    Height = 392
    OnClick = Image1Click
    OnMouseMove = MouseCoords
  end
  object Label1: TLabel
    Left = 552
    Top = 384
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label6: TLabel
    Left = 520
    Top = 8
    Width = 47
    Height = 13
    Caption = 'Poblacion'
  end
  object Image2: TImage
    Left = 520
    Top = 24
    Width = 113
    Height = 25
  end
  object Label7: TLabel
    Left = 520
    Top = 88
    Width = 101
    Height = 13
    Caption = 'Personas Trabajando'
  end
  object Label8: TLabel
    Left = 520
    Top = 216
    Width = 95
    Height = 13
    Caption = 'Recusrsos a Extraer'
  end
  object Label9: TLabel
    Left = 504
    Top = 232
    Width = 131
    Height = 13
    Caption = 'Mad            Oro            Com'
  end
  object Label10: TLabel
    Left = 552
    Top = 280
    Width = 37
    Height = 13
    Caption = 'Storage'
  end
  object Label11: TLabel
    Left = 504
    Top = 296
    Width = 131
    Height = 13
    Caption = 'Mad            Oro            Com'
  end
  object Button2: TButton
    Left = 560
    Top = 136
    Width = 25
    Height = 17
    Caption = 'AR'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 536
    Top = 160
    Width = 25
    Height = 17
    Caption = 'IZ'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 560
    Top = 184
    Width = 25
    Height = 17
    Caption = 'AB'
    TabOrder = 2
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 584
    Top = 160
    Width = 25
    Height = 17
    Caption = 'DE'
    TabOrder = 3
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 520
    Top = 56
    Width = 113
    Height = 17
    Caption = 'Crear Persona'
    TabOrder = 4
    OnClick = Button6Click
  end
  object Edit2: TEdit
    Left = 544
    Top = 104
    Width = 57
    Height = 21
    TabOrder = 5
  end
  object Edit3: TEdit
    Left = 488
    Top = 248
    Width = 49
    Height = 21
    TabOrder = 6
  end
  object Edit4: TEdit
    Left = 544
    Top = 248
    Width = 49
    Height = 21
    TabOrder = 7
  end
  object Edit5: TEdit
    Left = 600
    Top = 248
    Width = 49
    Height = 21
    TabOrder = 8
  end
  object Edit6: TEdit
    Left = 488
    Top = 312
    Width = 49
    Height = 21
    TabOrder = 9
  end
  object Edit7: TEdit
    Left = 544
    Top = 312
    Width = 49
    Height = 21
    TabOrder = 10
  end
  object Edit8: TEdit
    Left = 600
    Top = 312
    Width = 49
    Height = 21
    TabOrder = 11
  end
  object Button7: TButton
    Left = 512
    Top = 352
    Width = 113
    Height = 25
    Caption = 'Terminar Turno'
    TabOrder = 12
    OnClick = Button7Click
  end
  object MainMenu1: TMainMenu
    Left = 8
    object ComenzarSimulacion1: TMenuItem
      Caption = 'Menu'
      object form1ComboBox1SelText1: TMenuItem
        Caption = 'Comensar Simulacion'
        OnClick = form1ComboBox1SelText1Click
      end
      object Salir1: TMenuItem
        Caption = 'Salir'
        OnClick = Salir1Click
      end
    end
  end
end
