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
  SysUtils,
  RegExpr,
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
    FSourceLang: string;
    FTargetLang: string;
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
    property SourceLang: string read FSourceLang write FSourceLang;
    property TargetLang: string read FTargetLang write FTargetLang;
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
  FSourceLang := Language;
  FRegex := '\[\["(.*?)"';
end;

destructor TTranslate.Destroy;
begin
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

    if FSourceLang <> string.Empty then
      tarUrl := StringReplace(tarUrl, '{source}', FSourceLang, [rfReplaceAll])
    else
      tarUrl := StringReplace(tarUrl, '{source}', Language, [rfReplaceAll]);

    if FTargetLang <> string.Empty then
      tarUrl := StringReplace(tarUrl, '{target}', FTargetLang, [rfReplaceAll])
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

end.
