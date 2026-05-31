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
  fpjson,
  jsonparser,
  httpprotocol,
  {$PUSH}
  {$WARNINGS OFF}
  {$HINTS OFF}
  {$NOTES OFF}
  httpsend,
  //  synautil,
  blcksock,
  ssl_openssl11;
  {$POP}

type
  { TWebMethod }
  TWebMethod = (wmGet, wmPost);

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
    FServiceName: string;
    FServiceIcon: string;
    FServiceOrder: integer;
    FServiceVisible: boolean;
    FServiceAutoSwap: boolean;
    FServiceRealTime: boolean;
    FServiceOnlyButton: boolean;
    FWebMethod: TWebMethod;
    FUserAgent: string;
    FHeaders: TStringList;
    FCustomParameters: TStringList;
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

    FInitUserAgent: string;
    FInitHeaders: TStringList;
    FInitUrl: string;
    FInitParameters: TStringList;
    FInitLiveTime: integer;
    FParameterValues: TStringList;
    FParameterEncode: TStringList;

    FParametersAge: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    procedure GetParameters(Data: string);
    function SetParameters(Data: string; IncludeSet: boolean = True): string;
    procedure SetParametersList(Strings: TStrings);
    function GetInit: string;
    function Get(ReturnHeaders: boolean = False): string;
    function Post(ReturnHeaders: boolean = False): string;
    function ParseResponse(content: string): string;
    function Translate: string;

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
  CONNECT_TIMEOUT = 10000;
  IO_TIMEOUT = 300000;

implementation

uses systemtool, langtool, formattool;

  { TTranslate }

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
  FHeaders.TrailingLineBreak := False;
  FHeaders.SkipLastLineBreak := True;
  FCustomParameters := TStringList.Create;
  FCustomParameters.TrailingLineBreak := False;
  FCustomParameters.SkipLastLineBreak := True;
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
end;

destructor TTranslate.Destroy;
begin
  FHeaders.Free;
  FCustomParameters.Free;
  FServiceDescription.Free;
  FLanguages.Free;
  FLanguagesTarget.Free;

  FInitHeaders.Free;
  FInitParameters.Free;
  FParameterValues.Free;
  FParameterEncode.Free;
  inherited Destroy;
end;

procedure TTranslate.GetParameters(Data: string);
var
  i: integer;
  ParamName: string;
  RegExpStr: string;
  R: TRegExpr;
  Value: string;
  FullRandom: int64;
begin
  // Custom parameters (key=value)
  if Assigned(FCustomParameters) then
  begin
    for i := 0 to FCustomParameters.Count - 1 do
    begin
      ParamName := FCustomParameters.Names[i];
      Value := FCustomParameters.ValueFromIndex[i];

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
      FParameterValues.Values['text'] := Utf8TruncateWithEncoding(FTextToTranslate, FMaxLength, FEncodeText);
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
  FParameterValues.Values['timestamp'] := GetTimestampNow.ToString;

  // Random
  FullRandom := GetRandomID(9);
  FParameterValues.Values['random'] := FullRandom.ToString;
  FParameterValues.Values['rand'] := FullRandom.ToString;
  for i := 1 to Length(FullRandom.ToString) do
    FParameterValues.Values['rand' + IntToStr(i)] := Copy(FullRandom.ToString, 1, i);

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
        Result := EncodeURLElement(AValue)
      else
        Result := EscapeText(AValue);
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
    ParamValue := RemoveTrailingLineBreak(FParameterValues.ValueFromIndex[i]);

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
  HTTP: THTTPSend;
  responseHeaders: TStringList;
  rawStream: TMemoryStream;
  decompressedStream: TMemoryStream;
  bodyStream: TStringStream;
  i: integer;
  header: string;
  contentEncoding: string;
