//-----------------------------------------------------------------------------------
//  Trayslator © 2024 by Alexander Tverskoy
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
  fpjson,
  jsonparser,
  Graphics,
  IniFiles,
  mainform,
  translate;

function GetSettingsDirectory(fileName: string = string.Empty): string;

function GetIniDirectory(fileName: string = string.Empty): string;

procedure SaveFormSettings(Form: TformTrayslator);

function LoadFormSettings(Form: TformTrayslator): boolean;

procedure SaveIniSettings(Translate: TTranslate; AFileName: string);

procedure LoadIniSettings(Translate: TTranslate; AFileName: string);

procedure GetIniFiles(List: TStrings);

implementation

uses systemtool, langtool;

function GetSettingsDirectory(fileName: string = string.Empty): string;
  {$IFDEF Windows}
var
  baseDir: string;
  exeDir: string;
  {$ENDIF}
begin
  {$IFDEF Windows}
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

  Result := IncludeTrailingPathDelimiter(baseDir) + 'trayslator\' + fileName;
  {$ELSE}
  // Unix-like systems: use ~/.config/trayslator
  Result := IncludeTrailingPathDelimiter(GetUserDir) + '.config/trayslator/' + fileName;
  {$ENDIF}
end;

function GetIniDirectory(fileName: string = string.Empty): string;
begin
  {$IFDEF Windows}
  Result := ExtractFilePath(ParamStr(0)) + fileName;
  {$ELSE}
  Result := IncludeTrailingPathDelimiter(GetUserDir) + '.config/trayslator/' + filename;
  {$ENDIF}
end;

procedure SaveFormSettings(Form: TformTrayslator);
var
  JSONObj: TJSONObject;
  arrPairs: TJSONArray;
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
    JSONObj.Add('MemoTargetHeight', Form.ScaleFormTo96(Form.MemoTarget.Height));

    JSONObj.Add('FormConfigLeft', Round(Form.FormConfigLeft * 96 / DPI));
    JSONObj.Add('FormConfigTop', Round(Form.FormConfigTop * 96 / DPI));
    JSONObj.Add('FormConfigWidth', Round(Form.FormConfigWidth * 96 / DPI));
    JSONObj.Add('FormConfigHeight', Round(Form.FormConfigHeight * 96 / DPI));

    // Save language
    JSONObj.Add('Language', Language);

    // Save font
    JSONObj.Add('FontName', Form.Font.Name);
    JSONObj.Add('FontSize', Form.Font.Size);
    JSONObj.Add('FontStyle', integer(Form.Font.Style));  // Convert font style to number
    JSONObj.Add('FontCharset', Form.Font.Charset);
    JSONObj.Add('FontColor', Form.Font.Color);
    JSONObj.Add('FontPitch', Ord(Form.Font.Pitch));

    // Save config
    JSONObj.Add('ConfigFile', Form.ConfigFile);
    JSONObj.Add('AutoStart', Form.AutoStart);
    JSONObj.Add('IconBackgroundColor', Form.IconBackgroundColor);
    JSONObj.Add('IconFontColor', Form.IconFontColor);
    JSONObj.Add('IconTwoLang', Form.IconTwoLang);
    JSONObj.Add('LangSource', Form.LangSource);
    JSONObj.Add('LangTarget', Form.LangTarget);

    // Save hotkeys
    JSONObj.Add('HotKeyApp_Modifiers', Form.HotKeyApp.Modifiers);
    JSONObj.Add('HotKeyApp_Key', Form.HotKeyApp.Key);

    JSONObj.Add('HotKeyTransSwap_Modifiers', Form.HotKeyTransSwap.Modifiers);
    JSONObj.Add('HotKeyTransSwap_Key', Form.HotKeyTransSwap.Key);

    JSONObj.Add('HotKeyTransFromClipboard_Modifiers', Form.HotKeyTransFromClipboard.Modifiers);
    JSONObj.Add('HotKeyTransFromClipboard_Key', Form.HotKeyTransFromClipboard.Key);

    JSONObj.Add('HotKeyTransClipboard_Modifiers', Form.HotKeyTransClipboard.Modifiers);
    JSONObj.Add('HotKeyTransClipboard_Key', Form.HotKeyTransClipboard.Key);

    JSONObj.Add('HotKeyTransFromControl_Modifiers', Form.HotKeyTransFromControl.Modifiers);
    JSONObj.Add('HotKeyTransFromControl_Key', Form.HotKeyTransFromControl.Key);

    JSONObj.Add('HotKeyTransControl_Modifiers', Form.HotKeyTransControl.Modifiers);
    JSONObj.Add('HotKeyTransControl_Key', Form.HotKeyTransControl.Key);

    arrPairs := TJSONArray.Create;
    for i := 0 to Form.LangPairs.Count - 1 do
      arrPairs.Add(Form.LangPairs[i]);
    JSONObj.Add('RecentLangPairs', arrPairs);

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
end;

