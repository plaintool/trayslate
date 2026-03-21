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
  HTTPDefs,
  fphttpclient,
  fpjson,
  jsonparser;

type
  TWebMethod = (wmGet, wmPost);
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
    function Post(ReturnHeaders: boolean = False): string;
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
    property JsonPointer: string read FJsonPointer write FJsonPointer;
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
  FullRandom: int64;
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

function TTranslate.SetParameters(Data: string): string;
var
  i: integer;
  ParamName: string;
  ParamValue: string;

  function Encrypt(AName, AValue: string): string;
  begin
    if (Lowercase(AName) = 'text') then
    begin
      if (FEncryptText) then
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
  Result := string.Empty;
  if FInitUrl = string.Empty then Exit;
  if SecondsBetween(Now, FParametersAge) < FInitLiveTime then Exit;
  FParameterValues.Clear;

  http := TFPHTTPClient.Create(nil);
  response := TMemoryStream.Create;
  try
    http.AllowRedirect := True;
    http.RequestHeaders.Clear;
    if FInitUserAgent <> string.Empty then
      http.AddHeader('User-Agent', FInitUserAgent);
    if Assigned(InitHeaders) then
      for i := 0 to InitHeaders.Count - 1 do
        http.AddHeader(InitHeaders.Names[i], InitHeaders.ValueFromIndex[i]);

    http.Get(FInitUrl, response);
    response.Position := 0;

    // form a line with headings
    header := string.Empty;
    for i := 0 to http.ResponseHeaders.Count - 1 do
      header := header + http.ResponseHeaders[i] + LineEnding;

    bodyStream := TStringStream.Create(string.Empty, TEncoding.UTF8);
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
  rawResponse: TMemoryStream;            // raw HTTP response data
  decompressedStream: TMemoryStream;     // used if decompression is needed
  bodyStream: TStringStream;             // final string representation (UTF-8)
  TempUrl: string;
  TempHeaders: TStringList;
  i: integer;
  header: string;
  contentEncoding: string;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  try
    // Get parameters from base + initial get
    GetParameters(GetInit);

    http := TFPHTTPClient.Create(nil);
    rawResponse := TMemoryStream.Create;
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

      // Perform the GET request; rawResponse receives the uncompressed data
      http.Get(TempUrl, rawResponse);
      rawResponse.Position := 0;

      // Determine if the response is gzip compressed
      contentEncoding := Trim(http.ResponseHeaders.Values['Content-Encoding']);
      if SameText(contentEncoding, 'gzip') and IsGzip(rawResponse) then
      begin
        decompressedStream := DecompressGzipToStream(rawResponse);
        try
          // Convert the decompressed stream to a UTF-8 string
          bodyStream := TStringStream.Create(string.Empty, TEncoding.UTF8);
          try
            bodyStream.CopyFrom(decompressedStream, 0);
            if ReturnHeaders then
            begin
              header := string.Empty;
              for i := 0 to http.ResponseHeaders.Count - 1 do
                header := header + http.ResponseHeaders[i] + LineEnding;
              Result := header + LineEnding + bodyStream.DataString;
            end
            else
              Result := bodyStream.DataString;
          finally
            bodyStream.Free;
          end;
        finally
          decompressedStream.Free;
        end;
      end
      else
      begin
        // Plain text response (no decompression)
        bodyStream := TStringStream.Create(string.Empty, TEncoding.UTF8);
        try
          bodyStream.CopyFrom(rawResponse, 0);
          if ReturnHeaders then
          begin
            header := string.Empty;
            for i := 0 to http.ResponseHeaders.Count - 1 do
              header := header + http.ResponseHeaders[i] + LineEnding;
            Result := header + LineEnding + bodyStream.DataString;
          end
          else
            Result := bodyStream.DataString;
        finally
          bodyStream.Free;
        end;
      end;
    finally
      rawResponse.Free;
      http.Free;
    end;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

function TTranslate.Post(ReturnHeaders: boolean = False): string;
var
  http: TFPHTTPClient;
  rawResponse: TMemoryStream;            // raw HTTP response data
  decompressedStream: TMemoryStream;     // used if decompression is needed
  bodyStream: TStringStream;             // final string representation (UTF-8)
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

    http := TFPHTTPClient.Create(nil);
    rawResponse := TMemoryStream.Create;
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
        http.Post(TempUrl, rawResponse);
        rawResponse.Position := 0;

        // Determine if the response is gzip compressed
        contentEncoding := Trim(http.ResponseHeaders.Values['Content-Encoding']);
        if SameText(contentEncoding, 'gzip') and IsGzip(rawResponse) then
        begin
          decompressedStream := DecompressGzipToStream(rawResponse);
          try
            bodyStream := TStringStream.Create(string.Empty, TEncoding.UTF8);
            try
              bodyStream.CopyFrom(decompressedStream, 0);
              Result := bodyStream.DataString;
            finally
              bodyStream.Free;
            end;
          finally
            decompressedStream.Free;
          end;
        end
        else
        begin
          bodyStream := TStringStream.Create(string.Empty, TEncoding.UTF8);
          try
            bodyStream.CopyFrom(rawResponse, 0);
            if ReturnHeaders then
            begin
              header := string.Empty;
              for i := 0 to http.ResponseHeaders.Count - 1 do
                header := header + http.ResponseHeaders[i] + LineEnding;
              Result := header + LineEnding + bodyStream.DataString;
            end
            else
              Result := bodyStream.DataString;
          finally
            bodyStream.Free;
          end;
        end;
      finally
        postStream.Free;
      end;
    finally
      rawResponse.Free;
      http.Free;
    end;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

