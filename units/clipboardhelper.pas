//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit clipboardhelper;

{$mode ObjFPC}{$H+}

interface

uses
  Forms,
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Dialogs,
  Classes,
  SysUtils,
  Clipbrd;

type
  TClipboardHelper = class helper for TClipboard
  public
    function AddExcludeFlag: boolean;
    function GetTextExcluded: string;
    function GetTextExcludedWait: string;
    procedure SetTextExcluded(Value: string);
    function CreateClipboardViewerWindow: HWND;

    property AsTextExcluded: string read GetTextExcluded write SetTextExcluded;
    property AsTextExcludedWait: string read GetTextExcludedWait write SetTextExcluded;
  end;

implementation

uses systemtool;

{$IFDEF WINDOWS}
var
  CachedExcludeFormat: UINT = 0;  // cached format id
{$ENDIF}

{$IFDEF WINDOWS}

// Hidden window procedure that intercepts clipboard changes and immediately adds
// the ExcludeClipboardContentFromMonitorProcessing flag to prevent history entries.
function ClipViewerWndProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  FNext: HWND;
begin
  case Msg of
    WM_CREATE:
      begin
        // Join the clipboard viewer chain and store the next window handle
        FNext := SetClipboardViewer(hWnd);
        SetWindowLongPtr(hWnd, GWLP_USERDATA, FNext);
        Result := 0;
      end;
    WM_DRAWCLIPBOARD:
      begin
        FNext := GetWindowLongPtr(hWnd, GWLP_USERDATA);
        // Mark the current clipboard content as excluded from history
        Clipboard.AddExcludeFlag;
        // Pass the message to the next viewer in the chain
        if FNext <> 0 then
          SendMessage(FNext, WM_DRAWCLIPBOARD, 0, 0);
        Result := 0;
      end;
    WM_CHANGECBCHAIN:
      begin
        FNext := GetWindowLongPtr(hWnd, GWLP_USERDATA);
        // Update the chain when another viewer is removed
        if THandle(wParam) = FNext then
          SetWindowLongPtr(hWnd, GWLP_USERDATA, lParam)
        else if FNext <> 0 then
          SendMessage(FNext, WM_CHANGECBCHAIN, wParam, lParam);
        Result := 0;
      end;
    WM_DESTROY:
      begin
        FNext := GetWindowLongPtr(hWnd, GWLP_USERDATA);
        // Remove ourselves from the clipboard viewer chain
        if FNext <> 0 then
          ChangeClipboardChain(hWnd, FNext);
        Result := 0;
      end;
  else
    Result := DefWindowProc(hWnd, Msg, wParam, lParam);
  end;
end;

{$ENDIF}

  { TClipboardHelper }

function TClipboardHelper.AddExcludeFlag: boolean;
begin
  Result := False;
  {$IFDEF WINDOWS}
  if OpenClipboard(0) then
  try
    if CachedExcludeFormat <> 0 then
    begin
      SetClipboardData(CachedExcludeFormat, 0);
      Result := True;
    end;
  finally
    CloseClipboard;
  end;
  {$ENDIF}
end;

function TClipboardHelper.GetTextExcluded: string;
  {$IFDEF WINDOWS}
var
  hText: HGLOBAL;
  pText: PWideChar;
  cfExclude: UINT;
  OldPriority: Integer;   // stores the original thread priority
  {$ENDIF}
begin
  Result := string.Empty;
  {$IFDEF WINDOWS}
  // Boost our thread priority to win the race against the clipboard history service
  OldPriority := GetThreadPriority(GetCurrentThread);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_HIGHEST);
  try
    // Spin until the clipboard contains Unicode text and we can atomically add the exclusion flag
    while True do
    begin
      if not IsClipboardFormatAvailable(CF_UNICODETEXT) then
      begin
        Sleep(0);              // yield but stay at high priority
        Continue;
      end;

      if not OpenClipboard(0) then
      begin
        Sleep(0);
        Continue;
      end;

      try
        // Double‑check: the text might have vanished after we opened the clipboard
        if not IsClipboardFormatAvailable(CF_UNICODETEXT) then
          Continue;

        // Read the text
        hText := GetClipboardData(CF_UNICODETEXT);
        if hText <> 0 then
        begin
          pText := GlobalLock(hText);
          if pText <> nil then
          begin
            Result := pText;
            GlobalUnlock(hText);
          end;
        end;

        // Atomically add the exclude flag to prevent this entry from appearing in clipboard history (Win+V)
        cfExclude := RegisterClipboardFormat('ExcludeClipboardContentFromMonitorProcessing');
        if cfExclude <> 0 then
          SetClipboardData(cfExclude, 0);

        Break;   // success – exit the loop
      finally
        CloseClipboard;
      end;
    end;
  finally
    // Restore the original thread priority
    SetThreadPriority(GetCurrentThread, OldPriority);
  end;
  {$ENDIF}
