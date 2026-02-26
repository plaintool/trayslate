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
  Graphics,
  IniFiles,
  mainform,
  translate;

procedure SaveFormSettings(Form: TformTrayslator);

function LoadFormSettings(Form: TformTrayslator): boolean;

procedure SaveIniSettings(Form: TformTrayslator; Translate: TTranslate);

procedure LoadIniSettings(Form: TformTrayslator; Translate: TTranslate);

implementation

uses systemtool, formattool;

function GetSettingsDirectory(fileName: string = ''): string;
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

function GetIniDirectory(fileName: string = ''): string;
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
    JSONObj.Add('Language', Language);

    // Write to file
    with TStringList.Create do
    try
      Add(JSONObj.AsJSON);
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

      if JSONObj.FindPath('Language') <> nil then
      begin
        if (JSONObj.FindPath('Language').AsString <> string.Empty) and (Language <> JSONObj.FindPath('Language').AsString) then
          Language := JSONObj.FindPath('Language').AsString;
      end;

      Result := True;
    finally
      JSONData.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure SaveIniSettings(Form: TformTrayslator; Translate: TTranslate);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(GetIniDirectory('google.ini'));
  try
    Ini.WriteString('Translate', 'Source', Translate.SourceLang);
    Ini.WriteString('Translate', 'Target', Translate.TargetLang);

    // determine method string based on UsePost property
    if Translate.RequestType = rtPost then
      Ini.WriteString('Request', 'Method', 'POST')
    else
      Ini.WriteString('Request', 'Method', 'GET');

    Ini.WriteString('Request', 'Url', Translate.Url);
    Ini.WriteString('Request', 'PostData', Translate.PostData);
    Ini.WriteString('Request', 'UserAgent', Translate.UserAgent);
    Ini.WriteString('Request', 'ContentType', Translate.ContentType);

    if Translate.ResponseParserType = rpJson then
      Ini.WriteString('Response', 'ParserType', 'Json')
    else
      Ini.WriteString('Response', 'ParserType', 'Regexp');

    Ini.WriteString('Response', 'Regex', Translate.RegexPattern);

    Ini.WriteString('TrayIcon', 'BackgroundColor', ColorToHtml(Form.IconBackgroundColor));
    Ini.WriteString('TrayIcon', 'FontColor', ColorToHtml(Form.IconFontColor));
    Ini.WriteBool('TrayIcon', 'TwoLang', Form.IconTwoLang);
  finally
    Ini.Free;
  end;
end;

procedure LoadIniSettings(Form: TformTrayslator; Translate: TTranslate);
var
  Ini: TIniFile;
  Method: string;
begin
  Ini := TIniFile.Create(GetIniDirectory('google.ini'));
  try
    Translate.SourceLang := Ini.ReadString('Translate', 'Source', Translate.SourceLang);
    Translate.TargetLang := Ini.ReadString('Translate', 'Target', Translate.TargetLang);

    // read method and assign UsePost accordingly
    Method := Ini.ReadString('Request', 'Method', 'GET');
    if (SameText(Method, 'POST')) then
      Translate.RequestType := rtPost
    else
      Translate.RequestType := rtGet;

    // read URL
    Translate.Url := Ini.ReadString('Request', 'Url', Translate.Url);
    Translate.PostData := Ini.ReadString('Request', 'PostData', Translate.PostData);
    Translate.UserAgent := Ini.ReadString('Request', 'UserAgent', Translate.UserAgent);
    Translate.ContentType := Ini.ReadString('Request', 'ContentType', Translate.ContentType);

    Method := Ini.ReadString('Response', 'ParserType', 'Json');
    if (SameText(Method, 'Json')) then
      Translate.ResponseParserType := rpJson
    else
      Translate.ResponseParserType := rpRegEx;

    Translate.RegexPattern := Ini.ReadString('Response', 'Regex', Translate.RegexPattern);

    Form.IconBackgroundColor := ColorFromHtml(Ini.ReadString('TrayIcon', 'BackgroundColor', ColorToHtml(Form.IconBackgroundColor)));
    Form.IconFontColor := ColorFromHtml(Ini.ReadString('TrayIcon', 'FontColor', ColorToHtml(Form.IconFontColor)));
    Form.IconTwoLang := Ini.ReadBool('TrayIcon', 'TwoLang', Form.IconTwoLang);
  finally
    Ini.Free;
  end;
end;

end.
