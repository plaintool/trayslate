//-----------------------------------------------------------------------------------
//  Toolkit Package © 2026 by Alexander Tverskoy
//  Licensed under the MIT License
//  You may obtain a copy of the License at https://opensource.org/licenses/MIT
//-----------------------------------------------------------------------------------

unit TextDropTarget;

{$NOTES OFF}
{$HINTS OFF}
{$WARNINGS OFF}

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Controls
  {$IFDEF WINDOWS}
  , Windows, ActiveX, ComObj
  {$ENDIF};

type
  TTextDropTarget = class;   // forward declaration

  TTextDropEvent = procedure(Sender: TObject; const Text: string) of object;

  {$IFDEF WINDOWS}
  // Internal helper implementing IDropTarget for the primary target.
  // Lifetime fully controlled by interface references.
  TTextDropTargetImpl = class(TInterfacedObject, IDropTarget)
  private
    FOwner: TTextDropTarget;
    FEdit: TCustomEdit;
    function HasTextFormat(const dataObj: IDataObject): Boolean;
    // IDropTarget
    function DragEnter(const dataObj: IDataObject; grfKeyState: DWORD;
      pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
    function DragOver(grfKeyState: DWORD; pt: TPoint;
      var dwEffect: DWORD): HRESULT; stdcall;
    function DragLeave: HRESULT; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: DWORD;
      pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
  public
    constructor Create(AOwner: TTextDropTarget; AEdit: TCustomEdit);
  end;

  // Internal helper for sub-targets. Drops on these controls
  // fire the OnTextDropped event and optionally insert text into
  // the main target, never into the sub-target itself.
  TTextDropTargetSubImpl = class(TInterfacedObject, IDropTarget)
  private
    FOwner: TTextDropTarget;
    FSubControl: TWinControl;
    function HasTextFormat(const dataObj: IDataObject): Boolean;
    // IDropTarget
    function DragEnter(const dataObj: IDataObject; grfKeyState: DWORD;
      pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
    function DragOver(grfKeyState: DWORD; pt: TPoint;
      var dwEffect: DWORD): HRESULT; stdcall;
    function DragLeave: HRESULT; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: DWORD;
      pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
  public
    constructor Create(AOwner: TTextDropTarget; AControl: TWinControl);
  end;
  {$ENDIF}

  TTextDropTarget = class(TComponent)
  private
    FTarget: TCustomEdit;
    FInsertText: boolean;
    FOnTextDropped: TTextDropEvent;
    {$IFDEF WINDOWS}
    FImpl: IDropTarget;
    FRegisteredHandle: HWND;
    FSubControls: TFPList;               // list of sub-target controls (TWinControl)
    FSubHandles: TFPList;                // parallel list of original HWND used for registration
    FSubImpls: TInterfaceList;           // parallel list of IDropTarget interfaces
    procedure RegisterTarget;
    procedure UnregisterTarget;
    procedure RegisterSubTarget(AControl: TWinControl);
    procedure UnregisterSubTarget(AControl: TWinControl);
    function GetSubTarget(Index: Integer): TWinControl;
    {$ENDIF}
    procedure SetTarget(AValue: TCustomEdit);
    procedure SetInsertText(AValue: boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoTextDropped(ASender: TObject; const Text: string); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ForceRegister;
    procedure Unregister;

    // Sub-target management – any TWinControl can be used (TPanel, TGroupBox, etc.)
    procedure AddSubTarget(AControl: TWinControl);
    procedure RemoveSubTarget(AControl: TWinControl);
    procedure ClearSubTargets;
    function SubTargetCount: integer;
    property SubTargets[Index: integer]: TWinControl read GetSubTarget;
  published
    property Target: TCustomEdit read FTarget write SetTarget;
    property InsertText: boolean read FInsertText write SetInsertText default True;
    property OnTextDropped: TTextDropEvent read FOnTextDropped write FOnTextDropped;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Common Controls', [TTextDropTarget]);
end;

{ TTextDropTarget }

constructor TTextDropTarget.Create(AOwner: TComponent);
begin
  inherited;
  FTarget := nil;
  FInsertText := True;
  FOnTextDropped := nil;
  {$IFDEF WINDOWS}
  FImpl := nil;
  FRegisteredHandle := 0;
  FSubControls := TFPList.Create;
  FSubHandles  := TFPList.Create;
  FSubImpls    := TInterfaceList.Create;
  {$ENDIF}
end;

destructor TTextDropTarget.Destroy;
begin
  {$IFDEF WINDOWS}
  ClearSubTargets;                     // unregister and remove all sub-targets
  FSubImpls.Free;
  FSubHandles.Free;
  FSubControls.Free;
  {$ENDIF}
  Target := nil;                       // unregister primary target
  inherited;
end;

procedure TTextDropTarget.SetTarget(AValue: TCustomEdit);
begin
  if FTarget = AValue then Exit;

  {$IFDEF WINDOWS}
  UnregisterTarget;
  {$ENDIF}

  FTarget := AValue;

  {$IFDEF WINDOWS}
  if Assigned(FTarget) then
  begin
    FTarget.FreeNotification(Self);
    if FTarget.HandleAllocated then
      RegisterTarget;
  end;
  {$ENDIF}
end;

procedure TTextDropTarget.SetInsertText(AValue: boolean);
begin
  if FInsertText = AValue then Exit;
  FInsertText := AValue;
end;

procedure TTextDropTarget.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FTarget then
      Target := nil
    {$IFDEF WINDOWS}
    else if AComponent is TWinControl then
      RemoveSubTarget(TWinControl(AComponent));  // auto-remove destroyed sub-targets
    {$ELSE}
    ;
    {$ENDIF}
  end;
end;

procedure TTextDropTarget.DoTextDropped(ASender: TObject; const Text: string);
begin
  if Assigned(FOnTextDropped) then
    FOnTextDropped(ASender, Text);
end;

{$IFDEF WINDOWS}

var
  // Registered clipboard formats for various text types
  CF_HTML_FORMAT: UINT = 0;
  CF_HTML_MIME:   UINT = 0;
  CF_TEXT_PLAIN:  UINT = 0;

// Simple HTML-to-text converter that strips all tags
function StripHTMLTags(const HTML: string): string;
var
  i: Integer;
  InTag: Boolean;
begin
  Result := '';
  InTag := False;
  for i := 1 to Length(HTML) do
  begin
    if HTML[i] = '<' then
      InTag := True
    else if HTML[i] = '>' then
      InTag := False
    else if not InTag then
      Result := Result + HTML[i];
  end;
end;

// Standalone helper: returns True if the data object contains a supported text format.
function HasDropTextFormat(const dataObj: IDataObject): Boolean;
var
  fmt: TFormatEtc;
begin
  Result := False;
  fmt.ptd := nil;
  fmt.dwAspect := DVASPECT_CONTENT;
  fmt.lindex := -1;
  fmt.tymed := TYMED_HGLOBAL;

  fmt.cfFormat := CF_UNICODETEXT;
  if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);
  fmt.cfFormat := CF_TEXT;
  if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);

  if CF_HTML_FORMAT <> 0 then
  begin
    fmt.cfFormat := CF_HTML_FORMAT;
    if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);
  end;
  if CF_HTML_MIME <> 0 then
  begin
    fmt.cfFormat := CF_HTML_MIME;
    if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);
  end;
  if CF_TEXT_PLAIN <> 0 then
  begin
    fmt.cfFormat := CF_TEXT_PLAIN;
    if Succeeded(dataObj.QueryGetData(fmt)) then Exit(True);
  end;