begin
  Result := string.Empty;
  if FInitUrl = string.Empty then Exit;
  if SecondsBetween(Now, FParametersAge) < FInitLiveTime then Exit;
  FParameterValues.Clear;

  HTTP := THTTPSend.Create;
  rawStream := TMemoryStream.Create;
  responseHeaders := TStringList.Create;
  try
    HTTP.Sock.ConnectionTimeout := CONNECT_TIMEOUT;
    HTTP.Timeout := CONNECT_TIMEOUT;
    HTTP.Protocol := '1.1';
    TSSLOpenSSL.Create(HTTP.Sock);
    HTTP.Sock.SSL.SSLType := LT_TLSv1_2; // TLS 1.2 minimum

    HTTP.Headers.Clear;
    if FInitUserAgent <> string.Empty then
      HTTP.Headers.Add('User-Agent: ' + FInitUserAgent);
    if Assigned(InitHeaders) then
      for i := 0 to InitHeaders.Count - 1 do
        HTTP.Headers.Add(InitHeaders.Names[i] + ': ' + InitHeaders.ValueFromIndex[i]);

    HTTP.HTTPMethod('GET', FInitUrl);

    if (HTTP.ResultCode div 100) <> 2 then
    begin
      // Try to get socket-level error if HTTP status is not 2xx or zero
      if (HTTP.ResultCode = 0) and (HTTP.Sock.LastError <> 0) then
        Result := 'Socket Error: ' + HTTP.Sock.LastErrorDesc
      else
        Result := 'HTTP Error: ' + IntToStr(HTTP.ResultCode) + ' ' + HTTP.ResultString;
      Exit;
    end;

    // Save response headers
    responseHeaders.Assign(HTTP.Headers);

    // Copy raw body
    rawStream.CopyFrom(HTTP.Document, 0);
    rawStream.Position := 0;

    // Build header string
    header := string.Empty;
    for i := 0 to responseHeaders.Count - 1 do
      header := header + responseHeaders[i] + LineEnding;

    bodyStream := TStringStream.Create(string.Empty, TEncoding.UTF8);
    try
      contentEncoding := GetSynapseHeader(responseHeaders, 'Content-Encoding');
      if SameText(contentEncoding, 'gzip') and IsGzip(rawStream) then
      begin
        decompressedStream := DecompressGzipToStream(rawStream);
        try
          bodyStream.CopyFrom(decompressedStream, 0);
        finally
          decompressedStream.Free;
        end;
      end
      else
        bodyStream.CopyFrom(rawStream, 0);

      Result := header + LineEnding + bodyStream.DataString;
    finally
      bodyStream.Free;
    end;
  finally
    responseHeaders.Free;
    rawStream.Free;
    HTTP.Free;
  end;
end;

function TTranslate.Get(ReturnHeaders: boolean = False): string;
var
  HTTP: THTTPSend;
  rawStream: TMemoryStream;
  decompressedStream: TMemoryStream;
  bodyStream: TStringStream;
  TempUrl: string;
  TempHeaders: TStringList;
  i: integer;
  header: string;
  contentEncoding: string;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  try
    GetParameters(GetInit);

    HTTP := THTTPSend.Create;
    rawStream := TMemoryStream.Create;
    try
      TempUrl := FUrl;
      TempUrl := SetParameters(TempUrl);
      if (FLangSource = EMPTY_LANG) or (FLangSource = EMPTY_LANG) then
        TempUrl := RemoveEmptyParams(TempUrl);

      HTTP.Sock.ConnectionTimeout := CONNECT_TIMEOUT;
      HTTP.Timeout := IO_TIMEOUT;
      HTTP.Protocol := '1.1';
      TSSLOpenSSL.Create(HTTP.Sock);
      HTTP.Sock.SSL.SSLType := LT_TLSv1_2; // TLS 1.2 minimum

      HTTP.Headers.Clear;
      if FUserAgent <> string.Empty then
        HTTP.Headers.Add('User-Agent: ' + FUserAgent);
      if FContentType <> string.Empty then
        HTTP.Headers.Add('Content-Type: ' + FContentType);
      if FAccept <> string.Empty then
        HTTP.Headers.Add('Accept: ' + FAccept);

      if Assigned(Headers) then
      begin
        TempHeaders := TStringList.Create;
        try
          TempHeaders.Assign(Headers);
          SetParametersList(TempHeaders);
          for i := 0 to TempHeaders.Count - 1 do
            HTTP.Headers.Add(TempHeaders.Names[i] + ': ' + TempHeaders.ValueFromIndex[i]);
        finally
          TempHeaders.Free;
        end;
      end;

      HTTP.HTTPMethod('GET', TempUrl);

      if (HTTP.ResultCode div 100) <> 2 then
            begin
              // Try to get socket-level error if HTTP status is not 2xx or zero
              if (HTTP.ResultCode = 0) and (HTTP.Sock.LastError <> 0) then
                Result := 'Socket Error: ' + HTTP.Sock.LastErrorDesc
              else
                Result := 'HTTP Error: ' + IntToStr(HTTP.ResultCode) + ' ' + HTTP.ResultString;
              Exit;
            end;

      rawStream.CopyFrom(HTTP.Document, 0);
      rawStream.Position := 0;

      if ReturnHeaders then
      begin
        header := string.Empty;
        for i := 0 to HTTP.Headers.Count - 1 do
          header := header + HTTP.Headers[i] + LineEnding;
      end;

      contentEncoding := GetSynapseHeader(HTTP.Headers, 'Content-Encoding');
      bodyStream := TStringStream.Create(string.Empty, TEncoding.UTF8);
      try
        if SameText(contentEncoding, 'gzip') and IsGzip(rawStream) then
        begin
          decompressedStream := DecompressGzipToStream(rawStream);
          try
            bodyStream.CopyFrom(decompressedStream, 0);
          finally
            decompressedStream.Free;
          end;
        end
        else
          bodyStream.CopyFrom(rawStream, 0);

        if ReturnHeaders then
          Result := header + LineEnding + bodyStream.DataString
        else
          Result := bodyStream.DataString;
      finally
        bodyStream.Free;
      end;
    finally
      rawStream.Free;
      HTTP.Free;
    end;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

