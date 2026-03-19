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
  ExtCtrls,
  LazUTF8,
  fphttpclient,
  fpjson,
  jsonparser;

type
  TWebMethod = (wmGet, wmPost);
  TResponseParser = (rpJson, rpRegEx);
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

    FServiceName: string;
    FServiceOrder: integer;
    FAutoSwap: boolean;
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
    FValueType: TValueType;

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

    procedure GetParameters(Data: string);
    function SetParameters(Data: string): string;
    procedure SetParametersList(Strings: TStrings);
    function GetInit: string;
    function Get(ReturnHeaders: boolean = False): string;
    function Post: string;
    function TransRegEx(content: string): string;
    function TransJson(content: string): string;
    function Translate: string;

    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property TextToTranslate: string read FTextToTranslate write FTextToTranslate;
    property ParametersAge: TDateTime read FParametersAge write FParametersAge;
    property ParameterValues: TStringList read FParameterValues write FParameterValues;

    property ServiceName: string read FServiceName write FServiceName;
    property ServiceOrder: integer read FServiceOrder write FServiceOrder;
    property AutoSwap: boolean read FAutoSwap write FAutoSwap;
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
    procedure Cancel;
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
  FValueType := vtLanguage;

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

procedure TTranslate.GetParameters(Data: string);
var
  i: integer;
  ParamName: string;
  RegExpStr: string;
  R: TRegExpr;
  Value: string;
begin
  if FTextToTranslate <> string.Empty then
    FParameterValues.Values['text'] := FTextToTranslate
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

  function Encrypt(AName, AValue: string): string;
  begin
    if (FEncryptText) and (Lowercase(AName) = 'text') then
      Result := EncodeURLElement(AValue)
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
    ParamValue := RemoveTrailingLineBreak(FParameterValues.ValueFromIndex[i]);

    // Replace all occurrences of {name} with value
    Result := StringReplace(Result, '{' + ParamName + '}', Encrypt(ParamName, ParamValue), [rfReplaceAll]);

    // lowercase {!param}
    Result := StringReplace(Result, '{!' + ParamName + '}', Encrypt(ParamName, UTF8LowerCase(ParamValue)), [rfReplaceAll]);

    // UPPERCASE {^param}
    Result := StringReplace(Result, '{^' + ParamName + '}', Encrypt(ParamName, UTF8UpperCase(ParamValue)), [rfReplaceAll]);
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
  http: TFPHTTPClient;
  response: TMemoryStream;
  i: integer;
  header: string;
  bodyStream: TStringStream;
  decompressedStream: TMemoryStream;
  contentEncoding: string;
begin
  Result := '';
  if FInitUrl = '' then Exit;
  if SecondsBetween(Now, FParametersAge) < FInitLiveTime then Exit;
  FParameterValues.Clear;

  http := TFPHTTPClient.Create(nil);
  response := TMemoryStream.Create;
  try
    http.AllowRedirect := True;
    http.RequestHeaders.Clear;
    if FInitUserAgent <> '' then
      http.AddHeader('User-Agent', FInitUserAgent);
    if Assigned(InitHeaders) then
      for i := 0 to InitHeaders.Count - 1 do
        http.AddHeader(InitHeaders.Names[i], InitHeaders.ValueFromIndex[i]);

    http.Get(FInitUrl, response);
    response.Position := 0;

    // form a line with headings
    header := '';
    for i := 0 to http.ResponseHeaders.Count - 1 do
      header := header + http.ResponseHeaders[i] + LineEnding;

    bodyStream := TStringStream.Create('', TEncoding.UTF8);
    try
      contentEncoding := Trim(http.ResponseHeaders.Values['Content-Encoding']);

      // checking the gzip signature, not just the header
      if SameText(contentEncoding, 'gzip') and IsGzip(response) then
      begin
        decompressedStream := DecompressGzipToStream(response);
        try
          bodyStream.CopyFrom(decompressedStream, 0);
        finally
          decompressedStream.Free;
        end;
      end
      else
      begin
        // plain text
        bodyStream.CopyFrom(response, 0);
      end;

      Result := header + LineEnding + bodyStream.DataString;
    finally
      bodyStream.Free;
    end;

  finally
    response.Free;
    http.Free;
  end;
end;

function TTranslate.Get(ReturnHeaders: boolean = False): string;
var
  http: TFPHTTPClient;
  response: TStringStream;
  TempUrl: string;
  TempHeaders: TStringList;
  i: integer;
  header: string;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  try
    // Get parameters from base + initial get
    GetParameters(GetInit);

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

      if (ReturnHeaders) then
      begin
        header := string.Empty;
        for i := 0 to http.ResponseHeaders.Count - 1 do
          header := header + http.ResponseHeaders[i] + LineEnding;
        // Combine headers and body
        Result := header + LineEnding + response.DataString;
      end
      else
        Result := response.DataString;
    finally
      response.Free;
      http.Free;
    end;
  except
    on E: Exception do
      Result := E.Message;
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
  try
    GetParameters(GetInit);

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
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

function TTranslate.TransRegEx(content: string): string;
var
  regex: TRegExpr;
begin
  Result := string.Empty;
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
          Result := string.Empty;
      finally
        regex.Free;
      end;
    end
    else
      Result := content;
  except
    on E: Exception do
      Result := E.Message + #10 + content;
  end;
end;

function TTranslate.TransJson(content: string): string;
begin
  Result := string.Empty;

  if Trim(content) = string.Empty then Exit;
  if not IsJson(content) then Exit(content);

  try
    // Use universal path parser. JsonKeys is a field, e.g. '\responseData\translatedText' or '\matches\0\translation'
    if (JsonPointer <> string.Empty) then
      Result := ParseJsonByPointer(content, JsonPointer)
    else
      Result := content;

    if (Result <> string.Empty) then
      Result := UnescapeUnicode(Result)
    else
      Result := string.Empty;
  except
    on E: Exception do
      Result := E.Message + #10 + content;
  end;
end;

function TTranslate.Translate: string;
var
  content: string;
begin
  if FWebMethod = wmPost then
    content := Post
  else
    content := Get;

  if FResponseParser = rpJson then
    Result := TransJson(content)
  else
    Result := TransRegEx(content);
end;

{ TTranslateThread }

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
      if Length(Trim(FSourceText)) > 0 then
        FResultText := FTrans.Translate
      else
        FResultText := string.Empty;
    except
      on E: Exception do
        FException := Exception.Create(E.Message);
    end;
  finally
    // Call AfterExecute in main thread to handle exceptions
    Synchronize(@AfterExecute);
  end;
end;

procedure TTranslateThread.Cancel;
begin
  FreeOnTerminate := True;
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
      if Assigned(FMemo) then FMemo.Text := FResultText;
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

end.
