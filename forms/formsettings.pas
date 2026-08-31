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
  Clipbrd,
  Themes,
  Spin,
  Math,
  Grids,
  ValEdit,
  CheckLst,
  LCLType,
  LCLIntf,
  Consts,
  hotkeyhelper,
  stringhelper,
  network;

type

  { TformSettingsTrayslate }

  TformSettingsTrayslate = class(TForm)
    {%Region -fold Form Common}
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
    CheckAutoHidePopup: TCheckBox;
    CheckInsertKey: TCheckBox;
    CheckAutoHeight: TCheckBox;
    CheckBuiltInDetect: TCheckBox;
    CheckCircularIcon: TCheckBox;
    CheckSpellCheck: TCheckBox;
    CheckSpellCheckEmptySuggestions: TCheckBox;
    ClbProxiedConfigs: TCheckListBox;
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
    CheckAutoCopy: TCheckBox;
    ClbEnabledLang: TCheckListBox;
    ColorIconBackground: TColorBox;
    ColorMouseModeFrame: TColorBox;
    ColorIconFont: TColorBox;
    ColorDialog: TColorDialog;
    ComboAppLang: TComboBox;
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
    GroupAppLang: TGroupBox;
    GroupEnabledLang: TGroupBox;
    GroupSpellCheck: TGroupBox;
    GroupProxiedConfigs: TGroupBox;
    GroupUserParameters: TGroupBox;
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
    LabelInstalledLang: TLabel;
    LabelAppLang: TLabel;
    LabelMouseModeFrame: TLabel;
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
    ScrollNetwork: TScrollBox;
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
    PageParameters: TTabSheet;
    PageLanguages: TTabSheet;
    TrackOpacityHover: TTrackBar;
    TrackOpacityIdle: TTrackBar;
    ValueListUserParameters: TValueListEditor;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ScreenActiveControlChanged(Sender: TObject);
    procedure SettingChange(Sender: TObject);
    procedure ListPagesClick(Sender: TObject);
    procedure PageHotkeysHide(Sender: TObject);
    procedure PageHotkeysShow(Sender: TObject);
    procedure EditProxyHostKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnFontClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure BtnDefaultClick(Sender: TObject);
    procedure BtnDefaultHotkeysClick(Sender: TObject);
    procedure BtnFontPopupClick(Sender: TObject);
    procedure BtnResetPopupClick(Sender: TObject);
    procedure ValueListUserParametersColRowDeleted(Sender: TObject; IsColumn: boolean; sIndex, tIndex: integer);
    procedure ValueListUserParametersColRowInserted(Sender: TObject; IsColumn: boolean; sIndex, tIndex: integer);
    procedure ValueListUserParametersKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ValueListUserParametersKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ValueListUserParametersSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure GridHotkeysDrawCell(Sender: TObject; aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure GridHotkeysEditingDone(Sender: TObject);
    procedure GridHotkeysGetCellHint(Sender: TObject; ACol, ARow: integer; var HintText: string);
    procedure GridHotkeysKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure GridHotkeysSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
    procedure SplitterPagesMoved(Sender: TObject);
    procedure LabelInstalledLangClick(Sender: TObject);
    procedure ClbProxiedConfigsMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer;
      MousePos: TPoint; var Handled: boolean);
    procedure ComboMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
    procedure GridHotkeysMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
    procedure ClbEnabledLangKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ListPagesDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
    procedure ClbEnabledLangDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
    procedure ClbProxiedConfigsDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
    {%EndRegion}
  private
    FOriginalAutoStart: boolean;
    FOriginalFont: TFont;
    FOriginalFontPopup: TFont;
    FOriginalIconBackgroundColor: TColor;
    FOriginalIconMouseModeFrameColor: TColor;
    FOriginalIconFontColor: TColor;
    FOriginalIconFontName: string;
    FOriginalIconTwoLang: boolean;
    FOriginalIconCircular: boolean;
    FOriginalMaxLangPairs: integer;
    FOriginalAutoAddLangPairs: boolean;
    FOriginalAllowHotkeys: boolean;
    FOriginalRealTime: boolean;
    FOriginalRealTimeDelay: integer;
    FOriginalAutoSwap: boolean;
    FOriginalBuiltInDetect: boolean;
    FOriginalSmartSwap: boolean;
    FOriginalSmartHard: boolean;
    FOriginalPrimaryLang: string;
    FOriginalSecondaryLang: string;
    FOriginalEnableMouseMode: boolean;
    FOriginalMouseModeCtrl: boolean;
    FOriginalMouseMode: TMouseMode;
    FOriginalInsertKey: boolean;
    FOriginalSpellCheck: boolean;
    FOriginalSpellCheckEmptySuggestions: boolean;
    FOriginalVerticalSplit: boolean;
    FOriginalAutocopy: boolean;
    FOriginalStayOnTop: boolean;
    FOriginalAutoHidePopup: boolean;
    FOriginalHideControls: boolean;
    FOriginalAutoHeight: boolean;
    FOriginalMaxHeight: integer;
    FOriginalOpacityHover: integer;
    FOriginalOpacityIdle: integer;
    FOriginalConfigLangDetect: string;
    FOriginalProxy: TProxy;
    FOriginalTimeout: TTimeout;
    FOriginalUserParameters: TStringList;
    FOriginalProxiedConfigs: TStringList;
    FOriginalLanguage: string;
    FOriginalEnabledLanguages: TStringList;

    FOriginalHotKeyApp: THotKeyData;
    FOriginalHotKeyTransSwap: THotKeyData;
    FOriginalHotKeyTransFromClipboard: THotKeyData;
    FOriginalHotKeyTransClipboard: THotKeyData;
    FOriginalHotKeyTransClipboardPopup: THotKeyData;
    FOriginalHotKeyTransFromControl: THotKeyData;
    FOriginalHotKeyTransControl: THotKeyData;
    FOriginalHotKeyTransControlPopup: THotKeyData;
    FOriginalHotKeyFastAllowHotKeys: THotKeyData;
    FOriginalHotKeyFastEnableMouseMode: THotKeyData;
    FOriginalHotKeyFastMouseModeCtrl: THotKeyData;
    FOriginalHotKeyFastAutoSwap: THotKeyData;
    FOriginalHotKeyFastAutoAddLangPairs: THotKeyData;
    FOriginalHotKeyFastRealTime: THotKeyData;
    FOriginalHotKeyFastAutoCopy: THotKeyData;
    FOriginalHotKeyFastSpellCheck: THotKeyData;
    FOriginalHotKeyFastVerticalSplit: THotKeyData;
    FOriginalHotKeyFastAutoHeight: THotKeyData;
    FOriginalHotKeyFastAutoHidePopup: THotKeyData;
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
    FHotKeyFastAllowHotKeys: THotKeyData;
    FHotKeyFastEnableMouseMode: THotKeyData;
    FHotKeyFastMouseModeCtrl: THotKeyData;
    FHotKeyFastAutoSwap: THotKeyData;
    FHotKeyFastAutoAddLangPairs: THotKeyData;
    FHotKeyFastRealTime: THotKeyData;
    FHotKeyFastAutoCopy: THotKeyData;
    FHotKeyFastSpellCheck: THotKeyData;
    FHotKeyFastVerticalSplit: THotKeyData;
    FHotKeyFastAutoHeight: THotKeyData;
    FHotKeyFastAutoHidePopup: THotKeyData;
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
    FOldValueList: string;
    FLastFocused: TWinControl;

    procedure SetPanelFont(Panel: TPanel; const AFont: TFont);
    procedure ResetRealTimeSettings;
  public
    procedure Apply;
    procedure ResetHotkeys;
    procedure Reset;
    function GetHotKeyByRow(Row: integer): THotKeyData;
    procedure SetHotKeyByRow(Row: integer; const HK: THotKeyData);
    function GetOriginalHotKey(Row: integer): THotKeyData;
    function GetLanguage: string;
    procedure FillLanguage(ALangCode: string);
    procedure FillListPages;
    procedure FillGridHotkeys;
    procedure FillUserParameters;
    procedure FillMouseMode;
    procedure FillProxyMode;
    procedure FillLanguages;
    procedure FillConfigs;
    procedure SetPopup;
    procedure SetState;

    property ApplySettings: boolean read FApplySettings write FApplySettings;
  end;

var
  formSettingsTrayslate: TformSettingsTrayslate;

const
  HeaderRows: set of byte = [1, 10, 22];
  ColorBevel = $00D9D9D9;
  ColorBevelDark = $00555555;

  {%Region -fold Resource Strings}

