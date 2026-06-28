//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit network;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  Controls,
  SysUtils,
  Math,
  Dialogs,
  LCLIntf,
  LCLType,
  PasZLib,
  {$IFDEF WINDOWS}
  Windows,
  wininet,
  {$ENDIF}
  {$IFDEF Linux}
  Unix,
  Process,
  opensslsockets,
  {$ENDIF}
  {$IFDEF MacOS}
  MacOSAll,
  opensslsockets,
  {$ENDIF}
  fpjson,
  jsonparser,
  {$PUSH}
  {$WARNINGS OFF}
  {$HINTS OFF}
  {$NOTES OFF}
  httpsend,
  blcksock,
  ssl_openssl11;
  {$POP}

type
  { TWebMethod }

  TWebMethod = (wmGet, wmPost);

  { TProxyMode }

  TProxyMode = (pmNone, pmSystem, pmCustom);

  { TProxyType }

  TProxyType = (ptHTTP, ptSOCKS4, ptSOCKS5);

  { TProxy }

  TProxy = record
    ProxyMode: TProxyMode;
    ProxyType: TProxyType;

    Host: string;
    Port: string;

    Authentication: boolean;
    Login: string;
    Password: string;
  end;

  TTimeout = record
    Request: integer;
    Connection: integer;
  end;

  TNetwork = class sealed
  public
    { Web Request }
    class function GetSynapseHeader(const AHeaders: TStringList; const AName: string): string; static;
    class function GetSystemProxy(out Host: string; out Port: integer): boolean; static;
    class procedure ApplyProxy(HTTP: THTTPSend; const P: TProxy);
    class function WebRequest(AMethod: TWebMethod; const AUrl: string; const APostData: string; AHeaders: TStrings;
      const AUserAgent, AContentType, AAccept: string; AllowProxy: boolean; AProxy: TProxy; ATimeout: TTimeout;
      out AResponseHeaders: TStringList; out AError: boolean): string; static;
    { Gzip }
    class function IsGzip(Stream: TMemoryStream): boolean; static;
    class function DecompressGzipToStream(Compressed: TMemoryStream): TMemoryStream; static;
  end;

const
  CONNECT_TIMEOUT = 10000;
  REQUEST_TIMEOUT = 300000;

implementation

{%Region -fold Web Request}

class function TNetwork.GetSynapseHeader(const AHeaders: TStringList; const AName: string): string;
var
  j: integer;
  s: string;
  prefix: string;
begin
  Result := string.Empty;
  prefix := AName + ':';
  for j := 0 to AHeaders.Count - 1 do
  begin
    s := AHeaders[j];
    if Pos(prefix, s) = 1 then
    begin
      Result := Trim(Copy(s, Length(prefix) + 1, MaxInt));
      Break;
    end;
  end;
end;

class function TNetwork.GetSystemProxy(out Host: string; out Port: integer): boolean;
var
  {$IFDEF WINDOWS}
  ProxyInfo: PInternetProxyInfo;
  Size: DWORD;
  ProxyStr: string;
  P1: Integer;
  {$ENDIF}

  {$IFDEF LINUX}
  Proxy: string;
  P1: Integer;
  {$ENDIF}
