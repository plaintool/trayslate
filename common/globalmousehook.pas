//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit GlobalMouseHook;

{$NOTES OFF}
{$HINTS OFF}
{$WARNINGS OFF}

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  Controls
  {$IFDEF WINDOWS}
  , Windows
  , Messages
  {$ENDIF}
  ;

type
  PMouseEventInfo = ^TMouseEventInfo;

  TMouseEventInfo = record
    Button: TMouseButton;
    X, Y: integer;
    Time: longword;
    CtrlDown: boolean;
    ShiftDown: boolean;
    AltDown: boolean;
  end;

  TMouseEvent = procedure(Sender: TObject; const Info: TMouseEventInfo) of object;

  {$IFDEF WINDOWS}
type
  PMouseLLHookStruct = ^TMouseLLHookStruct;
  TMouseLLHookStruct = record
    pt: TPoint;
    mouseData: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: ULONG_PTR;
  end;
  {$ENDIF}

  TGlobalMouseHook = class
  private
    FEnabled: boolean;
    FEditFieldOnly: boolean;
    FOnLeftDown, FOnLeftUp: TMouseEvent;
    FOnRightDown, FOnRightUp: TMouseEvent;
    FOnMiddleDown, FOnMiddleUp: TMouseEvent;
    FLeftDownAccepted: boolean;
    procedure SetEnabled(AValue: boolean);
    {$IFDEF WINDOWS}
    class var FActiveInstance: TGlobalMouseHook;
    FHook: HHOOK;
    class function HookProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; static;
    procedure InternalMouseEvent(wParam: WPARAM; const p: TMouseLLHookStruct);
    function IsInputWindow(Wnd: THandle): Boolean;
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    property Enabled: boolean read FEnabled write SetEnabled;
    property EditFieldOnly: boolean read FEditFieldOnly write FEditFieldOnly;
    property OnLeftDown: TMouseEvent read FOnLeftDown write FOnLeftDown;
    property OnLeftUp: TMouseEvent read FOnLeftUp write FOnLeftUp;
    property OnRightDown: TMouseEvent read FOnRightDown write FOnRightDown;
    property OnRightUp: TMouseEvent read FOnRightUp write FOnRightUp;
    property OnMiddleDown: TMouseEvent read FOnMiddleDown write FOnMiddleDown;
    property OnMiddleUp: TMouseEvent read FOnMiddleUp write FOnMiddleUp;
    class function IsCtrlPressed: boolean;
    class function IsShiftPressed: boolean;
    class function IsAltPressed: boolean;
  end;

  {$IFDEF WINDOWS}
const
  WH_MOUSE_LL = 14;
  {$ENDIF}

implementation

{$IFDEF WINDOWS}
class function TGlobalMouseHook.HookProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  p: PMouseLLHookStruct;
begin
  if (nCode >= 0) and (FActiveInstance <> nil) then
  begin
    p := PMouseLLHookStruct(Pointer(PtrUInt(lParam)));
    FActiveInstance.InternalMouseEvent(wParam, p^);
  end;
  if FActiveInstance <> nil then
    Result := CallNextHookEx(FActiveInstance.FHook, nCode, wParam, lParam)
  else
    Result := CallNextHookEx(0, nCode, wParam, lParam);
end;

function TGlobalMouseHook.IsInputWindow(Wnd: THandle): Boolean;
const
  // Classes that we always ignore (blacklist)
 IgnoredClasses: array[0..9] of PChar = (
    'ComboLBox',          // popup list of a ComboBox
    'ScrollBar',          // standard scrollbar
    'msctls_updown32',    // up-down (spin) control
    'msctls_trackbar32',  // trackbar / slider
    'SysHeader32',        // column header in list view
    'ToolbarWindow32',    // standard toolbar
    'SysTabControl32',    // tab control (tabs)
    '#32768',             // system menu (popup) / window menu
    'tooltips_class32',   // tooltip window
    'Static'              // static text / label (rarely needed, but safe to ignore)
  );

  // Classes that are treated as text editing fields (whitelist)
  TextEditClasses: array[0..11] of PChar = (
    'Edit',                         // standard edit control
    'RichEdit20A',                  // RichEdit version 2.0 (ANSI)
    'RichEdit50W',                  // RichEdit version 5.0 (Unicode)
    'TMemo',                        // VCL/LCL memo control
    'TEdit',                        // VCL/LCL single-line edit
    'Scintilla',                    // Scintilla editing component (Notepad++, etc.)
    'Chrome_RenderWidgetHostHWND',  // Chromium-based browsers (Chrome, Edge)
    'MozillaContentWindowClass',    // Firefox content area
    'Internet Explorer_Server',     // IE / Trident engine
    'OperaWindowClass',             // older Opera
    'Windows.UI.Core.CoreWindow',   // UWP / WinRT text controls
    'Afx:FrameOrView:100'           // MFC-based applications
  );