resourcestring
  rdefaultfont = 'Default';
  rdefaultsettings = 'Are you sure you want to restore default settings?';
  rdefaulthotkeys = 'Are you sure you want to restore default hotkeys?';

  rglobal = 'Translate';
  rfast = 'Quick settings';
  rrecent = 'Recent Language Pairs';

  ron = 'On';
  roff = 'Off';

  rapp = 'Toggle Application (Tray Icon Click)';
  rapp_hint = 'Shows or hides the main application window';
  rapp_default = 'Default Ctrl+Shift+A';

  // HotKeys Common
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

  // HotKeys Fast Settings
  rfastallowhotkeys = 'Enable Global Hotkeys';
  rfastallowhotkeys_hint = 'Enable or disable all global hotkeys';
  rfastallowhotkeys_default = 'Shift+F1';

  rfastenablemousemode = 'Enable Mouse Mode';
  rfastenablemousemode_hint = 'Toggle mouse translation mode';
  rfastenablemousemode_default = 'Shift+F2';

  rfastmousemodectrl = 'Only When Ctrl Is Pressed';
  rfastmousemodectrl_hint = 'Mouse mode requires Ctrl key to be held';
  rfastmousemodectrl_default = 'Shift+F3';

  rfastautoswap = 'Auto-Swap Language Pair';
  rfastautoswap_hint = 'Automatically swap the language pair direction';
  rfastautoswap_default = 'Shift+F4';

  rfastautoaddlangpairs = 'Auto-Add Recent Language Pairs';
  rfastautoaddlangpairs_hint = 'Auto-add recent language pairs for quick access';
  rfastautoaddlangpairs_default = 'Shift+F5';

  rfastrealtime = 'Translate As You Type';
  rfastrealtime_hint = 'Translate text as you type in the popup';
  rfastrealtime_default = 'Shift+F6';

  rfastautocopy = 'Auto-Copy Translation';
  rfastautocopy_hint = 'Automatically copy translation to clipboard';
  rfastautocopy_default = 'Shift+F7';

  rfastverticalsplit = 'Side-By-Side Layout';
  rfastverticalsplit_hint = 'Switch between vertical and horizontal layout';
  rfastverticalsplit_default = 'Shift+F8';

  rfastautohidepopup = 'Auto-Hide Popup On Outside Click';
  rfastautohidepopup_hint = 'Automatically hide the popup window when you click anywhere outside of it';
  rfastautohidepopup_default = 'Shift+F9';

  rfastautoheight = 'Popup Auto Height';
  rfastautoheight_hint = 'Adjust popup height to content automatically';
  rfastautoheight_default = 'Shift+F10';

  rfastspellcheck = 'Enable Spell Check';
  rfastspellcheck_hint = 'Enable spell checking in the source text';
  rfastspellcheck_default = 'Shift+F11';

  // HotKeys Recent Pairs
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

  ruserparameterkey = 'Name';
  ruserparametervalue = 'Value';

  {%EndRegion}

implementation

uses mainform, formpopup, languages, translate, localize, darkutils, controlshelper, stringshelper, stringgridhelper, pascalutils,
  OneShotTooltip, SpellUtils;

  {$R *.lfm}

  { TformSettingsTrayslate }

  {%Region -fold Form Events}

procedure TformSettingsTrayslate.FormCreate(Sender: TObject);
var
  List: TStringList;
begin
  TLocalize.ApplicationTranslate(APP_NAME, language, self, TLocalize.LoadCustomPoFile(formTrayslate.CustomPoFile));

  PanelPages.BevelColor := TDarkUtils.ThemeColor(ColorBevel, ColorBevelDark);
  PagesSettings.PageIndex := 0;
  BtnCancel.Cancel := True;
  BtnReset.Enabled := True;
  BtnResetPopup.Enabled := True;
  FApplySettings := False;
  FOldKeyValue := string.Empty;

  FillConfigs;

  List := TLanguages.GetLanguageCodeDisplayPairs(vtLanguage, True);
  try
    ComboPrimaryLang.Items.Assign(List);
    ComboSecondaryLang.Items.Assign(List);
  finally
    List.Free;
  end;

  ClbEnabledLang.SetComposited(True);
  ClbProxiedConfigs.SetComposited(True);

  FOriginalUserParameters := TStringList.Create;
  FOriginalProxiedConfigs := TStringList.Create;
  FOriginalEnabledLanguages := TStringList.Create;

  ColorIconBackground.AddCustomColors;
  ColorIconFont.AddCustomColors;
  ColorMouseModeFrame.AddCustomColors;
  ComboIconFontName.FillFontCombo;

  Reset;
  FillListPages;
  FillGridHotkeys;
  FillUserParameters;
  FillMouseMode;
  FillProxyMode;
  FillLanguage(Language);
  FillLanguages;

  Screen.OnActiveControlChange := @ScreenActiveControlChanged;
end;

procedure TformSettingsTrayslate.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FOriginalUserParameters);
  FreeAndNil(FOriginalProxiedConfigs);
  FreeAndNil(FOriginalEnabledLanguages);
end;

procedure TformSettingsTrayslate.FormShow(Sender: TObject);
begin
  formTrayslate.TopMost := False;
  Self.FitToScreen;
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

{%EndRegion}

{%Region -fold Screen Events}

procedure TformSettingsTrayslate.ScreenActiveControlChanged(Sender: TObject);
begin
  if FApplySettings then Exit;

  // Save focus only if it is not the Apply button itself
  if (Screen.ActiveControl <> nil) and (not (Screen.ActiveControl is TButton)) and
    //(not (Screen.ActiveControl = ValueListUserParameters)) and (not (Screen.ActiveControl is TStringCellEditor)) then
    (not (Screen.ActiveControl is TStringCellEditor)) then
    FLastFocused := Screen.ActiveControl;
end;

{%EndRegion}

{%Region -fold Events}

procedure TformSettingsTrayslate.SettingChange(Sender: TObject);
begin
  if ApplySettings then exit;

  BtnApply.Enabled := True;

  if (Sender is TSpinEdit) then
  begin
    if (Sender as TSpinEdit).Value < 0 then
      (Sender as TSpinEdit).Value := 0;
  end;

  if (Sender = ColorIconBackground) or (Sender = ColorMouseModeFrame) or (Sender = ColorIconFont) or
    (Sender = ComboIconFontName) or (Sender = CheckTwoLang) or (Sender = CheckCircularIcon) then
  begin
    // Apply real time properies
    formTrayslate.IconBackgroundColor := ColorIconBackground.Selected;
    formTrayslate.IconMouseModeFrameColor := ColorMouseModeFrame.Selected;
    formTrayslate.IconFontColor := ColorIconFont.Selected;
    formTrayslate.IconFontName := ComboIconFontName.Text;
    formTrayslate.IconTwoLang := CheckTwoLang.Checked;
    formTrayslate.IconCircular := CheckCircularIcon.Checked;
    formTrayslate.SetTrayIcon;
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
  begin
    formTrayslate.aFastAutoSwap.Checked := CheckAutoSwap.Checked;
    SetState;
  end
  else
  if Sender = CheckBuiltInDetect then
    SetState
  else
  if Sender = CheckAllowHotkeys then
  begin
    formTrayslate.aFastAllowHotkeys.Checked := CheckAllowHotkeys.Checked;
    SetState;
  end
  else
  if Sender = CheckEnableMouseMode then
  begin
    formTrayslate.aFastEnableMouseMode.Checked := CheckEnableMouseMode.Checked;
    SetState;
  end
  else
  if Sender = CheckAutoHidePopup then
    formTrayslate.aFastAutoHidePopup.Checked := CheckAutoHidePopup.Checked
  else
  if Sender = CheckMouseModeCtrl then
    formTrayslate.aFastMouseModeCtrl.Checked := CheckMouseModeCtrl.Checked
  else
  if Sender = CheckRealTime then
  begin
    formTrayslate.aFastRealTime.Checked := CheckRealTime.Checked;
    SetState;
  end
  else
  if Sender = CheckSpellCheck then
  begin
    formTrayslate.aFastSpellCheck.Checked := CheckSpellCheck.Checked;
    SetState;
  end
  else
  if Sender = CheckVerticalSplit then
    formTrayslate.aFastVerticalSplit.Checked := CheckVerticalSplit.Checked
  else
  if Sender = CheckAutoCopy then
    formTrayslate.aFastAutoCopy.Checked := CheckAutoCopy.Checked
  else
  if Sender = CheckAutoHeight then
  begin
    formTrayslate.aFastAutoHeight.Checked := CheckAutoHeight.Checked;
    if Assigned(formPopupTrayslate) then
      formPopupTrayslate.aFastAutoHeight.ImageIndex := iif(CheckAutoHeight.Checked, 19, 18);
  end
  else
  if Sender = CheckProxyAuthentication then
    SetState
  else
  if Sender = ComboProxyMode then
    SetState;
end;

