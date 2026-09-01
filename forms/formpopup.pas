//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formpopup;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Buttons,
  ExtCtrls,
  Graphics,
  Dialogs,
  ActnList,
  Menus,
  StdCtrls,
  Clipbrd,
  Math,
  LCLType,
  LCLIntf,
  LMessages,
  RichMemo,
  textdroptarget
  {$IFDEF WINDOWS}
  ,Windows
  {$ENDIF}
  , Types;

type

  { TformPopupTrayslate }

  TformPopupTrayslate = class(TForm)
    aApplyAutoHeight: TAction;
    aCopy: TAction;
    aClear: TAction;
    aBidiRightToLeft: TAction;
    aTranslate: TAction;
    aDefaultZoom: TAction;
    aSelectAll: TAction;
    aPaste: TAction;
    aCut: TAction;
    aUndo: TAction;
    aTranslateFromControlPopup: TAction;
    aTranslateControl: TAction;
    aSwapPair: TAction;
    aFastAutoHeight: TAction;
    aMenu: TAction;
    aSendToMainWindow: TAction;
    aCopyTarget: TAction;
    aNewTranslate: TAction;
    ActionList: TActionList;
    FlowPairs: TFlowPanel;
    LabelWatermark: TLabel;
    MemoTarget: TRichMemo;
    MenuFastAutoHeight: TMenuItem;
    MenuApplyAutoHeight: TMenuItem;
    MenuDefaultZoom: TMenuItem;
    MenuTranslate: TMenuItem;
    MenuUndo: TMenuItem;
    MenuCut: TMenuItem;
    MenuCopy: TMenuItem;
    MenuPaste: TMenuItem;
    MenuClear: TMenuItem;
    MenuSelectAll: TMenuItem;
    MenuBidiRightToLeft: TMenuItem;
    MenuTranslateFromControlPopup: TMenuItem;
    MenuTranslateControl: TMenuItem;
    MenuSwapPair: TMenuItem;
    MenuSendToMainWindow: TMenuItem;
    PanelTarget: TPanel;
    PanelPairs: TPanel;
    PanelWatermark: TPanel;
    PanelButtonTarget: TPanel;
    Popup: TPopupMenu;
    PopupMemo: TPopupMenu;
    SbCopyTargetPanel: TSpeedButton;
    SbNewTranslate: TSpeedButton;
    SbCopyTarget: TSpeedButton;
    SbMenu: TSpeedButton;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    Separator4: TMenuItem;
    Separator5: TMenuItem;
    Timer: TTimer;

    procedure aApplyAutoHeightExecute(Sender: TObject);
    procedure aBidiRightToLeftExecute(Sender: TObject);
    procedure aClearExecute(Sender: TObject);
    procedure aCopyExecute(Sender: TObject);
    procedure aCopyTargetExecute(Sender: TObject);
    procedure aCutExecute(Sender: TObject);
    procedure aDefaultZoomExecute(Sender: TObject);
    procedure aFastAutoHeightExecute(Sender: TObject);
    procedure aMenuExecute(Sender: TObject);
    procedure aNewTranslateExecute(Sender: TObject);
    procedure aPasteExecute(Sender: TObject);
    procedure aSelectAllExecute(Sender: TObject);
    procedure aSendToMainWindowExecute(Sender: TObject);
    procedure aSwapPairExecute(Sender: TObject);
    procedure aTranslateExecute(Sender: TObject);
    procedure aTranslateFromControlPopupExecute(Sender: TObject);
    procedure aTranslateControlExecute(Sender: TObject);
    procedure aUndoExecute(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShortCut(var Msg: TLMKey; var Handled: boolean);
    procedure FormShow(Sender: TObject);
    procedure MemoTargetChange(Sender: TObject);
    procedure MemoTargetMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
    procedure PanelWatermarkClick(Sender: TObject);
    procedure PopupClose(Sender: TObject);
    procedure PopupPopup(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure OnTextDroppedHandler(Sender: TObject; const AText: string);
  private
    FSourceText: string;
    FDropTarget: TTextDropTarget;
    FInWindow: boolean;
    FPopupOpen: boolean;
    FPrevForegroundWnd: Handle;

    procedure UpdateControlsVisibility;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure DestroyWnd; override;
    procedure UpdateStayOnTop(Data: PtrInt);

    property SourceText: string read FSourceText write FSourceText;
    property InWindow: boolean read FInWindow;
    property PopupOpen: boolean read FPopupOpen;
  end;

var
  formPopupTrayslate: TformPopupTrayslate;

implementation

uses Consts, mainform, formsettings, localize, darkutils, pascalutils, osutils, hotkeyhelper, RichMemoHelper;

  {$R *.lfm}

  { TformPopupTrayslate }

procedure TformPopupTrayslate.FormCreate(Sender: TObject);
begin
  if Assigned(formTrayslate) then
  begin
    TLocalize.ApplicationTranslate(APP_NAME, language, self, TLocalize.LoadCustomPoFile(formTrayslate.CustomPoFile));
    aTranslateFromControlPopup.ShortCut := formTrayslate.HotKeyTransControlPopup.ToShortCut;
    aTranslateControl.ShortCut := formTrayslate.HotKeyTransControl.ToShortCut;
    aSwapPair.ShortCut := formTrayslate.HotKeyTransSwap.ToShortCut;
    aFastAutoHeight.ImageIndex := iif(formTrayslate.AutoHeight, 19, 18);
    aFastAutoHeight.Caption := iif(formTrayslate.AutoHeight, rlockheight, runlockheight);
    MemoTarget.ZoomFactor := formTrayslate.FormPopupZoomFactor;
  end;

  MemoTarget.DisableBuiltInDragDrop;
  FDropTarget := TTextDropTarget.Create(Self);
  FDropTarget.Target := MemoTarget;
  FDropTarget.AddSubTarget(PanelTarget);
  FDropTarget.AddSubTarget(PanelWatermark);
  FDropTarget.AddSubTarget(PanelButtonTarget);
  FDropTarget.InsertText := False;
  FDropTarget.OnTextDropped := @OnTextDroppedHandler;

  aNewTranslate.ImageIndex := TDarkUtils.ThemeValue(8, 9);
  aSendToMainWindow.ImageIndex := TDarkUtils.ThemeValue(14, 15);
  aSwapPair.ImageIndex := TDarkUtils.ThemeValue(0, 1);
  aMenu.ImageIndex := TDarkUtils.ThemeValue(6, 7);
  aCopyTarget.ImageIndex := TDarkUtils.ThemeValue(10, 11);
  aTranslateFromControlPopup.ImageIndex := TDarkUtils.ThemeValue(20, 21);
  aTranslateControl.ImageIndex := TDarkUtils.ThemeValue(22, 23);
  SbCopyTarget.PressedImageIndex := TDarkUtils.ThemeValue(12, 13);
  SbCopyTargetPanel.PressedImageIndex := TDarkUtils.ThemeValue(12, 13);

  FPopupOpen := False;
  FInWindow := False;

  MemoTarget.SetLeftIndent(3);

  UpdateControlsVisibility;
end;

procedure TformPopupTrayslate.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDropTarget);
end;

procedure TformPopupTrayslate.FormShow(Sender: TObject);
begin
  // Ensure no control gets focus, as the form is shown without activation
  ActiveControl := nil;

  // Add this popup window to the global mouse hook ignore list
  if Assigned(formTrayslate) and Assigned(formTrayslate.MouseHook) and HandleAllocated then
    formTrayslate.MouseHook.AddIgnoredWindow(Handle);

  FDropTarget.ForceRegister;
end;

procedure TformPopupTrayslate.FormHide(Sender: TObject);
begin
  FDropTarget.Unregister;

  // Remove this popup window from the global mouse hook ignore list
  if Assigned(formTrayslate) and Assigned(formTrayslate.MouseHook) and HandleAllocated then
    formTrayslate.MouseHook.RemoveIgnoredWindow(Handle);

  if Assigned(formTrayslate) and Assigned(formTrayslate.TranslateTarget) and (formTrayslate.TranslateTarget is TRichMemo) and
    (formTrayslate.TranslateTarget = MemoTarget) then
    formTrayslate.CancelTranslate;
end;

procedure TformPopupTrayslate.FormShortCut(var Msg: TLMKey; var Handled: boolean);
begin
  if Msg.CharCode = VK_ESCAPE then
  begin
    Close;
    Handled := True;
  end;
end;

procedure TformPopupTrayslate.FormResize(Sender: TObject);
begin
  if Assigned(formTrayslate) then
  begin
    formTrayslate.FormPopupWidth := Width;
    formTrayslate.FormPopupHeight := Height;
  end;

  PanelWatermark.Left := PanelTarget.Left + (PanelTarget.Width - PanelWatermark.Width) div 2;
  PanelWatermark.Top := PanelTarget.Top + (PanelTarget.Height - ifthen(PanelPairs.Visible, 0, PanelPairs.Height) -
    PanelWatermark.Height) div 2;

  SbCopyTargetPanel.Left := FlowPairs.Left + FlowPairs.Width;
  SbMenu.Left := SbCopyTargetPanel.Left + SbCopyTargetPanel.Width;

  UpdateControlsVisibility;
end;

procedure TformPopupTrayslate.FormChangeBounds(Sender: TObject);
begin
  if Assigned(formTrayslate) then
  begin
    formTrayslate.FormPopupLeft := Left;
    formTrayslate.FormPopupTop := Top;
  end;
end;

procedure TformPopupTrayslate.aNewTranslateExecute(Sender: TObject);
begin
  MemoTarget.Clear;
  SourceText := string.Empty;
  FormResize(Self);
end;

procedure TformPopupTrayslate.aSendToMainWindowExecute(Sender: TObject);
begin
  if MemoTarget.Text = string.Empty then exit;
  if Assigned(formTrayslate) then
  begin
    formTrayslate.MemoSource.SetTextSafe(SourceText);
    formTrayslate.MemoTarget.SetTextSafe(MemoTarget.Text);
    formTrayslate.aShow.Execute;
  end;
  Hide;
end;

procedure TformPopupTrayslate.aSwapPairExecute(Sender: TObject);
begin
  if Assigned(formTrayslate) then
    formTrayslate.aSwap.Execute;
end;

procedure TformPopupTrayslate.aTranslateExecute(Sender: TObject);
begin
  if Assigned(formTrayslate) then
    formTrayslate.aTranslate.Execute;
end;

procedure TformPopupTrayslate.aTranslateFromControlPopupExecute(Sender: TObject);
begin
  ActiveControl := nil;
  {$IFDEF WINDOWS}
    if FPrevForegroundWnd <> 0 then
      TOS.ForceForegroundWindow(FPrevForegroundWnd);
  {$ENDIF}
  if Assigned(formTrayslate) then
    Application.QueueAsyncCall(@formTrayslate.TranslateFromControlPopup, 0);
end;

procedure TformPopupTrayslate.aTranslateControlExecute(Sender: TObject);
begin
  ActiveControl := nil;
  {$IFDEF WINDOWS}
    if FPrevForegroundWnd <> 0 then
      TOS.ForceForegroundWindow(FPrevForegroundWnd);
  {$ENDIF}
  if Assigned(formTrayslate) then
    Application.QueueAsyncCall(@formTrayslate.TranslateControl, 0);
end;

procedure TformPopupTrayslate.aCopyTargetExecute(Sender: TObject);
begin
  Clipboard.AsText := MemoTarget.Text;
end;

procedure TformPopupTrayslate.aApplyAutoHeightExecute(Sender: TObject);
begin
  if Assigned(formTrayslate) then
    formTrayslate.AdjustPopupHeight(MemoTarget.Text, True);
end;

procedure TformPopupTrayslate.aUndoExecute(Sender: TObject);
begin
  MemoTarget.Undo;
end;

procedure TformPopupTrayslate.aCutExecute(Sender: TObject);
begin
  MemoTarget.CutToClipboard;
end;

procedure TformPopupTrayslate.aCopyExecute(Sender: TObject);
begin
  MemoTarget.CopyToClipboard;
end;

procedure TformPopupTrayslate.aPasteExecute(Sender: TObject);
begin
  MemoTarget.PasteFromClipboard;
end;

procedure TformPopupTrayslate.aClearExecute(Sender: TObject);
begin
  MemoTarget.Clear;
end;

procedure TformPopupTrayslate.aSelectAllExecute(Sender: TObject);
begin
  MemoTarget.SelectAll;
end;

procedure TformPopupTrayslate.aBidiRightToLeftExecute(Sender: TObject);
begin
  if aBidiRightToLeft.Checked then
    MemoTarget.BiDiMode := bdRightToLeft
  else
    MemoTarget.BiDiMode := bdLeftToRight;
  MemoTarget.ApplyBidiMode;
end;

procedure TformPopupTrayslate.aDefaultZoomExecute(Sender: TObject);
begin
  MemoTarget.ZoomFactor := 1;
  if Assigned(formTrayslate) then
    formTrayslate.FormPopupZoomFactor := 1;
end;

procedure TformPopupTrayslate.aFastAutoHeightExecute(Sender: TObject);
var
  Check: boolean;
begin
  if not Assigned(formTrayslate) then Exit;

  Check := not formTrayslate.FAutoHeight;
  formTrayslate.FAutoHeight := Check;
  formTrayslate.aFastAutoHeight.Checked := Check;

  if Assigned(formSettingsTrayslate) and formSettingsTrayslate.Visible then
    formSettingsTrayslate.CheckAutoHeight.Checked := Check;

  if Assigned(formSettingsTrayslate) and formTrayslate.AutoHeight then
    formTrayslate.AdjustPopupHeight(MemoTarget.Text);

  aFastAutoHeight.ImageIndex := iif(Check, 19, 18);
  aFastAutoHeight.Caption := iif(Check, rlockheight, runlockheight);
end;

procedure TformPopupTrayslate.aMenuExecute(Sender: TObject);
var
  P: TPoint;
begin
  // Bottom-right of button in screen coords
  P := SbMenu.ClientToScreen(Classes.Point(SbMenu.Width, SbMenu.Height));
  SbMenu.Down := True;
  Popup.PopUp(P.X, P.Y);
end;

procedure TformPopupTrayslate.MemoTargetChange(Sender: TObject);
begin
  UpdateControlsVisibility;
  TimerTimer(Self);
  if MemoTarget.BiDiMode = bdRightToLeft then
    MemoTarget.ApplyBidiMode;
end;

procedure TformPopupTrayslate.MemoTargetMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer;
  MousePos: TPoint; var Handled: boolean);