begin
  Result := False;
  Host := '';
  Port := 0;

  {$IFDEF WINDOWS}
  Size := 0;
  InternetQueryOption(nil, INTERNET_OPTION_PROXY, nil, Size);
  if Size = 0 then Exit;

  GetMem(ProxyInfo, Size);
  try
    if not InternetQueryOption(nil, INTERNET_OPTION_PROXY, ProxyInfo, Size) then
      Exit;

    // make sure proxy is really enabled and the string pointer is valid
    if (ProxyInfo^.dwAccessType <> INTERNET_OPEN_TYPE_PROXY) or
       (ProxyInfo^.lpszProxy = nil) then Exit;

    ProxyStr := ProxyInfo^.lpszProxy;

    // try to extract an HTTP (or HTTPS) proxy entry
    // format is typically "http=host:port;https=host:port" or just "host:port"
    if Pos('http=', LowerCase(ProxyStr)) > 0 then
      ProxyStr := Trim(Copy(ProxyStr, Pos('=', ProxyStr) + 1, MaxInt))
    else if Pos('https=', LowerCase(ProxyStr)) > 0 then
      ProxyStr := Trim(Copy(ProxyStr, Pos('=', ProxyStr) + 1, MaxInt))
    else if Pos('=', ProxyStr) > 0 then
      ProxyStr := Trim(Copy(ProxyStr, Pos('=', ProxyStr) + 1, MaxInt));

    // cut off any trailing parameters (other proxies, spaces)
    P1 := Pos(';', ProxyStr);
    if P1 > 0 then
      ProxyStr := Trim(Copy(ProxyStr, 1, P1 - 1));
    P1 := Pos(' ', ProxyStr);
    if P1 > 0 then
      ProxyStr := Trim(Copy(ProxyStr, 1, P1 - 1));

    // now we should have a clean "host:port" pair
    P1 := Pos(':', ProxyStr);
    if P1 = 0 then Exit;

    Host := Trim(Copy(ProxyStr, 1, P1 - 1));
    Port := StrToIntDef(Trim(Copy(ProxyStr, P1 + 1, MaxInt)), 0);

    Result := Host <> '';
  finally
    FreeMem(ProxyInfo);
  end;
  {$ENDIF}

  {$IFDEF LINUX}
  Proxy := GetEnvironmentVariable('http_proxy');
  if Proxy = '' then
    Proxy := GetEnvironmentVariable('https_proxy');
  if Proxy = '' then
    Proxy := GetEnvironmentVariable('all_proxy');

  if Proxy = '' then Exit;

  if Pos('://', Proxy) > 0 then
    Delete(Proxy, 1, Pos('://', Proxy) + 2);

  P1 := Pos(':', Proxy);
  if P1 = 0 then Exit;

  Host := Copy(Proxy, 1, P1 - 1);
  Port := StrToIntDef(Copy(Proxy, P1 + 1, MaxInt), 8080);

  Result := Host <> '';
  {$ENDIF}
end;

class procedure TNetwork.ApplyProxy(HTTP: THTTPSend; const P: TProxy);
var
  Host: string;
  Port: integer;
begin
  case P.ProxyMode of
    pmNone:
      Exit;

    pmSystem:
      if GetSystemProxy(Host, Port) then
      begin
        HTTP.ProxyHost := Host;
        HTTP.ProxyPort := Port.ToString;
      end;

    pmCustom:
    begin
      case P.ProxyType of
        ptHTTP:
        begin
          HTTP.ProxyHost := P.Host;
          HTTP.ProxyPort := P.Port;
          if P.Authentication then
          begin
            HTTP.ProxyUser := P.Login;
            HTTP.ProxyPass := P.Password;
          end;
        end;

        ptSOCKS4:
        begin
          HTTP.Sock.SocksType := ST_Socks4;
          HTTP.Sock.SocksIP := P.Host;
          HTTP.Sock.SocksPort := P.Port;
          if P.Authentication then
          begin
            HTTP.Sock.SocksUsername := P.Login;
            HTTP.Sock.SocksPassword := P.Password;
          end;
        end;

        ptSOCKS5:
        begin
          HTTP.Sock.SocksType := ST_Socks5;
          HTTP.Sock.SocksIP := P.Host;
          HTTP.Sock.SocksPort := P.Port;
          if P.Authentication then
          begin
            HTTP.Sock.SocksUsername := P.Login;
            HTTP.Sock.SocksPassword := P.Password;
          end;
        end;
        else
          ;
      end;
    end;
    else
      ;
  end;
end;

class function TNetwork.WebRequest(AMethod: TWebMethod; const AUrl: string; const APostData: string;
  AHeaders: TStrings; const AUserAgent, AContentType, AAccept: string; AllowProxy: boolean; AProxy: TProxy;
  ATimeout: TTimeout; out AResponseHeaders: TStringList; out AError: boolean): string;
var
  HTTP: THTTPSend;
  SSL: TSSLOpenSSL;
  rawStream: TMemoryStream;
  decompressedStream: TMemoryStream;
  bodyStream: TStringStream;
  postStream: TStringStream;
  contentEncoding: string;
  i: integer;