procedure TformSettingsTrayslate.ListPagesClick(Sender: TObject);
begin
  // Synchronize PageControl with the selected list item
  if (ListPages.ItemIndex >= 0) and (ListPages.ItemIndex < PagesSettings.PageCount) then
  begin
    PagesSettings.ActivePageIndex := ListPages.ItemIndex;
  end;
end;

procedure TformSettingsTrayslate.PageHotkeysHide(Sender: TObject);
begin
  formTrayslate.UpdateInputState(True);
end;

procedure TformSettingsTrayslate.PageHotkeysShow(Sender: TObject);
begin
  formTrayslate.UpdateInputState(False);
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
    if (aCol = 1) and not (gdSelected in aState) then  GridHotkeys.Canvas.Brush.Color := CellColor;
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
      if (GridHotkeys.Row < GridHotkeys.FixedRows) or (GridHotkeys.Row in HeaderRows) then
      begin
        Key := 0;
        Exit;
      end;
      GridHotkeys.Col := 1;
      GridHotkeys.EditorMode := True;
      Key := 0;
      Exit;
    end
    else
    if (Key = VK_DELETE) and (Shift = []) then
    begin
      if (GridHotkeys.Row < GridHotkeys.FixedRows) or (GridHotkeys.Row in HeaderRows) then
      begin
        Key := 0;
        Exit;
      end;
      HK.Modifiers := 0;
      HK.Key := 0;
      SetHotKeyByRow(GridHotkeys.Row, HK);
      GridHotkeys.Cells[1, GridHotkeys.Row] := string.Empty;
      BtnApply.Enabled := True;
      Key := 0;
      Exit;
    end
    else
    if not THotKeyData.Create(Key).IsSystemKey then
    begin
      Key := 0;
      Exit;
    end;
  end;

  // Enter inside editor → confirm input
  if (Key = VK_RETURN) and (Shift = []) and GridHotkeys.EditorMode then
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

    GridHotkeys.Cells[1, GridHotkeys.Row] := HK.ToText;

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
  HasRealKey := not (Key in [VK_CONTROL, VK_SHIFT, VK_MENU]);

  if HasRealKey then
  begin
    HK.Key := Key;
    Key := 0;
  end
  else
    HK.Key := 0;

  // Apply hotkey
  SetHotKeyByRow(GridHotkeys.Row, HK);

  GridHotkeys.Cells[1, GridHotkeys.Row] := HK.ToText;

  if (HK.Key > 0) and (FOldKeyValue <> HK.ToText) then
    SettingChange(Sender);
end;

procedure TformSettingsTrayslate.GridHotkeysSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
begin
  if (ACol <> 1) or (ARow < GridHotkeys.FixedRows) or (ARow in HeaderRows) then
    Editor := nil;

  FOldKeyValue := GridHotkeys.Cells[1, aRow];
end;

procedure TformSettingsTrayslate.GridHotkeysEditingDone(Sender: TObject);
var
  HK, OriginalHK: THotKeyData;
begin
  if (GridHotkeys.Row < GridHotkeys.FixedRows) or (GridHotkeys.Row in HeaderRows) then
    Exit;

  HK := GetHotKeyByRow(GridHotkeys.Row);
  OriginalHK := GetOriginalHotKey(GridHotkeys.Row);
  if (HK.Key = 0) and (HK.Modifiers <> 0) then
  begin
    SetHotKeyByRow(GridHotkeys.Row, OriginalHK);
    GridHotkeys.Cells[1, GridHotkeys.Row] := OriginalHK.ToText;
  end
  else
  if FOldKeyValue <> GridHotkeys.Cells[1, GridHotkeys.Row] then
    SettingChange(Sender);
end;

procedure TformSettingsTrayslate.SplitterPagesMoved(Sender: TObject);
begin
  formTrayslate.FormSettingsSplit := ListPages.Width;
end;

procedure TformSettingsTrayslate.EditProxyHostKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  s, ip: string;
  port: word;
begin
  // Check for paste shortcut: Ctrl+V or Shift+Insert
  if ((Key = VK_V) and (ssCtrl in Shift)) or ((Key = VK_INSERT) and (Shift = [ssShift])) then
  begin
    if ((EditProxyHost.Text = string.empty) or (EditProxyHost.SelLength = Length(EditProxyHost.Text))) and
      Clipboard.HasFormat(CF_TEXT) then
    begin
      s := Trim(Clipboard.AsText);
      if s.TryParseIPPort(ip, port) then
      begin
        // Replace the current selection with IP only
        EditProxyHost.SelText := ip;
        SpinProxyPort.Value := port;
        if SpinProxyPort.CanFocus then
        begin
          SpinProxyPort.SetFocus;
          SpinProxyPort.SelStart := Length(SpinProxyPort.Text);
        end;
        // Mark the key as handled so default paste does not occur
        Key := 0;
      end;
    end;
    // If it's not an IP:PORT string, the normal paste will happen (Key not set to 0)
  end;
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
  FillLanguages;
  FillUserParameters;
  Apply;
end;

procedure TformSettingsTrayslate.BtnDefaultHotkeysClick(Sender: TObject);
begin
  if MessageDlg(rdefaulthotkeys, mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;

  formTrayslate.SetDefaultHotKeys;
  ResetHotkeys;

  FillGridHotkeys;
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
  PanelFont.Font.Color := TDarkUtils.ThemeColor(clBlack, clWhite);
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
  PanelFontPopup.Font.Color := TDarkUtils.ThemeColor(clBlack, clWhite);
  SetPanelFont(PanelFontPopup, PanelFontPopup.Font);
  SettingChange(Self);
end;

procedure TformSettingsTrayslate.BtnOkClick(Sender: TObject);
begin
  Visible := False;
  Apply;
  ModalResult := mrOk;
  Close;
end;

procedure TformSettingsTrayslate.BtnCancelClick(Sender: TObject);
begin
  Visible := False;
  ResetRealTimeSettings;
  Reset;
  ModalResult := mrCancel;
  Close;
end;

procedure TformSettingsTrayslate.BtnApplyClick(Sender: TObject);
var
  r, c: integer;
begin
  ValueListUserParameters.Options := ValueListUserParameters.Options - [goEditing];
  r := ValueListUserParameters.Row;
  c := ValueListUserParameters.Col;
  try
    if Assigned(FLastFocused) and FLastFocused.Visible and FLastFocused.CanFocus and FLastFocused.CanSetFocus then
      FLastFocused.SetFocus;

    Apply;
  finally
    ValueListUserParameters.Row := r;
    ValueListUserParameters.Col := c;
    ValueListUserParameters.Options := ValueListUserParameters.Options + [goEditing];
  end;
end;

procedure TformSettingsTrayslate.ValueListUserParametersSelectEditor(Sender: TObject; aCol, aRow: integer; var Editor: TWinControl);
begin
  FOldValueList := ValueListUserParameters.Cells[aCol, aRow];
end;

procedure TformSettingsTrayslate.ValueListUserParametersKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  ValueList: TValueListEditor;
  CurrentRow: integer;
begin
  if (Key = VK_DELETE) and (ssCtrl in Shift) then
  begin
    ValueList := Sender as TValueListEditor;

    Key := 0; // Block default processing

    // Safety check: row index must be valid
    if (ValueList.Row < ValueList.FixedRows) or (ValueList.Row >= ValueList.RowCount) then
      Exit; // Row is invalid, do nothing (prevents the out-of-bounds error)

    CurrentRow := ValueList.Row;

    // Don't delete fixed rows or the last data row
    if (ValueList.RowCount <= ValueList.FixedRows + 1) or (CurrentRow < ValueList.FixedRows) then
      Exit;

    // Move selection to a safe row before deleting (avoids dangling editor)
    if CurrentRow > ValueList.FixedRows then
      ValueList.Row := CurrentRow - 1
    else
      ValueList.Row := ValueList.FixedRows;

    // Now safe to delete
    ValueList.DeleteRow(CurrentRow);
  end;
end;

procedure TformSettingsTrayslate.ValueListUserParametersKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Sender as TValueListEditor).EditorMode and (ValueListUserParameters.Cells[ValueListUserParameters.Col,
    ValueListUserParameters.Row] <> FOldValueList) then
    BtnApply.Enabled := True;
end;

procedure TformSettingsTrayslate.ValueListUserParametersColRowDeleted(Sender: TObject; IsColumn: boolean; sIndex, tIndex: integer);
begin
  BtnApply.Enabled := True;
end;

procedure TformSettingsTrayslate.ValueListUserParametersColRowInserted(Sender: TObject; IsColumn: boolean; sIndex, tIndex: integer);
begin
  BtnApply.Enabled := True;
end;

procedure TformSettingsTrayslate.LabelInstalledLangClick(Sender: TObject);
var
  Langs: TStrings;
begin
  Langs := TSpell.WinSupportedLanguages;
  try
    TOneShotTooltip.Show(Langs.Text, 100, clWhite);
  finally
    Langs.Free; // Free the returned TStrings object
  end;
