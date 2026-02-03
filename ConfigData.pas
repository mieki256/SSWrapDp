unit ConfigData;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  System.JSON.Serializers,
  System.JSON.Types;

const
  APP_NAME: string = 'SSWrapDp';
  APP_VERSION: string = '1.0.0.0';
  CONFIG_FILENAME: string = 'SSWrapDp.json';
  CONFIG_DIR: string = 'SSWrapDp';

type
  TSaverItem = record
    Name: string;
    Path: string;
    Args: string;
    Preview: string;
  end;

  TSettings = class
  private
    FSaverItems: TList<TSaverItem>;
    FselectIndexed: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    property Items: TList<TSaverItem> read FSaverItems write FSaverItems;
    property selectIndexed: Integer read FselectIndexed write FselectIndexed;
  end;

procedure SaveDataToJson(const FileName: string; Container: TSettings);
function LoadDataFromJson(const FileName: string): TSettings;
function GetConfigDir: string;
function GetConfigFilePath: string;
procedure CreateConfigDir;
function GetSelectedItem: TSaverItem;

implementation

constructor TSettings.Create;
var
  item: TSaverItem;

begin
  FselectIndexed := 0;
  FSaverItems := TList<TSaverItem>.Create;

  item.Name := 'None';
  item.Path := '';
  item.Args := '';
  item.Preview := '';
  FSaverItems.Add(item);
end;

destructor TSettings.Destroy;
begin
  FSaverItems.Free;
  inherited;
end;

// 設定ファイル保存先ディレクトリパスを取得
function GetConfigDir: string;
begin
  Result := TPath.Combine(TPath.GetHomePath, CONFIG_DIR);
end;

// 設定ファイルのパスを取得
function GetConfigFilePath: string;
begin
  Result := TPath.Combine(GetConfigDir, CONFIG_FILENAME);
end;

// 設定ファイル保存先ディレクトリを作成。既にある場合は何もしない
procedure CreateConfigDir;
begin
  if (not TDirectory.Exists(GetConfigDir)) then
  begin
    TDirectory.CreateDirectory(GetConfigDir);
  end;
end;

// 設定ファイルを読み込んで現在選択中のスクリーンセーバ設定を返す
function GetSelectedItem: TSaverItem;
var
  item: TSaverItem;
  cfg: TSettings;

begin
  if FileExists(GetConfigFilePath) then
  begin
    cfg := LoadDataFromJson(GetConfigFilePath);
    if (cfg.Items.Count > 0) and (cfg.selectIndexed >= 0) then
    begin
      item := cfg.Items[cfg.selectIndexed];
      Result := item;
      Exit;
    end;
  end;

  item.Name := '';
  item.Path := '';
  item.Args := '';
  item.Preview := '';
  Result := item;
end;

// 設定データ(クラス)をJSONファイルとして保存
procedure SaveDataToJson(const FileName: string; Container: TSettings);
var
  SL: TJsonSerializer;
  JSON: string;

begin
  SL := TJsonSerializer.Create;
  SL.Formatting := TJsonFormatting.Indented;

  try
    JSON := SL.Serialize(Container);
    TFile.WriteAllText(FileName, JSON, TEncoding.UTF8);
  finally
    SL.Free;
  end;
end;

// JSONファイルを読み込んで設定データ(クラス)にして返す
function LoadDataFromJson(const FileName: string): TSettings;
var
  SL: TJsonSerializer;
  JSON: string;

begin
  if FileExists(FileName) then
  begin
    JSON := TFile.ReadAllText(FileName, TEncoding.UTF8);
    SL := TJsonSerializer.Create;
    try
      Result := SL.Deserialize<TSettings>(JSON);
    finally
      SL.Free;
    end;
  end
  else
  begin
    Result := nil;
  end;
end;

end.
