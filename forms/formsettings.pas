//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formsettings;

{$mode ObjFPC}{$H+}

interface

uses
  Forms,
  Classes,
  Types,
  SysUtils,
  StrUtils,
  Controls,
  Graphics,
  Dialogs,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  ColorBox,
  Spin,
  Math,
  Grids,
  LCLType,
  LCLIntf,
  langtool,
  systemtool;

type

  { TformSettingsTrayslate }

  TformSettingsTrayslate = class(TForm)
    BtnDefaultHotkeys: TButton;
    BtnFont: TButton;
    BtnFontPopup: TButton;
    BtnDefault: TButton;
    BtnReset: TButton;
    BtnApply: TButton;
    BtnCancel: TButton;
    BtnOk: TButton;
    BtnResetPopup: TButton;
    CheckAllowHotkeys: TCheckBox;
    CheckAutoHeight: TCheckBox;
    CheckProxyAuthentication: TCheckBox;
    CheckSmartSwap: TCheckBox;
    CheckEnableMouseMode: TCheckBox;
    CheckMouseModeCtrl: TCheckBox;
    CheckSmartHard: TCheckBox;
    CheckStayOnTop: TCheckBox;
    CheckRealTime: TCheckBox;
    CheckAutoSwap: TCheckBox;
    CheckHideControls: TCheckBox;
    CheckTwoLang: TCheckBox;
    CheckAutostart: TCheckBox;
    CheckAutoAddLangPairs: TCheckBox;
    CheckVerticalSplit: TCheckBox;
    ColorIconBackground: TColorBox;
    ColorIconFont: TColorBox;
    ColorDialog: TColorDialog;
    ComboProxyMode: TComboBox;
    ComboPrimaryLang: TComboBox;
    ComboProxyType: TComboBox;
    ComboSecondaryLang: TComboBox;
    ComboMouseMode: TComboBox;
    ComboIconFontName: TComboBox;
    ComboLangDetect: TComboBox;
    EditProxyHost: TEdit;
    EditProxyLogin: TEdit;
    EditProxyPassword: TEdit;
    FontDialog: TFontDialog;
    GroupAutoSwap: TGroupBox;
    GroupAutostart: TGroupBox;
    GroupTimeouts: TGroupBox;
    GroupMainWindow: TGroupBox;
    GroupMouseMode: TGroupBox;
    GroupPopup: TGroupBox;
    GroupLangPairs: TGroupBox;
    GroupProxy: TGroupBox;
    GroupTransFromClipboard1: TGroupBox;
    GroupRealTime: TGroupBox;
    GroupTrayIcon: TGroupBox;
    ImagesPages: TImageList;
    LabelLangDetectConfig: TLabel;
    LabelMaxHeight: TLabel;
    LabelConnectTimeout: TLabel;
    LabelProxyMode: TLabel;
    LabelProxyType: TLabel;
    LabelHost: TLabel;
    LabelPort: TLabel;
    LabelLogin: TLabel;
    LabelPassword: TLabel;
    LabelRequestTimeout: TLabel;
    LabelPrimaryLang: TLabel;
    LabelMouseMode: TLabel;
    LabelIconFont1: TLabel;
    LabelMaxLangPairs: TLabel;
    LabelOpacityHover: TLabel;
    LabelOpacityIdle: TLabel;
    LabelSecondaryLang: TLabel;
    LabelRealTimeDelay: TLabel;
    LabelIconBackground: TLabel;
    LabelIconFont: TLabel;
    ListPages: TListBox;
    PagesSettings: TPageControl;
    PanelFontPopup: TPanel;
    PanelPages: TPanel;
    PanelBottom: TPanel;
    PanelFont: TPanel;
    PageInterface: TTabSheet;
    PageHotkeys: TTabSheet;
    ScrollHotkeys: TScrollBox;
    ScrollInterface: TScrollBox;
    ScrollGeneral: TScrollBox;
    SpinRequestTimeout: TSpinEdit;
    SpinHover: TSpinEdit;
    SpinIdle: TSpinEdit;
    SpinMaxLangPairs: TSpinEdit;
    PageGeneral: TTabSheet;
    SpinMaxHeight: TSpinEdit;
    SpinConnectTimeout: TSpinEdit;
    SpinRealTimeDelay: TSpinEdit;
    SpinProxyPort: TSpinEdit;
    SplitterPages: TSplitter;
    GridHotkeys: TStringGrid;
    PageNetwork: TTabSheet;
    TrackOpacityHover: TTrackBar;
    TrackOpacityIdle: TTrackBar;
    procedure BtnDefaultClick(Sender: TObject);
    procedure BtnDefaultHotkeysClick(Sender: TObject);
    procedure BtnFontPopupClick(Sender: TObject);
    procedure BtnResetPopupClick(Sender: TObject);
    procedure ComboIconFontNameMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer;
      MousePos: TPoint; var Handled: boolean);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnFontClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure ListPagesClick(Sender: TObject);
    procedure ListPagesDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
    procedure GridHotkeysDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure GridHotkeysEditingDone(Sender: TObject);
    procedure GridHotkeysGetCellHint(Sender: TObject; ACol, ARow: integer; var HintText: string);
    procedure GridHotkeysKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure GridHotkeysSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure SettingChange(Sender: TObject);
    procedure SplitterPagesMoved(Sender: TObject);
  private
    FOriginalAutoStart: boolean;
    FOriginalFont: TFont;
    FOriginalFontPopup: TFont;
    FOriginalIconBackgroundColor: TColor;
    FOriginalIconFontColor: TColor;
    FOriginalIconFontName: string;
    FOriginalIconTwoLang: boolean;
    FOriginalMaxLangPairs: integer;
    FOriginalAutoAddLangPairs: boolean;
    FOriginalAllowHotkeys: boolean;
    FOriginalRealTime: boolean;
    FOriginalRealTimeDelay: integer;
    FOriginalAutoSwap: boolean;
    FOriginalSmartSwap: boolean;
    FOriginalSmartHard: boolean;
    FOriginalPrimaryLang: string;
    FOriginalSecondaryLang: string;
    FOriginalEnableMouseMode: boolean;
    FOriginalMouseModeCtrl: boolean;
    FOriginalMouseMode: TMouseMode;
    FOriginalVerticalSplit: boolean;
    FOriginalStayOnTop: boolean;
    FOriginalHideControls: boolean;
    FOriginalAutoHeight: boolean;
    FOriginalMaxHeight: integer;
    FOriginalOpacityHover: integer;
    FOriginalOpacityIdle: integer;
    FOriginalConfigLangDetect: string;
    FOriginalProxy: TProxy;
    FOriginalTimeout: TTimeout;

    FOriginalHotKeyApp: THotKeyData;
    FOriginalHotKeyTransSwap: THotKeyData;
    FOriginalHotKeyTransFromClipboard: THotKeyData;
    FOriginalHotKeyTransClipboard: THotKeyData;
    FOriginalHotKeyTransClipboardPopup: THotKeyData;
    FOriginalHotKeyTransFromControl: THotKeyData;
    FOriginalHotKeyTransControl: THotKeyData;
    FOriginalHotKeyTransControlPopup: THotKeyData;
    FOriginalHotKeyRecent1: THotKeyData;
    FOriginalHotKeyRecent2: THotKeyData;
    FOriginalHotKeyRecent3: THotKeyData;
    FOriginalHotKeyRecent4: THotKeyData;
    FOriginalHotKeyRecent5: THotKeyData;
    FOriginalHotKeyRecent6: THotKeyData;
    FOriginalHotKeyRecent7: THotKeyData;
    FOriginalHotKeyRecent8: THotKeyData;
    FOriginalHotKeyRecent9: THotKeyData;

    FHotKeyApp: THotKeyData;
    FHotKeyTransSwap: THotKeyData;
    FHotKeyTransFromClipboard: THotKeyData;
    FHotKeyTransClipboard: THotKeyData;
    FHotKeyTransClipboardPopup: THotKeyData;
    FHotKeyTransFromControl: THotKeyData;
    FHotKeyTransControl: THotKeyData;
    FHotKeyTransControlPopup: THotKeyData;
    FHotKeyRecent1: THotKeyData;
    FHotKeyRecent2: THotKeyData;
    FHotKeyRecent3: THotKeyData;
    FHotKeyRecent4: THotKeyData;
    FHotKeyRecent5: THotKeyData;
    FHotKeyRecent6: THotKeyData;
    FHotKeyRecent7: THotKeyData;
    FHotKeyRecent8: THotKeyData;
    FHotKeyRecent9: THotKeyData;

    FApplySettings: boolean;
    FOldKeyValue: string;

    procedure SetPanelFont(Panel: TPanel; const AFont: TFont);
    procedure ResetRealTimeSettings;
  public
    procedure Apply;
    procedure ResetHotkeys;
    procedure Reset;
    function GetHotKeyByRow(Row: integer): THotKeyData;
    procedure SetHotKeyByRow(Row: integer; const HK: THotKeyData);
    function GetOriginalHotKey(Row: integer): THotKeyData;
    procedure FillListPages;
    procedure FillGridHotkeys;
    procedure FillMouseMode;
    procedure FillProxyMode;
    procedure SetPopup;
    procedure SetState;

    property ApplySettings: boolean read FApplySettings write FApplySettings;
  end;