begin
  if Assigned(formTrayslate) then
    formTrayslate.FormPopupZoomFactor := MemoTarget.ZoomFactor;
end;

procedure TformPopupTrayslate.PanelWatermarkClick(Sender: TObject);
begin
  if MemoTarget.Enabled and MemoTarget.Visible and MemoTarget.CanFocus then
    MemoTarget.SetFocus;
end;

procedure TformPopupTrayslate.PopupPopup(Sender: TObject);
var
  hWnd: Handle;
  pid: DWORD;
begin
  FPopupOpen := True;
  {$IFDEF WINDOWS}
  hWnd := GetForegroundWindow;
  GetWindowThreadProcessId(hWnd, @pid);
  if pid <> GetCurrentProcessId then
    FPrevForegroundWnd := hWnd;
  {$ENDIF}
end;

procedure TformPopupTrayslate.PopupClose(Sender: TObject);
begin
  FPopupOpen := False;
  SbMenu.Down := False;
end;

procedure TformPopupTrayslate.TimerTimer(Sender: TObject);
var
  CursorPos: TPoint;
  TargetAlpha: integer;
  DetectionRect: TRect;
const
  // Individual margins for each side (in pixels)
  MARGIN_LEFT = 15;
  MARGIN_RIGHT = 10; // Increased to compensate for invisible borders
  MARGIN_TOP = 45; // Covers the caption bar
  MARGIN_BOTTOM = 15; // Increased for easier resizing
