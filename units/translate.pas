//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit translate;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  Forms,
  SysUtils,
  StdCtrls,
  RegExpr,
  StrUtils,
  Controls,
  DateUtils,
  Graphics,
  ExtCtrls,
  LazUTF8,
  IniFiles,
  fpjson,
  jsonparser,
  scriptrunner,
  network;

type
  { TValueType}
  TValueType = (
    vtNone,            // as is
    vtLanguage,        // languages
    vtCurrencyAll,     // fiat + crypto
    vtCurrencyFiat,    // fiat only
    vtCurrencyCrypto,  // crypto only
    vtUnit             // units of measure
    );

  { TTranslate }
  TTranslate = class
  private
    FLangSource: string;
    FLangTarget: string;
    FTextToTranslate: string;
    FIsTruncated: boolean;
    FCookies: TStringList;

    FServiceName: string;
    FServiceIcon: string;
    FServiceOrder: integer;
    FServiceVisible: boolean;
    FServiceAutoSwap: boolean;
    FServiceRealTime: boolean;
    FServiceOnlyButton: boolean;
    FServiceProxy: boolean;
    FWebMethod: TWebMethod;
    FUserAgent: string;
    FHeaders: TStringList;
    FCustomParameters: TStringList;
    FScriptParameters: TStringList;
    FServiceColorRecent: TColor;
    FServiceDescription: TStringList;
    FEncodeText: boolean;
    FMaxLength: integer;
    FEncodeCustomParameters: boolean;
    FUrl: string;
    FContentType: string;
    FPostData: string;
    FAccept: string;
    FJsonPointer: string;
    FRegexp: string;
    FLanguages: TStringList;
    FLanguagesTarget: TStringList;
    FValueType: TValueType;
    FProxy: TProxy;
    FTimeout: TTimeout;

    FInitUserAgent: string;
    FInitHeaders: TStringList;
    FInitUrl: string;
    FInitParameters: TStringList;
    FInitLiveTime: integer;
    FParameterValues: TStringList;
    FParameterEncode: TStringList;

    FParametersAge: TDateTime;

    FParamName: string;
    FResultValue: string;
    FResultOk: boolean;
    procedure SyncGetParameterValue;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure ExecuteScript;
    function GetParameters(Data: string): boolean;
    function SetParameters(Data: string; IncludeSet: boolean = True): string;
    procedure SetParametersList(Strings: TStrings);
    function GetInit: string;
    function Get(ReturnHeaders: boolean = False): string;
    function Post(ReturnHeaders: boolean = False): string;
    function ParseJsonByPointer(const JsonStr, JsonPointer: string): string;
    function ParseResponse(content: string): string;
    function Translate: string;

    { Ini config }
    procedure SaveIniSettings(AFileName: string);
    procedure LoadIniSettings(AFileName: string);
    class function IsValidIni(const FileName: string): boolean; static;
    class procedure FindIniFiles(const Dir: string; List: TStrings); static;
    class procedure GetIniFiles(List: TStrings); static;
    class function GetConfigFullPath(const ConfigName: string; ConfigFiles: TStringList): string; static;
    class function ConfigSortByOrderPathName(List: TStringList; Index1, Index2: integer): integer; static;
    class procedure ClearSection(AIni: TIniFile; const ASection: string; AErase: boolean); static;
    class function GetIniDirectory(fileName: string = string.Empty): string; static;

    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property TextToTranslate: string read FTextToTranslate write FTextToTranslate;
    property ParametersAge: TDateTime read FParametersAge write FParametersAge;
    property ParameterValues: TStringList read FParameterValues write FParameterValues;
    property ParameterEncode: TStringList read FParameterEncode write FParameterEncode;

    property ServiceName: string read FServiceName write FServiceName;
    property ServiceIcon: string read FServiceIcon write FServiceIcon;
    property ServiceOrder: integer read FServiceOrder write FServiceOrder;
    property ServiceVisible: boolean read FServiceVisible write FServiceVisible;
    property ServiceAutoSwap: boolean read FServiceAutoSwap write FServiceAutoSwap;
    property ServiceRealTime: boolean read FServiceRealTime write FServiceRealTime;
    property ServiceOnlyButton: boolean read FServiceOnlyButton write FServiceOnlyButton;
    property ServiceProxy: boolean read FServiceProxy write FServiceProxy;
    property ServiceColorRecent: TColor read FServiceColorRecent write FServiceColorRecent;
    property ServiceDescription: TStringList read FServiceDescription write FServiceDescription;
    property WebMethod: TWebMethod read FWebMethod write FWebMethod;
    property UserAgent: string read FUserAgent write FUserAgent;
    property Headers: TStringList read FHeaders write FHeaders;
    property EncodeText: boolean read FEncodeText write FEncodeText;
    property MaxLength: integer read FMaxLength write FMaxLength;
    property Url: string read FUrl write FUrl;
    property ContentType: string read FContentType write FContentType;
    property PostData: string read FPostData write FPostData;
    property Accept: string read FAccept write FAccept;
    property JsonPointer: string read FJsonPointer write FJsonPointer;
    property EncodeCustomParameters: boolean read FEncodeCustomParameters write FEncodeCustomParameters;
    property CustomParameters: TStringList read FCustomParameters write FCustomParameters;
    property ScriptParameters: TStringList read FScriptParameters write FScriptParameters;
    property Proxy: TProxy read FProxy write FProxy;
    property Timeout: TTimeout read FTimeout write FTimeout;

    // Languages from config, eg en=en
    property Languages: TStringList read FLanguages write FLanguages;
    property LanguagesTarget: TStringList read FLanguagesTarget write FLanguagesTarget;
    property ValueType: TValueType read FValueType write FValueType;

    property InitUserAgent: string read FInitUserAgent write FInitUserAgent;
    property InitHeaders: TStringList read FInitHeaders write FInitHeaders;
    property InitUrl: string read FInitUrl write FInitUrl;
    property InitParameters: TStringList read FInitParameters write FInitParameters;
    property InitLiveTime: integer read FInitLiveTime write FInitLiveTime;
  end;

  { TTranslateThread }
  TTranslateThread = class(TThread)
  private
    FTrans: TTranslate;
    FMemo: TMemo;
    FTimer: TTimer;
    FSourceText: string;
    FResultText: string;
    FResultTextSync: string;
    FException: Exception;
    FCancelled: boolean;
  protected
    procedure BeforeExecute;
    procedure Execute; override;
    procedure AfterExecute;
  public
    constructor Create(ATrans: TTranslate; AMemo: TMemo = nil; ATimer: TTimer = nil; AFreeOnTerminate: boolean = True);
    destructor Destroy; override;
    procedure Cancel;
    property ExceptionObj: Exception read FException;
    property ResultText: string read FResultText;
    property ResultTextSync: string read FResultTextSync;
  end;

