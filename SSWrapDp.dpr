program SSWrapDp;

{$R 'myresources.res' 'myresources.rc'}

uses
  Vcl.Forms,
  Vcl.Dialogs,
  FullScreenFormUnit in 'FullScreenFormUnit.pas' {FullScreenForm} ,
  ConfigFormUnit in 'ConfigFormUnit.pas' {ConfigForm} ,
  PreviewFormUnit in 'PreviewFormUnit.pas' {PreviewForm} ,
  System.SysUtils,
  System.StrUtils,
  Winapi.Windows,
  Winapi.ShellAPI,
  ConfigData in 'ConfigData.pas';

{$R *.res}

var
  arg: string;
  phwnd: HWND;

const
  MUTEXNAME: string = 'DelphiScreenSaverMutex4649';

procedure FullScreenMode;
// ----------------------------------------
// Fullscreen Mode

var
  ExSaver: TSaverItem;
  hMutex: THandle;
  filePath: string;
  args: string;
  LhInstance: Cardinal;

begin
  // Load settings data
  ExSaver := GetSelectedItem;
  filePath := ExSaver.Path;
  args := ExSaver.args;

  if (ExSaver.Name <> 'None') and (filePath <> '') then
  begin
    // 外部スクリーンセーバ呼び出し
    if args = '' then
      LhInstance := ShellExecute(0, 'open', PChar(filePath), nil, nil,
        SW_SHOWNORMAL)
    else
      LhInstance := ShellExecute(0, 'open', PChar(filePath), PChar(args), nil,
        SW_SHOWNORMAL);

    if LhInstance <= 32 then
    begin
      Application.MessageBox(PChar('Failed to run ' + filePath), PChar('Error'),
        MB_ICONERROR);
    end;

    // 処理を抜ける。(return相当)
    Exit;
  end;

  // 外部スクリーンセーバの指定が無いので内蔵スクリーンセーバを表示

  // 多重起動禁止
  hMutex := CreateMutex(nil, False, PChar(MUTEXNAME));

  if hMutex = 0 then
    Exit;

  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    // 既に存在している。ハンドルは取得されているので CloseHandle() を呼ぶ
    CloseHandle(hMutex);
    Exit;
  end;

  try
    begin
      // Create fullscreen form
      Application.CreateForm(TFullScreenForm, FullScreenForm);
      Application.Run;
    end;
  finally
    // 処理が終わったら Mutex を解放
    CloseHandle(hMutex);
  end;
end;

// ----------------------------------------
// Config Mode
procedure ConfigMode;
begin
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.Run;
end;

// ----------------------------------------
// Preview Mode
procedure PreviewMode(const phwnd: HWND);
var
  ExSaver: TSaverItem;
  imgPath: string;
  Name: string;

begin
  // Load settings data
  ExSaver := GetSelectedItem;
  name := ExSaver.Name;
  imgPath := ExSaver.Preview;

  if (name = '') or (name = 'None') then
    name := APP_NAME;

  if (imgPath <> '') and (not FileExists(imgPath)) then
    imgPath := '';

  Application.CreateForm(TPreviewForm, PreviewForm);
  PreviewForm.SSaverName := name;
  PreviewForm.imagePath := imgPath;

  if phwnd <> 0 then
    PreviewForm.ParentWindow := phwnd;

  Application.Run;
end;

// ----------------------------------------
// Main
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  // Get commandline option
  if ParamCount > 0 then
    arg := ParamStr(1).Substring(0, 2).ToLower
  else
    arg := '';

  if arg = '/s' then
  begin
    FullScreenMode;
  end
  else if arg = '/c' then
  begin
    ConfigMode;
  end
  else if arg = '/p' then
  begin
    // Preview Mode
    if ParamCount >= 2 then
      phwnd := HWND(StrToInt64Def(ParamStr(2), 0))
    else
      phwnd := 0;

    PreviewMode(phwnd);
    Exit;
  end
  else
  begin
    ConfigMode;
  end;

end.