end;

procedure TformSettingsTrayslate.ClbProxiedConfigsMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
var
  Lines: integer;
begin
  // Get system wheel scroll setting (usually 3 lines, or -1 for full page)
  Lines := Mouse.WheelScrollLines;
  if Lines = -1 then
    Lines := ClbProxiedConfigs.Items.Count; // Full page if needed

  // Scroll the list manually
  if WheelDelta > 0 then
    ClbProxiedConfigs.TopIndex := Max(0, ClbProxiedConfigs.TopIndex - Lines)
  else
    ClbProxiedConfigs.TopIndex := Min(ClbProxiedConfigs.Items.Count - 1, ClbProxiedConfigs.TopIndex + Lines);

  Handled := True; // Block parent ScrollBox
end;

procedure TformSettingsTrayslate.ComboMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer;
  MousePos: TPoint; var Handled: boolean);
var
  SB: TScrollBox;
begin
  // Find the parent ScrollBox (assuming ComboBox.Parent is GroupBox, and its Parent is ScrollBox)
  if (Sender as TWinControl).Parent.Parent is TScrollBox then
  begin
    SB := TScrollBox((Sender as TWinControl).Parent.Parent);
    // Change the vertical scroll position directly.
    // WheelDelta > 0 means scroll up (decrease position), so we subtract it.
    SB.VertScrollBar.Position := SB.VertScrollBar.Position - WheelDelta div 2;
  end;

  Handled := True; // Prevent the ComboBox from processing the wheel itself
end;

procedure TformSettingsTrayslate.GridHotkeysMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: integer;
  MousePos: TPoint; var Handled: boolean);
begin
  GridHotkeys.EditorMode := False;

  // Call our helper method
  GridHotkeys.ScrollByWheel(WheelDelta);

  // Prevent default grid behavior (moving selection)
  Handled := True;
end;

procedure TformSettingsTrayslate.ClbEnabledLangKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Key = VK_SPACE) and (ssShift in Shift) then
  begin
    ClbEnabledLang.CheckSelection(False);
    SettingChange(Self);
    Key := 0;
  end
  else
  if (Key = VK_SPACE) and (ssCtrl in Shift) then
  begin
    ClbEnabledLang.CheckSelection(True);
    SettingChange(Self);
    Key := 0;
  end
  else if Key = VK_SPACE then
  begin
    ClbEnabledLang.CheckSelection(True, True);
    SettingChange(Self);
    Key := 0;
  end
  else if (Key = VK_A) and (ssCtrl in Shift) then
  begin
    ClbEnabledLang.SelectAll;
    Key := 0;
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

procedure TformSettingsTrayslate.ClbEnabledLangDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
var
  code: string;
  flag: TBitmap;
begin
  // Extract language code from item text
  code := TLanguages.ExtractCodeFromItem(ClbEnabledLang.Items[Index]);

  // Get flag bitmap (may be nil if not found)
  flag := TLanguages.GetFlag(code);

  try
    // Delegate drawing to the helper method
    ClbEnabledLang.DrawCheckListItem(
      ARect,
      State,
      ClbEnabledLang.Checked[Index],
      ClbEnabledLang.Enabled,
      ClbEnabledLang.Focused,
      ClbEnabledLang.Color,
      ClbEnabledLang.Font.Color,
      ClbEnabledLang.Items[Index],
      flag,
      TDarkUtils.IsDarkMode
      );
  finally
    // Free the flag bitmap if it was created by GetFlag
    // If GetFlag returns a cached object, remove this line
    if Assigned(flag) then
      flag.Free;
  end;
end;

procedure TformSettingsTrayslate.ClbProxiedConfigsDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
var
  Bmp: TBitmap;
  IconIdx: integer;
begin
  // Prepare optional icon
  Bmp := nil;
  if Assigned(formTrayslate.ImageConfig) and Assigned(formTrayslate.ConfigImages) and (Index < formTrayslate.ConfigImages.Count) then
  begin
    IconIdx := formTrayslate.ConfigImages.ValueFromIndex[Index].ToInteger;
    if (IconIdx >= 0) and (IconIdx < formTrayslate.ImageConfig.Count) then
    begin
      Bmp := TBitmap.Create;
      formTrayslate.ImageConfig.GetBitmap(IconIdx, Bmp);
      Bmp.Transparent := True;
      Bmp.TransparentColor := clWhite;
    end;
  end;

  try
    // Draw the whole item using the helper method
    ClbProxiedConfigs.DrawCheckListItem(
      ARect,
      State,
      ClbProxiedConfigs.Checked[Index],
      ClbProxiedConfigs.Enabled,
      ClbProxiedConfigs.Focused,
      ClbProxiedConfigs.Color,
      ClbProxiedConfigs.Font.Color,
      ClbProxiedConfigs.Items[Index],
      Bmp,
      TDarkUtils.IsDarkMode);
  finally
    if Assigned(Bmp) then
      Bmp.Free;
  end;
end;

{%EndRegion}

{%Region -fold Methods}

procedure TformSettingsTrayslate.SetPanelFont(Panel: TPanel; const AFont: TFont);
begin
  Panel.Caption := ifthen((Trim(AFont.Name) = string.Empty) or (LowerCase(AFont.Name) = 'default'), rdefaultfont, AFont.Name) +
    ',' + IntToStr(AFont.Size);
end;

procedure TformSettingsTrayslate.ResetRealTimeSettings;
begin
  formTrayslate.IconBackgroundColor := FOriginalIconBackgroundColor;
  formTrayslate.IconMouseModeFrameColor := FOriginalIconMouseModeFrameColor;
  formTrayslate.IconFontColor := FOriginalIconFontColor;
  formTrayslate.IconFontName := FOriginalIconFontName;
  formTrayslate.IconTwoLang := FOriginalIconTwoLang;
  formTrayslate.IconCircular := FOriginalIconCircular;
  formTrayslate.SetTrayIcon;

  formTrayslate.OpacityHover := FOriginalOpacityHover;
  formTrayslate.OpacityIdle := FOriginalOpacityIdle;
end;

function TformSettingsTrayslate.GetHotKeyByRow(Row: integer): THotKeyData;
begin
  case Row of
    // Common HotKeys (rows 2-9, header at row 1)
    2: Result := FHotKeyApp;
    3: Result := FHotKeyTransSwap;
    4: Result := FHotKeyTransFromClipboard;
    5: Result := FHotKeyTransClipboard;
    6: Result := FHotKeyTransClipboardPopup;
    7: Result := FHotKeyTransFromControl;
    8: Result := FHotKeyTransControl;
    9: Result := FHotKeyTransControlPopup;
    // Fast Settings HotKeys (rows 11-20, header at row 10)
    11: Result := FHotKeyFastAllowHotKeys;
    12: Result := FHotKeyFastEnableMouseMode;
    13: Result := FHotKeyFastMouseModeCtrl;
    14: Result := FHotKeyFastAutoSwap;
    15: Result := FHotKeyFastAutoAddLangPairs;
    16: Result := FHotKeyFastRealTime;
    17: Result := FHotKeyFastAutoCopy;
    18: Result := FHotKeyFastVerticalSplit;
    19: Result := FHotKeyFastAutoHidePopup;
    20: Result := FHotKeyFastAutoHeight;
    21: Result := FHotKeyFastSpellCheck;
    // Recent HotKeys (rows 22-30, header at row 22)
    23: Result := FHotKeyRecent1;
    24: Result := FHotKeyRecent2;
    25: Result := FHotKeyRecent3;
    26: Result := FHotKeyRecent4;
    27: Result := FHotKeyRecent5;
    28: Result := FHotKeyRecent6;
    29: Result := FHotKeyRecent7;
    30: Result := FHotKeyRecent8;
    31: Result := FHotKeyRecent9;
    else
      Result := Default(THotKeyData);
  end;
end;

procedure TformSettingsTrayslate.SetHotKeyByRow(Row: integer; const HK: THotKeyData);
begin
  case Row of
    // Common HotKeys (rows 2-9, header at row 1)
    2: FHotKeyApp := HK;
    3: FHotKeyTransSwap := HK;
    4: FHotKeyTransFromClipboard := HK;
    5: FHotKeyTransClipboard := HK;
    6: FHotKeyTransClipboardPopup := HK;
    7: FHotKeyTransFromControl := HK;
    8: FHotKeyTransControl := HK;
    9: FHotKeyTransControlPopup := HK;
    // Fast Settings HotKeys (rows 11-20, header at row 10)
    11: FHotKeyFastAllowHotKeys := HK;
    12: FHotKeyFastEnableMouseMode := HK;
    13: FHotKeyFastMouseModeCtrl := HK;
    14: FHotKeyFastAutoSwap := HK;
    15: FHotKeyFastAutoAddLangPairs := HK;
    16: FHotKeyFastRealTime := HK;
    17: FHotKeyFastAutoCopy := HK;
    18: FHotKeyFastVerticalSplit := HK;
    19: FHotKeyFastAutoHidePopup := HK;
    20: FHotKeyFastAutoHeight := HK;
    21: FHotKeyFastSpellCheck := HK;
    // Recent HotKeys (rows 22-30, header at row 22)
    23: FHotKeyRecent1 := HK;
    24: FHotKeyRecent2 := HK;
    25: FHotKeyRecent3 := HK;
    26: FHotKeyRecent4 := HK;
    27: FHotKeyRecent5 := HK;
    28: FHotKeyRecent6 := HK;
    29: FHotKeyRecent7 := HK;
    30: FHotKeyRecent8 := HK;
    31: FHotKeyRecent9 := HK;
    else
      ; // ignore
  end;
