unit ConfigFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.SysUtils, System.Variants, System.IOUtils,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  ConfigData;

type
  TConfigForm = class(TForm)
    LabelAppliName: TLabel;
    LabelVersion: TLabel;
    ListBox1: TListBox;
    Label3: TLabel;
    EditName: TEdit;
    Label4: TLabel;
    EditPath: TEdit;
    Label5: TLabel;
    EditArgs: TEdit;
    Label6: TLabel;
    EditPreview: TEdit;
    ButtonAdd: TButton;
    ButtonUpdate: TButton;
    ButtonDelete: TButton;
    ButtonSave: TButton;
    ButtonClose: TButton;
    ButtonSelPath: TButton;
    ButtonSelArgs: TButton;
    ButtonSelPreview: TButton;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure LabelConfigFilePathClick(Sender: TObject);
    procedure ButtonSelPathClick(Sender: TObject);
    procedure ButtonSelArgsClick(Sender: TObject);
    procedure ButtonSelPreviewClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private 宣言 }
    cfg: TSettings;
    procedure UpdateListBox;
    procedure UpdateEditBox;

  public
    { Public 宣言 }
  end;

var
  ConfigForm: TConfigForm;

implementation

{$R *.dfm}

// フォーム作成時の処理
procedure TConfigForm.FormCreate(Sender: TObject);
begin
  LabelAppliName.Caption := APP_NAME;
  LabelVersion.Caption := 'ver. ' + APP_VERSION;

  // セーブデータファイルがあるならロード
  if FileExists(GetConfigFilePath) then
    cfg := LoadDataFromJson(GetConfigFilePath)
  else
    cfg := TSettings.Create;

  UpdateListBox;
  UpdateEditBox;
end;

// Closeボタンが押された
procedure TConfigForm.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

// データをファイルに保存
procedure TConfigForm.ButtonSaveClick(Sender: TObject);
begin
  CreateConfigDir;
  SaveDataToJson(GetConfigFilePath, cfg);
  Close;
end;

// ListBoxの内容を更新
procedure TConfigForm.UpdateListBox;
var
  Item: TSaverItem;

begin
  ListBox1.Items.BeginUpdate;
  ListBox1.Items.Clear;
  for Item in cfg.Items do
    ListBox1.Items.Add(Item.Name);

  ListBox1.ItemIndex := cfg.selectIndexed;
  ListBox1.Items.EndUpdate;
end;

// 選択項目を右側の Edit に反映
procedure TConfigForm.UpdateEditBox;
var
  i: Integer;

begin
  i := ListBox1.ItemIndex;
  if i <> -1 then
  begin
    cfg.selectIndexed := i;
    EditName.Text := cfg.Items[i].Name;
    EditPath.Text := cfg.Items[i].Path;
    EditArgs.Text := cfg.Items[i].Args;
    EditPreview.Text := cfg.Items[i].Preview;
  end;
end;

// ListBoxで選択項目が変化した時の処理
procedure TConfigForm.ListBox1Click(Sender: TObject);
begin
  UpdateEditBox;
end;

// 項目を追加
procedure TConfigForm.ButtonAddClick(Sender: TObject);
var
  Item: TSaverItem;

begin
  Item.Name := EditName.Text;
  Item.Path := EditPath.Text;
  Item.Args := EditArgs.Text;
  Item.Preview := EditPreview.Text;

  cfg.Items.Add(Item);
  cfg.selectIndexed := cfg.Items.Count - 1;
  UpdateListBox;
end;

// 項目を削除
procedure TConfigForm.ButtonDeleteClick(Sender: TObject);
begin
  cfg.Items.Delete(cfg.selectIndexed);

  cfg.selectIndexed := cfg.selectIndexed - 1;

  if cfg.selectIndexed >= cfg.Items.Count then
    cfg.selectIndexed := cfg.Items.Count - 1;

  if cfg.selectIndexed < 0 then
    cfg.selectIndexed := 0;

  UpdateListBox;
  UpdateEditBox;
end;

// 項目を更新
procedure TConfigForm.ButtonUpdateClick(Sender: TObject);
var
  Item: TSaverItem;
  i: Integer;

begin
  Item.Name := EditName.Text;
  Item.Path := EditPath.Text;
  Item.Args := EditArgs.Text;
  Item.Preview := EditPreview.Text;

  i := cfg.selectIndexed;
  if (i >= 0) and (i < cfg.Items.Count) then
    cfg.Items[i] := Item;

  UpdateListBox;
end;

procedure TConfigForm.LabelConfigFilePathClick(Sender: TObject);
begin
end;

// 設定ファイル保存先ディレクトリをエクスプローラで開く
procedure TConfigForm.Button1Click(Sender: TObject);
begin
  if TDirectory.Exists(GetConfigDir) then
  begin
    ShellExecute(0, 'open', PChar(GetConfigDir), nil, nil, SW_SHOWNORMAL);
  end;
end;

// ファイル選択ダイアログを開いてPathに設定
procedure TConfigForm.ButtonSelPathClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    EditPath.Text := OpenDialog1.FileName;
end;

// ファイル選択ダイアログを開いてArgsに設定
procedure TConfigForm.ButtonSelArgsClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    EditArgs.Text := OpenDialog1.FileName;
end;

// ファイル選択ダイアログを開いてPreviewに設定
procedure TConfigForm.ButtonSelPreviewClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    EditPreview.Text := OpenDialog1.FileName;
end;

end.