var
  formSettingsTrayslate: TformSettingsTrayslate;

const
  HeaderRows: set of byte = [1, 10];
  ColorBevel = $00D9D9D9;
  ColorBevelDark = $00555555;

resourcestring
  rdefaultfont = 'Default';
  rdefaultsettings = 'Are you sure you want to restore default settings?';
  rdefaulthotkeys = 'Are you sure you want to restore default hotkeys?';

  rglobal = 'Global Hotkeys';
  rrecent = 'Recent Language Pairs';

  rapp = 'Toggle Application (Tray Icon Click)';
  rapp_hint = 'Shows or hides the main application window';
  rapp_default = 'Default Ctrl+Shift+A';

  rtransswap = 'Swap Languages (Tray Icon Middle-Click)';
  rtransswap_hint = 'Swaps the source and target languages';
  rtransswap_default = 'Default Ctrl+Shift+S';

  rtransfromclipboard = 'Translate From Clipboard (Tray Icon Double-Click)';
  rtransfromclipboard_hint = 'Translates the current text from the clipboard';
  rtransfromclipboard_default = 'Default Ctrl+Shift+T';

  rtransclipboard = 'Translate Clipboard to Clipboard';
  rtransclipboard_hint = 'Translates the current text in clipboard and copies the result to the clipboard';
  rtransclipboard_default = 'Default Ctrl+Shift+R';

  rtransclipboardpopup = 'Translate Clipboard to Popup Window';
  rtransclipboardpopup_hint = 'Translates clipboard text to a popup window near the mouse cursor';
  rtransclipboardpopup_default = 'Default: Ctrl+Shift+P';

  rtransfromcontrol = 'Translate From Active Application Selection';
  rtransfromcontrol_hint = 'Translates the selected text from the active application';
  rtransfromcontrol_default = 'Default Ctrl+Shift+C';

  rtranscontrol = 'Translate In Active Application Selection';
  rtranscontrol_hint = 'Replaces the selected text in the active application with the translation';
  rtranscontrol_default = 'Default Ctrl+Shift+V';

  rtranscontrolpopup = 'Translate Selected Text to Popup Window';
  rtranscontrolpopup_hint = 'Translates selected text from the active application to a popup window near the mouse cursor';
  rtranscontrolpopup_default = 'Default: Ctrl+Shift+X';

  rrecentpair = 'Recent Language Pair';
  rrecentpair_hint = 'Select Recent Language Pair';
  rrecentpair_default = 'Default: Ctrl+Shift+';

  rmousemodebutton = 'Show Translate Button';
  rmousemodeballon = 'Show Balloon Translation';
  rmousemodepopup = 'Show Popup Translation';
  rmousemodemain = 'Show Main Window';

  rproxymodenoproxy = 'No Proxy';
  rproxymodesystemproxy = 'System Proxy';
  rproxymodecustomproxy = 'Custom Proxy';

implementation

uses mainform, formattool, formpopup, languages, translate;

  {$R *.lfm}

  { TformSettingsTrayslate }

procedure TformSettingsTrayslate.FormCreate(Sender: TObject);
var
  i: integer;
  List: TStringList;
begin
  ApplicationTranslate(language, self, formTrayslate.LoadCustomPoFile(formTrayslate.CustomPoFile));

  PanelPages.BevelColor := ThemeColor(ColorBevel, ColorBevelDark);
  PagesSettings.PageIndex := 0;
  BtnCancel.Cancel := True;
  BtnReset.Enabled := True;
  BtnResetPopup.Enabled := True;
  FApplySettings := False;
  FOldKeyValue := string.Empty;

  ComboLangDetect.Items.Clear;
  ComboLangDetect.Items.Add(string.Empty);
  for i := 0 to formTrayslate.ConfigFiles.Count - 1 do
    ComboLangDetect.Items.Add(formTrayslate.ConfigTitles.Values[formTrayslate.ConfigFiles[i]]);
  ComboLangDetect.ItemIndex := formTrayslate.ConfigFiles.IndexOf(formTrayslate.ConfigLangDetect) + 1;

  List := GetLanguageCodeDisplayPairs(vtLanguage, True);
  try
    ComboPrimaryLang.Items.Assign(List);
    ComboSecondaryLang.Items.Assign(List);
  finally
    List.Free;
  end;

  AddCustomColors(ColorIconBackground);
  AddCustomColors(ColorIconFont);
  FillFontCombo(ComboIconFontName);
  Reset;
  FillListPages;
  FillGridHotkeys;
  FillMouseMode;
  FillProxyMode;
