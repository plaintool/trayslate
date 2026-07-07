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
  textdroptarget
  {$IFDEF WINDOWS}
  ,Windows
  {$ENDIF}
  ;

type

  { TformPopupTrayslate }

  TformPopupTrayslate = class(TForm)
    aSend: TAction;
    aCopyTarget: TAction;
    aNewTranslate: TAction;
    ActionList: TActionList;
    FlowPairs: TFlowPanel;
    LabelWatermark: TLabel;
    MemoTarget: TMemo;
    PanelTarget: TPanel;
    PanelPairs: TPanel;
    PanelWatermark: TPanel;
    PanelButtonTarget: TPanel;
    SbCopyTargetPanel: TSpeedButton;
    SbNewTranslate: TSpeedButton;
    SbCopyTarget: TSpeedButton;
    SbSend: TSpeedButton;
    Timer: TTimer;

    procedure aCopyTargetExecute(Sender: TObject);
    procedure aNewTranslateExecute(Sender: TObject);
    procedure aSendExecute(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShortCut(var Msg: TLMKey; var Handled: boolean);
    procedure FormShow(Sender: TObject);
    procedure MemoTargetChange(Sender: TObject);
    procedure PanelWatermarkClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure OnTextDroppedHandler(Sender: TObject; const AText: string);
  private
    FSourceText: string;
    FDropTarget: TTextDropTarget;
    FInWindow: boolean;

    procedure UpdateControlsVisibility;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure DestroyWnd; override;
    procedure UpdateStayOnTop(Data: PtrInt);

    property SourceText: string read FSourceText write FSourceText;
    property InWindow: boolean read FInWindow;
  end;

var
  formPopupTrayslate: TformPopupTrayslate;

implementation

uses mainform, localize, darkutils, controlshelper;

  {$R *.lfm}

  { TformPopupTrayslate }

procedure TformPopupTrayslate.FormCreate(Sender: TObject);
begin
  TLocalize.ApplicationTranslate(language, self, TLocalize.LoadCustomPoFile(formTrayslate.CustomPoFile));

  FDropTarget := TTextDropTarget.Create(Self);
  FDropTarget.Target := MemoTarget;
  FDropTarget.AddSubTarget(PanelTarget);
  FDropTarget.AddSubTarget(PanelWatermark);
  FDropTarget.AddSubTarget(PanelButtonTarget);
  FDropTarget.InsertText := False;
  FDropTarget.OnTextDropped := @OnTextDroppedHandler;

  aNewTranslate.ImageIndex := TDarkUtils.ThemeValue(8, 9);
  aSend.ImageIndex := TDarkUtils.ThemeValue(14, 15);
  aCopyTarget.ImageIndex := TDarkUtils.ThemeValue(10, 11);
  SbCopyTarget.PressedImageIndex := TDarkUtils.ThemeValue(12, 13);
  SbCopyTargetPanel.PressedImageIndex := TDarkUtils.ThemeValue(12, 13);

  UpdateControlsVisibility;
end;

procedure TformPopupTrayslate.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDropTarget);
end;

procedure TformPopupTrayslate.FormShow(Sender: TObject);
begin
  FDropTarget.ForceRegister;
end;

procedure TformPopupTrayslate.FormHide(Sender: TObject);
begin
  FDropTarget.Unregister;
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
  formTrayslate.FormPopupWidth := Width;
  formTrayslate.FormPopupHeight := Height;

  PanelWatermark.Left := PanelTarget.Left + (PanelTarget.Width - PanelWatermark.Width) div 2;
  PanelWatermark.Top := PanelTarget.Top + (PanelTarget.Height - ifthen(PanelPairs.Visible, 0, PanelPairs.Height) -
    PanelWatermark.Height) div 2;

  SbCopyTargetPanel.Left := FlowPairs.Left + FlowPairs.Width;
  SbSend.Left := SbCopyTargetPanel.Left + SbCopyTargetPanel.Width;

  UpdateControlsVisibility;
end;

procedure TformPopupTrayslate.FormChangeBounds(Sender: TObject);
begin
  formTrayslate.FormPopupLeft := Left;
  formTrayslate.FormPopupTop := Top;
end;

procedure TformPopupTrayslate.aNewTranslateExecute(Sender: TObject);
begin
  MemoTarget.Clear;
  SourceText := string.Empty;
  FormResize(Self);
end;

procedure TformPopupTrayslate.aSendExecute(Sender: TObject);
begin
  if MemoTarget.Text = string.Empty then exit;
  formTrayslate.MemoSource.Text := SourceText;
  formTrayslate.MemoTarget.Text := MemoTarget.Text;
  formTrayslate.aShow.Execute;
end;

procedure TformPopupTrayslate.aCopyTargetExecute(Sender: TObject);
begin
  Clipboard.AsText := MemoTarget.Text;
end;

procedure TformPopupTrayslate.MemoTargetChange(Sender: TObject);
begin
  UpdateControlsVisibility;
  TimerTimer(Self);
end;

procedure TformPopupTrayslate.PanelWatermarkClick(Sender: TObject);
begin
  if MemoTarget.Enabled and MemoTarget.Visible and MemoTarget.CanFocus then
    MemoTarget.SetFocus;
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
  if Self.AlphaBlendValue <> TargetAlpha then
  begin
    if not Self.AlphaBlend then
      Self.AlphaBlend := True;

    Self.AlphaBlendValue := TargetAlpha;
  end;

  UpdateControlsVisibility;
end;

procedure TformPopupTrayslate.OnTextDroppedHandler(Sender: TObject; const AText: string);
begin
  formTrayslate.TranslatePopup(AText);
end;

procedure TformPopupTrayslate.UpdateControlsVisibility;
var
  SizeOk: boolean;
  EnoughSpace: boolean;
begin
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
  if formTrayslate.StayOnTop then
    FormStyle := fsSystemStayOnTop
  else
    FormStyle := fsNormal;

  {$IFDEF WINDOWS}
  // Applying WS_EX_NOACTIVATE in a real window
  if HandleAllocated then
  begin
    ExStyle := GetWindowLongPtr(Handle, GWL_EXSTYLE);
    if FormStyle = fsSystemStayOnTop then
      ExStyle := ExStyle or WS_EX_NOACTIVATE
    else
      ExStyle := ExStyle and (not WS_EX_NOACTIVATE);
    SetWindowLongPtr(Handle, GWL_EXSTYLE, ExStyle);
    // We force the window manager to redraw non-client areas (frames, title)
    SetWindowPos(Handle, 0, 0, 0, 0, 0,
      SWP_FRAMECHANGED or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_NOACTIVATE);
  end;
  {$ENDIF}
end;

end.