function LoadFormSettings(Form: TformTrayslator): boolean;
var
  JSONData: TJSONData;
  JSONObj: TJSONObject;
  arrPairs: TJSONArray;
  FileName: string;
  FileStream: TFileStream;
  FileContent: string;
  HK: THotKeyData;
  DPI, i: integer;
begin
  Result := False;
  DPI := Screen.PixelsPerInch;
  FileContent := string.Empty;
  FileName := GetSettingsDirectory('form_settings.json'); // Get the settings file name
  if not FileExists(FileName) then Exit; // Exit if the file does not exist

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

      if JSONObj.FindPath('MemoTargetHeight') <> nil then
        Form.MemoTarget.Height := Form.Scale96ToForm(JSONObj.FindPath('MemoTargetHeight').AsInteger);

      if JSONObj.FindPath('FormConfigLeft') <> nil then
        Form.FormConfigLeft := Round(JSONObj.FindPath('FormConfigLeft').AsInteger * DPI / 96);

      if JSONObj.FindPath('FormConfigTop') <> nil then
        Form.FormConfigTop := Round(JSONObj.FindPath('FormConfigTop').AsInteger * DPI / 96);

      if JSONObj.FindPath('FormConfigWidth') <> nil then
        Form.FormConfigWidth := Round(JSONObj.FindPath('FormConfigWidth').AsInteger * DPI / 96);

      if JSONObj.FindPath('FormConfigHeight') <> nil then
        Form.FormConfigHeight := Round(JSONObj.FindPath('FormConfigHeight').AsInteger * DPI / 96);

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
      if JSONObj.FindPath('FontColor') <> nil then
        Form.Font.Color := JSONObj.FindPath('FontColor').AsInteger;
      if JSONObj.FindPath('FontPitch') <> nil then
        Form.Font.Pitch := TFontPitch(JSONObj.FindPath('FontPitch').AsInteger);

      // Load config
      if JSONObj.FindPath('ConfigFile') <> nil then
        Form.ConfigFile := JSONObj.FindPath('ConfigFile').AsString;

      if JSONObj.FindPath('AutoStart') <> nil then
        Form.AutoStart := JSONObj.FindPath('AutoStart').AsBoolean;

      if JSONObj.FindPath('IconBackgroundColor') <> nil then
        Form.IconBackgroundColor := JSONObj.FindPath('IconBackgroundColor').AsInteger;

      if JSONObj.FindPath('IconFontColor') <> nil then
        Form.IconFontColor := JSONObj.FindPath('IconFontColor').AsInteger;

      if JSONObj.FindPath('IconTwoLang') <> nil then
        Form.IconTwoLang := JSONObj.FindPath('IconTwoLang').AsBoolean;

      if (JSONObj.FindPath('LangSource') <> nil) and (JSONObj.FindPath('LangSource').AsString <> string.Empty) then
        Form.LangSource := JSONObj.FindPath('LangSource').AsString;

      if (JSONObj.FindPath('LangTarget') <> nil) and (JSONObj.FindPath('LangTarget').AsString <> string.Empty) then
        Form.LangTarget := JSONObj.FindPath('LangTarget').AsString;

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

      // Load recent language pairs
      Form.LangPairs.Clear;
      if JSONObj.FindPath('RecentLangPairs') <> nil then
      begin
        arrPairs := JSONObj.FindPath('RecentLangPairs') as TJSONArray;
        for i := 0 to arrPairs.Count - 1 do
          Form.LangPairs.Add(arrPairs.Items[i].AsString);
      end;

      Result := True;
    finally
      JSONData.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure SaveIniSettings(Translate: TTranslate; AFileName: string);
var
  Ini: TIniFile;
  i: integer;
  PostDataEscaped: string;
