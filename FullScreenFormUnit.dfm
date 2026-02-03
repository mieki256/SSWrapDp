object FullScreenForm: TFullScreenForm
  Left = 0
  Top = 0
  Caption = 'Screensaver by Delphi'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClick = FormClick
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  TextHeight = 15
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 504
    Height = 32
    Caption = 'SSWrapDp - Screensaver Wrapper by Delphi'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 40
    Top = 112
  end
end
