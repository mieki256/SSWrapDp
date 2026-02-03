object PreviewForm: TPreviewForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Preview Form'
  ClientHeight = 112
  ClientWidth = 152
  Color = clLawngreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 152
    Height = 112
  end
  object Label1: TLabel
    Left = 39
    Top = 46
    Width = 74
    Height = 20
    Caption = 'SSWrapDp'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
end