begin
  Ini := TIniFile.Create(AFileName);
  try
    Ini.DeleteKey('Service', 'Name');
    if Trim(Translate.ServiceName) <> string.Empty then
      Ini.WriteString('Service', 'Name', Translate.ServiceName);

    // determine method string based on UsePost property
    if Translate.WebMethod = wmPost then
      Ini.WriteString('Request', 'Method', 'POST')
    else
      Ini.WriteString('Request', 'Method', 'GET');

    Ini.DeleteKey('Request', 'UserAgent');
    if Trim(Translate.UserAgent) <> string.Empty then
      Ini.WriteString('Request', 'UserAgent', Translate.UserAgent);

    Ini.DeleteKey('Request', 'Url');
    if Trim(Translate.Url) <> string.Empty then
      Ini.WriteString('Request', 'Url', Translate.Url);

    Ini.DeleteKey('Request', 'ContentType');
    if Trim(Translate.ContentType) <> string.Empty then
      Ini.WriteString('Request', 'ContentType', Translate.ContentType);

    // Replace line breaks with \r\n for single-line storage
    Ini.DeleteKey('Request', 'PostData');
    if Trim(Translate.PostData) <> string.Empty then
    begin
      PostDataEscaped := StringReplace(Translate.PostData, LineEnding, '\r\n', [rfReplaceAll]);
      Ini.WriteString('Request', 'PostData', PostDataEscaped);
    end;

    Ini.DeleteKey('Request', 'Accept');
    if Trim(Translate.Accept) <> string.Empty then
      Ini.WriteString('Request', 'Accept', Translate.Accept);

    Ini.DeleteKey('Request', 'EncryptText');
    Ini.WriteBool('Request', 'EncryptText', Translate.EncryptText);

    if Translate.ResponseParser = rpJson then
      Ini.WriteString('Response', 'ParserType', 'Json')
    else
      Ini.WriteString('Response', 'ParserType', 'Regexp');

    Ini.DeleteKey('Response', 'Regexp');
    if Trim(Translate.Regexp) <> string.Empty then
      Ini.WriteString('Response', 'Regexp', Translate.Regexp);

    Ini.DeleteKey('Response', 'JsonPointer');
    if Trim(Translate.JsonPointer) <> string.Empty then
      Ini.WriteString('Response', 'JsonPointer', Translate.JsonPointer);

    // Save headers
    Ini.EraseSection('Headers'); // Clear previous entries
    if Assigned(Translate.Headers) then
      for i := 0 to Translate.Headers.Count - 1 do
        Ini.WriteString('Headers',
          Translate.Headers.Names[i],
          Translate.Headers.ValueFromIndex[i]);

    // Save language mappings (code=apiCode)
    Ini.EraseSection('Languages'); // Clear previous entries
    if Assigned(Translate.Languages) then
      for i := 0 to Translate.Languages.Count - 1 do
        Ini.WriteString('Languages',
          Translate.Languages.Names[i],
          Translate.Languages.ValueFromIndex[i]);

    // Save language target mappings (code=apiCode)
    Ini.EraseSection('LanguagesTarget'); // Clear previous entries
    if Assigned(Translate.LanguagesTarget) then
      for i := 0 to Translate.LanguagesTarget.Count - 1 do
        Ini.WriteString('LanguagesTarget',
          Translate.LanguagesTarget.Names[i],
          Translate.LanguagesTarget.ValueFromIndex[i]);
  finally
    Ini.Free;
  end;
end;

procedure LoadIniSettings(Translate: TTranslate; AFileName: string);
var
  Ini: TIniFile;
  Method: string;
  PostDataEscaped: string;
begin
  Ini := TIniFile.Create(AFileName);
  try
    Translate.ServiceName := Ini.ReadString('Service', 'Name', string.Empty);

    Method := Ini.ReadString('Request', 'Method', 'GET');
    if SameText(Method, 'POST') then
      Translate.WebMethod := wmPost
    else
      Translate.WebMethod := wmGet;

    Translate.UserAgent := Ini.ReadString('Request', 'UserAgent', string.Empty);

    Translate.Url := Ini.ReadString('Request', 'Url', string.Empty);

    Translate.ContentType := Ini.ReadString('Request', 'ContentType', string.Empty);

    // Restore line breaks from \r\n
    PostDataEscaped := Ini.ReadString('Request', 'PostData', string.Empty);
    Translate.PostData := StringReplace(PostDataEscaped, '\r\n', LineEnding, [rfReplaceAll]);

    Translate.Accept := Ini.ReadString('Request', 'Accept', string.Empty);

    Translate.EncryptText := Ini.ReadBool('Request', 'EncryptText', True);

    Method := Ini.ReadString('Response', 'ParserType', 'Json');
    if SameText(Method, 'Json') then
      Translate.ResponseParser := rpJson
    else
      Translate.ResponseParser := rpRegEx;

    Translate.Regexp := Ini.ReadString('Response', 'Regexp', string.Empty);
    Translate.JsonPointer := Ini.ReadString('Response', 'JsonPointer', string.Empty);

    Translate.Languages.Clear;
    Ini.ReadSectionValues('Languages', Translate.Languages);
    Translate.LanguagesTarget.Clear;
    Ini.ReadSectionValues('LanguagesTarget', Translate.LanguagesTarget);
    Translate.Headers.Clear;
    Ini.ReadSectionValues('Headers', Translate.Headers);
  finally
    Ini.Free;
  end;
end;

function IsValidIni(const FileName: string): boolean;
var
  Ini: TIniFile;
  Method: string;
  ParserType: string;
begin
  Result := False;

  if not FileExists(FileName) then
    Exit;

  Ini := TIniFile.Create(FileName);
  try
    // Check required keys
    Method := Ini.ReadString('Request', 'Method', string.Empty);
    ParserType := Ini.ReadString('Response', 'ParserType', string.Empty);

    if ((Method = 'GET') or (Method = 'POST')) and ((ParserType = 'Json') or (ParserType = 'Regexp')) then
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

end.