begin
  // Exit early if the form is not visible or is being destroyed
  if not Self.Visible or (csDestroying in Self.ComponentState) then
    Exit;

  // Safety check for the settings form to avoid Access Violation
  if not Assigned(formTrayslate) then
    Exit;

  // Convert global screen mouse position to local coordinates (0,0 is Top-Left of ClientArea)
  CursorPos := Self.ScreenToClient(Mouse.CursorPos);

  // Start with the basic client area rectangle
  DetectionRect := Self.ClientRect;

  // Manually expand the detection area to cover title bar and invisible borders
  DetectionRect.Left := DetectionRect.Left - MARGIN_LEFT;
  DetectionRect.Top := DetectionRect.Top - MARGIN_TOP;
  DetectionRect.Right := DetectionRect.Right + MARGIN_RIGHT;
  DetectionRect.Bottom := DetectionRect.Bottom + MARGIN_BOTTOM;

  // Check if the relative mouse position is within our expanded virtual rect
  if PtInRect(DetectionRect, CursorPos) then
  begin
    // Mouse is within range (including margins)
    FInWindow := True;
    TargetAlpha := Round(Power(EnsureRange(formTrayslate.OpacityHover, 0, 100) / 100, 0.5) * 255);
  end
  else
  begin
    // Mouse is outside the detection zone
    FInWindow := False;
    TargetAlpha := Round(Power(EnsureRange(formTrayslate.OpacityIdle, 0, 100) / 100, 0.5) * 255);
  end;

  // Apply AlphaBlendValue only when it changes to avoid UI flicker
  if not FPopupOpen and (Self.AlphaBlendValue <> TargetAlpha) then
  begin
    if not Self.AlphaBlend then
      Self.AlphaBlend := True;

    Self.AlphaBlendValue := TargetAlpha;

    MemoTarget.DisableBuiltInDragDrop;
  end;

  if PanelWatermark.Color <> MemoTarget.Color then
    PanelWatermark.Color := MemoTarget.Color;
  if PanelTarget.Color <> MemoTarget.Color then
    PanelTarget.Color := MemoTarget.Color;

  if not FPopupOpen then
    UpdateControlsVisibility;