end;

// Standalone helper: extracts text from the data object, returning an empty string on failure.
function GetDropText(const dataObj: IDataObject): string;
var
  fmt: TFormatEtc;
  stg: TStgMedium;
  pText: PChar;
  isUnicode, isPlainText, isHTML, isHTMLMime: Boolean;
  cf: UINT;
begin
  Result := '';
  fmt.ptd := nil;
  fmt.dwAspect := DVASPECT_CONTENT;
  fmt.lindex := -1;
  fmt.tymed := TYMED_HGLOBAL;

  isUnicode := False;
  isPlainText := False;
  isHTML := False;
  isHTMLMime := False;

  fmt.cfFormat := CF_UNICODETEXT;
  if Succeeded(dataObj.QueryGetData(fmt)) then
    isUnicode := True
  else
  begin
    if (CF_HTML_FORMAT <> 0) then
    begin
      fmt.cfFormat := CF_HTML_FORMAT;
      if Succeeded(dataObj.QueryGetData(fmt)) then
      begin
        isHTML := True;
        cf := CF_HTML_FORMAT;
      end;
    end;
    if not isHTML and (CF_HTML_MIME <> 0) then
    begin
      fmt.cfFormat := CF_HTML_MIME;
      if Succeeded(dataObj.QueryGetData(fmt)) then
      begin
        isHTMLMime := True;
        cf := CF_HTML_MIME;
      end;
    end;
    if not isHTML and not isHTMLMime and (CF_TEXT_PLAIN <> 0) then
    begin
      fmt.cfFormat := CF_TEXT_PLAIN;
      if Succeeded(dataObj.QueryGetData(fmt)) then
      begin
        isPlainText := True;
        cf := CF_TEXT_PLAIN;
      end;
    end;
    if not isHTML and not isHTMLMime and not isPlainText then
    begin
      fmt.cfFormat := CF_TEXT;
      if Failed(dataObj.QueryGetData(fmt)) then
        Exit;
    end;
  end;

  if isUnicode then
    fmt.cfFormat := CF_UNICODETEXT
  else if isHTML or isHTMLMime then
    fmt.cfFormat := cf
  else if isPlainText then
    fmt.cfFormat := CF_TEXT_PLAIN
  else
    fmt.cfFormat := CF_TEXT;

  if Failed(dataObj.GetData(fmt, stg)) then
    Exit;

  try
    if isUnicode then
    begin
      pText := GlobalLock(stg.hGlobal);
      if not Assigned(pText) then Exit;
      try
        Result := PWideChar(pText);
      finally
        GlobalUnlock(stg.hGlobal);
      end;
    end
    else if isHTML or isHTMLMime then
    begin
      pText := GlobalLock(stg.hGlobal);
      if not Assigned(pText) then Exit;
      try
        Result := StripHTMLTags(string(PAnsiChar(pText)));
      finally
        GlobalUnlock(stg.hGlobal);
      end;
    end
    else if isPlainText then
    begin
      pText := GlobalLock(stg.hGlobal);
      if not Assigned(pText) then Exit;
      try
        Result := string(PAnsiChar(pText));
      finally
        GlobalUnlock(stg.hGlobal);
      end;
    end
    else // CF_TEXT (ANSI)
    begin
      pText := GlobalLock(stg.hGlobal);
      if not Assigned(pText) then Exit;
      try
        Result := string(PAnsiChar(pText));
      finally
        GlobalUnlock(stg.hGlobal);
      end;
    end;
  finally
    ReleaseStgMedium(stg);
  end;