const
  DEFAULT_LANG = 'en';
  EMPTY_LANG = 'empty';
  REGEXP_ERROR = 'REGEX_ERROR: ';

implementation

uses mainform, settings, stringshelper, stringhelper, localize, osutils;

  {%Region -fold TTranslate }

constructor TTranslate.Create;
begin
  inherited Create;
  FServiceName := 'default';
  FServiceIcon := string.Empty;
  FServiceColorRecent := clBlue;
  FServiceVisible := True;
  FServiceAutoSwap := False;
  FServiceRealTime := False;
  FServiceOnlyButton := False;
  FWebMethod := wmGet;
  FUserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0';
  FHeaders := TStringList.Create;
  FHeaders.Duplicates := dupAccept;
  FHeaders.TrailingLineBreak := False;
  FHeaders.SkipLastLineBreak := True;
  FCustomParameters := TStringList.Create;
  FCustomParameters.TrailingLineBreak := False;
  FCustomParameters.SkipLastLineBreak := True;
  FScriptParameters := TStringList.Create;
  FScriptParameters.TrailingLineBreak := False;
  FScriptParameters.SkipLastLineBreak := True;
  FServiceDescription := TStringList.Create;
  FServiceDescription.TrailingLineBreak := False;
  FServiceDescription.SkipLastLineBreak := True;
  FEncodeText := True;
  FMaxLength := 0;
  FUrl := string.Empty;
  FContentType := 'application/json';
  FPostData := string.Empty;
  FAccept := 'application/json';
  FJsonPointer := '/0/*/0';
  FRegexp := string.Empty;
  FLanguages := TStringList.Create;
  FLanguages.TrailingLineBreak := False;
  FLanguages.SkipLastLineBreak := True;
  FLanguagesTarget := TStringList.Create;
  FLanguagesTarget.TrailingLineBreak := False;
  FLanguagesTarget.SkipLastLineBreak := True;
  FValueType := vtLanguage;

  FInitUserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0';
  FInitHeaders := TStringList.Create;
  FInitHeaders.TrailingLineBreak := False;
  FInitHeaders.SkipLastLineBreak := True;
  FInitUrl := string.Empty;
  FInitParameters := TStringList.Create;
  FInitParameters.TrailingLineBreak := False;
  FInitParameters.SkipLastLineBreak := True;
  FParameterValues := TStringList.Create;
  FParameterValues.TrailingLineBreak := False;
  FParameterValues.SkipLastLineBreak := True;
  FParameterEncode := TStringList.Create;
  FParameterEncode.TrailingLineBreak := False;
  FParameterEncode.SkipLastLineBreak := True;
  FInitLiveTime := 60;

  FLangSource := DEFAULT_LANG;
  FLangTarget := Language;
  FCookies := TStringList.Create;
end;

destructor TTranslate.Destroy;
begin
  FreeAndNil(FCookies);
  FreeAndNil(FHeaders);
  FreeAndNil(FCustomParameters);
  FreeAndNil(FScriptParameters);
  FreeAndNil(FServiceDescription);
  FreeAndNil(FLanguages);
  FreeAndNil(FLanguagesTarget);

  FInitHeaders.Free;
  FInitParameters.Free;
  FParameterValues.Free;
  FParameterEncode.Free;
  inherited Destroy;
end;

procedure TTranslate.SyncGetParameterValue;
begin
  if not Application.Terminated and Assigned(formTrayslate) then
    FResultValue := formTrayslate.GetParameterValue(FParamName, FResultOk);
end;

procedure TTranslate.Clear;
begin
  FServiceName := string.Empty;
  FServiceIcon := string.Empty;
  FServiceOrder := 0;
  FServiceVisible := True;
  FServiceAutoSwap := False;
  FServiceRealTime := False;
  FServiceOnlyButton := False;
  FServiceProxy := True;
  FServiceColorRecent := clBlue;
  FServiceDescription.Clear;
  FWebMethod := wmGet;
  FUserAgent := string.Empty;
  FHeaders.Clear;
  FEncodeText := False;
  FMaxLength := 0;
  FUrl := string.Empty;
  FContentType := string.Empty;
  FPostData := string.Empty;
  FAccept := string.Empty;
  FJsonPointer := string.Empty;
  FEncodeCustomParameters := False;
  FCustomParameters.Clear;
  FScriptParameters.Clear;
  FValueType := vtNone;
  FLanguages.Clear;
  FLanguagesTarget.Clear;
  FInitUserAgent := string.Empty;
  FInitHeaders.Clear;
  FInitUrl := string.Empty;
  FInitParameters.Clear;
  FInitLiveTime := 0;
  FServiceIcon := string.Empty;
end;

procedure TTranslate.ExecuteScript;
var
  Runner: TScriptRunner;
  i: integer;
begin
  if FScriptParameters.Count = 0 then Exit;

  // 1. Create the script runner instance
  Runner := TScriptRunner.Create;
  try
    // 2. Load the script source
    Runner.LoadScript(FScriptParameters);

    // 3. Pass input parameters
    Runner.Params.Assign(FParameterValues);

    // 4. Compile and run the script
    Runner.Execute;   // automatically compiles if needed

    // 5. Retrieve all outputs in a loop
    for i := 0 to Runner.OutputList.Count - 1 do
      FParameterValues.Values[Runner.OutputList.Names[i]] := Runner.OutputList.ValueFromIndex[i];
  finally
    Runner.Free;
  end;
end;

function TTranslate.GetParameters(Data: string): boolean;
var
  i: integer;
  ParamName: string;
  RegExpStr: string;
  R: TRegExpr;
  Value: string;
  FullRandom: int64;
