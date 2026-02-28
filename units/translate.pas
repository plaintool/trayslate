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
  TWebMethod = (wmGet, wmPost);
  TResponseParser = (rpJson, rpRegEx);

  { TTranslate }
  TTranslate = class
  private
    FWebMethod: TWebMethod;
    FResponseParser: TResponseParser;
    FUrl: string;
    FUserAgent: string;
    FContentType: string;
    FRegexp: string;
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

    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property TextToTranslate: string read FTextToTranslate write FTextToTranslate;

    property WebMethod: TWebMethod read FWebMethod write FWebMethod;
    property ResponseParser: TResponseParser read FResponseParser write FResponseParser;
    property Url: string read FUrl write FUrl;
    property UserAgent: string read FUserAgent write FUserAgent;
    property ContentType: string read FContentType write FContentType;
    property Regexp: string read FRegexp write FRegexp;
    property PostData: string read FPostData write FPostData;
    property Languages: TStringList read FLanguages write FLanguages;
  end;

  { TTranslateThread }
  TTranslateThread = class(TThread)
  private
    FTrans: TTranslate;
    FSourceText: string;
    FResultText: string;
    FMemoTarget: TMemo;
    FException: Exception;
  protected
    procedure Execute; override;
    procedure UpdateUI;
  public
    constructor Create(ATrans: TTranslate; AMemo: TMemo; const AText: string);
  end;

const
  defaultlang = 'en';

implementation

uses systemtool, formattool;

  { TTranslate }

constructor TTranslate.Create;
begin
  inherited Create;
  FWebMethod := wmGet;
  FResponseParser := rpJson;
  FUserAgent := 'Mozilla/5.0';
  FContentType := 'application/x-www-form-urlencoded';
  FLangSource := Language;
  FRegexp := '\[\["(.*?)"';
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
    Data := FPostData;

    if FTextToTranslate <> string.Empty then
      Data := StringReplace(Data, '{text}', EncodeURLElement(FTextToTranslate), [rfReplaceAll])
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
      end;
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
  Data: TJSONData;
  Arr, Item: TJSONArray;
  i: integer;
  jsonStr: string;
begin
  Result := string.Empty;
  jsonStr := Request;

  if Trim(jsonStr) = string.Empty then Exit;

  try
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
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message + #10 + jsonStr);
    end;
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
  try
    // Perform network request in background
    FTrans.TextToTranslate := FSourceText;

    if Length(Trim(FSourceText)) > 0 then
      FResultText := FTrans.Translate
    else
      FResultText := string.Empty;
  except
    on E: Exception do
      FException := Exception.Create(E.Message);
  end;
  Synchronize(@UpdateUI);
end;

procedure TTranslateThread.UpdateUI;
begin
  // Update UI in main thread
  Screen.Cursor := crDefault;
  if Assigned(FException) then
  begin
    if Assigned(Application.OnException) then
      Application.OnException(Self, FException)
    else
      Application.ShowException(FException);

    FreeAndNil(FException); // free manually
  end
  else
    FMemoTarget.Text := FResultText;
end;

end.
