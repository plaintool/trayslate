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
    function IsEditControl(Wnd: THandle): Boolean;
    function IsDropDownWindow(Wnd: THandle): Boolean;
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

function TGlobalMouseHook.IsDropDownWindow(Wnd: THandle): Boolean;
var
  szClass: array[0..255] of Char;
begin
  Result := False;
  if Wnd = 0 then Exit;
  if GetClassName(HWND(Wnd), szClass, Length(szClass)) > 0 then
  begin
    // ComboLBox is the class of the popup list in a ComboBox
    if StrIComp(szClass, 'ComboLBox') = 0 then Exit(True);
  end;
end;

function TGlobalMouseHook.IsEditControl(Wnd: THandle): Boolean;
const
  TextEditClasses: array[0..11] of PChar = (
    'Edit', 'RichEdit20A', 'RichEdit50W', 'TMemo', 'TEdit',
    'Scintilla',
    'Chrome_RenderWidgetHostHWND',
    'MozillaContentWindowClass',
    'Internet Explorer_Server',
    'OperaWindowClass',
    'Windows.UI.Core.CoreWindow',
    'Afx:FrameOrView:100'
  );
type
  // QueryFullProcessImageNameW signature, available from Vista
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

  if GetClassName(HWND(Wnd), szClass, Length(szClass)) > 0 then
  begin
    for i := Low(TextEditClasses) to High(TextEditClasses) do
      if StrIComp(szClass, TextEditClasses[i]) = 0 then
        Exit(True);
  end;

  // ---- explorer.exe check (dynamic, XP‑safe) ----
  // On XP this API is missing; the check is simply skipped.
  hKernel32 := GetModuleHandle('kernel32.dll');
  if hKernel32 <> 0 then
    Pointer(QueryFull) := GetProcAddress(hKernel32, 'QueryFullProcessImageNameW')
  else
    Pointer(QueryFull) := nil;

  if Assigned(QueryFull) then
  begin
    GetWindowThreadProcessId(HWND(Wnd), @pid);
    // PROCESS_QUERY_INFORMATION is available on XP (as opposed to PROCESS_QUERY_LIMITED_INFORMATION)
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
  // -------------------------------------------------

  // Fallback: try EM_GETSEL to detect editable controls
  if SendMessageTimeout(HWND(Wnd), EM_GETSEL, WPARAM(@dwStart), LPARAM(@dwEnd),
                        SMTO_ABORTIFHUNG, 20, nil) <> 0 then
    Exit(True);
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

  // --- Global drop-down list guard (always active) ---
  if (wParam = WM_LBUTTONDOWN) or (wParam = WM_LBUTTONUP) then
  begin
    wndHandle := THandle(WindowFromPoint(p.pt));
    if IsDropDownWindow(wndHandle) then
    begin
      // Down inside drop‑down list – mark as not accepted
      if wParam = WM_LBUTTONDOWN then
        FLeftDownAccepted := False;
      Exit;
    end;
  end;

  // Apply EditFieldOnly filter only if the option is enabled
  if FEditFieldOnly then
  begin
    wndHandle := THandle(WindowFromPoint(p.pt));
    if (wndHandle = 0) or (not IsEditControl(wndHandle)) then
    begin
      // Down outside an edit control – mark as not accepted
      if wParam = WM_LBUTTONDOWN then
        FLeftDownAccepted := False;
      Exit;
    end;

    // Additional check: release must be in the client area of the edit window
    if wParam = WM_LBUTTONUP then
    begin
      if GetClientRect(wndHandle, @R) then
      begin
        Pt := p.pt;
        ScreenToClient(wndHandle, Pt);
        if not PtInRect(R, Pt) then
        begin
          // Up outside the edit area – ignore if the corresponding down was not accepted
          if not FLeftDownAccepted then
            Exit;
          // Even if the down was accepted, release outside the edit area is suppressed
          Exit;
        end;
      end;
    end;
  end;

  // Left button down/up acceptance logic
  if wParam = WM_LBUTTONDOWN then
    FLeftDownAccepted := True          // we reached here → down is valid
  else if wParam = WM_LBUTTONUP then
  begin
    if not FLeftDownAccepted then
      Exit;                            // no valid down before this up
    FLeftDownAccepted := True;        // consume the valid down
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