begin
  Result := True;

  // User parameters {key=value}
  if Assigned(formTrayslate) then
    with formTrayslate do
      if Assigned(UserParameters) and (UserParameters.Count > 0) then
      begin
        for i := 0 to UserParameters.Count - 1 do
        begin
          ParamName := UserParameters.Names[i];
          Value := UserParameters.ValueFromIndex[i];

          // Skip empty parameters
          if (ParamName = string.Empty) or (Value = string.Empty) then
            Continue;

          // Add or override parameter
          FParameterValues.Values[ParamName] := Value;
          FParameterEncode.Values[ParamName] := ifthen(FEncodeCustomParameters, '1', '0');
        end;
      end;

  // Custom parameters (key=value)
  if Assigned(FCustomParameters) then
  begin
    for i := 0 to FCustomParameters.Count - 1 do
    begin
      ParamName := FCustomParameters.Names[i];
      Value := FCustomParameters.ValueFromIndex[i];

      if Trim(Value) = string.Empty then
      begin
        // Store parameters in fields of the current class
        Self.FParamName := ParamName;

        // Synchronize using the current thread context
        TThread.Synchronize(TThread.CurrentThread, @Self.SyncGetParameterValue);
        if Application.Terminated then Exit;

        // Get the result
        Result := FResultOk;
        Value := Self.FResultValue;
      end;

      // Skip empty keys
      if ParamName = string.Empty then
        Continue;

      // Add or override parameter
      FParameterValues.Values[ParamName] := Value;
      FParameterEncode.Values[ParamName] := ifthen(FEncodeCustomParameters, '1', '0');
    end;
  end;

  FIsTruncated := False;
  if FTextToTranslate <> string.Empty then
  begin
    if (FMaxLength > 0) then
    begin
      FParameterValues.Values['text'] := FTextToTranslate.Utf8TruncateWithEncoding(FMaxLength, FEncodeText);
      FIsTruncated := Length(FParameterValues.Values['text']) < Length(FTextToTranslate);
    end
    else
      FParameterValues.Values['text'] := FTextToTranslate;
  end
  else
    FParameterValues.Values['text'] := string.Empty;
  FParameterEncode.Values['text'] := ifthen(FEncodeText, '1', '0');

  FParameterValues.Values['source'] := ifthen(FLangSource = EMPTY_LANG, string.Empty, FLangSource);
  FParameterValues.Values['target'] := FLangTarget;

  // TimeStamp
  FParameterValues.Values['timestamp'] := TOS.GetTimestamp.ToString;

  // Random
  FullRandom := TOS.GetRandom(9);
  FParameterValues.Values['random'] := FullRandom.ToString;
  FParameterValues.Values['rand'] := FullRandom.ToString;
  for i := 1 to Length(FullRandom.ToString) do
    FParameterValues.Values['rand' + IntToStr(i)] := Copy(FullRandom.ToString, 1, i);

  // ScriptParameters
  ExecuteScript;

  // Extract additional parameters using regex
  if not Assigned(FInitParameters) or (Data = string.Empty) or (SecondsBetween(Now, FParametersAge) < FInitLiveTime) then
    Exit;

  R := TRegExpr.Create;
  try
    for i := 0 to FInitParameters.Count - 1 do
    begin
      ParamName := FInitParameters.Names[i];
      RegExpStr := FInitParameters.ValueFromIndex[i];

      R.Expression := RegExpStr;

      if R.Exec(Data) then
      begin
        // Use first captured group if exists, otherwise full match
        if R.SubExprMatchCount >= 1 then
          Value := R.Match[1]
        else
          Value := R.Match[0];

        // Only add parameter if value is not empty
        if Value <> string.Empty then
          FParameterValues.Values[ParamName] := Value;
      end;
    end;
  finally
    R.Free;
    FParametersAge := Now;
  end;
end;

function TTranslate.SetParameters(Data: string; IncludeSet: boolean = True): string;
var
  i: integer;
  ParamName: string;
  ParamValue: string;

  function Encode(AName, AValue: string): string;
  begin
    if (ParameterEncode.IndexOfName(AName) <> -1) then
    begin
      if (ParameterEncode.Values[AName] = '1') then
        Result := AValue.EncodeURLElement
      else
        Result := AValue.EscapeText;
    end
    else
      Result := AValue;
  end;

begin
  Result := Data;

  if not Assigned(FParameterValues) then
    Exit;

  for i := 0 to FParameterValues.Count - 1 do
  begin
    ParamName := FParameterValues.Names[i];
    ParamValue := FParameterValues.ValueFromIndex[i].RemoveTrailingLineBreak;

    if IncludeSet and (Pos('{', ParamValue) > 0) and (Pos('}', ParamValue) > 0) then
      ParamValue := SetParameters(ParamValue, False);

    // Replace all occurrences of {name} with value
    Result := StringReplace(Result, '{' + ParamName + '}', Encode(ParamName, ParamValue), [rfReplaceAll]);

    // lowercase {!param}
    Result := StringReplace(Result, '{!' + ParamName + '}', Encode(ParamName, UTF8LowerCase(ParamValue)), [rfReplaceAll]);

    // UPPERCASE {^param}
    Result := StringReplace(Result, '{^' + ParamName + '}', Encode(ParamName, UTF8UpperCase(ParamValue)), [rfReplaceAll]);
  end;
end;

procedure TTranslate.SetParametersList(Strings: TStrings);
var
  i: integer;
begin
  if not Assigned(Strings) then Exit;

  for i := 0 to Strings.Count - 1 do
    Strings[i] := SetParameters(Strings[i]);
end;

function TTranslate.GetInit: string;
var
  responseHeaders: TStringList;
  responseBody: string;
  i: integer;
  header: string;
  Error: boolean;
begin
  Result := string.Empty;
  if FInitUrl = string.Empty then Exit;
  if SecondsBetween(Now, FParametersAge) < FInitLiveTime then Exit;
  FParameterValues.Clear;
  FCookies.Clear;

  responseBody := TNetwork.WebRequest(wmGet, FInitUrl, string.Empty, InitHeaders, FInitUserAgent, string.Empty,
    string.Empty, FServiceProxy, FProxy, FTimeout, FCookies, responseHeaders, Error);
  try
    if Error then Exit(responseBody);

    // Build header string from response headers
    header := string.Empty;
    for i := 0 to responseHeaders.Count - 1 do
      header := header + responseHeaders[i] + LineEnding;

    Result := header + LineEnding + responseBody;
  finally
    responseHeaders.Free;
  end;
end;

function TTranslate.Get(ReturnHeaders: boolean = False): string;
var
  responseHeaders: TStringList;
  responseBody: string;
  TempUrl: string;
  TempHeaders: TStringList;
  i: integer;
  header: string;
  Error: boolean;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  try
    if not GetParameters(GetInit) or Application.Terminated then
      Exit;

    TempUrl := FUrl;
    TempUrl := SetParameters(TempUrl);
    if (FLangSource = EMPTY_LANG) or (FLangSource = EMPTY_LANG) then
      TempUrl := TempUrl.RemoveEmptyParams;

    // Prepare custom headers with parameter substitution
    TempHeaders := nil;
    if Assigned(Headers) then
    begin
      TempHeaders := TStringList.Create;
      TempHeaders.Duplicates := dupAccept;
      TempHeaders.Assign(Headers);
      SetParametersList(TempHeaders);
    end;
    responseBody := TNetwork.WebRequest(wmGet, TempUrl, string.Empty, TempHeaders, FUserAgent, FContentType,
      FAccept, FServiceProxy, FProxy, FTimeout, FCookies, responseHeaders, Error);
    try
      if Error then
      begin
        FCookies.Clear;
        FParametersAge := 0;
        Exit(responseBody);
      end;

      // Optionally prepend headers
      if ReturnHeaders then
      begin
        header := string.Empty;
        for i := 0 to responseHeaders.Count - 1 do
          header := header + responseHeaders[i] + LineEnding;
        Result := header + LineEnding + responseBody;
      end
      else
        Result := responseBody;

    finally
      TempHeaders.Free;
      responseHeaders.Free;
    end;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

