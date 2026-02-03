unit FullScreenFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Types,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFullScreenForm = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure ChangeLabelPos;
  private
    { Private 宣言 }
    mPos: TPoint; // 前回のマウスカーソル位置保持用
  public
    { Public 宣言 }
  end;

var
  FullScreenForm: TFullScreenForm;

implementation

{$R *.dfm}

// フォームが作成された際の処理
procedure TFullScreenForm.FormCreate(Sender: TObject);
begin
  self.BorderStyle := bsNone; // タイトルバー無し
  self.FormStyle := fsStayOnTop; // 最前面表示

  // フォームのサイズを画面解像度に合わせる
  self.Left := 0;
  self.Top := 0;
  self.Width := Screen.Width;
  self.Height := Screen.Height;

  ShowCursor(False); // マウスカーソル非表示

  Randomize; // 乱数初期化

  // ラベルの表示文字列を変更
  // Label1.Caption := 'SSWrapDp - Screen Saver Wrapper by Delphi';

  ChangeLabelPos;
  mPos := Point(-1, -1);
end;

// 一定時間毎に呼ばれる処理
procedure TFullScreenForm.Timer1Timer(Sender: TObject);
begin
  ChangeLabelPos;
end;

// ラベル表示位置をランダムに変更
procedure TFullScreenForm.ChangeLabelPos;
var
  maxX, maxY: Integer;

begin
  maxX := self.ClientWidth - Label1.Width;
  maxY := self.ClientHeight - Label1.Height;
  Label1.Left := Random(maxX);
  Label1.Top := Random(maxY);

  // ラベルの文字色をランダムに変更
  // Label1.Font.Color := RGB(Random(256), Random(256), Random(256));

  // フォームの背景色をランダムに変更
  // self.Color := RGB(Random(32), Random(32), Random(32));
end;

// キーが押された
procedure TFullScreenForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Application.Terminate;
end;

// マウスクリック
procedure TFullScreenForm.FormClick(Sender: TObject);
begin
  Application.Terminate;
end;

// マウスボタンが押された
procedure TFullScreenForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Application.Terminate;
end;

// マウスカーソルが移動した
procedure TFullScreenForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  dx, dy: Integer;
const
  DIST: Integer = 16; // マウス移動距離チェック
begin
  if mPos.X >= 0 then
  begin
    // 一定距離動いたかチェック
    dx := mPos.X - X;
    dy := mPos.Y - Y;
    if ((dx * dx) + (dy * dy)) > (DIST * DIST) then
      Application.Terminate;
  end;

  mPos := Point(X, Y);
end;

end.