type
  TQueryFullProcessImageNameW = function(hProcess: THandle; dwFlags: DWORD;
    lpExeName: PWideChar; lpdwSize: LPDWORD): BOOL; stdcall;
var
  szClass: array[0..255] of Char;
  i: Integer;
  pid: DWORD;
  hProc: THandle;
  fileName: array[0..MAX_PATH] of WideChar;
  len: DWORD;
  s: WideString;
  j: Integer;
  dwStart, dwEnd: DWORD;
  QueryFull: TQueryFullProcessImageNameW;
  hKernel32: THandle;
begin
  Result := False;
  if Wnd = 0 then Exit;

  // Get window class name
  if GetClassName(HWND(Wnd), szClass, Length(szClass)) > 0 then
  begin
    // 1. Reject ignored classes immediately
    for i := Low(IgnoredClasses) to High(IgnoredClasses) do
      if StrIComp(szClass, IgnoredClasses[i]) = 0 then
        Exit(False);   // always suppress events on these

    // 2. If EditFieldOnly is not active, any non-ignored window is allowed
    if not FEditFieldOnly then
      Exit(True);

    // 3. EditFieldOnly mode: check if the class is a known text editor
    for i := Low(TextEditClasses) to High(TextEditClasses) do
      if StrIComp(szClass, TextEditClasses[i]) = 0 then
        Exit(True);

    // 4. Not a recognized editor – fall through to additional checks
  end;

  // explorer.exe check (dynamic, XP-safe)
  hKernel32 := GetModuleHandle('kernel32.dll');
  if hKernel32 <> 0 then
    Pointer(QueryFull) := GetProcAddress(hKernel32, 'QueryFullProcessImageNameW')
  else
    Pointer(QueryFull) := nil;

  if Assigned(QueryFull) then
  begin
    GetWindowThreadProcessId(HWND(Wnd), @pid);
    hProc := OpenProcess(PROCESS_QUERY_INFORMATION, False, pid);
    if hProc <> 0 then
    begin
      len := MAX_PATH;
      if QueryFull(hProc, 0, @fileName[0], @len) then
      begin
        SetString(s, PWideChar(@fileName[0]), len);
        j := LastDelimiter('\', string(s));
        if (j > 0) and (StrIComp(PWideChar(@s[j+1]), 'explorer.exe') = 0) then
        begin
          CloseHandle(hProc);
          Exit(False);   // explorer.exe windows are not valid input targets
        end;
      end;
      CloseHandle(hProc);
    end;
  end;

  // Fallback: try EM_GETSEL to detect editable controls
  if SendMessageTimeout(HWND(Wnd), EM_GETSEL, WPARAM(@dwStart), LPARAM(@dwEnd),
                        SMTO_ABORTIFHUNG, 20, nil) <> 0 then
    Exit(True);

  // If we reached here in EditFieldOnly mode, the window is not a valid editor
  if FEditFieldOnly then
    Result := False
  else
    Result := True;   // in normal mode, allow everything except blacklisted classes
end;

procedure TGlobalMouseHook.InternalMouseEvent(wParam: WPARAM; const p: TMouseLLHookStruct);
var
  info: TMouseEventInfo;
  handler: TMouseEvent;
  wndHandle: THandle;
  R: TRect;
  Pt: TPoint;
begin
  info.X := p.pt.X;
  info.Y := p.pt.Y;
  info.Time := p.time;
  info.CtrlDown := (GetAsyncKeyState(VK_CONTROL) and $8000) <> 0;
  info.ShiftDown := (GetAsyncKeyState(VK_SHIFT) and $8000) <> 0;
  info.AltDown := (GetAsyncKeyState(VK_MENU) and $8000) <> 0;

  // Find the window under cursor
  wndHandle := THandle(WindowFromPoint(p.pt));

  // Check if this window is a valid input target (respects EditFieldOnly and ignores blacklisted classes)
  if not IsInputWindow(wndHandle) then
  begin
    // Left button down on an ignored window -> mark sequence as invalid
    if wParam = WM_LBUTTONDOWN then
      FLeftDownAccepted := False;
    Exit;
  end;

  // In EditFieldOnly mode, additionally ensure up happens inside the client area
  if FEditFieldOnly and (wParam = WM_LBUTTONUP) then
  begin
    if GetClientRect(wndHandle, @R) then
    begin
      Pt := p.pt;
      ScreenToClient(wndHandle, Pt);
      if not PtInRect(R, Pt) then
        Exit;   // mouse released outside the edit control – ignore
    end;
  end;

  // Left button acceptance tracking (prevents stray up events from being passed)
  if wParam = WM_LBUTTONDOWN then
    FLeftDownAccepted := True
  else if wParam = WM_LBUTTONUP then
  begin
    if not FLeftDownAccepted then
      Exit;                        // no valid down before this up
    FLeftDownAccepted := True;     // keep valid for potential multi‑click sequence
  end;

  handler := nil;
  case wParam of
    WM_LBUTTONDOWN: begin info.Button := mbLeft; handler := FOnLeftDown; end;
    WM_LBUTTONUP:   begin info.Button := mbLeft; handler := FOnLeftUp;   end;
    WM_RBUTTONDOWN: begin info.Button := mbRight; handler := FOnRightDown; end;
    WM_RBUTTONUP:   begin info.Button := mbRight; handler := FOnRightUp;  end;
    WM_MBUTTONDOWN: begin info.Button := mbMiddle; handler := FOnMiddleDown; end;
    WM_MBUTTONUP:   begin info.Button := mbMiddle; handler := FOnMiddleUp;  end;
  end;

  if Assigned(handler) then
    handler(Self, info);
end;

constructor TGlobalMouseHook.Create;
begin
  inherited;
  FHook := 0;
  FEnabled := False;
  FEditFieldOnly := False;
end;

destructor TGlobalMouseHook.Destroy;
begin
  Enabled := False;      // safe cleanup – see SetEnabled
  inherited;
end;

procedure TGlobalMouseHook.SetEnabled(AValue: Boolean);
begin
  if FEnabled = AValue then Exit;
  if AValue then
  begin
    if FActiveInstance <> nil then
      raise Exception.Create('Only one TGlobalMouseHook can be active at a time.');

    // Try to install the hook. HInstance is used for XP safety (error 1428 may still occur).
    FHook := SetWindowsHookEx(WH_MOUSE_LL, @HookProc, HInstance, 0);
    if FHook = 0 then
    begin
      // Hook installation failed – keep FActiveInstance nil and FEnabled false.
      // Show a warning instead of crashing, especially important for XP.
      MessageBox(0,
                 PChar('Cannot enable global mouse hook.' + sLineBreak +
                       'System error: ' + SysErrorMessage(GetLastError)),
                 'Trayslate',
                 MB_ICONWARNING);
      Exit;   // FEnabled stays False, FActiveInstance stays nil
    end;

    // Success – mark as active
    FActiveInstance := Self;
    FEnabled := True;
  end
  else
  begin
    // Disable: only unhook if we are the active instance
    if FActiveInstance = Self then
    begin
      if FHook <> 0 then
      begin
        UnhookWindowsHookEx(FHook);
        FHook := 0;
      end;
      FActiveInstance := nil;
    end;
    FEnabled := False;
  end;
end;

class function TGlobalMouseHook.IsCtrlPressed: Boolean;
begin
  Result := (GetAsyncKeyState(VK_CONTROL) and $8000) <> 0;
end;

class function TGlobalMouseHook.IsShiftPressed: Boolean;
begin
  Result := (GetAsyncKeyState(VK_SHIFT) and $8000) <> 0;
end;

class function TGlobalMouseHook.IsAltPressed: Boolean;
begin
  Result := (GetAsyncKeyState(VK_MENU) and $8000) <> 0;
end;

{$ELSE}

// Non Windows stub – compiles but does nothing

constructor TGlobalMouseHook.Create;
begin
  inherited;
  FEnabled := False;
  FEditFieldOnly := False;
end;

destructor TGlobalMouseHook.Destroy;
begin
  inherited;
end;

procedure TGlobalMouseHook.SetEnabled(AValue: boolean);
begin
  if AValue then
    raise Exception.Create('GlobalMouseHook is only supported on Windows.');
end;

class function TGlobalMouseHook.IsCtrlPressed: boolean;
begin
  Result := False;
end;

class function TGlobalMouseHook.IsShiftPressed: boolean;
begin
  Result := False;
end;

class function TGlobalMouseHook.IsAltPressed: boolean;
begin
  Result := False;
end;

{$ENDIF}

end.
