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
  { TTranslate }
  TTranslate = class
  private
    FUsePost: boolean;
    FUrl: string;
    FUserAgent: string;
    FContentType: string;
    FRegex: string;
    FTextToTranslate: string;
    FPostDataTemplate: string;
    FSourceLang: string;
    FTargetLang: string;
    FDefaultTarget: string;
  public
    constructor Create;
    destructor Destroy; override;

    // Basic GET POST
    function Get: string;
    function Post: string;

    // Universal request depending on UsePost
    function Request: string;

    // Regex extraction
    function TransRegEx: string;

    // Parse JSON to get clean translated text
    function TransJson: string;

    property UsePost: boolean read FUsePost write FUsePost;
    property Url: string read FUrl write FUrl;
    property UserAgent: string read FUserAgent write FUserAgent;
    property ContentType: string read FContentType write FContentType;
    property RegexPattern: string read FRegex write FRegex;
    property TextToTranslate: string read FTextToTranslate write FTextToTranslate;
    property PostDataTemplate: string read FPostDataTemplate write FPostDataTemplate;
    property SourceLang: string read FSourceLang write FSourceLang;
    property TargetLang: string read FTargetLang write FTargetLang;
    property DefaultLang: string read FDefaultTarget write FDefaultTarget;
  end;

implementation

uses systemtool;

  { TTranslate }

constructor TTranslate.Create;
begin
  inherited Create;
  FUsePost := False;
  FUserAgent := 'Mozilla/5.0';
  FContentType := 'application/x-www-form-urlencoded';
  FSourceLang := Language;
  FDefaultTarget := 'en';
  FRegex := '\[\["(.*?)"';
  FTargetLang := FDefaultTarget;
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
      tarUrl := StringReplace(tarUrl, '{target}', FDefaultTarget, [rfReplaceAll]);

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
  postData: string;
begin
  Result := string.Empty;
  http := TFPHTTPClient.Create(nil);
  response := TStringStream.Create(string.Empty);
  try
    postData := StringReplace(FPostDataTemplate, '{text}', TextToTranslate, [rfReplaceAll]);
    postStream := TStringStream.Create(postData, TEncoding.UTF8);
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
  if FUsePost then
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

end.