function TTranslate.Post(ReturnHeaders: boolean = False): string;
var
  responseHeaders: TStringList;
  responseBody: string;
  TempData: string;
  TempUrl: string;
  TempHeaders: TStringList;
  i: integer;
  header: string;
  Error: boolean;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  try
    if not GetParameters(GetInit) or Application.Terminated then
      Exit;

    TempUrl := FUrl;
    TempUrl := SetParameters(TempUrl);
    TempData := FPostData;
    TempData := SetParameters(TempData);

    if (FLangSource = EMPTY_LANG) or (FLangSource = EMPTY_LANG) then
    begin
      TempUrl := TempUrl.RemoveEmptyParams;
      TempData := TempData.RemoveEmptyParams;
    end;

    // Prepare custom headers with parameter substitution
    TempHeaders := nil;
    if Assigned(Headers) then
    begin
      TempHeaders := TStringList.Create;
      TempHeaders.Duplicates := dupAccept;
      TempHeaders.Assign(Headers);
      SetParametersList(TempHeaders);
    end;

    responseBody := TNetwork.WebRequest(wmPost, TempUrl, TempData, TempHeaders, FUserAgent, FContentType,
      FAccept, FServiceProxy, FProxy, FTimeout, FCookies, responseHeaders, Error);
    try
      if Error then
      begin
        FCookies.Clear;
        FParametersAge := 0;
        Exit(responseBody);
      end;

      if ReturnHeaders then
      begin
        header := string.Empty;
        for i := 0 to responseHeaders.Count - 1 do
          header := header + responseHeaders[i] + LineEnding;
        Result := header + LineEnding + responseBody;
      end
      else
        Result := responseBody;

    finally
      TempHeaders.Free;
      responseHeaders.Free;
    end;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

function TTranslate.ParseJsonByPointer(const JsonStr, JsonPointer: string): string;
var
  Data: TJSONData;

  function Traverse(Data: TJSONData; PathParts: TStringList; Level: integer): string;
  var
    Key: string;
    i: integer;
    Arr: TJSONArray;
    Obj: TJSONObject;
    SubResult: string;
    Child: TJSONData;
    ExtValue: extended;
  begin
    Result := string.Empty;
    if Data = nil then Exit;

    // --- NEW: Handle ~ (Return current branch as JSON string) ---
    if (Level < PathParts.Count) and (PathParts[Level] = '~') then
    begin
      Result := Data.AsJSON;
      Exit;
    end;

    // If we have reached the end of the path, return the value
    if Level >= PathParts.Count then
    begin
      case Data.JSONType of
        jtString:
          Result := Data.AsString;
        jtBoolean:
          Result := Data.AsString;
        jtNumber:
        begin
          ExtValue := TJSONNumber(Data).AsFloat; // get number as Extended
          Result := Format('%0.*g', [17, ExtValue]); // 17 digits precision
        end;
        jtArray:
        begin
          Arr := TJSONArray(Data);
          for i := 0 to Arr.Count - 1 do
          begin
            SubResult := Traverse(Arr.Items[i], PathParts, Level);
            if SubResult <> string.Empty then
            begin
              if Result <> string.Empty then
                Result := Result + #10;
              Result := Result + SubResult;
            end;
          end;
        end;
        // Return object as JSON if path ends on an object
        jtObject: Result := Data.AsJSON;
        else
          ;
      end;
      Exit;
    end;

    Key := PathParts[Level];

    // Decoding special characters JSON Pointer (RFC 6901)
    Key := StringReplace(Key, '~1', '/', [rfReplaceAll]);
    Key := StringReplace(Key, '~0', '~', [rfReplaceAll]);

    case Data.JSONType of
      jtObject:
      begin
        Obj := TJSONObject(Data);

        // 1. Processing Wildcard for an object (take all properties)
        if (Key = '*') or (Key = '*#10') then
        begin
          for i := 0 to Obj.Count - 1 do
          begin
            SubResult := Traverse(Obj.Items[i], PathParts, Level + 1);
            if SubResult <> string.Empty then
            begin
              if (Result <> string.Empty) and (Key = '*#10') then
                Result := Result + #10;
              Result := Result + SubResult;
            end;
          end;
        end
        else
        begin
          // 2. Search by key name
          Child := Obj.Find(Key);
          if Child <> nil then
            Result := Traverse(Child, PathParts, Level + 1)
          else
          begin
            // 3. If you can’t find it by name, try to interpret the key as an index
            i := StrToIntDef(Key, -1);
            if (i >= 0) and (i < Obj.Count) then
              Result := Traverse(Obj.Items[i], PathParts, Level + 1);
          end;
        end;
      end;

      jtArray:
      begin
        Arr := TJSONArray(Data);
        if (Key = '*') or (Key = '*#10') then
        begin
          for i := 0 to Arr.Count - 1 do
          begin
            SubResult := Traverse(Arr.Items[i], PathParts, Level + 1);
            if SubResult <> string.Empty then
            begin
              if (Result <> string.Empty) and (Key = '*#10') then
                Result := Result + #10;
              Result := Result + SubResult;
            end;
          end;
        end
        else
        begin
          i := StrToIntDef(Key, -1);
          if (i >= 0) and (i < Arr.Count) then
            Result := Traverse(Arr.Items[i], PathParts, Level + 1);
        end;
      end;
      else
        ;
    end;
  end;

var
  PathParts: TStringList;
begin
  Result := string.Empty;
  if Trim(JsonStr) = string.Empty then Exit;
  if (JsonPointer = '~') or (JsonPointer = '/~') then Exit(JsonStr);
  if not JsonStr.IsJson then Exit;

  PathParts := TStringList.Create;
  try
    PathParts.Delimiter := '/';
    PathParts.StrictDelimiter := True;
    PathParts.DelimitedText := JsonPointer;

    if (PathParts.Count > 0) and (PathParts[0] = string.Empty) then
      PathParts.Delete(0);

    // Root-level dump if pointer is just "~"
    if (PathParts.Count = 1) and (PathParts[0] = '~') then
    begin
      Result := JsonStr;
      Exit;
    end;

    try
      Data := fpjson.GetJSON(JsonStr);
      try
        Result := Traverse(Data, PathParts, 0);
      finally
        Data.Free;
      end;
    except
      Result := string.Empty;
    end;
  finally
    PathParts.Free;
  end;
