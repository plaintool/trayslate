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

function GetIniDirectory(fileName: string = string.Empty): string;

procedure SaveFormSettings(Form: TformTrayslator);

function LoadFormSettings(Form: TformTrayslator): boolean;

procedure SaveIniSettings(Translate: TTranslate; AFileName: string);

procedure LoadIniSettings(Translate: TTranslate; AFileName: string);

procedure GetIniFiles(List: TStrings);

implementation

uses systemtool;

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
  FileName: string;
begin
  FileName := GetSettingsDirectory('form_settings.json'); // Get settings file name
  ForceDirectories(GetSettingsDirectory); // Ensure the directory exists
  JSONObj := TJSONObject.Create;
  try
    // Save form position and size
    if (Form.WindowState in [wsMaximized, wsMinimized]) then
    begin
      JSONObj.Add('Left', Form.RestoredLeft);
      JSONObj.Add('Top', Form.RestoredTop);
      JSONObj.Add('Width', Form.RestoredWidth);
      JSONObj.Add('Height', Form.RestoredHeight);
    end
    else
    begin
      JSONObj.Add('Left', Form.Left);
      JSONObj.Add('Top', Form.Top);
      JSONObj.Add('Width', Form.Width);
      JSONObj.Add('Height', Form.Height);
    end;
    JSONObj.Add('WindowState', Ord(Form.WindowState));
    JSONObj.Add('MemoTargetHeight', Form.MemoTarget.Height);

    JSONObj.Add('FormConfigLeft', Form.FormConfigLeft);
    JSONObj.Add('FormConfigTop', Form.FormConfigTop);
    JSONObj.Add('FormConfigWidth', Form.FormConfigWidth);
    JSONObj.Add('FormConfigHeight', Form.FormConfigHeight);

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
    JSONObj.Add('IconBackgroundColor', Form.IconBackgroundColor);
    JSONObj.Add('IconFontColor', Form.IconFontColor);
    JSONObj.Add('IconTwoLang', Form.IconTwoLang);
    JSONObj.Add('LangSource', Form.LangSource);
    JSONObj.Add('LangTarget', Form.LangTarget);
    JSONObj.Add('AutoStart', Form.AutoStart);

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
  FileName: string;
  FileStream: TFileStream;
  FileContent: string;
begin
  Result := False;
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
        Form.Left := JSONObj.FindPath('Left').AsInteger;

      if JSONObj.FindPath('Top') <> nil then
        Form.Top := JSONObj.FindPath('Top').AsInteger;

      if JSONObj.FindPath('Width') <> nil then
        Form.Width := JSONObj.FindPath('Width').AsInteger;

      if JSONObj.FindPath('Height') <> nil then
        Form.Height := JSONObj.FindPath('Height').AsInteger;

      if JSONObj.FindPath('WindowState') <> nil then
        Form.WindowState := TWindowState(JSONObj.FindPath('WindowState').AsInteger);

      if JSONObj.FindPath('MemoTargetHeight') <> nil then
        Form.MemoTarget.Height := JSONObj.FindPath('MemoTargetHeight').AsInteger;

      if JSONObj.FindPath('FormConfigLeft') <> nil then
        Form.FormConfigLeft := JSONObj.FindPath('FormConfigLeft').AsInteger;

      if JSONObj.FindPath('FormConfigTop') <> nil then
        Form.FormConfigTop := JSONObj.FindPath('FormConfigTop').AsInteger;

      if JSONObj.FindPath('FormConfigWidth') <> nil then
        Form.FormConfigWidth := JSONObj.FindPath('FormConfigWidth').AsInteger;

      if JSONObj.FindPath('FormConfigHeight') <> nil then
        Form.FormConfigHeight := JSONObj.FindPath('FormConfigHeight').AsInteger;

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

      if JSONObj.FindPath('AutoStart') <> nil then
        Form.AutoStart := JSONObj.FindPath('AutoStart').AsBoolean;

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
begin
  Ini := TIniFile.Create(AFileName);
  try
    // determine method string based on UsePost property
    if Translate.WebMethod = wmPost then
      Ini.WriteString('Request', 'Method', 'POST')
    else
      Ini.WriteString('Request', 'Method', 'GET');

    Ini.WriteString('Request', 'Url', Translate.Url);
    Ini.WriteString('Request', 'PostData', Translate.PostData);
    Ini.WriteString('Request', 'UserAgent', Translate.UserAgent);
    Ini.WriteString('Request', 'ContentType', Translate.ContentType);

    if Translate.ResponseParser = rpJson then
      Ini.WriteString('Response', 'ParserType', 'Json')
    else
      Ini.WriteString('Response', 'ParserType', 'Regexp');

    Ini.WriteString('Response', 'Regexp', Translate.Regexp);

    // Save language mappings (code=apiCode)
    Ini.EraseSection('Languages'); // Clear previous entries
    if Assigned(Translate.Languages) then
      for i := 0 to Translate.Languages.Count - 1 do
        Ini.WriteString('Languages', Translate.Languages.Names[i], Translate.Languages.ValueFromIndex[i]);
  finally
    Ini.Free;
  end;
end;

procedure LoadIniSettings(Translate: TTranslate; AFileName: string);
var
  Ini: TIniFile;
  Method: string;
begin
  Ini := TIniFile.Create(AFileName);
  try
    // read method and assign UsePost accordingly
    Method := Ini.ReadString('Request', 'Method', 'GET');
    if (SameText(Method, 'POST')) then
      Translate.WebMethod := wmPost
    else
      Translate.WebMethod := wmGet;

    // read URL
    Translate.Url := Ini.ReadString('Request', 'Url', Translate.Url);
    Translate.PostData := Ini.ReadString('Request', 'PostData', Translate.PostData);
    Translate.UserAgent := Ini.ReadString('Request', 'UserAgent', Translate.UserAgent);
    Translate.ContentType := Ini.ReadString('Request', 'ContentType', Translate.ContentType);

    Method := Ini.ReadString('Response', 'ParserType', 'Json');
    if (SameText(Method, 'Json')) then
      Translate.ResponseParser := rpJson
    else
      Translate.ResponseParser := rpRegEx;

    Translate.Regexp := Ini.ReadString('Response', 'Regexp', Translate.Regexp);

    Ini.ReadSectionValues('Languages', Translate.Languages);
  finally
    Ini.Free;
  end;
end;

function IsValidIni(const FileName: string): boolean;
var
  Ini: TIniFile;
  Method: string;
  Url: string;
  ParserType: string;
begin
  Result := False;

  if not FileExists(FileName) then
    Exit;

  Ini := TIniFile.Create(FileName);
  try
    // Check required keys
    Method := Ini.ReadString('Request', 'Method', '');
    Url := Ini.ReadString('Request', 'Url', '');
    ParserType := Ini.ReadString('Response', 'ParserType', '');

    if (Method <> '') and ((Method = 'GET') or (Method = 'POST')) and (Url <> '') and
      ((ParserType = 'Json') or (ParserType = 'Regexp')) then
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

  if FindFirst(IncludeTrailingPathDelimiter(Dir) + '*.ini', faAnyFile, SR) = 0 then
  begin
    repeat
      FilePath := IncludeTrailingPathDelimiter(Dir) + SR.Name;

      if IsValidIni(FilePath) then
        List.Add(FilePath);

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
