//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit settings;

{$mode ObjFPC}{$H+}
{$codepage utf8}

interface

uses
  Forms,
  Classes,
  SysUtils,
  StrUtils,
  fpjson,
  jsonparser,
  Graphics,
  IniFiles,
  mainform,
  translate;

type
  PConfigData = ^TConfigData;

  TConfigData = record
    Order: integer;
    PathOnly: string;
    Name: string;
    Color: TColor;
    Visible: boolean;
    ImageIndex: integer;
  end;

function GetSettingsDirectory(fileName: string = string.Empty): string;

function GetIniDirectory(fileName: string = string.Empty): string;

procedure SaveFormSettings(Form: TformTrayslate);

function LoadFormSettings(Form: TformTrayslate): boolean;

procedure SaveIniSettings(Translate: TTranslate; AFileName: string);

procedure LoadIniSettings(Translate: TTranslate; AFileName: string);

procedure GetIniFiles(List: TStrings);

function GetConfigFullPath(const ConfigName: string; ConfigFiles: TStringList): string;

function ConfigSortByOrderPathName(List: TStringList; Index1, Index2: integer): integer;

procedure ClearSection(AIni: TIniFile; const ASection: string; AErase: boolean);

implementation

uses systemtool, langtool, formattool;

function GetSettingsDirectory(fileName: string = string.Empty): string;
  {$IFDEF WINDOWS}
var
  baseDir: string;
  exeDir: string;
  {$ENDIF}
begin
  {$IFDEF WINDOWS}
  // Get directory where exe is located
  exeDir := ExtractFilePath(ParamStr(0));

  // Portable mode: settings file exists near exe
  if FileExists(exeDir + 'form_settings.json') then
  begin
    Result := IncludeTrailingPathDelimiter(exeDir) + fileName;
    Exit;
  end;

  // Default mode: use LOCALAPPDATA or APPDATA
  baseDir := GetEnvironmentVariable('LOCALAPPDATA');
  if baseDir = '' then
    baseDir := GetEnvironmentVariable('APPDATA');

  Result := IncludeTrailingPathDelimiter(baseDir) + 'trayslate\' + fileName;
  {$ELSE}
  // Unix-like systems: use ~/.config/trayslate
  Result := IncludeTrailingPathDelimiter(GetUserDir) + '.config/trayslate/' + fileName;
  {$ENDIF}
end;

function GetIniDirectory(fileName: string = string.Empty): string;
begin
  {$IFDEF WINDOWS}
  Result := ExtractFilePath(ParamStr(0)) + fileName;
  {$ELSE}
  Result := IncludeTrailingPathDelimiter(GetUserDir) + '.config/trayslate/' + filename;
  {$ENDIF}
end;

procedure SaveFormSettings(Form: TformTrayslate);
var
  JSONObj: TJSONObject;
  ProxyObj: TJSONObject;
  TimeoutObj: TJSONObject;
  arrPairs, arrParams: TJSONArray;
  FileName: string;
  DPI, i: integer;