function TTranslate.Post(ReturnHeaders: boolean = False): string;
var
  HTTP: THTTPSend;
  rawStream: TMemoryStream;
  decompressedStream: TMemoryStream;
  bodyStream: TStringStream;
  postStream: TStringStream;
  TempData: string;
  TempUrl: string;
  TempHeaders: TStringList;
  i: integer;
  header: string;
  contentEncoding: string;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  try
    GetParameters(GetInit);

    HTTP := THTTPSend.Create;
    rawStream := TMemoryStream.Create;
    try
      TempUrl := FUrl;
      TempUrl := SetParameters(TempUrl);
      TempData := FPostData;
      TempData := SetParameters(TempData);

      if (FLangSource = EMPTY_LANG) or (FLangSource = EMPTY_LANG) then
      begin
        TempUrl := RemoveEmptyParams(TempUrl);
        TempData := RemoveEmptyParams(TempData);
      end;

      // Write POST body into the document stream
      //WriteStrToStream(HTTP.Document, TempData);

      // Write POST body with explicit UTF-8 encoding (as fphttpclient did)
      postStream := TStringStream.Create(TempData, TEncoding.UTF8);
      try
        HTTP.Document.CopyFrom(postStream, 0);
        HTTP.Document.Position := 0;   // Synapse reads from current position
      finally
        postStream.Free;
      end;

      HTTP.Sock.ConnectionTimeout := CONNECT_TIMEOUT;
      HTTP.Timeout := IO_TIMEOUT;
      HTTP.Protocol := '1.1';
      TSSLOpenSSL.Create(HTTP.Sock);
      HTTP.Sock.SSL.SSLType := LT_TLSv1_2; // TLS 1.2 minimum

      HTTP.Headers.Clear;
      if FUserAgent <> string.Empty then
        HTTP.Headers.Add('User-Agent: ' + FUserAgent);
      if FContentType <> string.Empty then
        HTTP.MimeType := FContentType; //  HTTP.Headers.Add('Content-Type: ' + FContentType);
      if FAccept <> string.Empty then
        HTTP.Headers.Add('Accept: ' + FAccept);

      if Assigned(Headers) then
      begin
        TempHeaders := TStringList.Create;
        try
          TempHeaders.Assign(Headers);
          SetParametersList(TempHeaders);
          for i := 0 to TempHeaders.Count - 1 do
            HTTP.Headers.Add(TempHeaders.Names[i] + ': ' + TempHeaders.ValueFromIndex[i]);
        finally
          TempHeaders.Free;
        end;
      end;

      HTTP.HTTPMethod('POST', TempUrl);

      if (HTTP.ResultCode div 100) <> 2 then
      begin
        // Try to get socket-level error if HTTP status is not 2xx or zero
        if (HTTP.ResultCode = 0) and (HTTP.Sock.LastError <> 0) then
          Result := 'Socket Error: ' + HTTP.Sock.LastErrorDesc
        else
          Result := 'HTTP Error: ' + IntToStr(HTTP.ResultCode) + ' ' + HTTP.ResultString;
        Exit;
      end;

      rawStream.CopyFrom(HTTP.Document, 0);
      rawStream.Position := 0;

      if ReturnHeaders then
      begin
        header := string.Empty;
        for i := 0 to HTTP.Headers.Count - 1 do
          header := header + HTTP.Headers[i] + LineEnding;
      end;

      contentEncoding := GetSynapseHeader(HTTP.Headers, 'Content-Encoding');
      bodyStream := TStringStream.Create(string.Empty, TEncoding.UTF8);
      try
        if SameText(contentEncoding, 'gzip') and IsGzip(rawStream) then
        begin
          decompressedStream := DecompressGzipToStream(rawStream);
          try
            bodyStream.CopyFrom(decompressedStream, 0);
          finally
            decompressedStream.Free;
          end;
        end
        else
          bodyStream.CopyFrom(rawStream, 0);

        if ReturnHeaders then
          Result := header + LineEnding + bodyStream.DataString
        else
          Result := bodyStream.DataString;
      finally
        bodyStream.Free;
      end;
    finally
      rawStream.Free;
      HTTP.Free;
    end;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

function TTranslate.ParseResponse(content: string): string;
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
  Expr: string; // Added for pre-processing
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

        PointerValue := UnescapeUnicode(HTTPDecode(PointerValue));

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

                    MatchRes := UnescapeUnicode(HTTPDecode(MatchRes));
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

      if (PointerPath <> string.Empty) and (Segment <> string.Empty) then
        Segment := StringReplace(Segment, PointerPath, PointerValue, [rfReplaceAll]);

      Segment := StringReplace(Segment, '#10', #10, [rfReplaceAll]);
      FinalResult := FinalResult + Segment;
    end;
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

  if content <> string.Empty then
    Result := ParseResponse(content);

  if (Trim(Result) = string.Empty) then
  begin
    if not TryFormatJson(content, Result) then
      Result := content;
  end
  else
  if FIsTruncated then Result := Result + '...';
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
      if Terminated then Exit;
      if Length(Trim(FSourceText)) > 0 then
        FResultText := FTrans.Translate
      else
        FResultText := string.Empty;
      if Terminated then Exit;
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
      if Assigned(FMemo) then
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

end.
