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
  fphttpclient,
  fpjson,
  jsonparser;

type
  TWebMethod = (wmGet, wmPost);
  TResponseParser = (rpJson, rpRegEx);

  { TTranslate }
  TTranslate = class
  private
    FLangSource: string;
    FLangTarget: string;
    FTextToTranslate: string;

    FServiceName: string;
    FWebMethod: TWebMethod;
    FUserAgent: string;
    FHeaders: TStringList;
    FEncryptText: boolean;
    FUrl: string;
    FContentType: string;
    FPostData: string;
    FAccept: string;
    FResponseParser: TResponseParser;
    FJsonPointer: string;
    FRegexp: string;
    FLanguages: TStringList;
    FLanguagesTarget: TStringList;

    FInitUserAgent: string;
    FInitHeaders: TStringList;
    FInitUrl: string;
    FInitParameters: TStringList;
    FInitLiveTime: integer;
    FParameterValues: TStringList;

    FParametersAge: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    function InitGet: string;
    procedure GetParameters(Data: string);
    function SetParameters(Data: string): string;
    procedure SetParametersList(Strings: TStrings);
    function Get: string;
    function Post: string;
    function Request: string;
    function TransRegEx: string;
    function TransJson: string;
    function Translate: string;

    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property TextToTranslate: string read FTextToTranslate write FTextToTranslate;
    property ParametersAge: TDateTime read FParametersAge write FParametersAge;
    property ParameterValues: TStringList read FParameterValues write FParameterValues;

    property ServiceName: string read FServiceName write FServiceName;
    property WebMethod: TWebMethod read FWebMethod write FWebMethod;
    property UserAgent: string read FUserAgent write FUserAgent;
    property Headers: TStringList read FHeaders write FHeaders;
    property EncryptText: boolean read FEncryptText write FEncryptText;
    property Url: string read FUrl write FUrl;
    property ContentType: string read FContentType write FContentType;
    property PostData: string read FPostData write FPostData;
    property Accept: string read FAccept write FAccept;
    property ResponseParser: TResponseParser read FResponseParser write FResponseParser;
    property JsonPointer: string read FJsonPointer write FJsonPointer;
    property Regexp: string read FRegexp write FRegexp;
    property Languages: TStringList read FLanguages write FLanguages;
    property LanguagesTarget: TStringList read FLanguagesTarget write FLanguagesTarget;

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
    FSourceText: string;
    FResultText: string;
    FResultTextSync: string;
    FException: Exception;
  protected
    procedure Execute; override;
    procedure UpdateUI;
  public
    constructor Create(ATrans: TTranslate; AMemo: TMemo = nil);
    property ExceptionObj: Exception read FException;
    property ResultText: string read FResultText;
    property ResultTextSync: string read FResultTextSync;
  end;

const
  defaultlang = 'en';
  emptylang = 'empty';

implementation

uses systemtool, langtool, formattool;

  { TTranslate }

constructor TTranslate.Create;
begin
  inherited Create;
  FServiceName := 'default';
  FWebMethod := wmGet;
  FUserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0';
  FHeaders := TStringList.Create;
  FHeaders.TrailingLineBreak := False;
  FEncryptText := True;
  FUrl := string.Empty;
  FContentType := 'application/json';
  FPostData := string.Empty;
  FAccept := 'application/json';
  FResponseParser := rpJson;
  FJsonPointer := '/0/*/0';
  FRegexp := string.Empty;
  FLanguages := TStringList.Create;
  FLanguages.TrailingLineBreak := False;
  FLanguagesTarget := TStringList.Create;
  FLanguagesTarget.TrailingLineBreak := False;

  FInitUserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0';
  FInitHeaders := TStringList.Create;
  FInitHeaders.TrailingLineBreak := False;
  FInitUrl := string.Empty;
  FInitParameters := TStringList.Create;
  FInitParameters.TrailingLineBreak := False;
  FParameterValues := TStringList.Create;
  FParameterValues.TrailingLineBreak := False;
  FInitLiveTime := 60;

  FLangSource := defaultlang;
  FLangTarget := Language;
end;

destructor TTranslate.Destroy;
begin
  FHeaders.Free;
  FLanguages.Free;
  FLanguagesTarget.Free;

  FInitHeaders.Free;
  FInitParameters.Free;
  FParameterValues.Free;
  inherited Destroy;