end;

function TformSettingsTrayslate.GetOriginalHotKey(Row: integer): THotKeyData;
begin
  case Row of
    // Common HotKeys (rows 2-9, header at row 1)
    2: Result := FOriginalHotKeyApp;
    3: Result := FOriginalHotKeyTransSwap;
    4: Result := FOriginalHotKeyTransFromClipboard;
    5: Result := FOriginalHotKeyTransClipboard;
    6: Result := FOriginalHotKeyTransClipboardPopup;
    7: Result := FOriginalHotKeyTransFromControl;
    8: Result := FOriginalHotKeyTransControl;
    9: Result := FOriginalHotKeyTransControlPopup;
    // Fast Settings HotKeys (rows 11-20, header at row 10)
    11: Result := FOriginalHotKeyFastAllowHotKeys;
    12: Result := FOriginalHotKeyFastEnableMouseMode;
    13: Result := FOriginalHotKeyFastMouseModeCtrl;
    14: Result := FOriginalHotKeyFastAutoSwap;
    15: Result := FOriginalHotKeyFastAutoAddLangPairs;
    16: Result := FOriginalHotKeyFastRealTime;
    17: Result := FOriginalHotKeyFastAutoCopy;
    18: Result := FOriginalHotKeyFastVerticalSplit;
    19: Result := FOriginalHotKeyFastAutoHidePopup;
    20: Result := FOriginalHotKeyFastAutoHeight;
    21: Result := FOriginalHotKeyFastSpellCheck;
    // Recent HotKeys (rows 22-30, header at row 22)
    23: Result := FOriginalHotKeyRecent1;
    24: Result := FOriginalHotKeyRecent2;
    25: Result := FOriginalHotKeyRecent3;
    26: Result := FOriginalHotKeyRecent4;
    27: Result := FOriginalHotKeyRecent5;
    28: Result := FOriginalHotKeyRecent6;
    29: Result := FOriginalHotKeyRecent7;
    30: Result := FOriginalHotKeyRecent8;
    31: Result := FOriginalHotKeyRecent9;
    else
      Result := Default(THotKeyData);
  end;
end;

function TformSettingsTrayslate.GetLanguage: string;
begin
  // Return language code from selected combobox item
  case ComboAppLang.ItemIndex of
    0: Result := 'ar';
    1: Result := 'be';
    2: Result := 'bg';
    3: Result := 'zh';
    4: Result := 'cs';
    5: Result := 'da';
    6: Result := 'nl';
    7: Result := 'en';
    8: Result := 'fi';
    9: Result := 'fr';
    10: Result := 'de';
    11: Result := 'el';
    12: Result := 'he';
    13: Result := 'hi';
    14: Result := 'id';
    15: Result := 'it';
    16: Result := 'ja';
    17: Result := 'ko';
    18: Result := 'pl';
    19: Result := 'pt';
    20: Result := 'pt-BR';
    21: Result := 'ro';
    22: Result := 'ru';
    23: Result := 'es';
    24: Result := 'sv';
    25: Result := 'tr';
    26: Result := 'uk';
    27: Result := 'vi';
    else
      Result := string.Empty; // no language selected or custom language
  end;
end;

procedure TformSettingsTrayslate.FillLanguage(ALangCode: string);
begin
  if formTrayslate.CustomPoFile <> string.Empty then
    ComboAppLang.ItemIndex := -1
  else
    // Select current language in the combobox
    case ALangCode of
      'ar': ComboAppLang.ItemIndex := 0;
      'be': ComboAppLang.ItemIndex := 1;
      'bg': ComboAppLang.ItemIndex := 2;
      'zh': ComboAppLang.ItemIndex := 3;
      'cs': ComboAppLang.ItemIndex := 4;
      'da': ComboAppLang.ItemIndex := 5;
      'nl': ComboAppLang.ItemIndex := 6;
      'en': ComboAppLang.ItemIndex := 7;
      'fi': ComboAppLang.ItemIndex := 8;
      'fr': ComboAppLang.ItemIndex := 9;
      'de': ComboAppLang.ItemIndex := 10;
      'el': ComboAppLang.ItemIndex := 11;
      'he': ComboAppLang.ItemIndex := 12;
      'hi': ComboAppLang.ItemIndex := 13;
      'id': ComboAppLang.ItemIndex := 14;
      'it': ComboAppLang.ItemIndex := 15;
      'ja': ComboAppLang.ItemIndex := 16;
      'ko': ComboAppLang.ItemIndex := 17;
      'pl': ComboAppLang.ItemIndex := 18;
      'pt': ComboAppLang.ItemIndex := 19;
      'pt-BR': ComboAppLang.ItemIndex := 20;
      'ro': ComboAppLang.ItemIndex := 21;
      'ru': ComboAppLang.ItemIndex := 22;
      'es': ComboAppLang.ItemIndex := 23;
      'sv': ComboAppLang.ItemIndex := 24;
      'tr': ComboAppLang.ItemIndex := 25;
      'uk': ComboAppLang.ItemIndex := 26;
      'vi': ComboAppLang.ItemIndex := 27;
      else
        ComboAppLang.ItemIndex := -1; // no selection for unknown or custom language
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

  // Row 1: Global header
  GridHotkeys.InsertRowWithValues(1, [rglobal]);

  // Rows 2-9: Common hotkeys
  GridHotkeys.InsertRowWithValues(2, [rapp, FHotKeyApp.ToText, rapp_hint, rapp_default]);
  GridHotkeys.InsertRowWithValues(3, [rtransswap, FHotKeyTransSwap.ToText, rtransswap_hint, rtransswap_default]);
  GridHotkeys.InsertRowWithValues(4, [rtransfromclipboard, FHotKeyTransFromClipboard.ToText, rtransfromclipboard_hint,
    rtransfromclipboard_default]);
  GridHotkeys.InsertRowWithValues(5, [rtransclipboard, FHotKeyTransClipboard.ToText, rtransclipboard_hint, rtransclipboard_default]);
  GridHotkeys.InsertRowWithValues(6, [rtransclipboardpopup, FHotKeyTransClipboardPopup.ToText, rtransclipboardpopup_hint,
    rtransclipboardpopup_default]);
  GridHotkeys.InsertRowWithValues(7, [rtransfromcontrol, FHotKeyTransFromControl.ToText, rtransfromcontrol_hint,
    rtransfromcontrol_default]);
  GridHotkeys.InsertRowWithValues(8, [rtranscontrol, FHotKeyTransControl.ToText, rtranscontrol_hint, rtranscontrol_default]);
  GridHotkeys.InsertRowWithValues(9, [rtranscontrolpopup, FHotKeyTransControlPopup.ToText, rtranscontrolpopup_hint,
    rtranscontrolpopup_default]);

  // Row 10: Fast header
  GridHotkeys.InsertRowWithValues(10, [rfast]);

  // Rows 11-20: Fast settings hotkeys
  GridHotkeys.InsertRowWithValues(11, [rfastallowhotkeys, FHotKeyFastAllowHotKeys.ToText, rfastallowhotkeys_hint,
    rfastallowhotkeys_default]);
  GridHotkeys.InsertRowWithValues(12, [rfastenablemousemode, FHotKeyFastEnableMouseMode.ToText,
    rfastenablemousemode_hint, rfastenablemousemode_default]);
  GridHotkeys.InsertRowWithValues(13, [rfastmousemodectrl, FHotKeyFastMouseModeCtrl.ToText, rfastmousemodectrl_hint,
    rfastmousemodectrl_default]);
  GridHotkeys.InsertRowWithValues(14, [rfastautoswap, FHotKeyFastAutoSwap.ToText, rfastautoswap_hint, rfastautoswap_default]);
  GridHotkeys.InsertRowWithValues(15, [rfastautoaddlangpairs, FHotKeyFastAutoAddLangPairs.ToText,
    rfastautoaddlangpairs_hint, rfastautoaddlangpairs_default]);
  GridHotkeys.InsertRowWithValues(16, [rfastrealtime, FHotKeyFastRealTime.ToText, rfastrealtime_hint, rfastrealtime_default]);
  GridHotkeys.InsertRowWithValues(17, [rfastautocopy, FHotKeyFastAutoCopy.ToText, rfastautocopy_hint, rfastautocopy_default]);
  GridHotkeys.InsertRowWithValues(18, [rfastverticalsplit, FHotKeyFastVerticalSplit.ToText, rfastverticalsplit_hint,
    rfastverticalsplit_default]);
  GridHotkeys.InsertRowWithValues(19, [rfastautohidepopup, FHotKeyFastAutoHidePopup.ToText, rfastautohidepopup,
    rfastautohidepopup_default]);
  GridHotkeys.InsertRowWithValues(20, [rfastautoheight, FHotKeyFastAutoHeight.ToText, rfastautoheight_hint, rfastautoheight_default]);
  GridHotkeys.InsertRowWithValues(21, [rfastspellcheck, FHotKeyFastSpellCheck.ToText, rfastspellcheck_hint, rfastspellcheck_default]);

  // Row 21: Recent header
  GridHotkeys.InsertRowWithValues(22, [rrecent]);

  // Rows 22-30: Recent hotkeys
  GridHotkeys.InsertRowWithValues(23, [rrecentpair + ' 1', FHotKeyRecent1.ToText, rrecentpair_hint + ' 1', rrecentpair_default + '1']);
  GridHotkeys.InsertRowWithValues(24, [rrecentpair + ' 2', FHotKeyRecent2.ToText, rrecentpair_hint + ' 2', rrecentpair_default + '2']);
  GridHotkeys.InsertRowWithValues(25, [rrecentpair + ' 3', FHotKeyRecent3.ToText, rrecentpair_hint + ' 3', rrecentpair_default + '3']);
  GridHotkeys.InsertRowWithValues(26, [rrecentpair + ' 4', FHotKeyRecent4.ToText, rrecentpair_hint + ' 4', rrecentpair_default + '4']);
  GridHotkeys.InsertRowWithValues(27, [rrecentpair + ' 5', FHotKeyRecent5.ToText, rrecentpair_hint + ' 5', rrecentpair_default + '5']);
  GridHotkeys.InsertRowWithValues(28, [rrecentpair + ' 6', FHotKeyRecent6.ToText, rrecentpair_hint + ' 6', rrecentpair_default + '6']);
  GridHotkeys.InsertRowWithValues(29, [rrecentpair + ' 7', FHotKeyRecent7.ToText, rrecentpair_hint + ' 7', rrecentpair_default + '7']);
  GridHotkeys.InsertRowWithValues(30, [rrecentpair + ' 8', FHotKeyRecent8.ToText, rrecentpair_hint + ' 8', rrecentpair_default + '8']);
  GridHotkeys.InsertRowWithValues(31, [rrecentpair + ' 9', FHotKeyRecent9.ToText, rrecentpair_hint + ' 9', rrecentpair_default + '9']);

  // Restore safely
  if SavedRow < GridHotkeys.RowCount then
    GridHotkeys.Row := SavedRow
  else
    GridHotkeys.Row := GridHotkeys.FixedRows;
