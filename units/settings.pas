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
    JSONObj.Add('MemoTargetHeight', Form.ScaleFormTo96(Form.PanelTarget.Height));

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
    //JSONObj.Add('FontColor', Form.Font.Color);
    JSONObj.Add('FontPitch', Ord(Form.Font.Pitch));

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
    JSONObj.Add('AutoAddLangPairs', Form.AutoAddLangPairs);
    JSONObj.Add('RecentPairHotKeys', Form.RecentPairHotKeys);
    JSONObj.Add('AutoCheckUpdates', Form.AutoCheckUpdates);

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

  try
    Form.MemoSource.Lines.TrailingLineBreak := False;
    Form.MemoSource.Lines.SaveToFile(GetSettingsDirectory('source.txt'));
    Form.MemoTarget.Lines.TrailingLineBreak := False;
    Form.MemoTarget.Lines.SaveToFile(GetSettingsDirectory('target.txt'));
  except
    // Do nothing if can't save current text files
  end;
end;

function LoadFormSettings(Form: TformTrayslate): boolean;
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

        if JSONObj.FindPath('MemoTargetHeight') <> nil then
          Form.PanelTarget.Height := Form.Scale96ToForm(JSONObj.FindPath('MemoTargetHeight').AsInteger);

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
        //if JSONObj.FindPath('FontColor') <> nil then
        //  Form.Font.Color := JSONObj.FindPath('FontColor').AsInteger;
        if JSONObj.FindPath('FontPitch') <> nil then
          Form.Font.Pitch := TFontPitch(JSONObj.FindPath('FontPitch').AsInteger);

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
          Form.RealTime := JSONObj.FindPath('RealTime').AsBoolean;

        if (JSONObj.FindPath('RealTimeDelay') <> nil) then
          Form.RealTimeDelay := JSONObj.FindPath('RealTimeDelay').AsInteger;

        if (JSONObj.FindPath('AutoSwap') <> nil) then
          Form.AutoSwap := JSONObj.FindPath('AutoSwap').AsBoolean;

        if (JSONObj.FindPath('AutoAddLangPairs') <> nil) then
          Form.AutoAddLangPairs := JSONObj.FindPath('AutoAddLangPairs').AsBoolean;

        if (JSONObj.FindPath('RecentPairHotKeys') <> nil) then
          Form.RecentPairHotKeys := JSONObj.FindPath('RecentPairHotKeys').AsBoolean;

        if (JSONObj.FindPath('AutoCheckUpdates') <> nil) then
          Form.AutoCheckUpdates := JSONObj.FindPath('AutoCheckUpdates').AsBoolean;

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
  Ini: TIniFile;
  i: integer;
  PostDataEscaped: string;
begin
  Ini := TIniFile.Create(AFileName);
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
    Ini.WriteBool('Service', 'AutoSwapLanguage', Translate.ServiceAutoSwap);
    Ini.WriteInteger('Service', 'ColorRecent', Translate.ServiceColorRecent);

    case Translate.ValueType of
      vtNone: Ini.WriteString('Service', 'ValueType', 'None');
      vtLanguage: Ini.WriteString('Service', 'ValueType', 'Language');
      vtCurrencyAll: Ini.WriteString('Service', 'ValueType', 'CurrencyAll');
      vtCurrencyFiat: Ini.WriteString('Service', 'ValueType', 'CurrencyFiat');
      vtCurrencyCrypto: Ini.WriteString('Service', 'ValueType', 'CurrencyCrypto');
      vtUnit: Ini.WriteString('Service', 'ValueType', 'Unit');
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
    Translate.ServiceAutoSwap := Ini.ReadBool('Service', 'AutoSwapLanguage', False);
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