end;

procedure TformPopupTrayslate.OnTextDroppedHandler(Sender: TObject; const AText: string);
begin
  if Assigned(formTrayslate) then
    formTrayslate.TranslatePopup(AText);
end;

procedure TformPopupTrayslate.UpdateControlsVisibility;
var
  SizeOk: boolean;
  EnoughSpace: boolean;
begin
  if not Assigned(formTrayslate) then Exit;

  // Watermark
  PanelWatermark.Visible := (MemoTarget.Text = '') and (Width >= PanelWatermark.Width) and
    (Height >= PanelWatermark.Height + FlowPairs.Height);

  // Pairs panel
  PanelPairs.Visible := FInWindow or not formTrayslate.HideControls;

  // Main button panel (Send, New, Copy)
  SizeOk := (Width > 100) and (Height > 50 + FlowPairs.Height);
  EnoughSpace := MemoTarget.GetBottomSpace >= 20;
  PanelButtonTarget.Visible :=
    ((FInWindow and SizeOk) or not formTrayslate.HideControls) and EnoughSpace;

  // Small copy panel (opposite of main)
  SbCopyTargetPanel.Visible := not PanelButtonTarget.Visible;
end;

procedure TformPopupTrayslate.CreateParams(var Params: TCreateParams);
{$IFDEF WINDOWS}
const
  WS_EX_NOACTIVATE = $08000000;
{$ENDIF}
begin
  inherited CreateParams(Params);
  {$IFDEF WINDOWS}
  // Prevent the form from taking focus (tool window style)
  if FormStyle = fsSystemStayOnTop then
    Params.ExStyle := Params.ExStyle or WS_EX_NOACTIVATE;
  {$ENDIF}
