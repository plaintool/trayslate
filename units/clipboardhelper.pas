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
  // Holds a single clipboard format together with its duplicated data handle
  TClipboardFormatData = record
    Format: UINT;
    Handle: HGLOBAL;
  end;

  TClipboardFormatDataArray = array of TClipboardFormatData;

  TClipboardHelper = class helper for TClipboard
  public
    // Windows: adds the exclusion flag to the clipboard to hide the content from clipboard history (Win+V)
    function AddExcludeFlag: boolean;

    // Windows: retrieves clipboard text while simultaneously marking it as excluded from history (high‑priority spin)
    function GetTextExcluded: string;

    // Windows: waits briefly for text to appear on the clipboard, then retrieves it and adds the exclusion flag
    function GetTextExcludedWait: string;

    // Windows: places the given text onto the clipboard and immediately marks it as excluded from history
    procedure SetTextExcluded(Value: string);

    // Windows: creates a hidden window that monitors clipboard changes and adds the exclusion flag automatically
    function CreateClipboardViewerWindow: HWND;

    // Saves every format currently on the clipboard into an array (data blocks are duplicated, original untouched)
    function SaveAllFormats: TClipboardFormatDataArray;

    // Restores all previously saved formats; the array is emptied after the call (handles transferred to clipboard)
    procedure RestoreAllFormats(var ASaved: TClipboardFormatDataArray);

    property AsTextExcluded: string read GetTextExcluded write SetTextExcluded;
    property AsTextExcludedWait: string read GetTextExcludedWait write SetTextExcluded;
  end;

implementation

uses osutils;

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
  Start := TOS.GetTickCountXp;
  while TOS.GetTickCountXp - Start < TimeoutMs do
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

function TClipboardHelper.SaveAllFormats: TClipboardFormatDataArray;
  {$IFDEF WINDOWS}
var
  Fmt: UINT;
  hOrig, hCopy: HGLOBAL;
  pSrc, pDst: Pointer;
  Size: NativeUInt;
  Count, Idx: Integer;
  {$ENDIF}
begin
  {$IFDEF WINDOWS}
  Result := [];
  SetLength(Result, 0);
  // Open clipboard directly via Win API to avoid TClipboard caching conflicts
  if not OpenClipboard(0) then
    Exit;
  try
    // First pass: count formats (for pre‑allocation)
    Count := 0;
    Fmt := 0;
    while True do
    begin
      Fmt := EnumClipboardFormats(Fmt);
      if Fmt = 0 then Break;
      Inc(Count);
    end;
    SetLength(Result, Count);   // maximum possible size, will be trimmed later

    // Second pass: duplicate only supported formats
    Idx := 0;
    Fmt := 0;
    while True do
    begin
      Fmt := EnumClipboardFormats(Fmt);
      if Fmt = 0 then Break;

      // Skip GDI‑object formats that don't use global memory
      if (Fmt = CF_BITMAP) or (Fmt = CF_PALETTE) or (Fmt = CF_ENHMETAFILE) then
        Continue;

      Result[Idx].Format := Fmt;

      hOrig := GetClipboardData(Fmt);
      if hOrig = 0 then
      begin
        // Format with no data handle – store as empty
        Result[Idx].Handle := 0;
      end
      else
      begin
        Size := GlobalSize(hOrig);   // safe now because we skipped GDI objects
        hCopy := GlobalAlloc(GMEM_MOVEABLE, Size);
        if hCopy = 0 then
        begin
          Result[Idx].Handle := 0;
          Inc(Idx);
          Continue;
        end;

        pSrc := GlobalLock(hOrig);
        pDst := GlobalLock(hCopy);
        try
          Move(pSrc^, pDst^, Size);
        finally
          GlobalUnlock(hOrig);
          GlobalUnlock(hCopy);
        end;
        Result[Idx].Handle := hCopy;
      end;
      Inc(Idx);
    end;

    // Trim array to actual number of saved formats
    SetLength(Result, Idx);
  finally
    CloseClipboard;
  end;
  {$ELSE}
  SetLength(Result, 0);
  {$ENDIF}
end;

procedure TClipboardHelper.RestoreAllFormats(var ASaved: TClipboardFormatDataArray);
{$IFDEF WINDOWS}
var
  I: Integer;
{$ENDIF}
begin
  {$IFDEF WINDOWS}
  // Nothing to restore – just ensure the array is cleared
  if Length(ASaved) = 0 then
    Exit;

  // Open clipboard directly to avoid TClipboard state issues
  if not OpenClipboard(0) then
  begin
    // If we can't open the clipboard, discard saved handles to prevent leaks
    for I := 0 to High(ASaved) do
      if ASaved[I].Handle <> 0 then
        GlobalFree(ASaved[I].Handle);
    SetLength(ASaved, 0);
    Exit;
  end;
  try
    EmptyClipboard;
    for I := 0 to High(ASaved) do
    begin
      if ASaved[I].Handle <> 0 then
        // Ownership of the handle moves to the clipboard
        SetClipboardData(ASaved[I].Format, ASaved[I].Handle)
      else if ASaved[I].Format <> 0 then
        // Restore NULL‑handle formats (like the exclude flag)
        SetClipboardData(ASaved[I].Format, 0);
    end;
  finally
    CloseClipboard;
  end;
  // Handles are now owned by the clipboard – discard array references
  SetLength(ASaved, 0);
  {$ELSE}
  SetLength(ASaved, 0);
  {$ENDIF}
end;

initialization

  {$IFDEF WINDOWS}
  CachedExcludeFormat := RegisterClipboardFormat('ExcludeClipboardContentFromMonitorProcessing');
  {$ENDIF}

end.