begin
  Result := string.Empty;
  AResponseHeaders := TStringList.Create;
  AError := False;

  HTTP := THTTPSend.Create;
  rawStream := TMemoryStream.Create;
  try
    // Common setup
    HTTP.Protocol := '1.1';
    SSL := TSSLOpenSSL.Create(HTTP.Sock);
    HTTP.Sock.SSL.SSLType := LT_TLSv1_2;

    // Timeouts
    HTTP.Timeout := IfThen(ATimeout.Request > 0, ATimeout.Request, REQUEST_TIMEOUT);
    HTTP.Sock.ConnectionTimeout := IfThen(ATimeout.Connection > 0, ATimeout.Connection, CONNECT_TIMEOUT);
    HTTP.Sock.HTTPTunnelTimeout := HTTP.Sock.ConnectionTimeout;
    HTTP.Sock.SocksTimeout := HTTP.Timeout;
    HTTP.Sock.NonblockSendTimeout := HTTP.Timeout;
    HTTP.Sock.SetSendTimeout(HTTP.Timeout);
    HTTP.Sock.SetRecvTimeout(HTTP.Timeout);
    HTTP.Sock.SetTimeout(HTTP.Timeout);

    if AllowProxy then
      ApplyProxy(HTTP, AProxy);

    HTTP.Headers.Clear;
    if AUserAgent <> string.Empty then
      HTTP.Headers.Add('User-Agent: ' + AUserAgent);
    if AContentType <> string.Empty then
    begin
      if AMethod = wmPost then
        HTTP.MimeType := AContentType
      else
        HTTP.Headers.Add('Content-Type: ' + AContentType);
    end;
    if AAccept <> string.Empty then
      HTTP.Headers.Add('Accept: ' + AAccept);

    // Custom headers – use Names/Values to ensure "Name: Value" format
    if Assigned(AHeaders) then
      for i := 0 to AHeaders.Count - 1 do
        HTTP.Headers.Add(AHeaders.Names[i] + ': ' + AHeaders.ValueFromIndex[i]);

    // POST body (UTF-8)
    if AMethod = wmPost then
    begin
      postStream := TStringStream.Create(APostData, TEncoding.UTF8);
      try
        HTTP.Document.CopyFrom(postStream, 0);
        HTTP.Document.Position := 0;   // Synapse reads from current position
      finally
        FreeAndNil(postStream);
      end;
    end;

    // Execute request
    rawStream.Clear;
    HTTP.OutputStream := rawStream;
    if AMethod = wmPost then
      HTTP.HTTPMethod('POST', AUrl)
    else
      HTTP.HTTPMethod('GET', AUrl);

    // Capture response headers
    AResponseHeaders.Assign(HTTP.Headers);

    // Error handling
    if (HTTP.ResultCode div 100) <> 2 then
    begin
      // Try to get the server's error body first
      rawStream.Position := 0;
      if rawStream.Size > 0 then
      begin
        contentEncoding := GetSynapseHeader(AResponseHeaders, 'Content-Encoding');
        bodyStream := TStringStream.Create('', TEncoding.UTF8);
        try
          if SameText(contentEncoding, 'gzip') and IsGzip(rawStream) then
          begin
            decompressedStream := DecompressGzipToStream(rawStream);
            try
              bodyStream.CopyFrom(decompressedStream, 0);
            finally
              FreeAndNil(decompressedStream);
            end;
          end
          else
            bodyStream.CopyFrom(rawStream, 0);

          Result := bodyStream.DataString;
        finally
          FreeAndNil(bodyStream);
        end;
      end;

      // Fallback to standard error description if body is empty
      if Result = string.Empty then
      begin
        if (HTTP.ResultCode = 0) and (HTTP.Sock.LastError <> 0) then
          Result := 'Socket Error: ' + HTTP.Sock.LastErrorDesc
        else
          Result := 'HTTP Error: ' + IntToStr(HTTP.ResultCode) + ' ' + HTTP.ResultString;
      end;

      AError := True;
      Exit;
    end;

    // Read response body
    rawStream.Position := 0;

    // Decompress gzip if needed
    contentEncoding := GetSynapseHeader(AResponseHeaders, 'Content-Encoding');
    bodyStream := TStringStream.Create(string.Empty, TEncoding.UTF8);
    try
      if SameText(contentEncoding, 'gzip') and IsGzip(rawStream) then
      begin
        decompressedStream := DecompressGzipToStream(rawStream);
        try
          bodyStream.CopyFrom(decompressedStream, 0);
        finally
          FreeAndNil(decompressedStream);
        end;
      end
      else
        bodyStream.CopyFrom(rawStream, 0);

      Result := bodyStream.DataString;
    finally
      FreeAndNil(bodyStream);
    end;
  finally
    FreeAndNil(rawStream);
    FreeAndNil(SSL);
    FreeAndNil(HTTP);
  end;