end;

{ Primary target registration }

procedure TTextDropTarget.RegisterTarget;
begin
  if not Assigned(FTarget) or not FTarget.HandleAllocated then Exit;
  if FRegisteredHandle = FTarget.Handle then Exit;

  UnregisterTarget;

  FImpl := TTextDropTargetImpl.Create(Self, FTarget);
  OleCheck(RegisterDragDrop(FTarget.Handle, FImpl));
  FRegisteredHandle := FTarget.Handle;
end;

procedure TTextDropTarget.UnregisterTarget;
begin
  if FRegisteredHandle <> 0 then
  begin
    if IsWindow(FRegisteredHandle) then
      RevokeDragDrop(FRegisteredHandle);
    FRegisteredHandle := 0;
  end;
  FImpl := nil;
end;

procedure TTextDropTarget.ForceRegister;
var
  i: Integer;
  ctrl: TWinControl;
  h: HWND;
  SubImpl: IDropTarget;
begin
  // Primary target
  if Assigned(FTarget) and FTarget.HandleAllocated then
  begin
    if FRegisteredHandle <> FTarget.Handle then
    begin
      UnregisterTarget;
      RegisterTarget;
    end;
  end
  else
    UnregisterTarget;

  // Unregister all sub-targets (keep FSubControls intact)
  for i := 0 to FSubHandles.Count - 1 do
  begin
    h := HWND(FSubHandles[i]);
    if (h <> 0) and IsWindow(h) then
      RevokeDragDrop(h);
  end;
  FSubHandles.Clear;
  FSubImpls.Clear;

  // Re-register all sub-targets from FSubControls
  for i := 0 to FSubControls.Count - 1 do
  begin
    ctrl := TWinControl(FSubControls[i]);
    if not ctrl.HandleAllocated then
      ctrl.HandleNeeded;
    h := ctrl.Handle;
    SubImpl := TTextDropTargetSubImpl.Create(Self, ctrl);
    OleCheck(RegisterDragDrop(h, SubImpl));
    FSubHandles.Add(Pointer(h));
    FSubImpls.Add(SubImpl as IUnknown);
  end;
