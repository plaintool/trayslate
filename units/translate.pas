//-----------------------------------------------------------------------------------
//  Trayslator © 2024 by Alexander Tverskoy
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
    FResponseParser: TResponseParser;
    FUrl: string;
    FPostData: string;
    FUserAgent: string;
    FContentType: string;
    FAccept: string;
    FRegexp: string;
    FJsonPointer: string;
    FEncryptText: boolean;
    FLanguages: TStringList;
    FLanguagesTarget: TStringList;
    FHeaders: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    function Get: string;
    function Post: string;
    function Request: string;
    function TransRegEx: string;
    function TransJson: string;
    function Translate: string;

    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property TextToTranslate: string read FTextToTranslate write FTextToTranslate;

    property ServiceName: string read FServiceName write FServiceName;
    property WebMethod: TWebMethod read FWebMethod write FWebMethod;
    property ResponseParser: TResponseParser read FResponseParser write FResponseParser;
    property Url: string read FUrl write FUrl;
    property PostData: string read FPostData write FPostData;
    property UserAgent: string read FUserAgent write FUserAgent;
    property ContentType: string read FContentType write FContentType;
    property Accept: string read FAccept write FAccept;
    property Regexp: string read FRegexp write FRegexp;
    property JsonPointer: string read FJsonPointer write FJsonPointer;
    property EncryptText: boolean read FEncryptText write FEncryptText;
    property Languages: TStringList read FLanguages write FLanguages;
    property LanguagesTarget: TStringList read FLanguagesTarget write FLanguagesTarget;
    property Headers: TStringList read FHeaders write FHeaders;
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

implementation

uses systemtool, langtool, formattool;

  { TTranslate }

constructor TTranslate.Create;
begin
  inherited Create;
  FServiceName := 'default';
  FWebMethod := wmGet;
  FUserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:148.0) Gecko/20100101 Firefox/148.0';
  FContentType := 'application/json';
  FUrl := string.Empty;
  FPostData := string.Empty;
  FAccept := 'application/json';
  FEncryptText := True;
  FResponseParser := rpJson;
  FJsonPointer := '/0/*/0';
  FRegexp := string.Empty;
  FEncryptText := True;

  FLangSource := defaultlang;
  FLangTarget := Language;
  FLanguages := TStringList.Create;
  FLanguages.TrailingLineBreak := False;
  FLanguagesTarget := TStringList.Create;
  FLanguagesTarget.TrailingLineBreak := False;
  FHeaders := TStringList.Create;
  FHeaders.TrailingLineBreak := False;
end;

destructor TTranslate.Destroy;
begin
  FLanguages.Free;
  FLanguagesTarget.Free;
  FHeaders.Free;
  inherited Destroy;
end;

function TTranslate.Get: string;
var
  http: TFPHTTPClient;
  response: TStringStream;
  tarUrl: string;
  i: integer;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  http := TFPHTTPClient.Create(nil);
  response := TStringStream.Create(string.Empty);
  try
    tarUrl := FUrl;
    http.AllowRedirect := True;
    http.RequestHeaders.Clear;
    if (FUserAgent <> string.Empty) then
      http.AddHeader('User-Agent', FUserAgent);
    if (FContentType <> string.Empty) then
      http.AddHeader('Content-Type', FContentType);
    if (FAccept <> string.Empty) then
      http.AddHeader('Accept', FAccept);
    if Assigned(Headers) then
      for i := 0 to Headers.Count - 1 do
        http.AddHeader(Headers.Names[i], Headers.ValueFromIndex[i]);

    if FTextToTranslate <> string.Empty then
      tarUrl := StringReplace(tarUrl, '{text}', ifthen(FEncryptText, EncodeURLElement(FTextToTranslate), FTextToTranslate), [rfReplaceAll])
    else
      tarUrl := StringReplace(tarUrl, '{text}', string.Empty, [rfReplaceAll]);

    if FLangSource <> string.Empty then
      tarUrl := StringReplace(tarUrl, '{source}', FLangSource, [rfReplaceAll])
    else
      tarUrl := StringReplace(tarUrl, '{source}', defaultlang, [rfReplaceAll]);

    if FLangTarget <> string.Empty then
      tarUrl := StringReplace(tarUrl, '{target}', FLangTarget, [rfReplaceAll])
    else
      tarUrl := StringReplace(tarUrl, '{target}', Language, [rfReplaceAll]);

    http.Get(tarUrl, response);
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
  Data: string;
  i: integer;
begin
  Result := string.Empty;
  if FUrl = string.Empty then exit;

  http := TFPHTTPClient.Create(nil);
  response := TStringStream.Create(string.Empty);
  try
    Data := FPostData;

    if FTextToTranslate <> string.Empty then
      Data := StringReplace(Data, '{text}', ifthen(FEncryptText, EncodeURLElement(FTextToTranslate), FTextToTranslate), [rfReplaceAll])
    else
      Data := StringReplace(Data, '{text}', string.Empty, [rfReplaceAll]);

    if FLangSource <> string.Empty then
      Data := StringReplace(Data, '{source}', FLangSource, [rfReplaceAll])
    else
      Data := StringReplace(Data, '{source}', Language, [rfReplaceAll]);

    if FLangTarget <> string.Empty then
      Data := StringReplace(Data, '{target}', FLangTarget, [rfReplaceAll])
    else
      Data := StringReplace(Data, '{target}', defaultlang, [rfReplaceAll]);

    postStream := TStringStream.Create(Data, TEncoding.UTF8);
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
        for i := 0 to Headers.Count - 1 do
          http.AddHeader(Headers.Names[i], Headers.ValueFromIndex[i]);

      http.RequestBody := postStream;
      http.Post(FUrl, response);
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

  FTrans := ATrans;
  if Assigned(AMemo) then FMemo := AMemo;
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
end;

end.