end;

procedure TformSettingsTrayslate.FormResize(Sender: TObject);
begin
  formTrayslate.FormSettingsWidth := Width;
  formTrayslate.FormSettingsHeight := Height;
end;

procedure TformSettingsTrayslate.FormChangeBounds(Sender: TObject);
begin
  formTrayslate.FormSettingsLeft := Left;
  formTrayslate.FormSettingsTop := Top;
end;

procedure TformSettingsTrayslate.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  ResetRealTimeSettings;
end;

procedure TformSettingsTrayslate.FormShow(Sender: TObject);
begin
  formTrayslate.TopMost := False;
end;

procedure TformSettingsTrayslate.BtnFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(PanelFont.Font);
  if FontDialog.Execute then
  begin
    PanelFont.Font.Assign(FontDialog.Font);
    SetPanelFont(PanelFont, FontDialog.Font);

    BtnApply.Enabled := True;
  end;
end;

procedure TformSettingsTrayslate.BtnResetClick(Sender: TObject);
begin
  PanelFont.Font.SetDefault;
  SetPanelFont(PanelFont, PanelFont.Font);
  SettingChange(Self);
end;

procedure TformSettingsTrayslate.BtnFontPopupClick(Sender: TObject);
begin
  FontDialog.Font.Assign(PanelFontPopup.Font);
  if FontDialog.Execute then
  begin
    PanelFontPopup.Font.Assign(FontDialog.Font);
    SetPanelFont(PanelFontPopup, FontDialog.Font);

    BtnApply.Enabled := True;
  end;
end;

procedure TformSettingsTrayslate.BtnResetPopupClick(Sender: TObject);
begin
  PanelFontPopup.Font.SetDefault;
  SetPanelFont(PanelFontPopup, PanelFontPopup.Font);
  SettingChange(Self);
end;

procedure TformSettingsTrayslate.ComboIconFontNameMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
begin
  Handled := True;
end;

procedure TformSettingsTrayslate.ListPagesClick(Sender: TObject);
begin
  // Synchronize PageControl with the selected list item
  if (ListPages.ItemIndex >= 0) and (ListPages.ItemIndex < PagesSettings.PageCount) then
  begin
    PagesSettings.ActivePageIndex := ListPages.ItemIndex;
  end;
end;

procedure TformSettingsTrayslate.ListPagesDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
var
  ListBox: TListBox;
  ImgY: integer;
  TextOffset: integer;
  TextRect: TRect;
  TextStyle: TTextStyle;
begin
  ListBox := Control as TListBox;

  // Draw item background
  ListBox.Canvas.FillRect(ARect);

  TextOffset := 4;

  // Calculate vertical centering for the image
  ImgY := ARect.Top + (ARect.Height - ImagesPages.Height) div 2;

  // Draw image if index is valid
  if (Index >= 0) and (Index < ImagesPages.Count) then
  begin
    ImagesPages.Draw(ListBox.Canvas, ARect.Left + TextOffset, ImgY, Index);
  end;

  // Prepare text rectangle
  TextRect := ARect;
  TextRect.Left := ARect.Left + ImagesPages.Width + (TextOffset * 2);
  TextRect.Right := ARect.Right - TextOffset;

  // Configure text style for LCL (Lazarus)
  TextStyle := ListBox.Canvas.TextStyle;
  TextStyle.Wordbreak := True;
  TextStyle.SingleLine := False;
  TextStyle.Layout := tlCenter; // In LCL use 'Layout' and 'tlCenter' for vertical centering

  // Draw wrapped text
  ListBox.Canvas.Brush.Style := bsClear;
  ListBox.Canvas.TextRect(TextRect, TextRect.Left, TextRect.Top, ListBox.Items[Index], TextStyle);
end;

procedure TformSettingsTrayslate.GridHotkeysDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
var
  Keys: TStringArray;
  KeyText: string;
  KeyRect: TRect;
  X, Y, i, TextW, TextH, BtnW: integer;
  CellColor: TColor;
begin
  // Selected row colors
  if gdSelected in aState then
  begin
    CellColor := clHighlight;
    GridHotkeys.Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    CellColor := (Sender as TStringGrid).Color;
    GridHotkeys.Canvas.Font.Color := clWindowText;
  end;

  // Draw fixed grid header exactly as default
  if gdFixed in aState then
  begin
    GridHotkeys.Canvas.Brush.Color := CellColor;
    GridHotkeys.DefaultDrawCell(aCol, aRow, aRect, aState);
    Exit;
  end;

  // Draw custom section headers
  if aRow in HeaderRows then
  begin
    GridHotkeys.Canvas.Font.Style := [fsBold];
    GridHotkeys.Canvas.Brush.Color := CellColor;
    GridHotkeys.DefaultDrawCell(aCol, aRow, aRect, aState);
    Exit;
  end;

  // Do not custom draw while editing current cell
  if (GridHotkeys.EditorMode and (aCol = GridHotkeys.Col) and (aRow = GridHotkeys.Row)) or
    (GridHotkeys.Cells[aCol, aRow] = string.Empty) then
  begin
    if (aCol = 1) and not (gdSelected in aState) then  GridHotkeys.Canvas.Brush.Color := clWindow;
    GridHotkeys.DefaultDrawCell(aCol, aRow, aRect, aState);
    Exit;
  end;

  GridHotkeys.Canvas.Font.Style := [];

  // Draw normal columns normally
  if aCol <> 1 then
  begin
    GridHotkeys.Canvas.Brush.Color := CellColor;
    GridHotkeys.DefaultDrawCell(aCol, aRow, aRect, aState);
    Exit;
  end;

  // Fill hotkey cell background
  GridHotkeys.Canvas.Brush.Color := CellColor;
  GridHotkeys.Canvas.FillRect(aRect);

  Keys := GridHotkeys.Cells[aCol, aRow].Split(['+']);

  X := aRect.Left + 6;
  Y := aRect.Top + (aRect.Height div 2);

  for i := 0 to High(Keys) do
  begin
    KeyText := Trim(Keys[i]);

    TextW := GridHotkeys.Canvas.TextWidth(KeyText);
    TextH := GridHotkeys.Canvas.TextHeight(KeyText);
    BtnW := TextW + 14;

    KeyRect := Rect(X, Y - (TextH div 2) - 4, X + BtnW, Y + (TextH div 2) + 4);

    // Darker keycaps on selection
    if gdSelected in aState then
    begin
      GridHotkeys.Canvas.Brush.Color := clGray;
      GridHotkeys.Canvas.Pen.Color := clGray;
    end
    else
    begin
      GridHotkeys.Canvas.Brush.Color := clBtnFace;
      GridHotkeys.Canvas.Pen.Color := clSilver;
    end;

    GridHotkeys.Canvas.RoundRect(
      KeyRect.Left,
      KeyRect.Top + 1,
      KeyRect.Right,
      KeyRect.Bottom - 1,
      8,
      8
      );

    // Draw key text
    GridHotkeys.Canvas.Brush.Style := bsClear;
    GridHotkeys.Canvas.TextOut(
      KeyRect.Left + 7,
      KeyRect.Top + 4,
      KeyText
      );
    GridHotkeys.Canvas.Brush.Style := bsSolid;

    X := KeyRect.Right + 5;
  end;