end;

procedure TTextDropTarget.Unregister;
var
  i: Integer;
  h: HWND;
begin
  UnregisterTarget;

  // Unregister all sub-targets, clear handles and impls but keep FSubControls
  for i := 0 to FSubHandles.Count - 1 do
  begin
    h := HWND(FSubHandles[i]);
    if (h <> 0) and IsWindow(h) then
      RevokeDragDrop(h);
  end;
  FSubHandles.Clear;
  FSubImpls.Clear;
end;

{ Sub-target management }

procedure TTextDropTarget.RegisterSubTarget(AControl: TWinControl);
var
  SubImpl: IDropTarget;
  h: HWND;
begin
  if not Assigned(AControl) or (AControl = FTarget) then Exit;   // ignore main target
  if FSubControls.IndexOf(AControl) >= 0 then Exit;             // already registered

  if not AControl.HandleAllocated then
    AControl.HandleNeeded;
  h := AControl.Handle;

  SubImpl := TTextDropTargetSubImpl.Create(Self, AControl);
  OleCheck(RegisterDragDrop(h, SubImpl));

  FSubControls.Add(AControl);
  FSubHandles.Add(Pointer(h));
  FSubImpls.Add(SubImpl as IUnknown);
  AControl.FreeNotification(Self);
end;

procedure TTextDropTarget.UnregisterSubTarget(AControl: TWinControl);
var
  idx: Integer;
  h: HWND;
begin
  idx := FSubControls.IndexOf(AControl);
  if idx < 0 then Exit;

  // Guard against desynchronized lists (e.g., after Unregister cleared FSubHandles)
  if idx < FSubHandles.Count then
  begin
    h := HWND(FSubHandles[idx]);
    if (h <> 0) and IsWindow(h) then
      RevokeDragDrop(h);
    FSubHandles.Delete(idx);
    FSubImpls.Delete(idx);
  end;

  FSubControls.Delete(idx);
end;

procedure TTextDropTarget.AddSubTarget(AControl: TWinControl);
begin
  RegisterSubTarget(AControl);
end;

procedure TTextDropTarget.RemoveSubTarget(AControl: TWinControl);
begin
  UnregisterSubTarget(AControl);
end;

procedure TTextDropTarget.ClearSubTargets;
begin
  while FSubControls.Count > 0 do
    RemoveSubTarget(TWinControl(FSubControls.Last));
end;

function TTextDropTarget.SubTargetCount: Integer;
begin
  Result := FSubControls.Count;
end;

function TTextDropTarget.GetSubTarget(Index: Integer): TWinControl;
begin
  Result := TWinControl(FSubControls[Index]);
end;

{ TTextDropTargetImpl }

constructor TTextDropTargetImpl.Create(AOwner: TTextDropTarget; AEdit: TCustomEdit);
begin
  inherited Create;
  FOwner := AOwner;
  FEdit := AEdit;
end;

function TTextDropTargetImpl.HasTextFormat(const dataObj: IDataObject): Boolean;
begin
  Result := HasDropTextFormat(dataObj);
end;