end;

function TTranslate.ParseResponse(content: string): string;
const
  // A unique marker that will not appear in user data.
  // Used to temporarily escape literal '#10' substrings in extracted data
  // so they are not converted to newline characters by the template substitution.
  TEMP_NL_MARKER = '<!--#1#0-->';
var
  Segments: TStringList;
  regex: TRegExpr;
  i, j, k, pStart, pEnd, innerStart, innerEnd, OpenBrackets, SlashPos: integer;
  rStart, rEnd: integer;
  MatchResPart: string;
  Segment, FinalResult, PointerPath, PointerValue: string;
  BlockContent, InnerBlock, MatchRes, MatchGlue, MatchIdxStr: string;
  PointerFound, IsInverted, HasAnyRegex, HasAnyMatch: boolean;
  MatchIdx, CurrentIdx: integer;
  Expr: string; // Pre-processed expression (comments removed)
begin
  Result := string.Empty;
  if (Trim(content) = string.Empty) then Exit;
  if (JsonPointer = string.Empty) then Exit;

  // Remove /* comments */ only if a closing tag exists
  Expr := JsonPointer;

  // Optimization: Quick check if both start and end markers even exist
  if (Pos('/*', Expr) > 0) and (Pos('*/', Expr) > 0) then
  begin
    j := 1;
    while j < Length(Expr) do
    begin
      // Check for "/*" starting sequence
      if (Expr[j] = '/') and (Expr[j + 1] = '*') then
      begin
        pStart := j;
        pEnd := j + 2;
        PointerFound := False; // Reuse existing boolean to flag if closing '*/' is found

        // Look for closing "*/"
        while pEnd < Length(Expr) do
        begin
          if (Expr[pEnd] = '*') and (Expr[pEnd + 1] = '/') then
          begin
            PointerFound := True;
            Break;
          end;
          Inc(pEnd);
        end;

        if PointerFound then
        begin
          // If closed, delete the whole block including markers
          Delete(Expr, pStart, (pEnd + 2) - pStart);
          // Do not increment j, check the new character at this position
          Continue;
        end;
      end;
      Inc(j);
    end;
  end;

  Segments := TStringList.Create;
  regex := TRegExpr.Create;
  regex.ModifierStr := 'is';
  FinalResult := string.Empty;
  try
    Segments.Delimiter := ';';
    Segments.StrictDelimiter := True;
    Segments.DelimitedText := Expr;

    for i := 0 to Segments.Count - 1 do
    begin
      Segment := Trim(Segments[i]);
      if Segment = string.Empty then Continue;

      PointerPath := string.Empty;
      PointerValue := string.Empty;
      PointerFound := False;
      IsInverted := False;
      SlashPos := 0;

      // 1 & 2. Segment Scan
      OpenBrackets := 0;
      j := 1;
      while j <= Length(Segment) do
      begin
        if Segment[j] = '{' then Inc(OpenBrackets)
        else if Segment[j] = '}' then Dec(OpenBrackets)
        else if (OpenBrackets = 0) then
        begin
          if Segment[j] = '!' then
          begin
            IsInverted := True;
            Delete(Segment, j, 1);
            Continue;
          end;
          if (SlashPos = 0) and ((Segment[j] = '/') or (Segment[j] = '~')) then
            SlashPos := j;
        end;
        Inc(j);
      end;

      // 3. Pointer processing
      if SlashPos > 0 then
      begin
        pEnd := SlashPos;
        while (pEnd <= Length(Segment)) and (Segment[pEnd] <> '{') do Inc(pEnd);
        PointerPath := Trim(Copy(Segment, SlashPos, pEnd - SlashPos));

        if PointerPath = '~' then PointerValue := content
        else
          PointerValue := ParseJsonByPointer(content, PointerPath);

        PointerValue := PointerValue.HTTPDecode.UnescapeUnicode;

        // Temporarily replace literal '#10' in the extracted data with a unique marker.
        // This prevents the final '#10' -> newline substitution from altering user data.
        PointerValue := StringReplace(PointerValue, '#10', TEMP_NL_MARKER, [rfReplaceAll]);

        if IsInverted then
        begin
          if PointerValue <> string.Empty then
          begin
            Segment := string.Empty; // Hide whole segment if data exists
            PointerValue := string.Empty;
          end
          else
            PointerValue := ' '; // Satisfaction of !
        end;

        if (not IsInverted) and (PointerValue = string.Empty) then
          Segment := string.Empty;

        PointerFound := (PointerPath <> string.Empty);
      end;

      // 4. Block processing
      if Segment <> string.Empty then
      begin
        k := 1;
        while k <= Length(Segment) do
        begin
          if Segment[k] = '{' then
          begin
            pStart := k;
            pEnd := k + 1;
            OpenBrackets := 1;
            while (pEnd <= Length(Segment)) and (OpenBrackets > 0) do
            begin
              if Segment[pEnd] = '{' then Inc(OpenBrackets)
              else if Segment[pEnd] = '}' then Dec(OpenBrackets);
              if OpenBrackets > 0 then Inc(pEnd);
            end;

            if (pEnd <= Length(Segment)) and (Segment[pEnd] = '}') then
            begin
              BlockContent := Copy(Segment, pStart + 1, pEnd - pStart - 1);
              HasAnyRegex := False;
              HasAnyMatch := False;

              innerStart := 1;
              while innerStart <= Length(BlockContent) do
              begin
                if BlockContent[innerStart] = '{' then
                begin
                  innerEnd := innerStart + 1;
                  OpenBrackets := 1;
                  while (innerEnd <= Length(BlockContent)) and (OpenBrackets > 0) do
                  begin
                    if BlockContent[innerEnd] = '{' then Inc(OpenBrackets)
                    else if BlockContent[innerEnd] = '}' then Dec(OpenBrackets);
                    if OpenBrackets > 0 then Inc(innerEnd);
                  end;

                  if (innerEnd <= Length(BlockContent)) and (BlockContent[innerEnd] = '}') then
                  begin
                    InnerBlock := Copy(BlockContent, innerStart + 1, innerEnd - innerStart - 1);
                    MatchRes := string.Empty;

                    if InnerBlock = '~' then
                    begin
                      MatchRes := content;
                      HasAnyMatch := True;
                    end
                    else
                    begin
                      HasAnyRegex := True;
                      MatchGlue := string.Empty;
                      MatchIdx := -1;

                      if (Length(InnerBlock) > 2) and (InnerBlock[Length(InnerBlock)] = ']') then
                      begin
                        rEnd := Length(InnerBlock) - 1;
                        rStart := rEnd;
                        while (rStart > 1) and (InnerBlock[rStart] <> '[') do Dec(rStart);

                        if (InnerBlock[rStart] = '[') and (InnerBlock[rStart - 1] <> '\') then
                        begin
                          MatchIdxStr := Copy(InnerBlock, rStart + 1, rEnd - rStart);
                          PointerFound := False;
                          if MatchIdxStr = '*' then
                          begin
                            MatchGlue := ' ';
                            PointerFound := True;
                          end
                          else if MatchIdxStr = '*#10' then
                          begin
                            MatchGlue := #10;
                            PointerFound := True;
                          end
                          else if TryStrToInt(MatchIdxStr, MatchIdx) then PointerFound := True;

                          if PointerFound then InnerBlock := Copy(InnerBlock, 1, rStart - 1);
                          PointerFound := (PointerPath <> string.Empty); // Restore state
                        end;
                      end;

                      try
                        regex.Expression := InnerBlock;
                        CurrentIdx := 0;
                        if regex.Exec(content) then
                        begin
                          HasAnyMatch := True;
                          repeat
                            if regex.SubExprMatchCount > 0 then MatchResPart := regex.Match[1]
                            else
                              MatchResPart := regex.Match[0];

                            if MatchIdx <> -1 then
                            begin
                              if CurrentIdx = MatchIdx then
                              begin
                                MatchRes := MatchResPart;
                                Break;
                              end;
                            end
                            else
                            begin
                              if MatchRes <> string.Empty then MatchRes := MatchRes + MatchGlue;
                              MatchRes := MatchRes + MatchResPart;
                              if MatchGlue = string.Empty then Break;
                            end;
                            Inc(CurrentIdx);
                          until not regex.ExecNext;
                        end;
                      except
                        on E: Exception do
                        begin
                          MatchRes := REGEXP_ERROR + E.Message;
                          HasAnyMatch := True;
                        end;
                      end;
                    end;

                    MatchRes := MatchRes.HTTPDecode.UnescapeUnicode;
                    // Temporarily replace literal '#10' in extracted match data
                    // with a unique marker to prevent corruption during final substitution.
                    MatchRes := StringReplace(MatchRes, '#10', TEMP_NL_MARKER, [rfReplaceAll]);

                    Delete(BlockContent, innerStart, innerEnd - innerStart + 1);
                    Insert(MatchRes, BlockContent, innerStart);
                    innerStart := innerStart + Length(MatchRes);
                    Continue;
                  end;
                end;
                Inc(innerStart);
              end;

              if HasAnyRegex and not HasAnyMatch then BlockContent := string.Empty;

              Delete(Segment, pStart, pEnd - pStart + 1);
              if BlockContent <> string.Empty then
              begin
                Insert(BlockContent, Segment, pStart);
                k := pStart + Length(BlockContent);
              end
              else
                k := pStart;
            end
            else
              Inc(k);
          end
          else
            Inc(k);
        end;
      end;

      // Replace the pointer path with the actual data value (now containing markers instead of #10)
      if (PointerPath <> string.Empty) and (Segment <> string.Empty) then
        Segment := StringReplace(Segment, PointerPath, PointerValue, [rfReplaceAll]);

      // Convert all remaining (template-only) '#10' sequences to actual newline characters.
      Segment := StringReplace(Segment, '#10', #10, [rfReplaceAll]);
      FinalResult := FinalResult + Segment;
    end;

    // Restore literal '#10' that came from user data (currently stored as the marker)
    FinalResult := StringReplace(FinalResult, TEMP_NL_MARKER, '#10', [rfReplaceAll]);
    Result := FinalResult;
  finally
    Segments.Free;
    regex.Free;
  end;
end;

function TTranslate.Translate: string;
var
  content: string;
begin
  Result := string.Empty;

  if FWebMethod = wmPost then
    content := Post
  else
    content := Get;

  if Assigned(formTrayslate) then
    formTrayslate.RawTranslate := content;

  if content <> string.Empty then
  begin
    // Workaround for an FPC 3.2.2 fpjson bug when parsing consecutive \u200B sequences.
    content := StringReplace(content, '\u200b', string.Empty, [rfReplaceAll, rfIgnoreCase]);

    Result := ParseResponse(content);
  end;

  if (Trim(Result) = string.Empty) then
  begin
    if not content.TryFormatJson(Result) then
      Result := content;
  end
  else
  if FIsTruncated then Result := Result + '...';
end;

{%EndRegion}

{%Region -fold TTranslate Ini Config }

procedure TTranslate.SaveIniSettings(AFileName: string);
var
  Ini: TMemIniFile;
  i: integer;
  PostDataEscaped: string;
begin
  Ini := TMemIniFile.Create(AFileName);
  try
    // { Service page }
    if Trim(ServiceName) <> string.Empty then
      Ini.WriteString('Service', 'Name', ServiceName)
    else
      Ini.DeleteKey('Service', 'Name');
    if Trim(ServiceIcon) <> string.Empty then
      Ini.WriteString('Service', 'Icon', ServiceIcon)
    else
      Ini.DeleteKey('Service', 'Icon');
    Ini.WriteInteger('Service', 'Order', ServiceOrder);
    Ini.WriteBool('Service', 'Visible', ServiceVisible);
    Ini.WriteBool('Service', 'AutoSwapLanguage', ServiceAutoSwap);
    Ini.WriteBool('Service', 'RealTimeTranslation', ServiceRealTime);
    Ini.WriteBool('Service', 'TranslateOnlyByButton', ServiceOnlyButton);
    Ini.WriteBool('Service', 'AllowProxy', ServiceProxy);
    Ini.WriteInteger('Service', 'ColorRecent', ServiceColorRecent);

    case ValueType of
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
    ClearSection(Ini, 'Service Description', not Assigned(ServiceDescription) or (ServiceDescription.Count = 0));
    if Assigned(ServiceDescription) then
      for i := 0 to ServiceDescription.Count - 1 do
        Ini.WriteString('Service Description',
          IntToStr(i), // key: 0,1,2...
          ServiceDescription[i]);

    // Request page
    if WebMethod = wmPost then
      Ini.WriteString('Request', 'Method', 'POST')
    else
      Ini.WriteString('Request', 'Method', 'GET');

    if Trim(UserAgent) <> string.Empty then
      Ini.WriteString('Request', 'UserAgent', UserAgent)
    else
      Ini.DeleteKey('Request', 'UserAgent');

    Ini.WriteBool('Request', 'EncodeText', EncodeText);
    Ini.WriteInteger('Request', 'MaxLength', MaxLength);

    if Trim(Url) <> string.Empty then
      Ini.WriteString('Request', 'Url', Url)
    else
      Ini.DeleteKey('Request', 'Url');

    if Trim(ContentType) <> string.Empty then
      Ini.WriteString('Request', 'ContentType', ContentType)
    else
      Ini.DeleteKey('Request', 'ContentType');

    // Replace line breaks with \r\n for single-line storage
    if Trim(PostData) <> string.Empty then
    begin
      PostDataEscaped := StringReplace(PostData, LineEnding, '\r\n', [rfReplaceAll]);
      Ini.WriteString('Request', 'PostData', PostDataEscaped);
    end
    else
      Ini.DeleteKey('Request', 'PostData');

    if Trim(Accept) <> string.Empty then
      Ini.WriteString('Request', 'Accept', Accept)
    else
      Ini.DeleteKey('Request', 'Accept');

    // Save headers
    ClearSection(Ini, 'Headers', not Assigned(Headers) or (Headers.Count = 0));
    if Assigned(Headers) then
      for i := 0 to Headers.Count - 1 do
        Ini.WriteString('Headers',
          IntToStr(i),
          Headers[i]);

    // Response page
    if Trim(JsonPointer) <> string.Empty then
      Ini.WriteString('Response', 'JsonPointer', JsonPointer)
    else
      Ini.DeleteKey('Response', 'JsonPointer');

    // Parameters page
    Ini.WriteBool('Parameters', 'EncodeCustomParameters', EncodeCustomParameters);

    // Save custom parameters
    ClearSection(Ini, 'Custom Parameters', not Assigned(CustomParameters) or (CustomParameters.Count = 0));
    if Assigned(CustomParameters) then
      for i := 0 to CustomParameters.Count - 1 do
        Ini.WriteString('Custom Parameters',
          CustomParameters.Names[i],
          CustomParameters.ValueFromIndex[i]);

    // Save script parameters
    ClearSection(Ini, 'Script Parameters', not Assigned(ScriptParameters) or (ScriptParameters.Count = 0));
    if Assigned(ScriptParameters) then
      for i := 0 to ScriptParameters.Count - 1 do
        Ini.WriteString('Script Parameters',
          IntToStr(i),
          '#' + ScriptParameters[i]);

    ClearSection(Ini, 'Initial Request', (Trim(InitUserAgent) = string.Empty) and (Trim(InitUrl) = string.Empty) and
      (InitLiveTime = 0));
    if Trim(InitUserAgent) <> string.Empty then
      Ini.WriteString('Initial Request', 'UserAgent', InitUserAgent)
    else
      Ini.DeleteKey('Initial Request', 'UserAgent');

    if Trim(InitUrl) <> string.Empty then
      Ini.WriteString('Initial Request', 'Url', InitUrl)
    else
      Ini.DeleteKey('Initial Request', 'Url');

    if InitLiveTime > 0 then
      Ini.WriteInteger('Initial Request', 'LiveTime', InitLiveTime)
    else
      Ini.DeleteKey('Initial Request', 'LiveTime');

    // Save initial headers
    ClearSection(Ini, 'Initial Headers', not Assigned(InitHeaders) or (InitHeaders.Count = 0));
    if Assigned(InitHeaders) then
      for i := 0 to InitHeaders.Count - 1 do
        Ini.WriteString('Initial Headers',
          InitHeaders.Names[i],
          InitHeaders.ValueFromIndex[i]);

    // Save initial parameters
    ClearSection(Ini, 'Initial Parameters', not Assigned(InitParameters) or (InitParameters.Count = 0));
    if Assigned(InitParameters) then
      for i := 0 to InitParameters.Count - 1 do
        Ini.WriteString('Initial Parameters',
          InitParameters.Names[i],
          InitParameters.ValueFromIndex[i]);

    // Languages Page
    // Save language mappings (code=apiCode)
    ClearSection(Ini, 'Languages', not Assigned(Languages) or (Languages.Count = 0));
    if Assigned(Languages) then
      for i := 0 to Languages.Count - 1 do
        Ini.WriteString('Languages',
          IfThen(Languages.Names[i] = string.Empty, Languages[i] + '_' + IntToStr(i), Languages.Names[i] + '_' + IntToStr(i)),
          IfThen(Languages.ValueFromIndex[i] = string.Empty, IfThen(Languages.Names[i] = string.Empty,
          Languages[i], Languages.Names[i]), Languages.ValueFromIndex[i]));

    // Target Languages Page
    // Save language target mappings (code=apiCode)
    ClearSection(Ini, 'LanguagesTarget', not Assigned(LanguagesTarget) or (LanguagesTarget.Count = 0));
    if Assigned(LanguagesTarget) then
      for i := 0 to LanguagesTarget.Count - 1 do
        Ini.WriteString('LanguagesTarget',
          IfThen(LanguagesTarget.Names[i] = string.Empty, LanguagesTarget[i] + '_' + IntToStr(i),
          LanguagesTarget.Names[i] + '_' + IntToStr(i)),
          IfThen(LanguagesTarget.ValueFromIndex[i] = string.Empty, IfThen(LanguagesTarget.Names[i] =
          string.Empty, LanguagesTarget[i], LanguagesTarget.Names[i]), LanguagesTarget.ValueFromIndex[i]));

    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

procedure TTranslate.LoadIniSettings(AFileName: string);
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
    FCookies.Clear;
    FParametersAge := 0;
    ServiceName := Ini.ReadString('Service', 'Name', string.Empty);
    ServiceIcon := Ini.ReadString('Service', 'Icon', string.Empty);
    ServiceOrder := Ini.ReadInteger('Service', 'Order', 0);
    ServiceVisible := Ini.ReadBool('Service', 'Visible', True);
    ServiceAutoSwap := Ini.ReadBool('Service', 'AutoSwapLanguage', False);
    ServiceRealTime := Ini.ReadBool('Service', 'RealTimeTranslation', False);
    ServiceOnlyButton := Ini.ReadBool('Service', 'TranslateOnlyByButton', False);
    ServiceProxy := Ini.ReadBool('Service', 'AllowProxy', False);
    ServiceColorRecent := Ini.ReadInteger('Service', 'ColorRecent', clBlue);

    ServiceDescription.Clear;
    Keys := TStringList.Create;
    try
      Ini.ReadSection('Service Description', Keys);

      for i := 0 to Keys.Count - 1 do
        ServiceDescription.Add(
          Ini.ReadString('Service Description', Keys[i], '')
          );
    finally
      Keys.Free;
    end;

    Value := Ini.ReadString('Service', 'ValueType', 'None');
    if SameText(Value, 'None') then
      ValueType := vtNone
    else if SameText(Value, 'Language') then
      ValueType := vtLanguage
    else if SameText(Value, 'CurrencyAll') then
      ValueType := vtCurrencyAll
    else if SameText(Value, 'CurrencyFiat') then
      ValueType := vtCurrencyFiat
    else if SameText(Value, 'CurrencyCrypto') then
      ValueType := vtCurrencyCrypto
    else if SameText(Value, 'Unit') then
      ValueType := vtUnit
    else
      ValueType := vtNone; // default

    Method := Ini.ReadString('Request', 'Method', 'GET');
    if SameText(Method, 'POST') then
      WebMethod := wmPost
    else
      WebMethod := wmGet;

    UserAgent := Ini.ReadString('Request', 'UserAgent', string.Empty);
    EncodeText := Ini.ReadBool('Request', 'EncodeText', True);
    MaxLength := Ini.ReadInteger('Request', 'MaxLength', 0);

    Url := Ini.ReadString('Request', 'Url', string.Empty);

    ContentType := Ini.ReadString('Request', 'ContentType', string.Empty);
    // Restore line breaks from \r\n
    PostDataEscaped := Ini.ReadString('Request', 'PostData', string.Empty);
    PostData := StringReplace(PostDataEscaped, '\r\n', LineEnding, [rfReplaceAll]);
    Accept := Ini.ReadString('Request', 'Accept', string.Empty);
    Headers.Clear;
    if Ini.ValueExists('Headers', '0') then
    begin
      // New format: indexed entries
      i := 0;
      while Ini.ValueExists('Headers', IntToStr(i)) do
      begin
        Headers.Add(Ini.ReadString('Headers', IntToStr(i), string.Empty));
        Inc(i);
      end;
    end
    else
    begin
      // Old format: Key=Value
      Ini.ReadSectionValues('Headers', Headers);
    end;

    JsonPointer := Ini.ReadString('Response', 'JsonPointer', string.Empty);

    // Custom Parameters
    EncodeCustomParameters := Ini.ReadBool('Parameters', 'EncodeCustomParameters', True);
    CustomParameters.Clear;
    Ini.ReadSectionValues('Custom Parameters', CustomParameters);

    // Script Parameters
    ScriptParameters.Clear;
    Keys := TStringList.Create;
    try
      Ini.ReadSection('Script Parameters', Keys);

      for i := 0 to Keys.Count - 1 do
      begin
        Value := Ini.ReadString('Script Parameters', Keys[i], '');

        if (Value <> string.Empty) and (Value[1] = '#') then
          Delete(Value, 1, 1);

        ScriptParameters.Add(Value);
      end;
    finally
      Keys.Free;
    end;

    InitUserAgent := Ini.ReadString('Initial Request', 'UserAgent', string.Empty);
    InitUrl := Ini.ReadString('Initial Request', 'Url', string.Empty);
    InitLiveTime := Ini.ReadInteger('Initial Request', 'LiveTime', 0);
    InitHeaders.Clear;
    Ini.ReadSectionValues('Initial Headers', InitHeaders);
    InitParameters.Clear;
    Ini.ReadSectionValues('Initial Parameters', InitParameters);

    LoadSection('Languages', Languages);
    LoadSection('LanguagesTarget', LanguagesTarget);

    Languages.RemoveEmptyValues;
    LanguagesTarget.RemoveEmptyValues;
  finally
    Ini.Free;
  end;
end;

class function TTranslate.IsValidIni(const FileName: string): boolean;
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

class procedure TTranslate.FindIniFiles(const Dir: string; List: TStrings);
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

class procedure TTranslate.GetIniFiles(List: TStrings);
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

class function TTranslate.GetConfigFullPath(const ConfigName: string; ConfigFiles: TStringList): string;
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

class function TTranslate.ConfigSortByOrderPathName(List: TStringList; Index1, Index2: integer): integer;
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

class procedure TTranslate.ClearSection(AIni: TIniFile; const ASection: string; AErase: boolean);
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

class function TTranslate.GetIniDirectory(fileName: string = string.Empty): string;
begin
  {$IFDEF WINDOWS}
  Result := ExtractFilePath(ParamStr(0)) + fileName;
  {$ELSE}
  Result := IncludeTrailingPathDelimiter(GetUserDir) + '.config/trayslate/' + filename;
  {$ENDIF}
end;

{%EndRegion}

{%Region -fold TTranslateThread }

constructor TTranslateThread.Create(ATrans: TTranslate; AMemo: TMemo = nil; ATimer: TTimer = nil; AFreeOnTerminate: boolean = True);
begin
  inherited Create(True);
  FreeOnTerminate := AFreeOnTerminate;

  FTrans := ATrans;
  FMemo := AMemo;
  FTimer := ATimer;
  FSourceText := FTrans.TextToTranslate;
  FCancelled := False;
  BeforeExecute;
  Start;
end;

destructor TTranslateThread.Destroy;
begin
  if Assigned(FException) then
    FreeAndNil(FException);
  inherited Destroy;
end;

procedure TTranslateThread.BeforeExecute;
begin
  if Assigned(FMemo) then
    Screen.Cursor := crAppStart;

  if Assigned(FTimer) then
    FTimer.Enabled := True;
end;

procedure TTranslateThread.Execute;
begin
  try
    try
      if Terminated or Application.Terminated then Exit;
      if Length(Trim(FSourceText)) > 0 then
        FResultText := FTrans.Translate
      else
        FResultText := string.Empty;

      if Terminated or Application.Terminated then Exit;
    except
      on E: Exception do
        if not Application.Terminated then
          FException := Exception.Create(E.Message);
    end;
  finally
    // Call AfterExecute in main thread to handle exceptions
    if not Application.Terminated then
      Synchronize(@AfterExecute);
  end;
end;

procedure TTranslateThread.Cancel;
begin
  FCancelled := True;
end;

procedure TTranslateThread.AfterExecute;
begin
  try
    if FCancelled then Exit; // check if cancelled

    // Handle exception in main thread if occurred
    if Assigned(FException) then
    begin
      if Assigned(Application.OnException) then
        Application.OnException(Self, FException)
      else
        Application.ShowException(FException);

      FreeAndNil(FException); // free manually
    end
    else
    begin
      if Assigned(FMemo) and (FResultText <> string.Empty) then
        FMemo.Text := FResultText;
      FResultTextSync := FResultText;
    end;
  finally
    if Assigned(FMemo) then
    begin
      Screen.Cursor := crDefault;

      if Assigned(FTimer) then
        FTimer.Enabled := False;
    end;
  end;
end;

{%EndRegion}

end.
