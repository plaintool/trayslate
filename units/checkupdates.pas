//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit checkupdates;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  Controls,
  SysUtils,
  Dialogs,
  FileInfo,
  LCLIntf,
  fphttpclient,
  {$IFDEF WINDOWS}
  wininet,
  {$ENDIF}
  {$IFDEF Linux}
  Unix,
  opensslsockets,
  {$ENDIF}
  {$IFDEF MacOS}
  MacOSAll,
  opensslsockets,
  {$ENDIF}
  fpjson;

type
  TCheckUpdateThread = class(TThread)
  private
    FRepo: string;       // GitHub repository (e.g. 'user/repo')
    FAppName: string;    // Application name for dialog captions
    FLatestVersion: string;
  protected
    procedure Execute; override;
    procedure UpdateAvailable;
  public
    // Pass all required parameters through the constructor
    constructor Create(const ARepo, AAppName: string; CreateSuspended: Boolean = True);
  end;

{ Check Github Version }
// Added AppName parameter to avoid global 'rappname' dependency.
// When Silent = True, AppName is not used and can be empty.
function CheckGithubLatestVersion(out Version: string; const Repo: string;
  const AppName: string; const Silent: boolean = False): boolean;

function GetAppVersion: string;

resourcestring
  newversion = 'New version available: %s. Open GitHub page to download?';
  newversionuptodate = 'Your version is up to date.';
  newversioncheckerror = 'Error checking version:';

implementation

{%Region -fold CheckUpdateThread}