function TTextDropTargetImpl.DragEnter(const dataObj: IDataObject;
  grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
begin
  if HasTextFormat(dataObj) then
    dwEffect := DROPEFFECT_COPY
  else
    dwEffect := DROPEFFECT_NONE;
  Result := S_OK;
end;

function TTextDropTargetImpl.DragOver(grfKeyState: DWORD; pt: TPoint;
  var dwEffect: DWORD): HRESULT; stdcall;
begin
  dwEffect := DROPEFFECT_COPY;
  Result := S_OK;
end;

function TTextDropTargetImpl.DragLeave: HRESULT; stdcall;
begin
  Result := S_OK;
end;

function TTextDropTargetImpl.Drop(const dataObj: IDataObject;
  grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
var
  s: string;
  ClientPt: TPoint;
  CharIdx: LResult;
begin
  if not Assigned(FEdit) or not Assigned(FOwner) then
  begin
    dwEffect := DROPEFFECT_NONE;
    Exit(E_FAIL);
  end;

  s := GetDropText(dataObj);
  if s = '' then
  begin
    dwEffect := DROPEFFECT_NONE;
    Exit(E_FAIL);
  end;

  // Pass the primary target control as Sender
  FOwner.DoTextDropped(FEdit, s);

  if FOwner.InsertText then
  begin
    ClientPt := FEdit.ScreenToClient(pt);
    CharIdx := SendMessage(FEdit.Handle, EM_CHARFROMPOS, 0,
      MakeLParam(ClientPt.X, ClientPt.Y));
    FEdit.SelStart := LoWord(CharIdx);
    FEdit.SelText := s;
  end;

  dwEffect := DROPEFFECT_COPY;
  Result := S_OK;
end;

{ TTextDropTargetSubImpl }

constructor TTextDropTargetSubImpl.Create(AOwner: TTextDropTarget; AControl: TWinControl);
begin
  inherited Create;
  FOwner := AOwner;
  FSubControl := AControl;
end;

function TTextDropTargetSubImpl.HasTextFormat(const dataObj: IDataObject): Boolean;
begin
  Result := HasDropTextFormat(dataObj);
end;

function TTextDropTargetSubImpl.DragEnter(const dataObj: IDataObject;
  grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
begin
  if HasTextFormat(dataObj) then
    dwEffect := DROPEFFECT_COPY
  else
    dwEffect := DROPEFFECT_NONE;
  Result := S_OK;
end;

function TTextDropTargetSubImpl.DragOver(grfKeyState: DWORD; pt: TPoint;
  var dwEffect: DWORD): HRESULT; stdcall;
begin
  dwEffect := DROPEFFECT_COPY;
  Result := S_OK;
end;

function TTextDropTargetSubImpl.DragLeave: HRESULT; stdcall;
begin
  Result := S_OK;
end;

function TTextDropTargetSubImpl.Drop(const dataObj: IDataObject;
  grfKeyState: DWORD; pt: TPoint; var dwEffect: DWORD): HRESULT; stdcall;
var
  s: string;
  ClientPt: TPoint;
  CharIdx: LResult;
begin
  if not Assigned(FOwner) then
  begin
    dwEffect := DROPEFFECT_NONE;
    Exit(E_FAIL);
  end;

  s := GetDropText(dataObj);
  if s = '' then
  begin
    dwEffect := DROPEFFECT_NONE;
    Exit(E_FAIL);
  end;

  // Pass the sub-target control as Sender
  FOwner.DoTextDropped(FSubControl, s);

  // Insert text into the **primary** target if allowed and available.
  if FOwner.InsertText and Assigned(FOwner.FTarget) and FOwner.FTarget.HandleAllocated then
  begin
    // Map the drop point to the primary target's client coordinates.
    ClientPt := FOwner.FTarget.ScreenToClient(pt);
    CharIdx := SendMessage(FOwner.FTarget.Handle, EM_CHARFROMPOS, 0,
      MakeLParam(ClientPt.X, ClientPt.Y));
    FOwner.FTarget.SelStart := LoWord(CharIdx);
    FOwner.FTarget.SelText := s;
  end;

  dwEffect := DROPEFFECT_COPY;
  Result := S_OK;
end;

{$ENDIF}

{$IFDEF WINDOWS}
initialization
  CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
  CF_HTML_FORMAT := RegisterClipboardFormat('HTML Format');
  CF_HTML_MIME   := RegisterClipboardFormat('text/html');
  CF_TEXT_PLAIN  := RegisterClipboardFormat('text/plain');
finalization
  CoUninitialize;
{$ENDIF}

end.
