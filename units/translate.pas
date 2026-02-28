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
  RegExpr,
  StdCtrls,
  Controls,
  fphttpclient,
  fpjson,
  jsonparser;

type
  TRequestType = (rtGet, rtPost);
  TResponseParserType = (rpJson, rpRegEx);

  { TTranslate }
  TTranslate = class
  private
    FRequestType: TRequestType;
    FResponseParserType: TResponseParserType;
    FUrl: string;
    FUserAgent: string;
    FContentType: string;
    FRegex: string;
    FTextToTranslate: string;
    FPostData: string;
    FLangSource: string;
    FLangTarget: string;
    FLanguages: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    function Get: string;
    function Post: string;
    function Request: string;
    function TransRegEx: string;
    function TransJson: string;
    function Translate: string;

    property RequestType: TRequestType read FRequestType write FRequestType;
    property ResponseParserType: TResponseParserType read FResponseParserType write FResponseParserType;
    property Url: string read FUrl write FUrl;
    property UserAgent: string read FUserAgent write FUserAgent;
    property ContentType: string read FContentType write FContentType;
    property RegexPattern: string read FRegex write FRegex;
    property TextToTranslate: string read FTextToTranslate write FTextToTranslate;
    property PostData: string read FPostData write FPostData;
    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property Languages: TStringList read FLanguages write FLanguages;
  end;

  { TTranslateThread }
  TTranslateThread = class(TThread)
  private
    FTrans: TTranslate;
    FSourceText: string;
    FResultText: string;
    FMemoTarget: TMemo;
  protected
    procedure Execute; override;
    procedure UpdateUI;
  public
    constructor Create(ATrans: TTranslate; AMemo: TMemo; const AText: string);
  end;

const
  defaultlang = 'en';

implementation

uses systemtool;

  { TTranslate }

constructor TTranslate.Create;
begin
  inherited Create;
  FRequestType := rtGet;
  FResponseParserType := rpJson;
  FUserAgent := 'Mozilla/5.0';
  FContentType := 'application/x-www-form-urlencoded';
  FLangSource := Language;
  FRegex := '\[\["(.*?)"';
  FLanguages := TStringList.Create;
end;

destructor TTranslate.Destroy;
begin
  FLanguages.Free;
  inherited Destroy;
end;

function TTranslate.Get: string;
var
  http: TFPHTTPClient;
  response: TStringStream;
  tarUrl: string;
begin
  Result := string.Empty;
  http := TFPHTTPClient.Create(nil);
  response := TStringStream.Create(string.Empty);
  try
    tarUrl := FUrl;
    http.AddHeader('User-Agent', FUserAgent);
    http.AllowRedirect := True;

    if FTextToTranslate <> string.Empty then
      tarUrl := StringReplace(tarUrl, '{text}', EncodeURLElement(FTextToTranslate), [rfReplaceAll])
    else
      tarUrl := StringReplace(tarUrl, '{text}', string.Empty, [rfReplaceAll]);

    if FLangSource <> string.Empty then
      tarUrl := StringReplace(tarUrl, '{source}', FLangSource, [rfReplaceAll])
    else
      tarUrl := StringReplace(tarUrl, '{source}', Language, [rfReplaceAll]);

    if FLangTarget <> string.Empty then
      tarUrl := StringReplace(tarUrl, '{target}', FLangTarget, [rfReplaceAll])
    else
      tarUrl := StringReplace(tarUrl, '{target}', defaultlang, [rfReplaceAll]);

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
begin
  Result := string.Empty;
  http := TFPHTTPClient.Create(nil);
  response := TStringStream.Create(string.Empty);
  try
    Data := StringReplace(FPostData, '{text}', TextToTranslate, [rfReplaceAll]);
    postStream := TStringStream.Create(Data, TEncoding.UTF8);
    try
      http.AddHeader('User-Agent', FUserAgent);
      http.AddHeader('Content-Type', FContentType);
      http.AllowRedirect := True;

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
  if FRequestType = rtPost then
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
  regex := TRegExpr.Create;
  try
    regex.Expression := FRegex;
    if regex.Exec(content) then
      Result := regex.Match[1];
  finally
    regex.Free;
  end;
end;

function TTranslate.TransJson: string;
var
  Data: TJSONData;
  Arr, Item: TJSONArray;
  i: integer;
  jsonStr: string;
begin
  Result := string.Empty;
  jsonStr := Request;

  if Trim(jsonStr) = string.Empty then Exit;

  Data := nil;
  try
    Data := fpjson.GetJSON(jsonStr);
    if (Data.Count > 0) and (Data.Items[0] is TJSONArray) then
    begin
      Arr := TJSONArray(Data.Items[0]);
      for i := 0 to Arr.Count - 1 do
      begin
        if Arr.Items[i] is TJSONArray then
        begin
          Item := TJSONArray(Arr.Items[i]);
          if Item.Count > 0 then
            Result := Result + Item.Strings[0];
        end;
      end;
    end;
  finally
    Data.Free;
  end;
end;

function TTranslate.Translate: string;
begin
  if FResponseParserType = rpJson then
    Result := TransJson
  else
    Result := TransRegEx;
end;

{ TTranslateThread }

constructor TTranslateThread.Create(ATrans: TTranslate; AMemo: TMemo; const AText: string);
begin
  inherited Create(True);
  FreeOnTerminate := True;

  FTrans := ATrans;
  FMemoTarget := AMemo;
  FSourceText := AText;

  Start;
end;

procedure TTranslateThread.Execute;
begin
  // Perform network request in background
  FTrans.TextToTranslate := FSourceText;

  if Length(Trim(FSourceText)) > 0 then
    FResultText := FTrans.Translate
  else
    FResultText := string.Empty;

  Synchronize(@UpdateUI);
end;

procedure TTranslateThread.UpdateUI;
begin
  // Update UI in main thread
  FMemoTarget.Text := FResultText;
  Screen.Cursor := crDefault;
end;

end.