end;

{%EndRegion}

{%Region -fold Gzip}

class function TNetwork.IsGzip(Stream: TMemoryStream): boolean;
var
  p: pbyte;
begin
  Result := False;
  if Stream.Size < 2 then Exit;
  p := Stream.Memory;
  Result := (p^ = $1F) and ((p + 1)^ = $8B);
end;

class function TNetwork.DecompressGzipToStream(Compressed: TMemoryStream): TMemoryStream;
var
  zstream: TZStream;
  err: integer;
  outBuffer: array[0..8191] of byte;
  bytesWritten: longint;
  p: pbyte;
  flags: byte;
  xlen: word;
  dataPos: integer;
begin
  zstream := Default(TZStream);

  // Basic validation: gzip header
  if Compressed.Size < 10 then
    raise Exception.Create('Compressed data too small for gzip');
  p := Compressed.Memory;
  if (p[0] <> $1F) or (p[1] <> $8B) then
    raise Exception.Create('Not a gzip stream (invalid ID bytes)');

  // Check compression method (must be deflate, 8)
  if p[2] <> 8 then
    raise Exception.Create('Unsupported compression method (not deflate)');

  flags := p[3];
  dataPos := 10; // start after fixed header (10 bytes)

  // Skip extra field (FEXTRA) if present
  if (flags and $04) <> 0 then
  begin
    if Compressed.Size < int64(dataPos) + 2 then
      raise Exception.Create('Truncated gzip: FEXTRA length missing');
    xlen := p[dataPos] or (p[dataPos + 1] shl 8);
    Inc(dataPos, 2 + xlen);
  end;

  // Skip original filename (FNAME) if present (null-terminated)
  if (flags and $08) <> 0 then
  begin
    while (dataPos < Compressed.Size) and (p[dataPos] <> 0) do
      Inc(dataPos);
    Inc(dataPos); // skip null terminator
  end;

  // Skip file comment (FCOMMENT) if present (null-terminated)
  if (flags and $10) <> 0 then
  begin
    while (dataPos < Compressed.Size) and (p[dataPos] <> 0) do
      Inc(dataPos);
    Inc(dataPos);
  end;

  // Skip header CRC (FHCRC) if present (2 bytes)
  if (flags and $02) <> 0 then
    Inc(dataPos, 2);

  if dataPos >= Compressed.Size then
    raise Exception.Create('No compressed data after gzip header');

  Result := TMemoryStream.Create;
  try
    {$PUSH}
    {$NOTES OFF}

    // Zero out the zstream structure
    FillChar(zstream, SizeOf(zstream), 0);

    // Initialize for raw deflate decoding (windowBits = -15)
    err := inflateInit2(zstream, -15);  // uses correct version and size automatically
    if err <> Z_OK then
      raise Exception.Create('inflateInit2 error: ' + IntToStr(err));

    try
      // Point to the compressed data after the header
      zstream.next_in := p + dataPos;
      zstream.avail_in := Compressed.Size - dataPos;

      repeat
        zstream.next_out := @outBuffer;
        zstream.avail_out := SizeOf(outBuffer);

        err := inflate(zstream, Z_NO_FLUSH);
        if err < 0 then
          raise Exception.Create('inflate error: ' + IntToStr(err));

        bytesWritten := SizeOf(outBuffer) - zstream.avail_out;
        if bytesWritten > 0 then
          Result.Write(outBuffer, bytesWritten);

      until err = Z_STREAM_END; // End of stream reached

    finally
      inflateEnd(zstream);
    end;
    {$POP}

    Result.Position := 0;
  except
    Result.Free;
    raise;
  end;
end;

{%EndRegion}

end.