end;

procedure TformSettingsTrayslate.FillUserParameters;
begin
  ValueListUserParameters.TitleCaptions.Clear;
  ValueListUserParameters.TitleCaptions.Add(ruserparameterkey);
  ValueListUserParameters.TitleCaptions.Add(ruserparametervalue);
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

procedure TformSettingsTrayslate.FillLanguages;
var
  List: TStringList;
  code: string;
  i: integer;
begin
  ClbEnabledLang.LockUpdate;
  List := TLanguages.GetLanguageCodeDisplayPairs(vtLanguage, True, False);
  try
    ClbEnabledLang.Items.Clear;
    ClbEnabledLang.Items.Assign(List);
    for i := 0 to ClbEnabledLang.Items.Count - 1 do
    begin
      code := TLanguages.ExtractCodeFromItem(ClbEnabledLang.Items[i]);
      ClbEnabledLang.Checked[i] := formTrayslate.EnabledLanguages.Contains(code);
    end;
  finally
    List.Free;
    ClbEnabledLang.UnlockUpdate;
  end;
end;

procedure TformSettingsTrayslate.FillConfigs;
var
  i: integer;
  Item, Path: string;
begin
  ComboLangDetect.Items.Clear;
  ClbProxiedConfigs.Items.Clear;
  ComboLangDetect.Items.Add(string.Empty);
  for i := 0 to formTrayslate.ConfigFiles.Count - 1 do
  begin
    Item := formTrayslate.ConfigTitles.Values[formTrayslate.ConfigFiles[i]];
    Path := formTrayslate.ConfigFiles[i];
    ComboLangDetect.Items.Add(Item);
    ClbProxiedConfigs.Checked[ClbProxiedConfigs.Items.Add(Item)] := formTrayslate.ProxiedConfigs.Contains(Path);
  end;
  ComboLangDetect.ItemIndex := formTrayslate.ConfigFiles.IndexOf(formTrayslate.ConfigLangDetect) + 1;
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
  // AutoSwap
  CheckBuiltInDetect.Enabled := CheckAutoSwap.Checked;
  LabelLangDetectConfig.Enabled := CheckAutoSwap.Checked;
  ComboLangDetect.Enabled := CheckAutoSwap.Checked and not CheckBuiltInDetect.Checked; // LangDetect Config
  CheckSmartSwap.Enabled := CheckAutoSwap.Checked;
  CheckSmartHard.Enabled := CheckAutoSwap.Checked;
  LabelPrimaryLang.Enabled := CheckAutoSwap.Checked;
  ComboPrimaryLang.Enabled := CheckAutoSwap.Checked;
  LabelSecondaryLang.Enabled := CheckAutoSwap.Checked;
  ComboSecondaryLang.Enabled := CheckAutoSwap.Checked;

  // RealTime
  LabelRealTimeDelay.Enabled := CheckRealTime.Checked;
  SpinRealTimeDelay.Enabled := LabelRealTimeDelay.Enabled;

  // MouseMode
  CheckMouseModeCtrl.Enabled := CheckEnableMouseMode.Checked;
  LabelMouseMode.Enabled := CheckMouseModeCtrl.Enabled;
  ComboMouseMode.Enabled := CheckMouseModeCtrl.Enabled;

  // SpellCheck
  CheckSpellCheckEmptySuggestions.Enabled := CheckSpellCheck.Checked;

  // Global HotKeys
  GridHotkeys.Enabled := CheckAllowHotkeys.Checked;
  GridHotkeys.Color := ifthen(GridHotkeys.Enabled, clWindow, clBtnFace);

  // Proxy
  LabelProxyType.Enabled := ComboProxyMode.ItemIndex > 1;
  ComboProxyType.Enabled := LabelProxyType.Enabled;
  LabelHost.Enabled := LabelProxyType.Enabled;
  EditProxyHost.Enabled := LabelProxyType.Enabled;
  LabelPort.Enabled := LabelProxyType.Enabled;
  SpinProxyPort.Enabled := LabelProxyType.Enabled;
  ClbProxiedConfigs.Enabled := ComboProxyMode.ItemIndex > 0;

  // Proxy Auth
  CheckProxyAuthentication.Enabled := ComboProxyMode.ItemIndex > 1;
  EditProxyLogin.Enabled := CheckProxyAuthentication.Checked and (ComboProxyMode.ItemIndex > 1);
  EditProxyPassword.Enabled := EditProxyLogin.Enabled;
  LabelLogin.Enabled := EditProxyLogin.Enabled;
  LabelPassword.Enabled := EditProxyLogin.Enabled;
end;

procedure TformSettingsTrayslate.Apply;
var
  T: TTimeout;
  P: TProxy;
  i: integer;
  LangCode: string;
