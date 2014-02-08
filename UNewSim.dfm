object Form2: TForm2
  Left = 274
  Top = 322
  BorderStyle = bsDialog
  Caption = 'Nueva SImulaci'#243'n'
  ClientHeight = 225
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 8
    Width = 47
    Height = 13
    Caption = 'Oro Inicail'
  end
  object Label2: TLabel
    Left = 96
    Top = 40
    Width = 65
    Height = 13
    Caption = 'Comida Inicial'
  end
  object Label3: TLabel
    Left = 96
    Top = 72
    Width = 66
    Height = 13
    Caption = 'Madera Inicial'
  end
  object Label4: TLabel
    Left = 96
    Top = 104
    Width = 173
    Height = 13
    Caption = 'Cantidad Maxima Inicial de Personas'
  end
  object Label5: TLabel
    Left = 96
    Top = 168
    Width = 148
    Height = 13
    Caption = 'Tama'#241'o del Mapa de la Ciudad'
  end
  object Label6: TLabel
    Left = 96
    Top = 136
    Width = 134
    Height = 13
    Caption = 'Cantidad Inicial de Personas'
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 81
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
    OnChange = Edit1Change
  end
  object Edit2: TEdit
    Left = 8
    Top = 40
    Width = 81
    Height = 21
    TabOrder = 1
    Text = 'Edit2'
    OnChange = Edit2Change
  end
  object Edit3: TEdit
    Left = 8
    Top = 72
    Width = 81
    Height = 21
    TabOrder = 2
    Text = 'Edit3'
    OnChange = Edit3Change
  end
  object Edit4: TEdit
    Left = 8
    Top = 104
    Width = 81
    Height = 21
    TabOrder = 3
    Text = 'Edit4'
    OnChange = Edit4Change
  end
  object Button1: TButton
    Left = 8
    Top = 200
    Width = 81
    Height = 17
    Caption = 'Comenzar'
    TabOrder = 4
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 136
    Width = 81
    Height = 21
    AutoComplete = False
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = ComboBox1Change
  end
  object ComboBox2: TComboBox
    Left = 8
    Top = 168
    Width = 81
    Height = 21
    AutoComplete = False
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnChange = ComboBox2Change
  end
end