end;

procedure TformSettingsTrayslate.GridHotkeysGetCellHint(Sender: TObject; ACol, ARow: integer; var HintText: string);
begin
  if ACol = 0 then
    HintText := GridHotkeys.Cells[2, ARow]  // hidden hint column
  else
  if ACol = 1 then
    HintText := GridHotkeys.Cells[3, ARow]  // hidden default column
  else
    HintText := string.Empty;
end;

procedure TformSettingsTrayslate.GridHotkeysKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  HK: THotKeyData;
  HasRealKey: boolean;
begin
  // Enter outside editor → start editing column 1
  if (not GridHotkeys.EditorMode) then
  begin
    if (Key in [VK_RETURN, VK_F2]) then
    begin
      GridHotkeys.Col := 1;
      GridHotkeys.EditorMode := True;
      Key := 0;
      Exit;
    end
    else
    if (Key = VK_DELETE) and (Shift = []) then
    begin
      HK.Modifiers := 0;
      HK.Key := 0;

      SetHotKeyByRow(GridHotkeys.Row, HK);
      GridHotkeys.Cells[1, GridHotkeys.Row] := string.Empty;

      BtnApply.Enabled := True;
      Key := 0;
      Exit;
    end
    else
    if not IsSystemKey(Key) then
    begin
      Key := 0;
      Exit;
    end;
  end;

  // Enter inside editor → confirm input
  if (Key = VK_RETURN) and GridHotkeys.EditorMode then
  begin
    GridHotkeys.EditorMode := False;
    Key := 0;
    Exit;
  end;

  // Safety guards
  if (GridHotkeys.Col <> 1) or (not GridHotkeys.EditorMode) then Exit;

  HK := Default(THotKeyData);

  // Escape → restore original + exit editor
  if (Key = VK_ESCAPE) then
  begin
    HK := GetOriginalHotKey(GridHotkeys.Row);
    SetHotKeyByRow(GridHotkeys.Row, HK);

    GridHotkeys.Cells[1, GridHotkeys.Row] := HotKeyToText(HK);

    GridHotkeys.EditorMode := False;

    Key := 0;
    Exit;
  end;

  // Delete clear hotkey
  if (Key = VK_DELETE) and (Shift = []) then
  begin
    HK.Modifiers := 0;
    HK.Key := 0;

    SetHotKeyByRow(GridHotkeys.Row, HK);
    GridHotkeys.Cells[1, GridHotkeys.Row] := string.Empty;

    Key := 0;
    Exit;
  end;

  // Build modifiers
  HK.Modifiers := 0;
  HK.Key := 0;

  if ssCtrl in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_CTRL;

  if ssShift in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_SHIFT;

  if ssAlt in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_ALT;

  if ssMeta in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_META;

  // Detect real key
  HasRealKey := not (Key in [VK_CONTROL, VK_SHIFT, VK_MENU, VK_LWIN, VK_RWIN]);

  if HasRealKey then
  begin
    HK.Key := Key;
    Key := 0;
  end
  else
    HK.Key := 0;

  // Apply hotkey
  SetHotKeyByRow(GridHotkeys.Row, HK);

  GridHotkeys.Cells[1, GridHotkeys.Row] := HotKeyToText(HK);
end;

procedure TformSettingsTrayslate.GridHotkeysSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
begin
  if (ACol = 1) and (ARow in HeaderRows) then
    Editor := nil;

  FOldKeyValue := GridHotkeys.Cells[aCol, aRow];
end;

procedure TformSettingsTrayslate.GridHotkeysEditingDone(Sender: TObject);
var
  HK, OriginalHK: THotKeyData;
begin
  HK := GetHotKeyByRow(GridHotkeys.Row);
  OriginalHK := GetOriginalHotKey(GridHotkeys.Row);
  if (HK.Key = 0) and (HK.Modifiers <> 0) then
  begin
    SetHotKeyByRow(GridHotkeys.Row, OriginalHK);
    GridHotkeys.Cells[1, GridHotkeys.Row] := HotKeyToText(OriginalHK);
  end
  else
  if FOldKeyValue <> GridHotkeys.Cells[1, GridHotkeys.Row] then
    SettingChange(Sender);
end;

procedure TformSettingsTrayslate.SettingChange(Sender: TObject);
begin
  BtnApply.Enabled := True;

  if (Sender is TSpinEdit) then
  begin
    if (Sender as TSpinEdit).Value < 0 then
      (Sender as TSpinEdit).Value := 0;
  end;

  if (Sender = ColorIconBackground) or (Sender = ColorIconFont) or (Sender = ComboIconFontName) or (Sender = CheckTwoLang) then
  begin
    // Apply real time properies
    formTrayslate.IconBackgroundColor := ColorIconBackground.Selected;
    formTrayslate.IconFontColor := ColorIconFont.Selected;
    formTrayslate.IconFontName := ComboIconFontName.Text;
    formTrayslate.IconTwoLang := CheckTwoLang.Checked;
    formTrayslate.SetIcon;
  end
  else
  if Sender = TrackOpacityHover then
  begin
    SpinHover.Value := TrackOpacityHover.Position;
    SetPopup;
  end
  else
  if Sender = TrackOpacityIdle then
  begin
    SpinIdle.Value := TrackOpacityIdle.Position;
    SetPopup;
  end
  else
  if Sender = SpinHover then
  begin
    TrackOpacityHover.Position := SpinHover.Value;
    SetPopup;
  end
  else
  if Sender = SpinIdle then
  begin
    TrackOpacityIdle.Position := SpinIdle.Value;
    SetPopup;
  end
  else
  if Sender = CheckAutoAddLangPairs then
    formTrayslate.aFastAutoAddLangPairs.Checked := CheckAutoAddLangPairs.Checked
  else
  if Sender = CheckAutoSwap then
    formTrayslate.aFastAutoSwap.Checked := CheckAutoSwap.Checked
  else
  if Sender = CheckAllowHotkeys then
  begin
    formTrayslate.aFastAllowHotkeys.Checked := CheckAllowHotkeys.Checked;
    SetState;
  end
  else
  if Sender = CheckEnableMouseMode then
    formTrayslate.aFastEnableMouseMode.Checked := CheckEnableMouseMode.Checked
  else
  if Sender = CheckHideControls then
    formTrayslate.aFastHideControls.Checked := CheckHideControls.Checked
  else
  if Sender = CheckMouseModeCtrl then
    formTrayslate.aFastMouseModeCtrl.Checked := CheckMouseModeCtrl.Checked
  else
  if Sender = CheckRealTime then
    formTrayslate.aFastRealTime.Checked := CheckRealTime.Checked
  else
  if Sender = CheckVerticalSplit then
    formTrayslate.aFastVerticalSplit.Checked := CheckVerticalSplit.Checked
  else
  if Sender = CheckProxyAuthentication then
    SetState
  else
  if Sender = ComboProxyMode then
    SetState;