end;

procedure TformPopupTrayslate.DestroyWnd;
begin
  if Assigned(FDropTarget) then
    FDropTarget.Unregister;
  inherited DestroyWnd;
end;

procedure TformPopupTrayslate.UpdateStayOnTop(Data: PtrInt);
{$IFDEF WINDOWS}
var
  ExStyle: LONG_PTR;
{$ENDIF}
begin
  if Assigned(formTrayslate) then
  begin
    if formTrayslate.StayOnTop then
      FormStyle := fsSystemStayOnTop
    else
      FormStyle := fsNormal;
  end;

  {$IFDEF WINDOWS}
  // Applying WS_EX_NOACTIVATE in a real window
  if HandleAllocated and (Data = 1) then
  begin
    ExStyle := GetWindowLongPtr(Handle, GWL_EXSTYLE);
    if FormStyle = fsSystemStayOnTop then
      ExStyle := ExStyle or WS_EX_NOACTIVATE
    else
      ExStyle := ExStyle and (not WS_EX_NOACTIVATE);

    SetWindowLongPtr(Handle, GWL_EXSTYLE, ExStyle);

    // Update non-client area and restore correct Z-order
    if FormStyle = fsSystemStayOnTop then
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,
        SWP_FRAMECHANGED or SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE)
    else
      SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0,
        SWP_FRAMECHANGED or SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
  end;
  {$ENDIF}

  MemoTarget.DisableBuiltInDragDrop;
end;

end.