constructor TCheckUpdateThread.Create(const ARepo, AAppName: string; CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FRepo := ARepo;
  FAppName := AAppName;
  FreeOnTerminate := True;   // optional, as before
end;

procedure TCheckUpdateThread.Execute;
begin
  // Use fields instead of global REPO
  if CheckGithubLatestVersion(FLatestVersion, FRepo, '', True) then
  begin
    Synchronize(@UpdateAvailable);
  end;
end;

procedure TCheckUpdateThread.UpdateAvailable;
begin
  // Use fields instead of global rappname and REPO
  if MessageDlg(FAppName, Format(newversion, [FLatestVersion]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    OpenURL(Format('https://github.com/%s/releases/latest', [FRepo]));
end;

{%EndRegion}

{%Region -fold Check Github Version}

function CheckGithubLatestVersion(out Version: string; const Repo: string;
  const AppName: string; const Silent: boolean = False): boolean;
var
  JsonData: TJSONData;
  LatestVersion, Msg: string;
  Url: string;
  CurrentVersion: string;
  ResponseContent: string;
  ErrorMsg: string;

{$IFDEF WINDOWS}

  function HttpGetWinInet(const AUrl: string): string;
  var
    hInet, hUrl: HINTERNET;
    Buffer: array[0..4095] of Char;
    BytesRead: DWORD = 0;
    I: Integer;
  begin
    for I := 0 to High(Buffer) do
      Buffer[I] := #0;

    Result := '';
    hInet := InternetOpen('TrayslateVersionChecker', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    if hInet = nil then
      Exit;

    try
      hUrl := InternetOpenUrl(hInet, PChar(AUrl), nil, 0,
                             INTERNET_FLAG_RELOAD or INTERNET_FLAG_SECURE or
                             INTERNET_FLAG_EXISTING_CONNECT, 0);
      if hUrl = nil then
        Exit;

      try
        while InternetReadFile(hUrl, @Buffer, SizeOf(Buffer), BytesRead) and (BytesRead > 0) do
        begin
          Result := Result + Copy(Buffer, 1, BytesRead);
        end;
      finally
        InternetCloseHandle(hUrl);
      end;
    finally
      InternetCloseHandle(hInet);
    end;
  end;

  function HttpClientGet(const AUrl: string): string;
  var
    HttpClient: TFPHTTPClient;
  begin
    try
      HttpClient := TFPHTTPClient.Create(nil);
      try
        HttpClient.AddHeader('User-Agent', 'TrayslateVersionChecker');
        HttpClient.AllowRedirect := True;
        HttpClient.ConnectTimeout := 5000;
        HttpClient.IOTimeout := 5000;
        Result := HttpClient.Get(AUrl);
      finally
        HttpClient.Free;
      end;
    except
      Result := string.Empty;
    end;
  end;

{$ELSE}

  function HttpGetCurl(const AUrl: string): string;
  var
    Process: TProcess;
    OutputStream: TMemoryStream;
    BytesRead: longint;
    Buffer: TBytes = nil;
    OutputString: ansistring = '';
  begin
    Result := '';
    SetLength(Buffer, 2048);
    Process := TProcess.Create(nil);
    OutputStream := TMemoryStream.Create;
    try
      Process.Executable := 'curl';
      Process.Parameters.Add('-s');
      Process.Parameters.Add('-L');
      Process.Parameters.Add('-H');
      Process.Parameters.Add('User-Agent: TrayslateVersionChecker');
      Process.Parameters.Add(AUrl);

      Process.Options := [poUsePipes, poNoConsole];
      Process.Execute;

      while Process.Running or (Process.Output.NumBytesAvailable > 0) do
      begin
        BytesRead := Process.Output.Read(Buffer[1], SizeOf(Buffer));
        if BytesRead > 0 then
          OutputStream.Write(Buffer[1], BytesRead);
      end;

      Process.WaitOnExit;

      if OutputStream.Size > 0 then
      begin
        SetLength(OutputString, OutputStream.Size);
        OutputStream.Position := 0;
        OutputStream.Read(OutputString[1], OutputStream.Size);
        Result := string(OutputString);
      end;
    finally
      OutputStream.Free;
      Process.Free;
    end;
  end;

  function IsCurlAvailable: boolean;
  var
    Process: TProcess;
    ExitStatus: integer;
  begin
    Result := False;
    Process := TProcess.Create(nil);
    try
      Process.Executable := 'curl';
      Process.Parameters.Add('--version');
      Process.Options := [poWaitOnExit, poNoConsole, poUsePipes];
      Process.ShowWindow := swoHIDE;

      try
        Process.Execute;
        Process.WaitOnExit;
        ExitStatus := Process.ExitStatus;
        Result := (ExitStatus = 0);
      except
        on E: EProcess do
          Result := False;
        on E: Exception do
          Result := False;
      end;
    finally
      Process.Free;
    end;
  end;

  function HttpGetWget(const AUrl: string): string;
  var
    Process: TProcess;
    OutputStream: TMemoryStream;
    BytesRead: longint;
    Buffer: TBytes = ();
  begin
    Result := '';
    SetLength(Buffer, 2048);
    Process := TProcess.Create(nil);
    OutputStream := TMemoryStream.Create;
    try
      Process.Executable := 'wget';
      Process.Parameters.Add('-q');
      Process.Parameters.Add('-O');
      Process.Parameters.Add('-');
      Process.Parameters.Add('--header=User-Agent: TrayslateVersionChecker');
      Process.Parameters.Add(AUrl);

      Process.Options := [poUsePipes, poNoConsole];
      Process.Execute;

      while Process.Running or (Process.Output.NumBytesAvailable > 0) do
      begin
        BytesRead := Process.Output.Read(Buffer[0], Length(Buffer));
        if BytesRead > 0 then
          OutputStream.Write(Buffer[0], BytesRead);
      end;

      Process.WaitOnExit;

      if OutputStream.Size > 0 then
      begin
        SetLength(Result, OutputStream.Size);
        OutputStream.Position := 0;
        OutputStream.Read(Result[1], OutputStream.Size);
      end;
    finally
      OutputStream.Free;
      Process.Free;
    end;
  end;

  function IsWgetAvailable: boolean;
  var
    Process: TProcess;
  begin
    Result := False;
    Process := TProcess.Create(nil);
    try
      Process.Executable := 'wget';
      Process.Parameters.Add('--version');
      Process.Options := [poWaitOnExit, poNoConsole];
      try
        Process.Execute;
        Process.WaitOnExit;
        Result := (Process.ExitStatus = 0);
      except
        Result := False;
      end;
    finally
      Process.Free;
    end;
  end;

{$ENDIF}
begin
  Result := False;
  Version := string.Empty;
  try
    CurrentVersion := GetAppVersion;
    Url := Format('https://api.github.com/repos/%s/releases/latest', [Repo]);

    {$IFDEF WINDOWS}
    ResponseContent := HttpClientGet(Url);
    if ResponseContent = string.Empty then
      ResponseContent := HttpGetWinInet(Url);
    {$ELSE}
    try
      with TFPHttpClient.Create(nil) do
      try
        AddHeader('User-Agent', 'TrayslateVersionChecker');
        ResponseContent := Get(Url);
      finally
        Free;
      end;
    except
      on E: Exception do
      begin
        if IsCurlAvailable then
        begin
          ResponseContent := HttpGetCurl(Url);
        end
        else if IsWgetAvailable then
        begin
          ResponseContent := HttpGetWget(Url);
        end
        else
        begin
          if not Silent then
            ShowMessage(newversioncheckerror + ' ' + 'Please install OpenSSL, curl or wget library!');
          Exit;
        end;
      end;
    end;
    {$ENDIF}

    if ResponseContent <> string.Empty then
    begin
      JsonData := GetJSON(ResponseContent);
      try
        if JsonData.FindPath('tag_name') = nil then
        begin
          try
            ErrorMsg := JsonData.GetPath('message').AsString;
            if not Silent then
            begin
              if ErrorMsg <> string.Empty then
                ShowMessage(newversioncheckerror + LineEnding + Url + LineEnding + 'GitHub API: ' + ErrorMsg)
              else
                ShowMessage(newversioncheckerror + LineEnding + Url);
            end;
          except
            if not Silent then
              ShowMessage(newversioncheckerror + LineEnding + Url);
          end;
          Exit;
        end;

        LatestVersion := JsonData.GetPath('tag_name').AsString;

        if AnsiLowerCase(StringReplace(LatestVersion, 'v', '', [rfReplaceAll])) <> AnsiLowerCase(
          StringReplace(CurrentVersion, 'v', '', [rfReplaceAll])) then
        begin
          Version := LatestVersion;
          if not Silent then
          begin
            Msg := Format(newversion, [LatestVersion]);
            // Use the passed AppName instead of global rappname
            if MessageDlg(AppName, Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
              OpenURL(Format('https://github.com/%s/releases/latest', [Repo]));
          end;
          Result := True;
        end
        else
        begin
          if not Silent then
            ShowMessage(newversionuptodate);
        end;
      finally
        JsonData.Free;
      end;
    end
    else
    begin
      if not Silent then
        ShowMessage(newversioncheckerror + LineEnding + Url);
    end;
  except
    on E: Exception do
    begin
      Result := False;
      if not Silent then
        ShowMessage(newversioncheckerror + LineEnding + Url + LineEnding + E.Message);
    end;
  end;
end;

function GetAppVersion: string;
var
  Info: TFileVersionInfo;
begin
  Info := TFileVersionInfo.Create(nil);
  try
    Info.FileName := ParamStr(0);
    Info.ReadFileInfo;
    Result := Info.VersionStrings.Values['ProductVersion'];
  finally
    Info.Free;
  end;
end;

{%EndRegion}

end.