begin
  FApplySettings := True;
  ValueListUserParameters.EditingDone;
  try
    formTrayslate.AutoStart := CheckAutostart.Checked;
    formTrayslate.MaxLangPairs := SpinMaxLangPairs.Value;
    formTrayslate.AutoAddLangPairs := CheckAutoAddLangPairs.Checked;
    formTrayslate.AllowHotKeys := CheckAllowHotkeys.Checked;
    formTrayslate.RealTime := CheckRealTime.Checked;
    formTrayslate.RealTimeDelay := SpinRealTimeDelay.Value;
    formTrayslate.AutoSwap := CheckAutoSwap.Checked;
    formTrayslate.BuiltInDetect := CheckBuiltInDetect.Checked;
    formTrayslate.SmartSwap := CheckSmartSwap.Checked;
    formTrayslate.SmartHard := CheckSmartHard.Checked;
    formTrayslate.PrimaryLang := TLanguages.ExtractCodeFromItem(ComboPrimaryLang.Text);
    formTrayslate.SecondaryLang := TLanguages.ExtractCodeFromItem(ComboSecondaryLang.Text);
    formTrayslate.EnableMouseMode := CheckEnableMouseMode.Checked;
    formTrayslate.MouseModeCtrl := CheckMouseModeCtrl.Checked;
    formTrayslate.MouseMode := TMouseMode(ComboMouseMode.ItemIndex);
    formTrayslate.InsertKey := CheckInsertKey.Checked;
    formTrayslate.SpellCheck := CheckSpellCheck.Checked;
    formTrayslate.SpellCheckEmptySuggestions := CheckSpellCheckEmptySuggestions.Checked;
    formTrayslate.VerticalSplit := CheckVerticalSplit.Checked;
    formTrayslate.AutoCopy := CheckAutoCopy.Checked;
    formTrayslate.StayOnTop := CheckStayOnTop.Checked;
    formTrayslate.HideControls := CheckHideControls.Checked;
    formTrayslate.AutoHidePopup := CheckAutoHidePopup.Checked;
    formTrayslate.AutoHeight := CheckAutoHeight.Checked;
    formTrayslate.MaxHeight := SpinMaxHeight.Value;
    formTrayslate.OpacityHover := TrackOpacityHover.Position;
    formTrayslate.OpacityIdle := TrackOpacityIdle.Position;

    if (ComboLangDetect.ItemIndex > 0) and (ComboLangDetect.ItemIndex - 1 < formTrayslate.ConfigFiles.Count) then
      formTrayslate.ConfigLangDetect := formTrayslate.ConfigFiles[ComboLangDetect.ItemIndex - 1]
    else
      formTrayslate.ConfigLangDetect := string.Empty;

    formTrayslate.EnabledLanguages.Clear;
    for i := 0 to ClbEnabledLang.Count - 1 do
      if ClbEnabledLang.Checked[i] then
        formTrayslate.EnabledLanguages.Add(TLanguages.ExtractCodeFromItem(ClbEnabledLang.Items[i]));

    formTrayslate.ProxiedConfigs.Clear;
    for i := 0 to ClbProxiedConfigs.Count - 1 do
      if ClbProxiedConfigs.Checked[i] and (i < formTrayslate.ConfigFiles.Count) then
        formTrayslate.ProxiedConfigs.Add(formTrayslate.ConfigFiles[i]);

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

    formTrayslate.UserParameters.Assign(ValueListUserParameters.Strings);

    formTrayslate.Font.Assign(PanelFont.Font);
    formTrayslate.FontPopup.Assign(PanelFontPopup.Font);
    formTrayslate.IconBackgroundColor := ColorIconBackground.Selected;
    formTrayslate.IconMouseModeFrameColor := ColorMouseModeFrame.Selected;
    formTrayslate.IconFontColor := ColorIconFont.Selected;
    formTrayslate.IconFontName := ComboIconFontName.Text;
    formTrayslate.IconTwoLang := CheckTwoLang.Checked;
    formTrayslate.IconCircular := CheckCircularIcon.Checked;
    formTrayslate.SetTrayIcon;

    // HotKeys Common
    formTrayslate.HotKeyApp := FHotKeyApp;
    formTrayslate.HotKeyTransSwap := FHotKeyTransSwap;
    formTrayslate.HotKeyTransFromClipboard := FHotKeyTransFromClipboard;
    formTrayslate.HotKeyTransClipboard := FHotKeyTransClipboard;
    formTrayslate.HotKeyTransClipboardPopup := FHotKeyTransClipboardPopup;
    formTrayslate.HotKeyTransFromControl := FHotKeyTransFromControl;
    formTrayslate.HotKeyTransControl := FHotKeyTransControl;
    formTrayslate.HotKeyTransControlPopup := FHotKeyTransControlPopup;

    // HotKeys Fast Settings
    formTrayslate.HotKeyFastAllowHotKeys := FHotKeyFastAllowHotKeys;
    formTrayslate.HotKeyFastEnableMouseMode := FHotKeyFastEnableMouseMode;
    formTrayslate.HotKeyFastMouseModeCtrl := FHotKeyFastMouseModeCtrl;
    formTrayslate.HotKeyFastAutoSwap := FHotKeyFastAutoSwap;
    formTrayslate.HotKeyFastAutoAddLangPairs := FHotKeyFastAutoAddLangPairs;
    formTrayslate.HotKeyFastRealTime := FHotKeyFastRealTime;
    formTrayslate.HotKeyFastAutoCopy := FHotKeyFastAutoCopy;
    formTrayslate.HotKeyFastVerticalSplit := FHotKeyFastVerticalSplit;
    formTrayslate.HotKeyFastAutoHeight := FHotKeyFastAutoHeight;
    formTrayslate.HotKeyFastAutoHidePopup := FHotKeyFastAutoHidePopup;
    formTrayslate.HotKeyFastSpellCheck := FHotKeyFastSpellCheck;

    // HotKeys Recent Pairs
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

    // Change the language at the end to avoid resetting the settings
    LangCode := GetLanguage;
    if (LangCode <> string.Empty) and (FOriginalLanguage <> LangCode) then
    begin
      Language := LangCode;
      formTrayslate.CustomPoFile := string.Empty;
      formTrayslate.SetLanguage(LangCode);
    end;

    Reset;

    formTrayslate.Trans.Languages.Assign(formTrayslate.Trans.LanguagesOriginal);
    formTrayslate.Trans.LanguagesTarget.Assign(formTrayslate.Trans.LanguagesTargetOriginal);
    formTrayslate.RestrictTranslate;
    formTrayslate.LoadLanguages;
    formTrayslate.UpdateComboState;

    formTrayslate.TimerTranslate.Interval := Max(formTrayslate.RealTimeDelay, 1);
    formTrayslate.LoadLangDetect;
    formTrayslate.UpdateProxyState;
    formTrayslate.ComboSource.AdjustComboHeight;
    formTrayslate.ComboTarget.AdjustComboHeight;
    formTrayslate.DoRealign(0);
    Application.QueueAsyncCall(@formTrayslate.RebuildLangPairsPanel, 0);
    formTrayslate.UpdateSpellCheck;
  finally
    FApplySettings := False;
  end;
end;

procedure TformSettingsTrayslate.ResetHotkeys;
begin
  // HotKeys Common
  FOriginalHotKeyApp := formTrayslate.HotKeyApp;
  FOriginalHotKeyTransSwap := formTrayslate.HotKeyTransSwap;
  FOriginalHotKeyTransFromClipboard := formTrayslate.HotKeyTransFromClipboard;
  FOriginalHotKeyTransClipboard := formTrayslate.HotKeyTransClipboard;
  FOriginalHotKeyTransClipboardPopup := formTrayslate.HotKeyTransClipboardPopup;
  FOriginalHotKeyTransFromControl := formTrayslate.HotKeyTransFromControl;
  FOriginalHotKeyTransControl := formTrayslate.HotKeyTransControl;
  FOriginalHotKeyTransControlPopup := formTrayslate.HotKeyTransControlPopup;

  // HotKeys Fast Settings
  FOriginalHotKeyFastAllowHotKeys := formTrayslate.HotKeyFastAllowHotKeys;
  FOriginalHotKeyFastEnableMouseMode := formTrayslate.HotKeyFastEnableMouseMode;
  FOriginalHotKeyFastMouseModeCtrl := formTrayslate.HotKeyFastMouseModeCtrl;
  FOriginalHotKeyFastAutoSwap := formTrayslate.HotKeyFastAutoSwap;
  FOriginalHotKeyFastAutoAddLangPairs := formTrayslate.HotKeyFastAutoAddLangPairs;
  FOriginalHotKeyFastRealTime := formTrayslate.HotKeyFastRealTime;
  FOriginalHotKeyFastAutoCopy := formTrayslate.HotKeyFastAutoCopy;
  FOriginalHotKeyFastVerticalSplit := formTrayslate.HotKeyFastVerticalSplit;
  FOriginalHotKeyFastAutoHeight := formTrayslate.HotKeyFastAutoHeight;
  FOriginalHotKeyFastAutoHidePopup := formTrayslate.HotKeyFastAutoHidePopup;
  FOriginalHotKeyFastSpellCheck := formTrayslate.HotKeyFastSpellCheck;

  // HotKeys Recent Pairs
  FOriginalHotKeyRecent1 := formTrayslate.HotKeyRecent1;
  FOriginalHotKeyRecent2 := formTrayslate.HotKeyRecent2;
  FOriginalHotKeyRecent3 := formTrayslate.HotKeyRecent3;
  FOriginalHotKeyRecent4 := formTrayslate.HotKeyRecent4;
  FOriginalHotKeyRecent5 := formTrayslate.HotKeyRecent5;
  FOriginalHotKeyRecent6 := formTrayslate.HotKeyRecent6;
  FOriginalHotKeyRecent7 := formTrayslate.HotKeyRecent7;
  FOriginalHotKeyRecent8 := formTrayslate.HotKeyRecent8;
  FOriginalHotKeyRecent9 := formTrayslate.HotKeyRecent9;

  // Copy current values to working hotkeys
  // HotKeys Common
  FHotKeyApp := formTrayslate.HotKeyApp;
  FHotKeyTransSwap := formTrayslate.HotKeyTransSwap;
  FHotKeyTransFromClipboard := formTrayslate.HotKeyTransFromClipboard;
  FHotKeyTransClipboard := formTrayslate.HotKeyTransClipboard;
  FHotKeyTransClipboardPopup := formTrayslate.HotKeyTransClipboardPopup;
  FHotKeyTransFromControl := formTrayslate.HotKeyTransFromControl;
  FHotKeyTransControl := formTrayslate.HotKeyTransControl;
  FHotKeyTransControlPopup := formTrayslate.HotKeyTransControlPopup;

  // HotKeys Fast Settings
  FHotKeyFastAllowHotKeys := formTrayslate.HotKeyFastAllowHotKeys;
  FHotKeyFastEnableMouseMode := formTrayslate.HotKeyFastEnableMouseMode;
  FHotKeyFastMouseModeCtrl := formTrayslate.HotKeyFastMouseModeCtrl;
  FHotKeyFastAutoSwap := formTrayslate.HotKeyFastAutoSwap;
  FHotKeyFastAutoAddLangPairs := formTrayslate.HotKeyFastAutoAddLangPairs;
  FHotKeyFastRealTime := formTrayslate.HotKeyFastRealTime;
  FHotKeyFastAutoCopy := formTrayslate.HotKeyFastAutoCopy;
  FHotKeyFastVerticalSplit := formTrayslate.HotKeyFastVerticalSplit;
  FHotKeyFastAutoHeight := formTrayslate.HotKeyFastAutoHeight;
  FHotKeyFastAutoHidePopup := formTrayslate.HotKeyFastAutoHidePopup;
  FHotKeyFastSpellCheck := formTrayslate.HotKeyFastSpellCheck;

  // HotKeys Recent Pairs
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
var
  i: integer;
