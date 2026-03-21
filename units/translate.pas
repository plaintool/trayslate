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
    function ParseResponse(content: string): string;
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
  DEFAULT_LANG = 'en';
  EMPTY_LANG = 'empty';
  REGEXP_ERROR = 'REGEX_ERROR: ';

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

  FLangSource := DEFAULT_LANG;
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
    FParameterValues.Values['source'] := ifthen(FLangSource = EMPTY_LANG, string.Empty, FLangSource)
  else
    FParameterValues.Values['source'] := DEFAULT_LANG;

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

      if (FLangSource = EMPTY_LANG) or (FLangSource = EMPTY_LANG) then
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

      if (FLangSource = EMPTY_LANG) or (FLangSource = EMPTY_LANG) then
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
begin
  Result := string.Empty;
  if (Trim(content) = string.Empty) then Exit;
  if (JsonPointer = string.Empty) then Exit(content);

  Segments := TStringList.Create;
  regex := TRegExpr.Create;
  regex.ModifierStr := 'is';
  FinalResult := string.Empty;
  try
    Segments.Delimiter := ';';
    Segments.StrictDelimiter := True;
    Segments.DelimitedText := JsonPointer;

    for i := 0 to Segments.Count - 1 do
    begin
      Segment := Trim(Segments[i]);
      if Segment = string.Empty then Continue;

      PointerPath := string.Empty;
      PointerValue := string.Empty;
      PointerFound := False;
      IsInverted := False;
      SlashPos := 0;

      // 1 & 2. SEGMENT SCAN
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

      // 3. POINTER PROCESSING
      if SlashPos > 0 then
      begin
        pEnd := SlashPos;
        while (pEnd <= Length(Segment)) and (Segment[pEnd] <> '{') do Inc(pEnd);
        PointerPath := Trim(Copy(Segment, SlashPos, pEnd - SlashPos));

        if PointerPath = '~' then PointerValue := content
        else
          PointerValue := ParseJsonByPointer(content, PointerPath);

        if IsInverted then
        begin
          if PointerValue <> string.Empty then Continue
          else
            PointerValue := ' ';
        end;

        PointerValue := UnescapeUnicode(HTTPDecode(PointerValue));
        if (not IsInverted) and (PointerValue = string.Empty) then Continue;
        PointerFound := True;
      end;

      // 4. BLOCK PROCESSING
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
                      if InnerBlock[rStart] = '[' then
                      begin
                        MatchIdxStr := Copy(InnerBlock, rStart + 1, rEnd - rStart);
                        if MatchIdxStr = '*' then MatchGlue := ' '
                        else if MatchIdxStr = '*#10' then MatchGlue := #10
                        else if TryStrToInt(MatchIdxStr, MatchIdx) then
                        begin
                        end;

                        if (MatchGlue <> string.Empty) or (MatchIdx <> -1) then
                          InnerBlock := Copy(InnerBlock, 1, rStart - 1);
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
                        HasAnyMatch := True; // Show the error, don't hide the block
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

            // If we had regexes but NONE of them found anything (and no errors occurred), hide block
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

      if PointerFound and (PointerPath <> string.Empty) then
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
    Result := content;
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