end;

function TTranslate.InitGet: string;
var
  http: TFPHTTPClient;
  response: TStringStream;
  i: integer;
  header: string;
begin
  Result := string.Empty;
  if FInitUrl = string.Empty then Exit;

  if SecondsBetween(Now, FParametersAge) < FInitLiveTime then Exit;
  FParameterValues.Clear;

  http := TFPHTTPClient.Create(nil);
  response := TStringStream.Create(string.Empty);
  try
    http.AllowRedirect := True;
    http.RequestHeaders.Clear;
    if (FInitUserAgent <> string.Empty) then
      http.AddHeader('User-Agent', FInitUserAgent);
    if Assigned(InitHeaders) then
      for i := 0 to InitHeaders.Count - 1 do
        http.AddHeader(InitHeaders.Names[i], InitHeaders.ValueFromIndex[i]);

    http.Get(FInitUrl, response);

    header := string.Empty;
    for i := 0 to http.ResponseHeaders.Count - 1 do
      header := header + http.ResponseHeaders[i] + LineEnding;
    // Combine headers and body
    Result := header + LineEnding + response.DataString;
  finally
    response.Free;
    http.Free;
  end;
end;

procedure TTranslate.GetParameters(Data: string);
var
  i: integer;
  ParamName: string;
  RegExpStr: string;
  R: TRegExpr;
  Value: string;
begin
  if FTextToTranslate <> string.Empty then
    FParameterValues.Values['text'] := IfThen(FEncryptText, EncodeURLElement(FTextToTranslate), FTextToTranslate)
  else
    FParameterValues.Values['text'] := string.Empty;

  if FLangSource <> string.Empty then
    FParameterValues.Values['source'] := ifthen(FLangSource = emptylang, string.Empty, FLangSource)
  else
    FParameterValues.Values['source'] := defaultlang;

  if FLangTarget <> string.Empty then
    FParameterValues.Values['target'] := FLangTarget
  else
    FParameterValues.Values['target'] := Language;

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

function TTranslate.SetParameters(Data: string): string;
var
  i: integer;
  ParamName: string;
  ParamValue: string;
begin
  Result := Data;

  if not Assigned(FParameterValues) then
    Exit;

  for i := 0 to FParameterValues.Count - 1 do
  begin
    ParamName := FParameterValues.Names[i];
    ParamValue := FParameterValues.ValueFromIndex[i];

    // Replace all occurrences of {name} with value
    Result := StringReplace(Result, '{' + ParamName + '}', ParamValue, [rfReplaceAll]);
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

function TTranslate.Get: string;
var
  http: TFPHTTPClient;
  response: TStringStream;
  TempUrl: string;
  TempHeaders: TStringList;
  i: integer;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  // Get parameters from base + initial get
  GetParameters(InitGet);

  http := TFPHTTPClient.Create(nil);
  response := TStringStream.Create(string.Empty);
  try
    TempUrl := FUrl;
    TempUrl := SetParameters(TempUrl);

    if (FLangSource = emptylang) or (FLangSource = emptylang) then
      TempUrl := RemoveEmptyParams(TempUrl);

    http.AllowRedirect := True;
    http.RequestHeaders.Clear;
    if (FUserAgent <> string.Empty) then
      http.AddHeader('User-Agent', FUserAgent);
    if (FContentType <> string.Empty) then
      http.AddHeader('Content-Type', FContentType);
    if (FAccept <> string.Empty) then
      http.AddHeader('Accept', FAccept);
    if Assigned(Headers) then
    begin
      TempHeaders := TStringList.Create;
      try
        TempHeaders.Assign(Headers);
        SetParametersList(TempHeaders);
        for i := 0 to TempHeaders.Count - 1 do
          http.AddHeader(TempHeaders.Names[i], TempHeaders.ValueFromIndex[i]);
      finally
        TempHeaders.Free;
      end;
    end;

    http.Get(TempUrl, response);

    Result := response.DataString;
  finally
    response.Free;
    http.Free;
  end;
end;