begin
  FOriginalAutoStart := formTrayslate.AutoStart;
  FOriginalMaxLangPairs := formTrayslate.MaxLangPairs;
  FOriginalAutoAddLangPairs := formTrayslate.AutoAddLangPairs;
  FOriginalAllowHotkeys := formTrayslate.AllowHotKeys;
  FOriginalRealTime := formTrayslate.RealTime;
  FOriginalRealTimeDelay := formTrayslate.RealTimeDelay;
  FOriginalBuiltInDetect := formTrayslate.BuiltInDetect;
  FOriginalAutoSwap := formTrayslate.AutoSwap;
  FOriginalSmartSwap := formTrayslate.SmartSwap;
  FOriginalSmartHard := formTrayslate.SmartHard;
  FOriginalPrimaryLang := formTrayslate.PrimaryLang;
  FOriginalSecondaryLang := formTrayslate.SecondaryLang;
  FOriginalEnableMouseMode := formTrayslate.EnableMouseMode;
  FOriginalMouseModeCtrl := formTrayslate.MouseModeCtrl;
  FOriginalMouseMode := formTrayslate.MouseMode;
  FOriginalInsertKey := formTrayslate.InsertKey;
  FOriginalSpellCheck := formTrayslate.SpellCheck;
  FOriginalSpellCheckEmptySuggestions := formTrayslate.SpellCheckEmptySuggestions;
  FOriginalVerticalSplit := formTrayslate.VerticalSplit;
  FOriginalAutoCopy := formTrayslate.AutoCopy;
  FOriginalStayOnTop := formTrayslate.StayOnTop;
  FOriginalHideControls := formTrayslate.HideControls;
  FOriginalAutoHidePopup := formTrayslate.AutoHidePopup;
  FOriginalAutoHeight := formTrayslate.AutoHeight;
  FOriginalMaxHeight := formTrayslate.MaxHeight;
  FOriginalOpacityHover := formTrayslate.OpacityHover;
  FOriginalOpacityIdle := formTrayslate.OpacityIdle;
  FOriginalConfigLangDetect := formTrayslate.ConfigLangDetect;
  FOriginalLanguage := Language;
  FOriginalEnabledLanguages.Assign(formTrayslate.EnabledLanguages);
  FOriginalProxiedConfigs.Assign(formTrayslate.ProxiedConfigs);
  FOriginalProxy := formTrayslate.Proxy;
  FOriginalTimeout := formTrayslate.Timeout;
  FOriginalUserParameters.Assign(formTrayslate.UserParameters);
  FOriginalFont := formTrayslate.Font;
  FOriginalFontPopup := formTrayslate.FontPopup;
  FOriginalIconBackgroundColor := formTrayslate.IconBackgroundColor;
  FOriginalIconMouseModeFrameColor := formTrayslate.IconMouseModeFrameColor;
  FOriginalIconFontColor := formTrayslate.IconFontColor;
  FOriginalIconFontName := formTrayslate.IconFontName;
  FOriginalIconTwoLang := formTrayslate.IconTwoLang;
  FOriginalIconCircular := formTrayslate.IconCircular;

  ResetHotKeys;

  CheckAutostart.Checked := FOriginalAutoStart;
  SpinMaxLangPairs.Value := FOriginalMaxLangPairs;
  CheckAutoAddLangPairs.Checked := FOriginalAutoAddLangPairs;
  CheckAllowHotkeys.Checked := FOriginalAllowHotkeys;
  CheckRealTime.Checked := FOriginalRealTime;
  SpinRealTimeDelay.Value := FOriginalRealTimeDelay;
  CheckAutoSwap.Checked := FOriginalAutoSwap;
  CheckBuiltInDetect.Checked := FOriginalBuiltInDetect;
  CheckSmartSwap.Checked := FOriginalSmartSwap;
  CheckSmartHard.Checked := FOriginalSmartHard;
  ComboPrimaryLang.ItemIndex := TLanguages.FindIndexByCode(ComboPrimaryLang.Items, FOriginalPrimaryLang);
  ComboSecondaryLang.ItemIndex := TLanguages.FindIndexByCode(ComboSecondaryLang.Items, FOriginalSecondaryLang);
  CheckEnableMouseMode.Checked := FOriginalEnableMouseMode;
  CheckMouseModeCtrl.Checked := FOriginalMouseModeCtrl;
  ComboMouseMode.ItemIndex := Ord(FOriginalMouseMode);
  CheckInsertKey.Checked := FOriginalInsertKey;
  CheckSpellCheck.Checked := FOriginalSpellCheck;
  CheckSpellCheckEmptySuggestions.Checked := FOriginalSpellCheckEmptySuggestions;
  CheckVerticalSplit.Checked := FOriginalVerticalSplit;
  CheckAutoCopy.Checked := FOriginalAutoCopy;
  CheckStayOnTop.Checked := FOriginalStayOnTop;
  CheckHideControls.Checked := FOriginalHideControls;
  CheckAutoHidePopup.Checked := FOriginalAutoHidePopup;
  CheckAutoHeight.Checked := FOriginalAutoHeight;
  SpinMaxHeight.Value := FOriginalMaxHeight;
  TrackOpacityHover.Position := FOriginalOpacityHover;
  TrackOpacityIdle.Position := FOriginalOpacityIdle;

  if FOriginalConfigLangDetect <> string.Empty then
    ComboLangDetect.ItemIndex := Max(formTrayslate.ConfigFiles.IndexOf(FOriginalConfigLangDetect) + 1, 0)
  else
    ComboLangDetect.ItemIndex := 0;

  FillLanguage(FOriginalLanguage);
  for i := 0 to ClbEnabledLang.Count - 1 do
    ClbEnabledLang.Checked[i] := FOriginalEnabledLanguages.Contains(TLanguages.ExtractCodeFromItem(ClbEnabledLang.Items[i]));

  for i := 0 to ClbProxiedConfigs.Count - 1 do
    if formTrayslate.ConfigFiles.Count > i then
      ClbProxiedConfigs.Checked[i] := FOriginalProxiedConfigs.Contains(formTrayslate.ConfigFiles[i]);

  ValueListUserParameters.Strings.Assign(FOriginalUserParameters);

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
  ColorMouseModeFrame.Selected := FOriginalIconMouseModeFrameColor;
  ColorIconFont.Selected := FOriginalIconFontColor;
  ComboIconFontName.Text := FOriginalIconFontName;
  CheckTwoLang.Checked := FOriginalIconTwoLang;
  CheckCircularIcon.Checked := FOriginalIconCircular;

  BtnApply.Enabled := False;
  SetState;
end;

{%EndRegion}

end.