begin
  DPI := Screen.PixelsPerInch;
  FileName := GetSettingsDirectory('form_settings.json'); // Get settings file name
  ForceDirectories(GetSettingsDirectory); // Ensure the directory exists
  JSONObj := TJSONObject.Create;
  try
    // Save form position and size
    if (Form.WindowState in [wsMaximized, wsMinimized]) then
    begin
      JSONObj.Add('Left', Round(Form.RestoredLeft * 96 / DPI));
      JSONObj.Add('Top', Round(Form.RestoredTop * 96 / DPI));
      JSONObj.Add('Width', Form.ScaleFormTo96(Form.RestoredWidth));
      JSONObj.Add('Height', Form.ScaleFormTo96(Form.RestoredHeight));
    end
    else
    begin
      JSONObj.Add('Left', Round(Form.Left * 96 / DPI));
      JSONObj.Add('Top', Round(Form.Top * 96 / DPI));
      JSONObj.Add('Width', Form.ScaleFormTo96(Form.Width));
      JSONObj.Add('Height', Form.ScaleFormTo96(Form.Height));
    end;
    JSONObj.Add('WindowState', Ord(Form.WindowState));
    JSONObj.Add('SplitRatio', Form.SplitRatio);

    JSONObj.Add('FormConfigLeft', Round(Form.FormConfigLeft * 96 / DPI));
    JSONObj.Add('FormConfigTop', Round(Form.FormConfigTop * 96 / DPI));
    JSONObj.Add('FormConfigWidth', Round(Form.FormConfigWidth * 96 / DPI));
    JSONObj.Add('FormConfigHeight', Round(Form.FormConfigHeight * 96 / DPI));
    JSONObj.Add('FormPopupLeft', Round(Form.FormPopupLeft * 96 / DPI));
    JSONObj.Add('FormPopupTop', Round(Form.FormPopupTop * 96 / DPI));
    JSONObj.Add('FormPopupWidth', Round(Form.FormPopupWidth * 96 / DPI));
    JSONObj.Add('FormPopupHeight', Round(Form.FormPopupHeight * 96 / DPI));
    JSONObj.Add('FormSettingsLeft', Round(Form.FormSettingsLeft * 96 / DPI));
    JSONObj.Add('FormSettingsTop', Round(Form.FormSettingsTop * 96 / DPI));
    JSONObj.Add('FormSettingsWidth', Round(Form.FormSettingsWidth * 96 / DPI));
    JSONObj.Add('FormSettingsHeight', Round(Form.FormSettingsHeight * 96 / DPI));
    JSONObj.Add('FormSettingsSplit', Round(Form.FormSettingsSplit * 96 / DPI));
    JSONObj.Add('FormAboutWidth', Round(Form.FormAboutWidth * 96 / DPI));
    JSONObj.Add('FormAboutHeight', Round(Form.FormAboutHeight * 96 / DPI));

    // Save language
    JSONObj.Add('Language', Language);

    // Save font
    JSONObj.Add('FontName', Form.Font.Name);
    JSONObj.Add('FontSize', Form.Font.Size);
    JSONObj.Add('FontStyle', integer(Form.Font.Style));  // Convert font style to number
    JSONObj.Add('FontCharset', Form.Font.Charset);
    //JSONObj.Add('FontColor', Form.Font.Color);
    JSONObj.Add('FontPitch', Ord(Form.Font.Pitch));

    // Save font popup
    JSONObj.Add('PopupFontName', Form.FontPopup.Name);
    JSONObj.Add('PopupFontSize', Form.FontPopup.Size);
    JSONObj.Add('PopupFontStyle', integer(Form.FontPopup.Style));  // Convert font style to number
    JSONObj.Add('PopupFontCharset', Form.FontPopup.Charset);
    //JSONObj.Add('PopupFontColor', Form.FontPopup.Color);
    JSONObj.Add('PopupFontPitch', Ord(Form.FontPopup.Pitch));

    // Save config
    JSONObj.Add('ConfigFile', Form.ConfigFile);
    JSONObj.Add('ConfigLangDetect', Form.ConfigLangDetect);
    JSONObj.Add('AutoStart', Form.AutoStart);
    JSONObj.Add('IconBackgroundColor', Form.IconBackgroundColor);
    JSONObj.Add('IconFontColor', Form.IconFontColor);
    JSONObj.Add('IconFontName', Form.IconFontName);
    JSONObj.Add('IconTwoLang', Form.IconTwoLang);
    JSONObj.Add('LangSource', Form.LangSource);
    JSONObj.Add('LangTarget', Form.LangTarget);
    JSONObj.Add('MaxLangPairs', Form.MaxLangPairs);
    JSONObj.Add('RealTime', Form.RealTime);
    JSONObj.Add('RealTimeDelay', Form.RealTimeDelay);
    JSONObj.Add('AutoSwap', Form.AutoSwap);
    JSONObj.Add('SmartSwap', Form.SmartSwap);
    JSONObj.Add('SmartHard', Form.SmartHard);
    JSONObj.Add('PrimaryLang', Form.PrimaryLang);
    JSONObj.Add('SecondaryLang', Form.SecondaryLang);
    JSONObj.Add('EnableMouseMode', Form.EnableMouseMode);
    JSONObj.Add('MouseModeCtrl', Form.MouseModeCtrl);
    JSONObj.Add('MouseMode', Ord(Form.MouseMode));
    JSONObj.Add('VerticalSplit', Form.VerticalSplit);
    JSONObj.Add('AutoCopy', Form.AutoCopy);
    JSONObj.Add('StayOnTop', Form.StayOnTop);
    JSONObj.Add('HideControls', Form.HideControls);
    JSONObj.Add('AutoHeight', Form.AutoHeight);
    JSONObj.Add('MaxHeight', Form.MaxHeight);
    JSONObj.Add('OpacityHover', Form.OpacityHover);
    JSONObj.Add('OpacityIdle', Form.OpacityIdle);
    JSONObj.Add('AutoAddLangPairs', Form.AutoAddLangPairs);
    JSONObj.Add('AllowHotKeys', Form.AllowHotKeys);
    JSONObj.Add('AutoCheckUpdates', Form.AutoCheckUpdates);
    JSONObj.Add('CustomPoFile', Form.CustomPoFile);

    ProxyObj := TJSONObject.Create;
    ProxyObj.Add('ProxyMode', Ord(Form.Proxy.ProxyMode));
    ProxyObj.Add('ProxyType', Ord(Form.Proxy.ProxyType));
    ProxyObj.Add('Host', Form.Proxy.Host);
    ProxyObj.Add('Port', Form.Proxy.Port);
    ProxyObj.Add('Authentication', Form.Proxy.Authentication);
    ProxyObj.Add('Login', Form.Proxy.Login);
    ProxyObj.Add('Password', Form.Proxy.Password);

    JSONObj.Add('Proxy', ProxyObj);

    TimeoutObj := TJSONObject.Create;
    TimeoutObj.Add('Request', Form.Timeout.Request);
    TimeoutObj.Add('Connection', Form.Timeout.Connection);

    JSONObj.Add('Timeout', TimeoutObj);

    // Save hotkeys
    JSONObj.Add('HotKeyApp_Modifiers', Form.HotKeyApp.Modifiers);
    JSONObj.Add('HotKeyApp_Key', Form.HotKeyApp.Key);

    JSONObj.Add('HotKeyTransSwap_Modifiers', Form.HotKeyTransSwap.Modifiers);
    JSONObj.Add('HotKeyTransSwap_Key', Form.HotKeyTransSwap.Key);

    JSONObj.Add('HotKeyTransFromClipboard_Modifiers', Form.HotKeyTransFromClipboard.Modifiers);
    JSONObj.Add('HotKeyTransFromClipboard_Key', Form.HotKeyTransFromClipboard.Key);

    JSONObj.Add('HotKeyTransClipboard_Modifiers', Form.HotKeyTransClipboard.Modifiers);
    JSONObj.Add('HotKeyTransClipboard_Key', Form.HotKeyTransClipboard.Key);

    JSONObj.Add('HotKeyTransClipboardPopup_Modifiers', Form.HotKeyTransClipboardPopup.Modifiers);
    JSONObj.Add('HotKeyTransClipboardPopup_Key', Form.HotKeyTransClipboardPopup.Key);

    JSONObj.Add('HotKeyTransFromControl_Modifiers', Form.HotKeyTransFromControl.Modifiers);
    JSONObj.Add('HotKeyTransFromControl_Key', Form.HotKeyTransFromControl.Key);

    JSONObj.Add('HotKeyTransControl_Modifiers', Form.HotKeyTransControl.Modifiers);
    JSONObj.Add('HotKeyTransControl_Key', Form.HotKeyTransControl.Key);

    JSONObj.Add('HotKeyTransControlPopup_Modifiers', Form.HotKeyTransControlPopup.Modifiers);
    JSONObj.Add('HotKeyTransControlPopup_Key', Form.HotKeyTransControlPopup.Key);

    JSONObj.Add('HotKeyRecent1_Modifiers', Form.HotKeyRecent1.Modifiers);
    JSONObj.Add('HotKeyRecent1_Key', Form.HotKeyRecent1.Key);
    JSONObj.Add('HotKeyRecent2_Modifiers', Form.HotKeyRecent2.Modifiers);
    JSONObj.Add('HotKeyRecent2_Key', Form.HotKeyRecent2.Key);
    JSONObj.Add('HotKeyRecent3_Modifiers', Form.HotKeyRecent3.Modifiers);
    JSONObj.Add('HotKeyRecent3_Key', Form.HotKeyRecent3.Key);
    JSONObj.Add('HotKeyRecent4_Modifiers', Form.HotKeyRecent4.Modifiers);
    JSONObj.Add('HotKeyRecent4_Key', Form.HotKeyRecent4.Key);
    JSONObj.Add('HotKeyRecent5_Modifiers', Form.HotKeyRecent5.Modifiers);
    JSONObj.Add('HotKeyRecent5_Key', Form.HotKeyRecent5.Key);
    JSONObj.Add('HotKeyRecent6_Modifiers', Form.HotKeyRecent6.Modifiers);
    JSONObj.Add('HotKeyRecent6_Key', Form.HotKeyRecent6.Key);
    JSONObj.Add('HotKeyRecent7_Modifiers', Form.HotKeyRecent7.Modifiers);
    JSONObj.Add('HotKeyRecent7_Key', Form.HotKeyRecent7.Key);
    JSONObj.Add('HotKeyRecent8_Modifiers', Form.HotKeyRecent8.Modifiers);
    JSONObj.Add('HotKeyRecent8_Key', Form.HotKeyRecent8.Key);
    JSONObj.Add('HotKeyRecent9_Modifiers', Form.HotKeyRecent9.Modifiers);
    JSONObj.Add('HotKeyRecent9_Key', Form.HotKeyRecent9.Key);

    arrPairs := TJSONArray.Create;
    for i := 0 to Form.LangPairs.Count - 1 do
      arrPairs.Add(Form.LangPairs[i]);
    JSONObj.Add('RecentLangPairs', arrPairs);

    arrParams := TJSONArray.Create;
    for i := 0 to Form.UserParameters.Count - 1 do
      arrParams.Add(Form.UserParameters[i]);
    JSONObj.Add('UserParameters', arrParams);

    // Write to file
    with TStringList.Create do
    try
      Text := JSONObj.FormatJSON;
      SaveToFile(FileName);
    finally
      Free;
    end;
  finally
    JSONObj.Free;
  end;

  try
    Form.MemoSource.Lines.TrailingLineBreak := False;
    Form.MemoSource.Lines.SaveToFile(GetSettingsDirectory('source.txt'));
    Form.MemoTarget.Lines.TrailingLineBreak := False;
    Form.MemoTarget.Lines.SaveToFile(GetSettingsDirectory('target.txt'));
  except
    on E: Exception do
      // Do nothing if can't save current text files
  end;