function TTranslate.TransJson(content: string): string;
var
  Segments: TStringList;
  regex: TRegExpr;
  i, j, k, pStart, pEnd, rStart, rEnd, OpenBrackets, SlashPos: integer;
  Segment, FinalResult, PointerPath, PointerValue, CurrentContext: string;
  BlockContent, ProcessedBlock, Prefix, RegexPart, Suffix, MatchRes: string;
  PointerFound, IsInverted: boolean;
begin
  Result := '';
  if (Trim(content) = '') then Exit;
  if not IsJson(content) then Exit(content);
  if (JsonPointer = '') then Exit(content);

  Segments := TStringList.Create;
  regex := TRegExpr.Create;
  regex.ModifierStr := 'i';
  FinalResult := '';
  try
    Segments.Delimiter := ';';
    Segments.StrictDelimiter := True;
    Segments.DelimitedText := JsonPointer;

    for i := 0 to Segments.Count - 1 do
    begin
      Segment := Trim(Segments[i]);
      if Segment = '' then Continue;

      PointerPath := '';
      PointerValue := '';
      PointerFound := False;
      IsInverted := False;
      SlashPos := 0;

      // 1. Check if the segment starts with the inversion marker '!'
      if (Segment <> '') and (Segment[1] = '!') then
      begin
        IsInverted := True;
        Delete(Segment, 1, 1); // Remove '!' for further processing
      end;

      // Locate JSON Pointer
      OpenBrackets := 0;
      for j := 1 to Length(Segment) do
      begin
        if Segment[j] = '{' then Inc(OpenBrackets)
        else if Segment[j] = '}' then Dec(OpenBrackets)
        else if (OpenBrackets = 0) and (Segment[j] = '/') then
        begin
          SlashPos := j;
          Break;
        end;
      end;

      if SlashPos > 0 then
      begin
        pEnd := SlashPos;
        while (pEnd <= Length(Segment)) and (Segment[pEnd] <> '{') do Inc(pEnd);
        PointerPath := Trim(Copy(Segment, SlashPos, pEnd - SlashPos));

        PointerValue := ParseJsonByPointer(content, PointerPath);

        if IsInverted then
        begin
          // INVERSION LOGIC:
          // If data is FOUND, we return empty string to kill the error segment.
          // If data is NOT found (Empty), we return a placeholder to keep the segment alive.
          if PointerValue <> '' then
            Continue // Key exists, so this "Error Segment" should be hidden
          else
            PointerValue := ' '; // Key missing, keep segment to show the error text
        end;

        PointerValue := UnescapeUnicode(HTTPDecode(PointerValue));

        // Rule: If pointer is empty (and not inverted), skip segment
        if (not IsInverted) and (PointerValue = '') then Continue;

        PointerFound := True;
        Segment := StringReplace(Segment, PointerPath, PointerValue, [rfReplaceAll]);
      end;

      if PointerFound then CurrentContext := PointerValue
      else
        CurrentContext := content;

      // 2. Process all {blocks}
      k := 1;
      while k <= Length(Segment) do
      begin
        if Segment[k] = '{' then
        begin
          pStart := k;
          pEnd := pStart + 1;
          OpenBrackets := 1;
          while (pEnd <= Length(Segment)) and (OpenBrackets > 0) do
          begin
            if Segment[pEnd] = '{' then Inc(OpenBrackets);
            if Segment[pEnd] = '}' then Dec(OpenBrackets);
            if OpenBrackets > 0 then Inc(pEnd);
          end;

          BlockContent := Copy(Segment, pStart + 1, pEnd - pStart - 1);
          ProcessedBlock := '';

          try
            if (pStart > 1) and (Segment[pStart - 1] = '{') then
            begin
              regex.Expression := BlockContent;
              if regex.Exec(CurrentContext) then
              begin
                if regex.SubExprMatchCount > 0 then MatchRes := regex.Match[1]
                else
                  MatchRes := regex.Match[0];
                ProcessedBlock := UnescapeUnicode(HTTPDecode(MatchRes));
              end;
              Dec(pStart);
              Inc(pEnd);
            end
            else
            begin
              rStart := Pos('{', BlockContent);
              if rStart > 0 then
              begin
                rEnd := Length(BlockContent);
                while (rEnd > rStart) and (BlockContent[rEnd] <> '}') do Dec(rEnd);
                Prefix := Copy(BlockContent, 1, rStart - 1);
                RegexPart := Copy(BlockContent, rStart + 1, rEnd - rStart - 1);
                Suffix := Copy(BlockContent, rEnd + 1, Length(BlockContent));
                regex.Expression := RegexPart;
                if regex.Exec(CurrentContext) then
                begin
                  if regex.SubExprMatchCount > 0 then MatchRes := regex.Match[1]
                  else
                    MatchRes := regex.Match[0];
                  ProcessedBlock := Prefix + UnescapeUnicode(HTTPDecode(MatchRes)) + Suffix;
                end
                else
                  ProcessedBlock := '';
              end
              else
                ProcessedBlock := BlockContent;
            end;
          except
            ProcessedBlock := '';
          end;

          Delete(Segment, pStart, pEnd - pStart + 1);
          Insert(ProcessedBlock, Segment, pStart);
          k := pStart + Length(ProcessedBlock);
        end
        else
          Inc(k);
      end;

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
  if FWebMethod = wmPost then
    content := Post
  else
    content := Get;

  Result := TransJson(content);
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