function TTranslate.Post: string;
var
  http: TFPHTTPClient;
  response, postStream: TStringStream;
  TempData: string;
  TempUrl: string;
  TempHeaders: TStringList;
  i: integer;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  GetParameters(InitGet);

  http := TFPHTTPClient.Create(nil);
  response := TStringStream.Create(string.Empty);
  try
    TempUrl := FUrl;
    TempUrl := SetParameters(TempUrl);

    TempData := FPostData;
    TempData := SetParameters(TempData);

    if (FLangSource = emptylang) or (FLangSource = emptylang) then
    begin
      TempUrl := RemoveEmptyParams(TempUrl);
      TempData := RemoveEmptyParams(TempData);
    end;

    postStream := TStringStream.Create(TempData, TEncoding.UTF8);
    try
      http.AllowRedirect := True;
      http.RequestHeaders.Clear;
      if FUserAgent <> string.Empty then
        http.AddHeader('User-Agent', FUserAgent);
      if FContentType <> string.Empty then
        http.AddHeader('Content-Type', FContentType);
      if FAccept <> string.Empty then
        http.AddHeader('Accept', FAccept);
      if Assigned(Headers) then
      begin
        TempHeaders := TStringList.Create;
        try
          TempHeaders.Assign(Headers);
          SetParametersList(TempHeaders);
          for i := 0 to TempHeaders.Count - 1 do
            http.AddHeader(TempHeaders.Names[i], TempHeaders.ValueFromIndex[i]);
        finally
          TempHeaders.Free;
        end;
      end;

      http.RequestBody := postStream;
      http.Post(TempUrl, response);
    finally
      postStream.Free;
    end;
    Result := response.DataString;
  finally
    response.Free;
    http.Free;
  end;
end;

function TTranslate.Request: string;
begin
  if FWebMethod = wmPost then
    Result := Post
  else
    Result := Get;
end;

function TTranslate.TransRegEx: string;
var
  regex: TRegExpr;
  content: string;
begin
  Result := string.Empty;
  content := Request;

  try
    if (FRegexp <> string.Empty) then
    begin
      regex := TRegExpr.Create;
      try
        regex.Expression := FRegexp;
        if regex.Exec(content) then
        begin
          Result := regex.Match[1];
          Result := UnescapeUnicode(Result);
        end
        else
          Result := content;
      finally
        regex.Free;
      end;
    end
    else
      Result := content;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message + #10 + content);
    end;
  end;
end;

function TTranslate.TransJson: string;
var
  jsonStr: string;
begin
  Result := string.Empty;

  jsonStr := Request;
  if Trim(jsonStr) = string.Empty then Exit;
  if not IsJson(jsonStr) then Exit(jsonstr);

  try
    // Use universal path parser. JsonKeys is a field, e.g. '\responseData\translatedText' or '\matches\0\translation'
    if (JsonPointer <> string.Empty) then
      Result := ParseJsonByPointer(jsonStr, JsonPointer);

    if (Result <> string.Empty) then
      Result := UnescapeUnicode(Result)
    else
      Result := jsonStr;
  except
    on E: Exception do
      raise Exception.Create(E.Message + #10 + Request);
  end;
end;

function TTranslate.Translate: string;
begin
  if FResponseParser = rpJson then
    Result := TransJson
  else
    Result := TransRegEx;
end;

{ TTranslateThread }

constructor TTranslateThread.Create(ATrans: TTranslate; AMemo: TMemo = nil);
begin
  inherited Create(True);
  FreeOnTerminate := True;

  if Assigned(AMemo) then
    Screen.Cursor := crAppStart;

  FTrans := ATrans;
  FMemo := AMemo;
  FSourceText := FTrans.TextToTranslate;

  Start;
end;

procedure TTranslateThread.Execute;
begin
  try
    if Length(Trim(FSourceText)) > 0 then
      FResultText := FTrans.Translate
    else
      FResultText := string.Empty;
  except
    on E: Exception do
      FException := Exception.Create(E.Message);
  end;

  // Call UpdateUI in main thread to handle exceptions
  Synchronize(@UpdateUI);
end;

procedure TTranslateThread.UpdateUI;
begin
  try
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
      if Assigned(FMemo) then FMemo.Text := FResultText;
      FResultTextSync := FResultText;
    end;
  finally
    if Assigned(FMemo) then
      Screen.Cursor := crDefault;
  end;
end;

end.
