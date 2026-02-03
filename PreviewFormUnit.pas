unit PreviewFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TPreviewForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);

  private
    { Private 宣言 }
    FImagePath: string;
    FSSaverName: string;
    procedure SetImagePath(const Value: string);
    procedure UpdateLabel;

  public
    { Public 宣言 }
    property ImagePath: string read FImagePath write SetImagePath;
    property SSaverName: string read FSSaverName write FSSaverName;
  end;

var
  PreviewForm: TPreviewForm;

implementation

{$R *.dfm}

// フォーム生成時の処理
procedure TPreviewForm.FormCreate(Sender: TObject);
begin
  // 表示位置とサイズを設定
  self.Left := 0;
  self.Top := 0;
  self.Width := 152;
  self.Height := 112;

  Image1.Visible := False;
  Label1.Visible := False;
end;

// キーが押された
procedure TPreviewForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // ESCキーが押された時だけ終了させる
  if Key = VK_ESCAPE then
    Application.Terminate;
end;

// 画像ファイルのパスが指定された時の処理
procedure TPreviewForm.SetImagePath(const Value: string);
begin
  FImagePath := Value;
  UpdateLabel;
end;

// ラベルもしくは表示画像を更新
procedure TPreviewForm.UpdateLabel;
begin
  if (FImagePath <> '') and FileExists(FImagePath) then
  begin
    // 画像を表示
    Label1.Visible := False;

    Image1.Left := 0;
    Image1.Top := 0;
    Image1.Width := self.ClientWidth;
    Image1.Height := self.ClientHeight;

    Image1.Picture.LoadFromFile(FImagePath);
    Image1.Visible := True;
  end
  else
  begin
    // ラベルを表示
    Image1.Visible := False;

    Label1.Caption := FSSaverName;
    Label1.Left := trunc((self.ClientWidth - Label1.Width) * 0.5);
    Label1.Top := trunc((self.ClientHeight - Label1.Height) * 0.5);
    Label1.Font.Color := RGB(0, 100, 0);
    Label1.Visible := True;
  end;
end;

end.
