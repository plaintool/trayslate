//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit FormButton;

{$mode ObjFPC}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,      // Required for CreateRoundRectRgn and SetWindowRgn
  {$ENDIF}
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  Buttons,
  ExtCtrls,
  LCLType, Menus;

type

  { TformButtonTrayslate }

  TformButtonTrayslate = class(TForm)
    ImageTranslate: TImage;
    MenuCancelTranslate: TMenuItem;
    MenuTranslateFromControl: TMenuItem;
    MenuTranslateFromControlPopup: TMenuItem;
    MenuTranslateControl: TMenuItem;
    Popup: TPopupMenu;
    Separator1: TMenuItem;
    TimerHide: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ImageTranslateMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure ImageTranslateMouseEnter(Sender: TObject);
    procedure ImageTranslateMouseLeave(Sender: TObject);
    procedure ImageTranslateClick(Sender: TObject);
    procedure MenuCancelTranslateClick(Sender: TObject);
    procedure MenuTranslateControlClick(Sender: TObject);
    procedure MenuTranslateFromControlPopupClick(Sender: TObject);
    procedure MenuTranslateFromControlClick(Sender: TObject);
    procedure PopupClose(Sender: TObject);
    procedure PopupPopup(Sender: TObject);
    procedure TimerHideTimer(Sender: TObject);
  private
    FSourceText: string;
    FHoverColor: TColor;
    FPopupOpen: boolean;
    FPopupClosed: boolean;
    FPrevForegroundWnd: Handle;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    property SourceText: string read FSourceText write FSourceText;
  end;

var
  formButtonTrayslate: TformButtonTrayslate;

const
  clHotterlight = TColor($FFF0DC);

implementation

uses Consts, MainForm, Localize, DarkUtils, OSUtils, HotKeyHelper;

  {$R *.lfm}

  { TformButtonTrayslate }

procedure TformButtonTrayslate.FormCreate(Sender: TObject);
begin
  // Apply localization
  TLocalize.ApplicationTranslate(APP_NAME, language, self, TLocalize.LoadCustomPoFile(formTrayslate.CustomPoFile));

  // Set the appropriate icon based on the theme
  ImageTranslate.ImageIndex := TDarkUtils.ThemeValue(2, 3);
  FHoverColor := TDarkUtils.ThemeColor(clHotterlight, clNavy);
  Width := 27;
  Height := 27;

  MenuTranslateFromControlPopup.ImageIndex := TDarkUtils.ThemeValue(20, 21);
  menuTranslateFromControl.ImageIndex := TDarkUtils.ThemeValue(20, 21);
  menuTranslateControl.ImageIndex := TDarkUtils.ThemeValue(22, 23);

  menuTranslateFromControl.ShortCut := formTrayslate.HotKeyTransFromControl.ToShortCut;
  MenuTranslateFromControlPopup.ShortCut := formTrayslate.HotKeyTransControlPopup.ToShortCut;
  menuTranslateControl.ShortCut := formTrayslate.HotKeyTransControl.ToShortCut;

  // Remove standard window borders to allow custom rounded shape
  BorderStyle := bsNone;
end;

procedure TformButtonTrayslate.FormShow(Sender: TObject);
{$IFDEF WINDOWS}
var
  Rgn: HRGN;
{$ENDIF}
begin
  // Create a rounded-rectangle region for the form (radius = 6 pixels)
  // For other platforms, TForm.SetShape with a bitmap can be used instead.
  {$IFDEF WINDOWS}
  Rgn := CreateRoundRectRgn(0, 0, Width, Height, 17, 17);
  SetWindowRgn(Handle, Rgn, True);
  {$ENDIF}

  TimerHide.Enabled := True;

  // Variables defaults
  FPopupClosed := False;
  FPopupOpen := False;
end;

procedure TformButtonTrayslate.FormPaint(Sender: TObject);
begin
  Canvas.AntialiasingMode := amOn;
  if not TimerHide.Enabled then // hover
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := FHoverColor;
    Canvas.FillRect(ClientRect);
  end
  else
    Canvas.Brush.Style := bsClear;

  Canvas.Pen.Width := 2;
  Canvas.Pen.Color := clGray;
  Canvas.RoundRect(-3, -3, Width - 1, Height - 1, 20, 20);

  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clSilver;
  Canvas.RoundRect(-2, -2, Width - 2, Height - 2, 17, 17);
end;

procedure TformButtonTrayslate.ImageTranslateMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if FPopupOpen then
  begin
    Popup.Close;
    FPopupClosed := True;
  end;
end;

procedure TformButtonTrayslate.ImageTranslateClick(Sender: TObject);
begin
  if not FPopupOpen and not FPopupClosed then
  begin
    // Hide the button and trigger the translation popup
    TimerHideTimer(Self);
    formTrayslate.TranslatePopup(SourceText, Left, Top);
  end;
  FPopupClosed := False;
end;

procedure TformButtonTrayslate.MenuCancelTranslateClick(Sender: TObject);
begin
  TimerHide.Enabled := False;
  Hide;
end;

procedure TformButtonTrayslate.MenuTranslateFromControlPopupClick(Sender: TObject);
begin
  ActiveControl := nil;
  {$IFDEF WINDOWS}
    if FPrevForegroundWnd <> 0 then
      TOS.ForceForegroundWindow(FPrevForegroundWnd);
  {$ENDIF}
  Application.QueueAsyncCall(@formTrayslate.TranslateFromControlPopup, 0);
end;

procedure TformButtonTrayslate.MenuTranslateControlClick(Sender: TObject);
begin
  ActiveControl := nil;
  {$IFDEF WINDOWS}
    if FPrevForegroundWnd <> 0 then
      TOS.ForceForegroundWindow(FPrevForegroundWnd);
  {$ENDIF}
  Application.QueueAsyncCall(@formTrayslate.TranslateControl, 0);
end;

procedure TformButtonTrayslate.MenuTranslateFromControlClick(Sender: TObject);
begin
  ActiveControl := nil;
  {$IFDEF WINDOWS}
    if FPrevForegroundWnd <> 0 then
      TOS.ForceForegroundWindow(FPrevForegroundWnd);
  {$ENDIF}
  Application.QueueAsyncCall(@formTrayslate.TranslateFromControl, 0);
end;

procedure TformButtonTrayslate.PopupClose(Sender: TObject);
begin
  FPopupOpen := False;
  FPopupClosed := True;
end;

procedure TformButtonTrayslate.PopupPopup(Sender: TObject);
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

procedure TformButtonTrayslate.CreateParams(var Params: TCreateParams);
{$IFDEF WINDOWS}
const
  WS_EX_NOACTIVATE = $08000000;
{$ENDIF}
begin
  inherited CreateParams(Params);
  {$IFDEF WINDOWS}
  // Prevent the form from taking focus (tool window style)
  Params.ExStyle := Params.ExStyle or WS_EX_NOACTIVATE;
  {$ENDIF}
end;

procedure TformButtonTrayslate.ImageTranslateMouseEnter(Sender: TObject);
begin
  // Keep the button visible while the mouse is over it
  TimerHide.Enabled := False;
  Invalidate;
end;

procedure TformButtonTrayslate.ImageTranslateMouseLeave(Sender: TObject);
begin
  // Resume auto-hide timer when the mouse leaves
  TimerHide.Enabled := True;
  Invalidate;
end;

procedure TformButtonTrayslate.TimerHideTimer(Sender: TObject);
begin
  // Automatically hide the form after a REQUEST_TIMEOUT
  if not FPopupOpen then
  begin
    TimerHide.Enabled := False;
    Hide;
  end;
end;

end.