end;

procedure TformSettingsTrayslate.SplitterPagesMoved(Sender: TObject);
begin
  formTrayslate.FormSettingsSplit := ListPages.Width;
end;

procedure TformSettingsTrayslate.BtnDefaultClick(Sender: TObject);
begin
  if MessageDlg(rdefaultsettings, mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;

  formTrayslate.SetDefaultSettings;
  Reset;

  PanelFont.Font.SetDefault;
  SetPanelFont(PanelFont, PanelFont.Font);
  PanelFontPopup.Font.SetDefault;
  SetPanelFont(PanelFontPopup, PanelFontPopup.Font);
  FillGridHotkeys;

  Apply;
end;

procedure TformSettingsTrayslate.BtnDefaultHotkeysClick(Sender: TObject);
begin
  if MessageDlg(rdefaulthotkeys, mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;

  formTrayslate.SetDefaultHotKeys;
  ResetHotkeys;

  FillGridHotkeys;
end;

procedure TformSettingsTrayslate.BtnOkClick(Sender: TObject);
begin
  Apply;
  ModalResult := mrOk;
end;

procedure TformSettingsTrayslate.BtnCancelClick(Sender: TObject);
begin
  ResetRealTimeSettings;
  Reset;
  ModalResult := mrCancel;
end;

procedure TformSettingsTrayslate.BtnApplyClick(Sender: TObject);
begin
  Apply;

  formTrayslate.UnregisterHotKeys;
  formTrayslate.MouseHook.Enabled := False;
  formTrayslate.KeyHook.Enabled := False;
end;

procedure TformSettingsTrayslate.SetPanelFont(Panel: TPanel; const AFont: TFont);
begin
  Panel.Caption := ifthen((Trim(AFont.Name) = string.Empty) or (LowerCase(AFont.Name) = 'default'), rdefaultfont, AFont.Name) +
    ',' + IntToStr(AFont.Size);
end;

procedure TformSettingsTrayslate.ResetRealTimeSettings;
begin
  formTrayslate.IconBackgroundColor := FOriginalIconBackgroundColor;
  formTrayslate.IconFontColor := FOriginalIconFontColor;
  formTrayslate.IconFontName := FOriginalIconFontName;
  formTrayslate.IconTwoLang := FOriginalIconTwoLang;
  formTrayslate.SetIcon;

  formTrayslate.OpacityHover := FOriginalOpacityHover;
  formTrayslate.OpacityIdle := FOriginalOpacityIdle;
end;

function TformSettingsTrayslate.GetHotKeyByRow(Row: integer): THotKeyData;
begin
  case Row of
    2: Result := FHotKeyApp;
    3: Result := FHotKeyTransSwap;
    4: Result := FHotKeyTransFromClipboard;
    5: Result := FHotKeyTransClipboard;
    6: Result := FHotKeyTransClipboardPopup;
    7: Result := FHotKeyTransFromControl;
    8: Result := FHotKeyTransControl;
    9: Result := FHotKeyTransControlPopup;
    11: Result := FHotKeyRecent1;
    12: Result := FHotKeyRecent2;
    13: Result := FHotKeyRecent3;
    14: Result := FHotKeyRecent4;
    15: Result := FHotKeyRecent5;
    16: Result := FHotKeyRecent6;
    17: Result := FHotKeyRecent7;
    18: Result := FHotKeyRecent8;
    19: Result := FHotKeyRecent9;
    else
      Result := Default(THotKeyData);
  end;
end;

procedure TformSettingsTrayslate.SetHotKeyByRow(Row: integer; const HK: THotKeyData);
begin
  case Row of
    2: FHotKeyApp := HK;
    3: FHotKeyTransSwap := HK;
    4: FHotKeyTransFromClipboard := HK;
    5: FHotKeyTransClipboard := HK;
    6: FHotKeyTransClipboardPopup := HK;
    7: FHotKeyTransFromControl := HK;
    8: FHotKeyTransControl := HK;
    9: FHotKeyTransControlPopup := HK;
    11: FHotKeyRecent1 := HK;
    12: FHotKeyRecent2 := HK;
    13: FHotKeyRecent3 := HK;
    14: FHotKeyRecent4 := HK;
    15: FHotKeyRecent5 := HK;
    16: FHotKeyRecent6 := HK;
    17: FHotKeyRecent7 := HK;
    18: FHotKeyRecent8 := HK;
    19: FHotKeyRecent9 := HK;
    else
      ;
  end;
end;

function TformSettingsTrayslate.GetOriginalHotKey(Row: integer): THotKeyData;
begin
  case Row of
    2: Result := FOriginalHotKeyApp;
    3: Result := FOriginalHotKeyTransSwap;
    4: Result := FOriginalHotKeyTransFromClipboard;
    5: Result := FOriginalHotKeyTransClipboard;
    6: Result := FOriginalHotKeyTransClipboardPopup;
    7: Result := FOriginalHotKeyTransFromControl;
    8: Result := FOriginalHotKeyTransControl;
    9: Result := FOriginalHotKeyTransControlPopup;
    11: Result := FOriginalHotKeyRecent1;
    12: Result := FOriginalHotKeyRecent2;
    13: Result := FOriginalHotKeyRecent3;
    14: Result := FOriginalHotKeyRecent4;
    15: Result := FOriginalHotKeyRecent5;
    16: Result := FOriginalHotKeyRecent6;
    17: Result := FOriginalHotKeyRecent7;
    18: Result := FOriginalHotKeyRecent8;
    19: Result := FOriginalHotKeyRecent9;
    else
      Result := Default(THotKeyData);
  end;
end;

procedure TformSettingsTrayslate.FillListPages;
var
  i: integer;
begin
  if PagesSettings.ShowTabs then
    PagesSettings.ShowTabs := False;
  ListPages.Clear;
  for i := 0 to PagesSettings.PageCount - 1 do
    ListPages.Items.Add(PagesSettings.Pages[i].Caption);
  ListPages.ItemIndex := PagesSettings.PageIndex;
end;

procedure TformSettingsTrayslate.FillGridHotkeys;
var
  SavedRow: integer;
begin
  // Save current position
  SavedRow := GridHotkeys.Row;

  // Clear grid
  while GridHotkeys.RowCount > GridHotkeys.FixedRows do
    GridHotkeys.DeleteRow(GridHotkeys.RowCount - 1);

  GridHotkeys.InsertRowWithValues(1, [rglobal]);
  GridHotkeys.InsertRowWithValues(2, [rapp, HotKeyToText(FHotKeyApp), rapp_hint, rapp_default]);
  GridHotkeys.InsertRowWithValues(3, [rtransswap, HotKeyToText(FHotKeyTransSwap), rtransswap_hint, rtransswap_default]);
  GridHotkeys.InsertRowWithValues(4, [rtransfromclipboard, HotKeyToText(FHotKeyTransFromClipboard),
    rtransfromclipboard_hint, rtransfromclipboard_default]);
  GridHotkeys.InsertRowWithValues(5, [rtransclipboard, HotKeyToText(FHotKeyTransClipboard), rtransclipboard_hint,
    rtransclipboard_default]);
  GridHotkeys.InsertRowWithValues(6, [rtransclipboardpopup, HotKeyToText(FHotKeyTransClipboardPopup),
    rtransclipboardpopup_hint, rtransclipboardpopup_default]);
  GridHotkeys.InsertRowWithValues(7, [rtransfromcontrol, HotKeyToText(FHotKeyTransFromControl),
    rtransfromcontrol_hint, rtransfromcontrol_default]);
  GridHotkeys.InsertRowWithValues(8, [rtranscontrol, HotKeyToText(FHotKeyTransControl), rtranscontrol_hint, rtranscontrol_default]);
  GridHotkeys.InsertRowWithValues(9, [rtranscontrolpopup, HotKeyToText(FHotKeyTransControlPopup),
    rtranscontrolpopup_hint, rtranscontrolpopup_default]);
  GridHotkeys.InsertRowWithValues(10, [rrecent]);
  GridHotkeys.InsertRowWithValues(11, [rrecentpair + ' 1', HotKeyToText(FHotKeyRecent1), rrecentpair_hint +
    ' 1', rrecentpair_default + '1']);
  GridHotkeys.InsertRowWithValues(12, [rrecentpair + ' 2', HotKeyToText(FHotKeyRecent2), rrecentpair_hint +
    ' 2', rrecentpair_default + '2']);
  GridHotkeys.InsertRowWithValues(13, [rrecentpair + ' 3', HotKeyToText(FHotKeyRecent3), rrecentpair_hint +
    ' 3', rrecentpair_default + '3']);
  GridHotkeys.InsertRowWithValues(14, [rrecentpair + ' 4', HotKeyToText(FHotKeyRecent4), rrecentpair_hint +
    ' 4', rrecentpair_default + '4']);
  GridHotkeys.InsertRowWithValues(15, [rrecentpair + ' 5', HotKeyToText(FHotKeyRecent5), rrecentpair_hint +
    ' 5', rrecentpair_default + '5']);
  GridHotkeys.InsertRowWithValues(16, [rrecentpair + ' 6', HotKeyToText(FHotKeyRecent6), rrecentpair_hint +
    ' 6', rrecentpair_default + '6']);
  GridHotkeys.InsertRowWithValues(17, [rrecentpair + ' 7', HotKeyToText(FHotKeyRecent7), rrecentpair_hint +
    ' 7', rrecentpair_default + '7']);
  GridHotkeys.InsertRowWithValues(18, [rrecentpair + ' 8', HotKeyToText(FHotKeyRecent8), rrecentpair_hint +
    ' 8', rrecentpair_default + '8']);
  GridHotkeys.InsertRowWithValues(19, [rrecentpair + ' 9', HotKeyToText(FHotKeyRecent9), rrecentpair_hint +
    ' 9', rrecentpair_default + '9']);

  // Restore safely
  if SavedRow < GridHotkeys.RowCount then
    GridHotkeys.Row := SavedRow
  else
    GridHotkeys.Row := GridHotkeys.FixedRows;
end;

procedure TformSettingsTrayslate.FillMouseMode;
var
  SavedIndex: integer;
begin
  // Save current selection
  SavedIndex := ComboMouseMode.ItemIndex;

  ComboMouseMode.Items.Clear;

  ComboMouseMode.Items.Add(rmousemodebutton);
  ComboMouseMode.Items.Add(rmousemodeballon);
  ComboMouseMode.Items.Add(rmousemodepopup);
  ComboMouseMode.Items.Add(rmousemodemain);

  // Restore selection safely
  if (SavedIndex >= 0) and (SavedIndex < ComboMouseMode.Items.Count) then
    ComboMouseMode.ItemIndex := SavedIndex
  else
    ComboMouseMode.ItemIndex := Ord(formTrayslate.MouseMode);
end;

procedure TformSettingsTrayslate.FillProxyMode;
var
  SavedIndex: integer;
begin
  // Save current selection
  SavedIndex := ComboProxyMode.ItemIndex;

  ComboProxyMode.Items.Clear;

  ComboProxyMode.Items.Add(rproxymodenoproxy);
  ComboProxyMode.Items.Add(rproxymodesystemproxy);
  ComboProxyMode.Items.Add(rproxymodecustomproxy);

  // Restore selection safely
  if (SavedIndex >= 0) and (SavedIndex < ComboProxyMode.Items.Count) then
    ComboProxyMode.ItemIndex := SavedIndex
  else
    ComboProxyMode.ItemIndex := Ord(formTrayslate.Proxy.ProxyMode);
end;

procedure TformSettingsTrayslate.SetPopup;
begin
  if Assigned(formPopupTrayslate) then
  begin
    formTrayslate.OpacityHover := TrackOpacityHover.Position;
    formTrayslate.OpacityIdle := TrackOpacityIdle.Position;
  end;
end;

procedure TformSettingsTrayslate.SetState;
begin
  GridHotkeys.Enabled := CheckAllowHotkeys.Checked;
  GridHotkeys.Color := ifthen(GridHotkeys.Enabled, clWindow, clBtnFace);

  ComboProxyType.Enabled := ComboProxyMode.ItemIndex > 1;
  EditProxyHost.Enabled := ComboProxyMode.ItemIndex > 1;
  SpinProxyPort.Enabled := ComboProxyMode.ItemIndex > 1;
  CheckProxyAuthentication.Enabled := ComboProxyMode.ItemIndex > 1;
  EditProxyLogin.Enabled := CheckProxyAuthentication.Checked and (ComboProxyMode.ItemIndex > 1);
  EditProxyPassword.Enabled := CheckProxyAuthentication.Checked and (ComboProxyMode.ItemIndex > 1);
end;

procedure TformSettingsTrayslate.Apply;
var
  T: TTimeout;
  P: TProxy;
begin
  FApplySettings := True;
  try
    formTrayslate.AutoStart := CheckAutostart.Checked;
    formTrayslate.MaxLangPairs := SpinMaxLangPairs.Value;
    formTrayslate.AutoAddLangPairs := CheckAutoAddLangPairs.Checked;
    formTrayslate.AllowHotKeys := CheckAllowHotkeys.Checked;
    formTrayslate.RealTime := CheckRealTime.Checked;
    formTrayslate.RealTimeDelay := SpinRealTimeDelay.Value;
    formTrayslate.AutoSwap := CheckAutoSwap.Checked;
    formTrayslate.SmartSwap := CheckSmartSwap.Checked;
    formTrayslate.SmartHard := CheckSmartHard.Checked;
    formTrayslate.PrimaryLang := ExtractCodeFromItem(ComboPrimaryLang.Text);
    formTrayslate.SecondaryLang := ExtractCodeFromItem(ComboSecondaryLang.Text);
    formTrayslate.EnableMouseMode := CheckEnableMouseMode.Checked;
    formTrayslate.MouseModeCtrl := CheckMouseModeCtrl.Checked;
    formTrayslate.MouseMode := TMouseMode(ComboMouseMode.ItemIndex);
    formTrayslate.VerticalSplit := CheckVerticalSplit.Checked;
    formTrayslate.StayOnTop := CheckStayOnTop.Checked;
    formTrayslate.HideControls := CheckHideControls.Checked;
    formTrayslate.AutoHeight := CheckAutoHeight.Checked;
    formTrayslate.MaxHeight := SpinMaxHeight.Value;
    formTrayslate.OpacityHover := TrackOpacityHover.Position;
    formTrayslate.OpacityIdle := TrackOpacityIdle.Position;
    if ComboLangDetect.ItemIndex > 0 then
      formTrayslate.ConfigLangDetect := formTrayslate.ConfigFiles[ComboLangDetect.ItemIndex - 1]
    else
      formTrayslate.ConfigLangDetect := string.Empty;
    T := formTrayslate.Timeout;
    T.Connection := SpinConnectTimeout.Value * 1000;
    T.Request := SpinRequestTimeout.Value * 1000;
    formTrayslate.Timeout := T;
    P := formTrayslate.Proxy;
    P.ProxyMode := TProxyMode(ComboProxyMode.ItemIndex);
    P.ProxyType := TProxyType(ComboProxyType.ItemIndex);
    P.Host := EditProxyHost.Text;
    P.Port := SpinProxyPort.Value.ToString;
    P.Authentication := CheckProxyAuthentication.Checked;
    P.Login := EditProxyLogin.Text;
    P.Password := EditProxyPassword.Text;
    formTrayslate.Proxy := P;

    formTrayslate.Font.Assign(PanelFont.Font);
    formTrayslate.FontPopup.Assign(PanelFontPopup.Font);
    formTrayslate.IconBackgroundColor := ColorIconBackground.Selected;
    formTrayslate.IconFontColor := ColorIconFont.Selected;
    formTrayslate.IconFontName := ComboIconFontName.Text;
    formTrayslate.IconTwoLang := CheckTwoLang.Checked;
    formTrayslate.SetIcon;

    formTrayslate.HotKeyApp := FHotKeyApp;
    formTrayslate.HotKeyTransSwap := FHotKeyTransSwap;
    formTrayslate.HotKeyTransFromClipboard := FHotKeyTransFromClipboard;
    formTrayslate.HotKeyTransClipboard := FHotKeyTransClipboard;
    formTrayslate.HotKeyTransClipboardPopup := FHotKeyTransClipboardPopup;
    formTrayslate.HotKeyTransFromControl := FHotKeyTransFromControl;
    formTrayslate.HotKeyTransControl := FHotKeyTransControl;
    formTrayslate.HotKeyTransControlPopup := FHotKeyTransControlPopup;
    formTrayslate.HotKeyRecent1 := FHotKeyRecent1;
    formTrayslate.HotKeyRecent2 := FHotKeyRecent2;
    formTrayslate.HotKeyRecent3 := FHotKeyRecent3;
    formTrayslate.HotKeyRecent4 := FHotKeyRecent4;
    formTrayslate.HotKeyRecent5 := FHotKeyRecent5;
    formTrayslate.HotKeyRecent6 := FHotKeyRecent6;
    formTrayslate.HotKeyRecent7 := FHotKeyRecent7;
    formTrayslate.HotKeyRecent8 := FHotKeyRecent8;
    formTrayslate.HotKeyRecent9 := FHotKeyRecent9;

    formTrayslate.ComboSource.SelLength := 0;
    formTrayslate.ComboTarget.SelLength := 0;

    if Assigned(formPopupTrayslate) then
    begin
      formPopupTrayslate.Font.Assign(PanelFontPopup.Font);
      formPopupTrayslate.PanelWatermark.Font.Size := PanelFontPopup.Font.Size;
      formPopupTrayslate.PanelWatermark.Font.Name := PanelFontPopup.Font.Name;
    end;

    Reset;
    formTrayslate.TimerTranslate.Interval := Max(formTrayslate.RealTimeDelay, 1);
    formTrayslate.LoadConfig;
    formTrayslate.DoRealign(0);
    Application.QueueAsyncCall(@formTrayslate.RebuildLangPairsPanel, 0);
  finally
    FApplySettings := False;
  end;
end;

procedure TformSettingsTrayslate.ResetHotkeys;
begin
  FOriginalHotKeyApp := formTrayslate.HotKeyApp;
  FOriginalHotKeyTransSwap := formTrayslate.HotKeyTransSwap;
  FOriginalHotKeyTransFromClipboard := formTrayslate.HotKeyTransFromClipboard;
  FOriginalHotKeyTransClipboard := formTrayslate.HotKeyTransClipboard;
  FOriginalHotKeyTransClipboardPopup := formTrayslate.HotKeyTransClipboardPopup;
  FOriginalHotKeyTransFromControl := formTrayslate.HotKeyTransFromControl;
  FOriginalHotKeyTransControl := formTrayslate.HotKeyTransControl;
  FOriginalHotKeyTransControlPopup := formTrayslate.HotKeyTransControlPopup;
  FOriginalHotKeyRecent1 := formTrayslate.HotKeyRecent1;
  FOriginalHotKeyRecent2 := formTrayslate.HotKeyRecent2;
  FOriginalHotKeyRecent3 := formTrayslate.HotKeyRecent3;
  FOriginalHotKeyRecent4 := formTrayslate.HotKeyRecent4;
  FOriginalHotKeyRecent5 := formTrayslate.HotKeyRecent5;
  FOriginalHotKeyRecent6 := formTrayslate.HotKeyRecent6;
  FOriginalHotKeyRecent7 := formTrayslate.HotKeyRecent7;
  FOriginalHotKeyRecent8 := formTrayslate.HotKeyRecent8;
  FOriginalHotKeyRecent9 := formTrayslate.HotKeyRecent9;
  FHotKeyApp := formTrayslate.HotKeyApp;
  FHotKeyTransSwap := formTrayslate.HotKeyTransSwap;
  FHotKeyTransFromClipboard := formTrayslate.HotKeyTransFromClipboard;
  FHotKeyTransClipboard := formTrayslate.HotKeyTransClipboard;
  FHotKeyTransClipboardPopup := formTrayslate.HotKeyTransClipboardPopup;
  FHotKeyTransFromControl := formTrayslate.HotKeyTransFromControl;
  FHotKeyTransControl := formTrayslate.HotKeyTransControl;
  FHotKeyTransControlPopup := formTrayslate.HotKeyTransControlPopup;
  FHotKeyRecent1 := formTrayslate.HotKeyRecent1;
  FHotKeyRecent2 := formTrayslate.HotKeyRecent2;
  FHotKeyRecent3 := formTrayslate.HotKeyRecent3;
  FHotKeyRecent4 := formTrayslate.HotKeyRecent4;
  FHotKeyRecent5 := formTrayslate.HotKeyRecent5;
  FHotKeyRecent6 := formTrayslate.HotKeyRecent6;
  FHotKeyRecent7 := formTrayslate.HotKeyRecent7;
  FHotKeyRecent8 := formTrayslate.HotKeyRecent8;
  FHotKeyRecent9 := formTrayslate.HotKeyRecent9;
end;

procedure TformSettingsTrayslate.Reset;
begin
  FOriginalAutoStart := formTrayslate.AutoStart;
  FOriginalMaxLangPairs := formTrayslate.MaxLangPairs;
  FOriginalAutoAddLangPairs := formTrayslate.AutoAddLangPairs;
  FOriginalAllowHotkeys := formTrayslate.AllowHotKeys;
  FOriginalRealTime := formTrayslate.RealTime;
  FOriginalRealTimeDelay := formTrayslate.RealTimeDelay;
  FOriginalAutoSwap := formTrayslate.AutoSwap;
  FOriginalSmartSwap := formTrayslate.SmartSwap;
  FOriginalSmartHard := formTrayslate.SmartHard;
  FOriginalPrimaryLang := formTrayslate.PrimaryLang;
  FOriginalSecondaryLang := formTrayslate.SecondaryLang;
  FOriginalEnableMouseMode := formTrayslate.EnableMouseMode;
  FOriginalMouseModeCtrl := formTrayslate.MouseModeCtrl;
  FOriginalMouseMode := formTrayslate.MouseMode;
  FOriginalVerticalSplit := formTrayslate.VerticalSplit;
  FOriginalStayOnTop := formTrayslate.StayOnTop;
  FOriginalHideControls := formTrayslate.HideControls;
  FOriginalAutoHeight := formTrayslate.AutoHeight;
  FOriginalMaxHeight := formTrayslate.MaxHeight;
  FOriginalOpacityHover := formTrayslate.OpacityHover;
  FOriginalOpacityIdle := formTrayslate.OpacityIdle;
  FOriginalConfigLangDetect := formTrayslate.ConfigLangDetect;
  FOriginalProxy := formTrayslate.Proxy;
  FOriginalTimeout := formTrayslate.Timeout;
  FOriginalFont := formTrayslate.Font;
  FOriginalFontPopup := formTrayslate.FontPopup;
  FOriginalIconBackgroundColor := formTrayslate.IconBackgroundColor;
  FOriginalIconFontColor := formTrayslate.IconFontColor;
  FOriginalIconFontName := formTrayslate.IconFontName;
  FOriginalIconTwoLang := formTrayslate.IconTwoLang;

  ResetHotKeys;

  CheckAutostart.Checked := FOriginalAutoStart;
  SpinMaxLangPairs.Value := FOriginalMaxLangPairs;
  CheckAutoAddLangPairs.Checked := FOriginalAutoAddLangPairs;
  CheckAllowHotkeys.Checked := FOriginalAllowHotkeys;
  CheckRealTime.Checked := FOriginalRealTime;
  SpinRealTimeDelay.Value := FOriginalRealTimeDelay;
  CheckAutoSwap.Checked := FOriginalAutoSwap;
  CheckSmartSwap.Checked := FOriginalSmartSwap;
  CheckSmartHard.Checked := FOriginalSmartHard;
  ComboPrimaryLang.ItemIndex := FindIndexByCode(ComboPrimaryLang.Items, FOriginalPrimaryLang);
  ComboSecondaryLang.ItemIndex := FindIndexByCode(ComboSecondaryLang.Items, FOriginalSecondaryLang);
  CheckEnableMouseMode.Checked := FOriginalEnableMouseMode;
  CheckMouseModeCtrl.Checked := FOriginalMouseModeCtrl;
  ComboMouseMode.ItemIndex := Ord(FOriginalMouseMode);
  CheckVerticalSplit.Checked := FOriginalVerticalSplit;
  CheckStayOnTop.Checked := FOriginalStayOnTop;
  CheckHideControls.Checked := FOriginalHideControls;
  CheckAutoHeight.Checked := FOriginalAutoHeight;
  SpinMaxHeight.Value := FOriginalMaxHeight;
  TrackOpacityHover.Position := FOriginalOpacityHover;
  TrackOpacityIdle.Position := FOriginalOpacityIdle;
  if FOriginalConfigLangDetect <> string.Empty then
    ComboLangDetect.ItemIndex := Max(formTrayslate.ConfigFiles.IndexOf(FOriginalConfigLangDetect) + 1, 0)
  else
    ComboLangDetect.ItemIndex := 0;
  SpinConnectTimeout.Value := FOriginalTimeout.Connection div 1000;
  SpinRequestTimeout.Value := FOriginalTimeout.Request div 1000;
  ComboProxyMode.ItemIndex := Ord(FOriginalProxy.ProxyMode);
  ComboProxyType.ItemIndex := Ord(FOriginalProxy.ProxyType);
  EditProxyHost.Text := FOriginalProxy.Host;
  SpinProxyPort.Value := StrToIntDef(FOriginalProxy.Port, 0);
  CheckProxyAuthentication.Checked := FOriginalProxy.Authentication;
  EditProxyLogin.Text := FOriginalProxy.Login;
  EditProxyPassword.Text := FOriginalProxy.Password;

  PanelFont.Font.Assign(FOriginalFont);
  SetPanelFont(PanelFont, FOriginalFont);
  PanelFontPopup.Font.Assign(FOriginalFontPopup);
  SetPanelFont(PanelFontPopup, FOriginalFontPopup);
  ColorIconBackground.Selected := FOriginalIconBackgroundColor;
  ColorIconFont.Selected := FOriginalIconFontColor;
  ComboIconFontName.Text := FOriginalIconFontName;
  CheckTwoLang.Checked := FOriginalIconTwoLang;

  BtnApply.Enabled := False;
  SetState;
end;

end.
