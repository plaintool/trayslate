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
    // Forward only button-down/up messages to our handler; ignore everything else
    case wParam of
      WM_LBUTTONDOWN, WM_LBUTTONUP,
      WM_RBUTTONDOWN, WM_RBUTTONUP,
      WM_MBUTTONDOWN, WM_MBUTTONUP:
        begin
          p := PMouseLLHookStruct(Pointer(PtrUInt(lParam)));
          FActiveInstance.InternalMouseEvent(wParam, p^);
        end;
      // all other messages (move, wheel, etc.) are passed through without any processing
    end;
  end;

  // Always call the next hook in the chain
  if FActiveInstance <> nil then
    Result := CallNextHookEx(FActiveInstance.FHook, nCode, wParam, lParam)
  else
    Result := CallNextHookEx(0, nCode, wParam, lParam);
end;

function TGlobalMouseHook.IsInputWindow(Wnd: THandle): Boolean;
const
  // Classes that we always ignore (blacklist)
  IgnoredClasses: array[0..13] of PChar = (
    'ComboLBox',          // popup list of a ComboBox
    'ScrollBar',          // standard scrollbar
    'msctls_updown32',    // up-down (spin) control
    'msctls_trackbar32',  // trackbar / slider
    'SysHeader32',        // column header in list view
    'ToolbarWindow32',    // standard toolbar
    'SysTabControl32',    // tab control (tabs)
    '#32768',             // system menu (popup) / window menu
    'tooltips_class32',   // tooltip window
    'Static',             // static text / label
    'SysListView32',      // classic file list in Explorer
    'DirectUIHWND',       // modern Explorer file view (Vista+)
    'CtrlNotifySink',     // sometimes used in Explorer details pane
    'Shell DocObject View'// embedded Explorer views
  );

  // Virtual machine window classes – fast preliminary check
  VMWindowClasses: array[0..1] of PChar = (
    'QWidget',            // VirtualBox (older) / Qt main window
    'VMwareUnityHostWnd'  // VMware Workstation/Player
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

  // Process names of known virtual machines and emulators
  VMProcessNames: array[0..2] of string = (
    'virtualboxvm.exe',
    'vboxheadless.exe',
    'vmware-vmx.exe'
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
  isVM: Boolean;

  //---------------------------------------------------------------
  // Helper – returns True if the window belongs to a VM process
  //---------------------------------------------------------------
  function WindowBelongsToVM(Wnd: THandle): Boolean;
  var
    pidLocal: DWORD;
    hP: THandle;
    fname: array[0..MAX_PATH] of WideChar;
    fLen: DWORD;
    nameStr: WideString;
    k: Integer;
    ext: string;
  begin
    Result := False;
    if not Assigned(QueryFull) then Exit;
    GetWindowThreadProcessId(HWND(Wnd), @pidLocal);
    hP := OpenProcess(PROCESS_QUERY_INFORMATION, False, pidLocal);
    if hP = 0 then Exit;
    try
      fLen := MAX_PATH;
      if QueryFull(hP, 0, @fname[0], @fLen) then
      begin
        SetString(nameStr, PWideChar(@fname[0]), fLen);
        k := LastDelimiter('\', string(nameStr));
        if k > 0 then
          ext := LowerCase(Copy(string(nameStr), k + 1, MaxInt))
        else
          ext := LowerCase(string(nameStr));
        for k := Low(VMProcessNames) to High(VMProcessNames) do
          if ext = VMProcessNames[k] then
            Exit(True);
      end;
    finally
      CloseHandle(hP);
    end;
  end;

begin
  Result := False;
  if Wnd = 0 then Exit;

  // Load kernel function once per call (can be cached in a class field)
  hKernel32 := GetModuleHandle('kernel32.dll');
  if hKernel32 <> 0 then
    Pointer(QueryFull) := GetProcAddress(hKernel32, 'QueryFullProcessImageNameW')
  else
    Pointer(QueryFull) := nil;

  // Get window class name
  if GetClassName(HWND(Wnd), szClass, Length(szClass)) > 0 then
  begin
    // 0. IMMEDIATE REJECTION – virtual machine window classes
    for i := Low(VMWindowClasses) to High(VMWindowClasses) do
      if StrIComp(szClass, VMWindowClasses[i]) = 0 then
        Exit(False);

    // 1. Reject ignored classes (blacklist)
    for i := Low(IgnoredClasses) to High(IgnoredClasses) do
      if StrIComp(szClass, IgnoredClasses[i]) = 0 then
        Exit(False);

    // ------------------------------------------------------------
    // 2. MODE: not EditFieldOnly
    // ------------------------------------------------------------
    if not FEditFieldOnly then
    begin
      // a) Reject windows owned by explorer.exe
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
              Exit(False);
            end;
          end;
          CloseHandle(hProc);
        end;
      end;

      // b) Reject windows owned by known VM processes
      if Assigned(QueryFull) then
      begin
        if WindowBelongsToVM(Wnd) then
          Exit(False);
      end;

      // All remaining windows are valid input targets
      Exit(True);
    end;

    // ------------------------------------------------------------
    // 3. MODE: EditFieldOnly
    // ------------------------------------------------------------
    // First, check if the class is a known text editor
    for i := Low(TextEditClasses) to High(TextEditClasses) do
      if StrIComp(szClass, TextEditClasses[i]) = 0 then
        Exit(True);

    // Unknown class – perform process-based checks BEFORE EM_GETSEL
    if Assigned(QueryFull) then
    begin
      // a) Reject explorer.exe
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
            Exit(False);
          end;
        end;
        CloseHandle(hProc);
      end;

      // b) Reject VM processes
      if WindowBelongsToVM(Wnd) then
        Exit(False);

      // c) If the window belongs to none of the above, try EM_GETSEL
      //    (allows non‑standard editors that support this message)
      if SendMessageTimeout(HWND(Wnd), EM_GETSEL, WPARAM(@dwStart), LPARAM(@dwEnd),
                            SMTO_ABORTIFHUNG, 20, nil) <> 0 then
        Exit(True);
    end;

    // Not a recognised editor – reject
    Exit(False);
  end;

  // Should never reach here (GetClassName failed)
  Exit(False);
end;

procedure TGlobalMouseHook.InternalMouseEvent(wParam: WPARAM; const p: TMouseLLHookStruct);
var
  handler: TMouseEvent;
  info: TMouseEventInfo;
  wndHandle: THandle;
  R: TRect;
  Pt: TPoint;
begin
  // 1. Determine which handler (if any) is assigned for this message type
  case wParam of
    WM_LBUTTONDOWN: handler := FOnLeftDown;
    WM_LBUTTONUP:   handler := FOnLeftUp;
    WM_RBUTTONDOWN: handler := FOnRightDown;
    WM_RBUTTONUP:   handler := FOnRightUp;
    WM_MBUTTONDOWN: handler := FOnMiddleDown;
    WM_MBUTTONUP:   handler := FOnMiddleUp;
  else
    Exit;   // ignore all other messages (move, wheel, etc.) immediately
  end;

  // 2. If no handler is assigned for this event, exit without any further work
  if not Assigned(handler) then
    Exit;

  // 3. Only now, for events we actually care about, fill the event info
  info.X := p.pt.X;
  info.Y := p.pt.Y;
  info.Time := p.time;
  info.CtrlDown := (GetAsyncKeyState(VK_CONTROL) and $8000) <> 0;
  info.ShiftDown := (GetAsyncKeyState(VK_SHIFT) and $8000) <> 0;
  info.AltDown := (GetAsyncKeyState(VK_MENU) and $8000) <> 0;

  // 4. Find the window under the cursor and check if it's a valid input target
  wndHandle := THandle(WindowFromPoint(p.pt));

  if not IsInputWindow(wndHandle) then
  begin
    if wParam = WM_LBUTTONDOWN then
      FLeftDownAccepted := False;
    Exit;
  end;

  // 5. Extra check for EditFieldOnly mode: release must be inside client area
  if FEditFieldOnly and (wParam = WM_LBUTTONUP) then
  begin
    if GetClientRect(wndHandle, @R) then
    begin
      Pt := p.pt;
      ScreenToClient(wndHandle, Pt);
      if not PtInRect(R, Pt) then
        Exit;
    end;
  end;

  // 6. Left button acceptance logic (prevents stray up events)
  if wParam = WM_LBUTTONDOWN then
    FLeftDownAccepted := True
  else if wParam = WM_LBUTTONUP then
  begin
    if not FLeftDownAccepted then
      Exit;
    FLeftDownAccepted := True;   // keep valid for subsequent clicks
  end;

  // 7. Set button type and call the assigned handler
  case wParam of
    WM_LBUTTONDOWN,
    WM_LBUTTONUP:   info.Button := mbLeft;
    WM_RBUTTONDOWN,
    WM_RBUTTONUP:   info.Button := mbRight;
    WM_MBUTTONDOWN,
    WM_MBUTTONUP:   info.Button := mbMiddle;
  end;

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