end;

function LoadFormSettings(Form: TformTrayslate): boolean;
var
  JSONData: TJSONData;
  JSONObj: TJSONObject;
  ProxyObj: TJSONObject;
  TimeoutObj: TJSONObject;
  Proxy: TProxy;
  Timeout: TTimeout;
  arrPairs, arrParams: TJSONArray;
  FileName: string;
  FileStream: TFileStream;
  FileContent: string;
  HK: THotKeyData;
  DPI, i: integer;
begin
  Result := False;
  try
    DPI := Screen.PixelsPerInch;
    FileContent := string.Empty;
    FileName := GetSettingsDirectory('form_settings.json'); // Get the settings file name
    if not FileExists(FileName) then Exit(True); // Exit if the file does not exist

    // Read from file
    FileStream := TFileStream.Create(FileName, fmOpenRead);
    try
      SetLength(FileContent, FileStream.Size);
      FileStream.Read(Pointer(FileContent)^, FileStream.Size);
      JSONData := GetJSON(FileContent);
      try
        JSONObj := JSONData as TJSONObject;

        // Check and load form's position and size
        if JSONObj.FindPath('Left') <> nil then
          Form.Left := Round(JSONObj.FindPath('Left').AsInteger * DPI / 96);

        if JSONObj.FindPath('Top') <> nil then
          Form.Top := Round(JSONObj.FindPath('Top').AsInteger * DPI / 96);

        if JSONObj.FindPath('Width') <> nil then
          Form.Width := Form.Scale96ToForm(JSONObj.FindPath('Width').AsInteger);

        if JSONObj.FindPath('Height') <> nil then
          Form.Height := Form.Scale96ToForm(JSONObj.FindPath('Height').AsInteger);

        if JSONObj.FindPath('WindowState') <> nil then
          Form.WindowState := TWindowState(JSONObj.FindPath('WindowState').AsInteger);

        if JSONObj.FindPath('SplitRatio') <> nil then
          Form.SplitRatio := JSONObj.FindPath('SplitRatio').AsFloat
        else
          Form.SplitRatio := 0.5;

        if JSONObj.FindPath('FormConfigLeft') <> nil then
          Form.FormConfigLeft := Round(JSONObj.FindPath('FormConfigLeft').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormConfigTop') <> nil then
          Form.FormConfigTop := Round(JSONObj.FindPath('FormConfigTop').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormConfigWidth') <> nil then
          Form.FormConfigWidth := Round(JSONObj.FindPath('FormConfigWidth').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormConfigHeight') <> nil then
          Form.FormConfigHeight := Round(JSONObj.FindPath('FormConfigHeight').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormPopupLeft') <> nil then
          Form.FormPopupLeft := Round(JSONObj.FindPath('FormPopupLeft').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormPopupTop') <> nil then
          Form.FormPopupTop := Round(JSONObj.FindPath('FormPopupTop').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormPopupWidth') <> nil then
          Form.FormPopupWidth := Round(JSONObj.FindPath('FormPopupWidth').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormPopupHeight') <> nil then
          Form.FormPopupHeight := Round(JSONObj.FindPath('FormPopupHeight').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormSettingsLeft') <> nil then
          Form.FormSettingsLeft := Round(JSONObj.FindPath('FormSettingsLeft').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormSettingsTop') <> nil then
          Form.FormSettingsTop := Round(JSONObj.FindPath('FormSettingsTop').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormSettingsWidth') <> nil then
          Form.FormSettingsWidth := Round(JSONObj.FindPath('FormSettingsWidth').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormSettingsHeight') <> nil then
          Form.FormSettingsHeight := Round(JSONObj.FindPath('FormSettingsHeight').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormSettingsSplit') <> nil then
          Form.FormSettingsSplit := Round(JSONObj.FindPath('FormSettingsSplit').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormAboutWidth') <> nil then
          Form.FormAboutWidth := Round(JSONObj.FindPath('FormAboutWidth').AsInteger * DPI / 96);

        if JSONObj.FindPath('FormAboutHeight') <> nil then
          Form.FormAboutHeight := Round(JSONObj.FindPath('FormAboutHeight').AsInteger * DPI / 96);

        // Load language
        if JSONObj.FindPath('Language') <> nil then
        begin
          if (JSONObj.FindPath('Language').AsString <> string.Empty) and (Language <> JSONObj.FindPath('Language').AsString) then
            Language := JSONObj.FindPath('Language').AsString;
        end;

        // Check and load font properties
        if JSONObj.FindPath('FontName') <> nil then
          Form.Font.Name := JSONObj.FindPath('FontName').AsString;
        if JSONObj.FindPath('FontSize') <> nil then
          Form.Font.Size := JSONObj.FindPath('FontSize').AsInteger;
        if JSONObj.FindPath('FontStyle') <> nil then
          Form.Font.Style := TFontStyles(JSONObj.FindPath('FontStyle').AsInteger); // Convert integer back to TFontStyles
        if JSONObj.FindPath('FontCharset') <> nil then
          Form.Font.Charset := JSONObj.FindPath('FontCharset').AsInteger;
        //if JSONObj.FindPath('FontColor') <> nil then
        //  Form.Font.Color := JSONObj.FindPath('FontColor').AsInteger;
        if JSONObj.FindPath('FontPitch') <> nil then
          Form.Font.Pitch := TFontPitch(JSONObj.FindPath('FontPitch').AsInteger);

        // Check and load puifont properties
        if JSONObj.FindPath('PopupFontName') <> nil then
          Form.FontPopup.Name := JSONObj.FindPath('PopupFontName').AsString;
        if JSONObj.FindPath('PopupFontSize') <> nil then
          Form.FontPopup.Size := JSONObj.FindPath('PopupFontSize').AsInteger;
        if JSONObj.FindPath('PopupFontStyle') <> nil then
          Form.FontPopup.Style := TFontStyles(JSONObj.FindPath('PopupFontStyle').AsInteger); // Convert integer back to TFontStyles
        if JSONObj.FindPath('PopupFontCharset') <> nil then
          Form.FontPopup.Charset := JSONObj.FindPath('PopupFontCharset').AsInteger;
        //if JSONObj.FindPath('PopupFontColor') <> nil then
        //  Form.FontPopup.Color := JSONObj.FindPath('PopupFontColor').AsInteger;
        if JSONObj.FindPath('PopupFontPitch') <> nil then
          Form.FontPopup.Pitch := TFontPitch(JSONObj.FindPath('PopupFontPitch').AsInteger);

        // Load config
        if JSONObj.FindPath('ConfigFile') <> nil then
          Form.ConfigFile := JSONObj.FindPath('ConfigFile').AsString;

        if JSONObj.FindPath('ConfigLangDetect') <> nil then
          Form.ConfigLangDetect := JSONObj.FindPath('ConfigLangDetect').AsString;

        if JSONObj.FindPath('AutoStart') <> nil then
          Form.AutoStart := JSONObj.FindPath('AutoStart').AsBoolean;

        if JSONObj.FindPath('IconBackgroundColor') <> nil then
          Form.IconBackgroundColor := JSONObj.FindPath('IconBackgroundColor').AsInteger;

        if JSONObj.FindPath('IconFontColor') <> nil then
          Form.IconFontColor := JSONObj.FindPath('IconFontColor').AsInteger;

        if JSONObj.FindPath('IconFontName') <> nil then
          Form.IconFontName := JSONObj.FindPath('IconFontName').AsString;

        if JSONObj.FindPath('IconTwoLang') <> nil then
          Form.IconTwoLang := JSONObj.FindPath('IconTwoLang').AsBoolean;

        if (JSONObj.FindPath('LangSource') <> nil) and (JSONObj.FindPath('LangSource').AsString <> string.Empty) then
          Form.LangSource := JSONObj.FindPath('LangSource').AsString;

        if (JSONObj.FindPath('LangTarget') <> nil) and (JSONObj.FindPath('LangTarget').AsString <> string.Empty) then
          Form.LangTarget := JSONObj.FindPath('LangTarget').AsString;

        if (JSONObj.FindPath('MaxLangPairs') <> nil) then
          Form.MaxLangPairs := JSONObj.FindPath('MaxLangPairs').AsInteger;

        if (JSONObj.FindPath('RealTime') <> nil) then
          Form.FRealTime := JSONObj.FindPath('RealTime').AsBoolean;

        if (JSONObj.FindPath('RealTimeDelay') <> nil) then
          Form.RealTimeDelay := JSONObj.FindPath('RealTimeDelay').AsInteger;

        if (JSONObj.FindPath('AutoSwap') <> nil) then
          Form.FAutoSwap := JSONObj.FindPath('AutoSwap').AsBoolean;

        if (JSONObj.FindPath('SmartSwap') <> nil) then
          Form.SmartSwap := JSONObj.FindPath('SmartSwap').AsBoolean;

        if (JSONObj.FindPath('SmartHard') <> nil) then
          Form.SmartHard := JSONObj.FindPath('SmartHard').AsBoolean;

        if (JSONObj.FindPath('PrimaryLang') <> nil) and (JSONObj.FindPath('PrimaryLang').AsString <> string.Empty) then
          Form.PrimaryLang := JSONObj.FindPath('PrimaryLang').AsString;

        if (JSONObj.FindPath('SecondaryLang') <> nil) and (JSONObj.FindPath('SecondaryLang').AsString <> string.Empty) then
          Form.SecondaryLang := JSONObj.FindPath('SecondaryLang').AsString;

        if (JSONObj.FindPath('EnableMouseMode') <> nil) then
          Form.FEnableMouseMode := JSONObj.FindPath('EnableMouseMode').AsBoolean;

        if (JSONObj.FindPath('MouseModeCtrl') <> nil) then
          Form.FMouseModeCtrl := JSONObj.FindPath('MouseModeCtrl').AsBoolean;

        if (JSONObj.FindPath('MouseMode') <> nil) then
          Form.MouseMode := TMouseMode(JSONObj.FindPath('MouseMode').AsInteger);

        if (JSONObj.FindPath('VerticalSplit') <> nil) then
          Form.FVerticalSplit := JSONObj.FindPath('VerticalSplit').AsBoolean;

        if (JSONObj.FindPath('AutoCopy') <> nil) then
          Form.FAutoCopy := JSONObj.FindPath('AutoCopy').AsBoolean;

        if (JSONObj.FindPath('StayOnTop') <> nil) then
          Form.StayOnTop := JSONObj.FindPath('StayOnTop').AsBoolean;

        if (JSONObj.FindPath('HideControls') <> nil) then
          Form.FHideControls := JSONObj.FindPath('HideControls').AsBoolean;

        if (JSONObj.FindPath('AutoHeight') <> nil) then
          Form.AutoHeight := JSONObj.FindPath('AutoHeight').AsBoolean;

        if (JSONObj.FindPath('MaxHeight') <> nil) then
          Form.MaxHeight := JSONObj.FindPath('MaxHeight').AsInteger;

        if (JSONObj.FindPath('OpacityHover') <> nil) then
          Form.OpacityHover := JSONObj.FindPath('OpacityHover').AsInteger;

        if (JSONObj.FindPath('OpacityIdle') <> nil) then
          Form.OpacityIdle := JSONObj.FindPath('OpacityIdle').AsInteger;

        if (JSONObj.FindPath('AutoAddLangPairs') <> nil) then
          Form.FAutoAddLangPairs := JSONObj.FindPath('AutoAddLangPairs').AsBoolean;

        if (JSONObj.FindPath('AllowHotKeys') <> nil) then
          Form.FAllowHotKeys := JSONObj.FindPath('AllowHotKeys').AsBoolean;

        if (JSONObj.FindPath('AutoCheckUpdates') <> nil) then
          Form.AutoCheckUpdates := JSONObj.FindPath('AutoCheckUpdates').AsBoolean;

        if (JSONObj.FindPath('CustomPoFile') <> nil) then
          Form.CustomPoFile := JSONObj.FindPath('CustomPoFile').AsString;

        // Proxy settings
        if JSONObj.FindPath('Proxy') <> nil then
        begin
          ProxyObj := JSONObj.FindPath('Proxy') as TJSONObject;

          Proxy := Form.Proxy;

          if ProxyObj.FindPath('ProxyMode') <> nil then
            Proxy.ProxyMode := TProxyMode(ProxyObj.FindPath('ProxyMode').AsInteger);

          if ProxyObj.FindPath('ProxyType') <> nil then
            Proxy.ProxyType := TProxyType(ProxyObj.FindPath('ProxyType').AsInteger);

          if ProxyObj.FindPath('Host') <> nil then
            Proxy.Host := ProxyObj.FindPath('Host').AsString;

          if ProxyObj.FindPath('Port') <> nil then
            Proxy.Port := ProxyObj.FindPath('Port').AsString;

          if ProxyObj.FindPath('Authentication') <> nil then
            Proxy.Authentication := ProxyObj.FindPath('Authentication').AsBoolean;

          if ProxyObj.FindPath('Login') <> nil then
            Proxy.Login := ProxyObj.FindPath('Login').AsString;

          if ProxyObj.FindPath('Password') <> nil then
            Proxy.Password := ProxyObj.FindPath('Password').AsString;

          Form.Proxy := Proxy;
        end;

        // Timeout Settings
        if JSONObj.FindPath('Timeout') <> nil then
        begin
          TimeoutObj := JSONObj.FindPath('Timeout') as TJSONObject;

          Timeout := Form.Timeout;

          if TimeoutObj.FindPath('Request') <> nil then
            Timeout.Request := TimeoutObj.FindPath('Request').AsInteger;

          if TimeoutObj.FindPath('Connection') <> nil then
            Timeout.Connection := TimeoutObj.FindPath('Connection').AsInteger;

          Form.Timeout := Timeout;
        end;

        // Load HotKeys
        // HotKeyApp
        HK := Form.HotKeyApp;
        if JSONObj.FindPath('HotKeyApp_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyApp_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyApp_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyApp_Key').AsInteger;
        Form.HotKeyApp := HK;

        // HotKeyTransSwap
        HK := Form.HotKeyTransSwap;
        if JSONObj.FindPath('HotKeyTransSwap_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyTransSwap_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyTransSwap_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyTransSwap_Key').AsInteger;
        Form.HotKeyTransSwap := HK;

        // HotKeyTransFromClipboard
        HK := Form.HotKeyTransFromClipboard;
        if JSONObj.FindPath('HotKeyTransFromClipboard_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyTransFromClipboard_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyTransFromClipboard_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyTransFromClipboard_Key').AsInteger;
        Form.HotKeyTransFromClipboard := HK;

        // HotKeyTransClipboard
        HK := Form.HotKeyTransClipboard;
        if JSONObj.FindPath('HotKeyTransClipboard_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyTransClipboard_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyTransClipboard_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyTransClipboard_Key').AsInteger;
        Form.HotKeyTransClipboard := HK;

        // HotKeyTransClipboardPopup;
        HK := Form.HotKeyTransClipboardPopup;
        if JSONObj.FindPath('HotKeyTransClipboardPopup_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyTransClipboardPopup_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyTransClipboardPopup_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyTransClipboardPopup_Key').AsInteger;
        Form.HotKeyTransClipboardPopup := HK;

        // HotKeyTransFromControl
        HK := Form.HotKeyTransFromControl;
        if JSONObj.FindPath('HotKeyTransFromControl_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyTransFromControl_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyTransFromControl_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyTransFromControl_Key').AsInteger;
        Form.HotKeyTransFromControl := HK;

        // HotKeyTransControl
        HK := Form.HotKeyTransControl;
        if JSONObj.FindPath('HotKeyTransControl_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyTransControl_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyTransControl_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyTransControl_Key').AsInteger;
        Form.HotKeyTransControl := HK;

        // HotKeyTransControlPopup
        HK := Form.HotKeyTransControlPopup;
        if JSONObj.FindPath('HotKeyTransControlPopup_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyTransControlPopup_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyTransControlPopup_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyTransControlPopup_Key').AsInteger;
        Form.HotKeyTransControlPopup := HK;

        // HotKeyRecent1
        HK := Form.HotKeyRecent1;
        if JSONObj.FindPath('HotKeyRecent1_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyRecent1_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyRecent1_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyRecent1_Key').AsInteger;
        Form.HotKeyRecent1 := HK;

        // HotKeyRecent2
        HK := Form.HotKeyRecent2;
        if JSONObj.FindPath('HotKeyRecent2_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyRecent2_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyRecent2_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyRecent2_Key').AsInteger;
        Form.HotKeyRecent2 := HK;

        // HotKeyRecent3
        HK := Form.HotKeyRecent3;
        if JSONObj.FindPath('HotKeyRecent3_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyRecent3_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyRecent3_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyRecent3_Key').AsInteger;
        Form.HotKeyRecent3 := HK;

        // HotKeyRecent4
        HK := Form.HotKeyRecent4;
        if JSONObj.FindPath('HotKeyRecent4_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyRecent4_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyRecent4_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyRecent4_Key').AsInteger;
        Form.HotKeyRecent4 := HK;

        // HotKeyRecent5
        HK := Form.HotKeyRecent5;
        if JSONObj.FindPath('HotKeyRecent5_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyRecent5_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyRecent5_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyRecent5_Key').AsInteger;
        Form.HotKeyRecent5 := HK;

        // HotKeyRecent6
        HK := Form.HotKeyRecent6;
        if JSONObj.FindPath('HotKeyRecent6_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyRecent6_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyRecent6_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyRecent6_Key').AsInteger;
        Form.HotKeyRecent6 := HK;

        // HotKeyRecent7
        HK := Form.HotKeyRecent7;
        if JSONObj.FindPath('HotKeyRecent7_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyRecent7_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyRecent7_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyRecent7_Key').AsInteger;
        Form.HotKeyRecent7 := HK;

        // HotKeyRecent8
        HK := Form.HotKeyRecent8;
        if JSONObj.FindPath('HotKeyRecent8_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyRecent8_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyRecent8_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyRecent8_Key').AsInteger;
        Form.HotKeyRecent8 := HK;

        // HotKeyRecent9
        HK := Form.HotKeyRecent9;
        if JSONObj.FindPath('HotKeyRecent9_Modifiers') <> nil then
          HK.Modifiers := JSONObj.FindPath('HotKeyRecent9_Modifiers').AsInteger;
        if JSONObj.FindPath('HotKeyRecent9_Key') <> nil then
          HK.Key := JSONObj.FindPath('HotKeyRecent9_Key').AsInteger;
        Form.HotKeyRecent9 := HK;

        // Load recent language pairs
        Form.LangPairs.Clear;
        if JSONObj.FindPath('RecentLangPairs') <> nil then
        begin
          arrPairs := JSONObj.FindPath('RecentLangPairs') as TJSONArray;
          for i := 0 to arrPairs.Count - 1 do
            Form.LangPairs.Add(arrPairs.Items[i].AsString);
        end;

        // Load user parameters
        Form.UserParameters.Clear;
        if JSONObj.FindPath('UserParameters') <> nil then
        begin
          arrParams := JSONObj.FindPath('UserParameters') as TJSONArray;
          for i := 0 to arrParams.Count - 1 do
            Form.UserParameters.Add(arrParams.Items[i].AsString);
        end;
      finally
        JSONData.Free;
      end;
    finally
      FileStream.Free;
    end;

    FileName := GetSettingsDirectory('source.txt');
    if FileExists(FileName) then
    begin
      Form.MemoSource.Lines.TrailingLineBreak := False;
      Form.MemoSource.Lines.LoadFromFile(FileName);
    end;
    FileName := GetSettingsDirectory('target.txt');
    if FileExists(FileName) then
    begin
      Form.MemoTarget.Lines.TrailingLineBreak := False;
      Form.MemoTarget.Lines.LoadFromFile(FileName);
    end;

    Result := True;
  except
    Result := False;
  end;
end;

procedure SaveIniSettings(Translate: TTranslate; AFileName: string);
var
  Ini: TMemIniFile;
  i: integer;
  PostDataEscaped: string;
begin
  Ini := TMemIniFile.Create(AFileName);
  try
    // { Service page }
    if Trim(Translate.ServiceName) <> string.Empty then
      Ini.WriteString('Service', 'Name', Translate.ServiceName)
    else
      Ini.DeleteKey('Service', 'Name');
    if Trim(Translate.ServiceIcon) <> string.Empty then
      Ini.WriteString('Service', 'Icon', Translate.ServiceIcon)
    else
      Ini.DeleteKey('Service', 'Icon');
    Ini.WriteInteger('Service', 'Order', Translate.ServiceOrder);
    Ini.WriteBool('Service', 'Visible', Translate.ServiceVisible);
    Ini.WriteBool('Service', 'AutoSwapLanguage', Translate.ServiceAutoSwap);
    Ini.WriteBool('Service', 'RealTimeTranslation', Translate.ServiceRealTime);
    Ini.WriteBool('Service', 'TranslateOnlyByButton', Translate.ServiceOnlyButton);
    Ini.WriteBool('Service', 'AllowProxy', Translate.ServiceProxy);
    Ini.WriteInteger('Service', 'ColorRecent', Translate.ServiceColorRecent);

    case Translate.ValueType of
      vtNone: Ini.WriteString('Service', 'ValueType', 'None');
      vtLanguage: Ini.WriteString('Service', 'ValueType', 'Language');
      vtCurrencyAll: Ini.WriteString('Service', 'ValueType', 'CurrencyAll');
      vtCurrencyFiat: Ini.WriteString('Service', 'ValueType', 'CurrencyFiat');
      vtCurrencyCrypto: Ini.WriteString('Service', 'ValueType', 'CurrencyCrypto');
      vtUnit: Ini.WriteString('Service', 'ValueType', 'Unit');
      else
        ;
    end;

    // Save service description
    ClearSection(Ini, 'Service Description', not Assigned(Translate.ServiceDescription) or (Translate.ServiceDescription.Count = 0));
    if Assigned(Translate.ServiceDescription) then
      for i := 0 to Translate.ServiceDescription.Count - 1 do
        Ini.WriteString('Service Description',
          IntToStr(i), // key: 0,1,2...
          Translate.ServiceDescription[i]);

    // { Request page }
    if Translate.WebMethod = wmPost then
      Ini.WriteString('Request', 'Method', 'POST')
    else
      Ini.WriteString('Request', 'Method', 'GET');

    if Trim(Translate.UserAgent) <> string.Empty then
      Ini.WriteString('Request', 'UserAgent', Translate.UserAgent)
    else
      Ini.DeleteKey('Request', 'UserAgent');

    Ini.WriteBool('Request', 'EncodeText', Translate.EncodeText);
    Ini.WriteInteger('Request', 'MaxLength', Translate.MaxLength);

    if Trim(Translate.Url) <> string.Empty then
      Ini.WriteString('Request', 'Url', Translate.Url)
    else
      Ini.DeleteKey('Request', 'Url');

    if Trim(Translate.ContentType) <> string.Empty then
      Ini.WriteString('Request', 'ContentType', Translate.ContentType)
    else
      Ini.DeleteKey('Request', 'ContentType');

    // Replace line breaks with \r\n for single-line storage
    if Trim(Translate.PostData) <> string.Empty then
    begin
      PostDataEscaped := StringReplace(Translate.PostData, LineEnding, '\r\n', [rfReplaceAll]);
      Ini.WriteString('Request', 'PostData', PostDataEscaped);
    end
    else
      Ini.DeleteKey('Request', 'PostData');

    if Trim(Translate.Accept) <> string.Empty then
      Ini.WriteString('Request', 'Accept', Translate.Accept)
    else
      Ini.DeleteKey('Request', 'Accept');

    // Save headers
    ClearSection(Ini, 'Headers', not Assigned(Translate.Headers) or (Translate.Headers.Count = 0));
    if Assigned(Translate.Headers) then
      for i := 0 to Translate.Headers.Count - 1 do
        Ini.WriteString('Headers',
          Translate.Headers.Names[i],
          Translate.Headers.ValueFromIndex[i]);

    // {  Response page }
    if Trim(Translate.JsonPointer) <> string.Empty then
      Ini.WriteString('Response', 'JsonPointer', Translate.JsonPointer)
    else
      Ini.DeleteKey('Response', 'JsonPointer');

    // { Parameters page }
    Ini.WriteBool('Parameters', 'EncodeCustomParameters', Translate.EncodeCustomParameters);

    // Save custom parameters
    ClearSection(Ini, 'Custom Parameters', not Assigned(Translate.CustomParameters) or (Translate.CustomParameters.Count = 0));
    if Assigned(Translate.CustomParameters) then
      for i := 0 to Translate.CustomParameters.Count - 1 do
        Ini.WriteString('Custom Parameters',
          Translate.CustomParameters.Names[i],
          Translate.CustomParameters.ValueFromIndex[i]);

    ClearSection(Ini, 'Initial Request', (Trim(Translate.InitUserAgent) = string.Empty) and
      (Trim(Translate.InitUrl) = string.Empty) and (Translate.InitLiveTime = 0));
    if Trim(Translate.InitUserAgent) <> string.Empty then
      Ini.WriteString('Initial Request', 'UserAgent', Translate.InitUserAgent)
    else
      Ini.DeleteKey('Initial Request', 'UserAgent');

    if Trim(Translate.InitUrl) <> string.Empty then
      Ini.WriteString('Initial Request', 'Url', Translate.InitUrl)
    else
      Ini.DeleteKey('Initial Request', 'Url');

    if Translate.InitLiveTime > 0 then
      Ini.WriteInteger('Initial Request', 'LiveTime', Translate.InitLiveTime)
    else
      Ini.DeleteKey('Initial Request', 'LiveTime');

    // Save initial headers
    ClearSection(Ini, 'Initial Headers', not Assigned(Translate.InitHeaders) or (Translate.InitHeaders.Count = 0));
    if Assigned(Translate.InitHeaders) then
      for i := 0 to Translate.InitHeaders.Count - 1 do
        Ini.WriteString('Initial Headers',
          Translate.InitHeaders.Names[i],
          Translate.InitHeaders.ValueFromIndex[i]);

    // Save initial parameters
    ClearSection(Ini, 'Initial Parameters', not Assigned(Translate.InitParameters) or (Translate.InitParameters.Count = 0));
    if Assigned(Translate.InitParameters) then
      for i := 0 to Translate.InitParameters.Count - 1 do
        Ini.WriteString('Initial Parameters',
          Translate.InitParameters.Names[i],
          Translate.InitParameters.ValueFromIndex[i]);

    // Languages Page
    // Save language mappings (code=apiCode)
    ClearSection(Ini, 'Languages', not Assigned(Translate.Languages) or (Translate.Languages.Count = 0));
    if Assigned(Translate.Languages) then
      for i := 0 to Translate.Languages.Count - 1 do
        Ini.WriteString('Languages',
          IfThen(Translate.Languages.Names[i] = string.Empty, Translate.Languages[i] + '_' + IntToStr(i),
          Translate.Languages.Names[i] + '_' + IntToStr(i)),
          IfThen(Translate.Languages.ValueFromIndex[i] = string.Empty, IfThen(Translate.Languages.Names[i] =
          string.Empty, Translate.Languages[i], Translate.Languages.Names[i]), Translate.Languages.ValueFromIndex[i]));

    // Target Languages Page
    // Save language target mappings (code=apiCode)
    ClearSection(Ini, 'LanguagesTarget', not Assigned(Translate.LanguagesTarget) or (Translate.LanguagesTarget.Count = 0));
    if Assigned(Translate.LanguagesTarget) then
      for i := 0 to Translate.LanguagesTarget.Count - 1 do
        Ini.WriteString('LanguagesTarget',
          IfThen(Translate.LanguagesTarget.Names[i] = string.Empty, Translate.LanguagesTarget[i] + '_' +
          IntToStr(i), Translate.LanguagesTarget.Names[i] + '_' + IntToStr(i)),
          IfThen(Translate.LanguagesTarget.ValueFromIndex[i] = string.Empty, IfThen(
          Translate.LanguagesTarget.Names[i] = string.Empty, Translate.LanguagesTarget[i], Translate.LanguagesTarget.Names[i]),
          Translate.LanguagesTarget.ValueFromIndex[i]));

    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

procedure LoadIniSettings(Translate: TTranslate; AFileName: string);
var
  Ini: TIniFile;
  Method: string;
  PostDataEscaped: string;
  Value: string;
  Keys: TStringList;
  i: integer;

  procedure LoadSection(const Section: string; Dest: TStrings);
  var
    Keys: TStringList;
    i, Num: integer;
    Key, Val: string;
    UnderscorePos: integer;
  begin
    Dest.Clear;
    Keys := TStringList.Create;
    try
      Ini.ReadSection(Section, Keys);
      for i := 0 to Keys.Count - 1 do
      begin
        Key := Keys[i];
        Val := Ini.ReadString(Section, Key, '');

        // remove trailing _number
        UnderscorePos := LastDelimiter('_', Key);
        if (UnderscorePos > 0) and TryStrToInt(Copy(Key, UnderscorePos + 1, MaxInt), Num) then
          Key := Copy(Key, 1, UnderscorePos - 1);

        Dest.Add(Key + '=' + Val);
      end;
    finally
      Keys.Free;
    end;
  end;

begin
  Ini := TIniFile.Create(AFileName);
  try
    Translate.ServiceName := Ini.ReadString('Service', 'Name', string.Empty);
    Translate.ServiceIcon := Ini.ReadString('Service', 'Icon', string.Empty);
    Translate.ServiceOrder := Ini.ReadInteger('Service', 'Order', 0);
    Translate.ServiceVisible := Ini.ReadBool('Service', 'Visible', True);
    Translate.ServiceAutoSwap := Ini.ReadBool('Service', 'AutoSwapLanguage', False);
    Translate.ServiceRealTime := Ini.ReadBool('Service', 'RealTimeTranslation', False);
    Translate.ServiceOnlyButton := Ini.ReadBool('Service', 'TranslateOnlyByButton', False);
    Translate.ServiceProxy:= Ini.ReadBool('Service', 'AllowProxy', False);
    Translate.ServiceColorRecent := Ini.ReadInteger('Service', 'ColorRecent', clBlue);

    Translate.ServiceDescription.Clear;
    Keys := TStringList.Create;
    try
      Ini.ReadSection('Service Description', Keys);

      for i := 0 to Keys.Count - 1 do
        Translate.ServiceDescription.Add(
          Ini.ReadString('Service Description', Keys[i], '')
          );
    finally
      Keys.Free;
    end;

    Value := Ini.ReadString('Service', 'ValueType', 'None');
    if SameText(Value, 'None') then
      Translate.ValueType := vtNone
    else if SameText(Value, 'Language') then
      Translate.ValueType := vtLanguage
    else if SameText(Value, 'CurrencyAll') then
      Translate.ValueType := vtCurrencyAll
    else if SameText(Value, 'CurrencyFiat') then
      Translate.ValueType := vtCurrencyFiat
    else if SameText(Value, 'CurrencyCrypto') then
      Translate.ValueType := vtCurrencyCrypto
    else if SameText(Value, 'Unit') then
      Translate.ValueType := vtUnit
    else
      Translate.ValueType := vtNone; // default

    Method := Ini.ReadString('Request', 'Method', 'GET');
    if SameText(Method, 'POST') then
      Translate.WebMethod := wmPost
    else
      Translate.WebMethod := wmGet;

    Translate.UserAgent := Ini.ReadString('Request', 'UserAgent', string.Empty);
    Translate.EncodeText := Ini.ReadBool('Request', 'EncodeText', True);
    Translate.MaxLength := Ini.ReadInteger('Request', 'MaxLength', 0);

    Translate.Url := Ini.ReadString('Request', 'Url', string.Empty);

    Translate.ContentType := Ini.ReadString('Request', 'ContentType', string.Empty);
    // Restore line breaks from \r\n
    PostDataEscaped := Ini.ReadString('Request', 'PostData', string.Empty);
    Translate.PostData := StringReplace(PostDataEscaped, '\r\n', LineEnding, [rfReplaceAll]);
    Translate.Accept := Ini.ReadString('Request', 'Accept', string.Empty);
    Translate.Headers.Clear;
    Ini.ReadSectionValues('Headers', Translate.Headers);

    Translate.JsonPointer := Ini.ReadString('Response', 'JsonPointer', string.Empty);

    Translate.EncodeCustomParameters := Ini.ReadBool('Parameters', 'EncodeCustomParameters', True);
    Translate.CustomParameters.Clear;
    Ini.ReadSectionValues('Custom Parameters', Translate.CustomParameters);

    Translate.InitUserAgent := Ini.ReadString('Initial Request', 'UserAgent', string.Empty);
    Translate.InitUrl := Ini.ReadString('Initial Request', 'Url', string.Empty);
    Translate.InitLiveTime := Ini.ReadInteger('Initial Request', 'LiveTime', 0);
    Translate.InitHeaders.Clear;
    Ini.ReadSectionValues('Initial Headers', Translate.InitHeaders);
    Translate.InitParameters.Clear;
    Ini.ReadSectionValues('Initial Parameters', Translate.InitParameters);

    LoadSection('Languages', Translate.Languages);
    LoadSection('LanguagesTarget', Translate.LanguagesTarget);

    RemoveEmptyValues(Translate.Languages);
    RemoveEmptyValues(Translate.LanguagesTarget);
  finally
    Ini.Free;
  end;
end;

function IsValidIni(const FileName: string): boolean;
var
  Ini: TIniFile;
  Method: string;
begin
  Result := False;

  if not FileExists(FileName) then
    Exit;

  Ini := TIniFile.Create(FileName);
  try
    // Check required keys
    Method := Ini.ReadString('Request', 'Method', string.Empty);

    if ((Method = 'GET') or (Method = 'POST')) and Ini.ValueExists('Request', 'EncodeText') and
      Ini.ValueExists('Service', 'Order') then
      Result := True;
  finally
    Ini.Free;
  end;
end;

procedure FindIniFiles(const Dir: string; List: TStrings);
var
  SR: TSearchRec;
  FilePath: string;
begin
  if not DirectoryExists(Dir) then
    Exit;

  // Search for *.ini files in current directory
  if FindFirst(IncludeTrailingPathDelimiter(Dir) + '*.ini', faAnyFile and not faDirectory, SR) = 0 then
  begin
    repeat
      FilePath := IncludeTrailingPathDelimiter(Dir) + SR.Name;

      if IsValidIni(FilePath) then
        List.Add(FilePath);

    until FindNext(SR) <> 0;

    FindClose(SR);
  end;

  // Search subdirectories recursively
  if FindFirst(IncludeTrailingPathDelimiter(Dir) + '*', faDirectory, SR) = 0 then
  begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') then
      begin
        if (SR.Attr and faDirectory) <> 0 then
        begin
          FilePath := IncludeTrailingPathDelimiter(Dir) + SR.Name;
          FindIniFiles(FilePath, List); // Recursive call
        end;
      end;
    until FindNext(SR) <> 0;

    FindClose(SR);
  end;
end;

procedure GetIniFiles(List: TStrings);
var
  ExeDir: string;
  SettingsDir: string;
begin
  List.Clear;

  // Executable directory
  ExeDir := ExtractFilePath(ParamStr(0));
  FindIniFiles(ExeDir, List);

  // Settings directory
  SettingsDir := GetSettingsDirectory('');
  if CompareText(ExcludeTrailingPathDelimiter(ExeDir), ExcludeTrailingPathDelimiter(SettingsDir)) <> 0 then
    FindIniFiles(SettingsDir, List);
end;

function GetConfigFullPath(const ConfigName: string; ConfigFiles: TStringList): string;
var
  i: integer;
  NameOnly: string;
begin
  // Initialize result as empty string
  Result := string.Empty;

  // Extract only the file name in case ConfigName contains a full path
  NameOnly := ExtractFileName(ConfigName);

  // Iterate through all config file paths
  for i := 0 to ConfigFiles.Count - 1 do
  begin
    // Compare only the file name, case-insensitive
    if SameText(ExtractFileName(ConfigFiles[i]), NameOnly) then
    begin
      Result := ConfigFiles[i]; // return full path
      Exit;
    end;
  end;
  // If not found, Result remains empty
end;

function ConfigSortByOrderPathName(List: TStringList; Index1, Index2: integer): integer;
var
  Data1, Data2: PConfigData;
  Ord1, Ord2: integer;
begin
  Data1 := PConfigData(List.Objects[Index1]);
  Data2 := PConfigData(List.Objects[Index2]);

  // Treat Order=0 as "largest" to push it to the bottom
  if Data1^.Order = 0 then
    Ord1 := MaxInt
  else
    Ord1 := Data1^.Order;

  if Data2^.Order = 0 then
    Ord2 := MaxInt
  else
    Ord2 := Data2^.Order;

  Result := Ord1 - Ord2; // primary sort
  if Result = 0 then
  begin
    Result := CompareText(Data1^.PathOnly, Data2^.PathOnly); // secondary sort
    if Result = 0 then
      Result := CompareText(Data1^.Name, Data2^.Name); // tertiary sort
  end;
end;

procedure ClearSection(AIni: TIniFile; const ASection: string; AErase: boolean);
var
  Keys: TStringList;
  i: integer;
begin
  if AErase then
  begin
    // Completely remove section (may change file order)
    AIni.EraseSection(ASection);
    Exit;
  end;

  Keys := TStringList.Create;
  try
    // Read all keys from section
    AIni.ReadSection(ASection, Keys);

    // Delete each key individually (keeps section position)
    for i := 0 to Keys.Count - 1 do
      AIni.DeleteKey(ASection, Keys[i]);
  finally
    Keys.Free;
  end;
end;

end.