end;

function TClipboardHelper.GetTextExcludedWait: string;
  {$IFDEF WINDOWS}
  var
  Start: DWORD;
  TimeoutMs: integer = 100;
  {$ENDIF}
begin
  Result := string.Empty;
  {$IFDEF WINDOWS}
  Start := GetTickCountXp;
  while GetTickCountXp - Start < TimeoutMs do
  begin
    // Check if text is available using standard TClipboard
    if Clipboard.HasFormat(CF_UNICODETEXT) then
    begin
      Result := Clipboard.AsText;
      if Result <> string.Empty then
      begin
        // Immediately mark clipboard as excluded from history
        AddExcludeFlag;
        Exit;
      end;
    end;
    Sleep(1);
    Application.ProcessMessages; // keep UI responsive
  end;
  {$ENDIF}
end;

procedure TClipboardHelper.SetTextExcluded(Value: string);
{$IFDEF WINDOWS}
  var
  hMem: HGLOBAL;
  pMem: Pointer;
  cfExclude: UINT;
  WideText: unicodestring;
  Len: integer;
{$ENDIF}
begin
  {$IFDEF WINDOWS}
  WideText := UTF8Decode(Value); // or just Value if the string is already Unicode
  Len := (Length(WideText) + 1) * SizeOf(widechar);
  hMem := GlobalAlloc(GMEM_MOVEABLE, Len);
  if hMem = 0 then Exit;
  pMem := GlobalLock(hMem);
  if pMem = nil then
  begin
    GlobalFree(hMem);
    Exit;
  end;
  Move(pwidechar(WideText)^, pMem^, Len);
  GlobalUnlock(hMem);

  if not OpenClipboard(0) then
  begin
    GlobalFree(hMem);
    Exit;
  end;
  try
    EmptyClipboard;
    if SetClipboardData(CF_UNICODETEXT, hMem) = 0 then
    begin
      GlobalFree(hMem);
      Exit;
    end;
    // Add exclusion flag
    cfExclude := RegisterClipboardFormat('ExcludeClipboardContentFromMonitorProcessing');
    if cfExclude <> 0 then
      SetClipboardData(cfExclude, 0);
  finally
    CloseClipboard;
  end;
  {$ENDIF}
end;

function TClipboardHelper.CreateClipboardViewerWindow: HWND;
  {
    To call a buffer interception attempt and specify the do not save flag, in the main form:
    private:
    FClipViewerWnd:HWND;

    OnCreate:
    $IFDEF WINDOWS
    FClipViewerWnd := CreateClipboardViewerWindow;
    $ENDIF

    OnDestroy:
    $IFDEF WINDOWS
    if FClipViewerWnd <> 0 then DestroyWindow(FClipViewerWnd);
    $ENDIF
  }

  {$IFDEF WINDOWS}
  var
  WC: WNDCLASSA;
  Dummy: TWNDCLASSA; // not used, needed only for testing
  {$ENDIF}
begin
  Result := 0;
  {$IFDEF WINDOWS}
  // Register the window class only if not already registered
  if not GetClassInfoA(HINSTANCE, 'TrayslateClipViewer', @Dummy) then
  begin
    ZeroMemory(@WC, SizeOf(WC));
    WC.lpfnWndProc := @ClipViewerWndProc;
    WC.hInstance := HINSTANCE;
    WC.lpszClassName := 'TrayslateClipViewer';
    if RegisterClassA(@WC) = 0 then
      Exit;
  end;

  // Create the hidden window (WM_CREATE will call SetClipboardViewer)
  Result := CreateWindowExA(0, 'TrayslateClipViewer', string.Empty, WS_POPUP, 0, 0, 0, 0, 0, 0, HINSTANCE, nil);
  {$ENDIF}
end;

initialization

  {$IFDEF WINDOWS}
  CachedExcludeFormat := RegisterClipboardFormat('ExcludeClipboardContentFromMonitorProcessing');
  {$ENDIF}

end.
