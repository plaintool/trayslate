//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit mainform;

{$mode ObjFPC}{$H+}
{$codepage utf8}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  Messages,
  {$ENDIF}
  Classes,
  SysUtils,
  DateUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ExtCtrls,
  Menus,
  ActnList,
  StdCtrls,
  StrUtils,
  Clipbrd,
  Buttons,
  Math,
  IniFiles,
  LCLType,
  LMessages,
  mouseandkeyinput,
  globalkeyboardhook,
  globalmousehook,
  translate,
  langtool,
  systemtool;

type

  { TformTrayslate }

  TformTrayslate = class(TForm)
    aAbout: TAction;
    aConfigEditor: TAction;
    aCheckForUpdates: TAction;
    aAddPair: TAction;
    aAutoCheckUpdates: TAction;
    aCopySource: TAction;
    aCopyTarget: TAction;
    aFastMouseModeCtrl: TAction;
    aFastAllowHotKeys: TAction;
    aFastEnableMouseMode: TAction;
    aFastAutoSwap: TAction;
    aFastRealTime: TAction;
    aFastAutoAddLangPairs: TAction;
    aFastHideControls: TAction;
    aFastVerticalSplit: TAction;
    aPopupTranslate: TAction;
    aLangCustom: TAction;
    aLangBulgarian: TAction;
    aMenu: TAction;
    aNewTranslate: TAction;
    ApplicationProp: TApplicationProperties;
    aSettings: TAction;
    aTranslateClipboard: TAction;
    aSwap: TAction;
    aTranslate: TAction;
    aShow: TAction;
    aDonate: TAction;
    aExit: TAction;
    ActionList: TActionList;
    ImageConfig: TImageList;
    MenuBulgarian: TMenuItem;
    MenuItem1: TMenuItem;
    MenuFastMouseModeCtrl: TMenuItem;
    MenuItem2: TMenuItem;
    MenuFastSettings: TMenuItem;
    MenuFastAllowHotKeys: TMenuItem;
    MenuFastEnableMouseMode: TMenuItem;
    MenuFastVerticalSplit: TMenuItem;
    MenuFastAutoSwap: TMenuItem;
    MenuFastRealTime: TMenuItem;
    MenuFastAutoAddLangPairs: TMenuItem;
    MenuFastHideControls: TMenuItem;
    OpenPo: TOpenDialog;
    SbCopySource: TSpeedButton;
    SbCopyTarget: TSpeedButton;
    ComboSource: TComboBox;
    ComboTarget: TComboBox;
    FlowPairs: TFlowPanel;
    ImageButtons: TImageList;
    MemoSource: TMemo;
    MemoTarget: TMemo;
    MenuExit: TMenuItem;
    MenuSettings: TMenuItem;
    MenuLangPairs: TMenuItem;
    MenuAutoCheckUpdates: TMenuItem;
    MenuConfigEditor: TMenuItem;
    MenuConfig: TMenuItem;
    MenuHelp: TMenuItem;
    MenuDonate: TMenuItem;
    MenuCheckForUpdates: TMenuItem;
    MenuAbout: TMenuItem;
    MenuLanguage: TMenuItem;
    MenuShow: TMenuItem;
    MenuShowTranslate: TMenuItem;
    PanelButtonTarget: TPanel;
    PanelTarget: TPanel;
    PanelSource: TPanel;
    PanelButtonSource: TPanel;
    PanelPairs: TPanel;
    PanelLang: TPanel;
    PopupTray: TPopupMenu;
    SbMenu: TSpeedButton;
    SbNewTranslate: TSpeedButton;
    SbAddPair: TSpeedButton;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    SbSwap: TSpeedButton;
    SbTranslate: TSpeedButton;
    Separator3: TMenuItem;
    Separator4: TMenuItem;
    Separator5: TMenuItem;
    Separator6: TMenuItem;
    Separator9: TMenuItem;
    Splitter: TSplitter;
    TimerUnapply: TTimer;
    TimerHideHint: TTimer;
    TimerAnimate: TTimer;
    TimerTranslate: TTimer;
    TimerClick: TTimer;
    TimerActive: TTimer;
    TrayIcon: TTrayIcon;
    aLangTurkish: TAction;
    aLangGreek: TAction;
    aLangHebrew: TAction;
    aLangIndonesian: TAction;
    aLangPolish: TAction;
    aLangRomanian: TAction;
    aLangSwedish: TAction;
    aLangCzech: TAction;
    aLangDanish: TAction;
    aLangDutch: TAction;
    aLangFinnish: TAction;
    aLangEnglish: TAction;
    aLangRussian: TAction;
    aLangGerman: TAction;
    aLangSpanish: TAction;
    aLangFrench: TAction;
    aLangItalian: TAction;
    aLangPortuguese: TAction;
    aLangJapanese: TAction;
    aLangKorean: TAction;
    aLangChinese: TAction;
    aLangArabic: TAction;
    aLangUkrainian: TAction;
    aLangBelarusian: TAction;
    aLangHindi: TAction;
    MenuTurkish: TMenuItem;
    MenuGreek: TMenuItem;
    MenuHebrew: TMenuItem;
    MenuIndonesian: TMenuItem;
    MenuPolish: TMenuItem;
    MenuRomanian: TMenuItem;
    MenuSwedish: TMenuItem;
    MenuCzech: TMenuItem;
    MenuDanish: TMenuItem;
    MenuDutch: TMenuItem;
    MenuFinnish: TMenuItem;
    MenuEnglish: TMenuItem;
    MenuRussian: TMenuItem;
    MenuGerman: TMenuItem;
    MenuSpanish: TMenuItem;
    MenuFrench: TMenuItem;
    MenuItalian: TMenuItem;
    MenuPortuguese: TMenuItem;
    MenuJapanese: TMenuItem;
    MenuKorean: TMenuItem;
    MenuChinese: TMenuItem;
    MenuArabic: TMenuItem;
    MenuUkrainian: TMenuItem;
    MenuBelarusian: TMenuItem;
    MenuHindi: TMenuItem;
    procedure aFastAllowHotKeysExecute(Sender: TObject);
    procedure aFastAutoAddLangPairsExecute(Sender: TObject);
    procedure aFastAutoSwapExecute(Sender: TObject);
    procedure aFastEnableMouseModeExecute(Sender: TObject);
    procedure aFastHideControlsExecute(Sender: TObject);
    procedure aFastMouseModeCtrlExecute(Sender: TObject);
    procedure aFastRealTimeExecute(Sender: TObject);
    procedure aFastVerticalSplitExecute(Sender: TObject);
    procedure aLangBulgarianExecute(Sender: TObject);
    procedure aLangCustomExecute(Sender: TObject);
    procedure ApplicationPropUserInput(Sender: TObject; Msg: cardinal);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ApplicationPropActivate(Sender: TObject);
    procedure ApplicationPropDeactivate(Sender: TObject);
    procedure ApplicationPropShowHint(var HintStr: string; var CanShow: boolean; var HintInfo: THintInfo);
    procedure ApplicationPropException(Sender: TObject; E: Exception);
    procedure ScreenActiveFormChanged(Sender: TObject);
    procedure OnKeyboardEvent(Sender: TObject; const Info: TKeyboardEventInfo);
    procedure OnHookLeftDown(Sender: TObject; const Info: TMouseEventInfo);
    procedure OnHookLeftUp(Sender: TObject; const Info: TMouseEventInfo);
    procedure OnTranslateMouseMode(Data: PtrInt);
    procedure aConfigEditorExecute(Sender: TObject);
    procedure aSettingsExecute(Sender: TObject);
    procedure aNewTranslateExecute(Sender: TObject);
    procedure aTranslateExecute(Sender: TObject);
    procedure aTranslateClipboardExecute(Sender: TObject);
    procedure aPopupTranslateExecute(Sender: TObject);
    procedure aSwapExecute(Sender: TObject);
    procedure aCopySourceExecute(Sender: TObject);
    procedure aCopyTargetExecute(Sender: TObject);
    procedure aShowExecute(Sender: TObject);
    procedure aAddPairExecute(Sender: TObject);
    procedure aMenuExecute(Sender: TObject);
    procedure aAutoCheckUpdatesExecute(Sender: TObject);
    procedure aCheckForUpdatesExecute(Sender: TObject);
    procedure aDonateExecute(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure ComboSourceCloseUp(Sender: TObject);
    procedure ComboTargetCloseUp(Sender: TObject);
    procedure ComboSourceDropDown(Sender: TObject);
    procedure ComboTargetDropDown(Sender: TObject);
    procedure ComboSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ComboTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoSourceKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure PanelLangResize(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure SbSwapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure TimerActiveTimer(Sender: TObject);
    procedure TimerAnimateStopTimer(Sender: TObject);
    procedure TimerAnimateTimer(Sender: TObject);
    procedure TimerHideHintTimer(Sender: TObject);
    procedure TimerUnapplyTimer(Sender: TObject);
    procedure TimerTranslateTimer(Sender: TObject);
    procedure TimerClickTimer(Sender: TObject);
    procedure TrayIconMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure TrayIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure TrayIconClick(Sender: TObject);
    procedure LabelMouseEnter(Sender: TObject);
    procedure LabelMouseLeave(Sender: TObject);
    procedure LabelLangMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure MenuConfigItemClick(Sender: TObject);
    procedure MenuPairClick(Sender: TObject);
    procedure PopupTrayClose(Sender: TObject);
    procedure PopupTrayPopup(Sender: TObject);
    procedure aLangTurkishExecute(Sender: TObject);
    procedure aLangGreekExecute(Sender: TObject);
    procedure aLangHebrewExecute(Sender: TObject);
    procedure aLangIndonesianExecute(Sender: TObject);
    procedure aLangPolishExecute(Sender: TObject);
    procedure aLangRomanianExecute(Sender: TObject);
    procedure aLangSwedishExecute(Sender: TObject);
    procedure aLangCzechExecute(Sender: TObject);
    procedure aLangDanishExecute(Sender: TObject);
    procedure aLangDutchExecute(Sender: TObject);
    procedure aLangFinnishExecute(Sender: TObject);
    procedure aLangEnglishExecute(Sender: TObject);
    procedure aLangRussianExecute(Sender: TObject);
    procedure aLangGermanExecute(Sender: TObject);
    procedure aLangSpanishExecute(Sender: TObject);
    procedure aLangFrenchExecute(Sender: TObject);
    procedure aLangItalianExecute(Sender: TObject);
    procedure aLangPortugueseExecute(Sender: TObject);
    procedure aLangJapaneseExecute(Sender: TObject);
    procedure aLangKoreanExecute(Sender: TObject);
    procedure aLangChineseExecute(Sender: TObject);
    procedure aLangArabicExecute(Sender: TObject);
    procedure aLangUkrainianExecute(Sender: TObject);
    procedure aLangBelarusianExecute(Sender: TObject);
    procedure aLangHindiExecute(Sender: TObject);
  private
    FTrans: TTranslate;
    FTransDetect: TTranslate;
    FProxy: TProxy;
    FTimeout: TTimeout;
    FCancelled: boolean;
    FTopMost: boolean;
    FLeftButton: boolean;
    FLastEnterTime: DWORD;
    FLastHotkeyTime: DWORD;
    FLastMouseInfo: TMouseEventInfo;
    FMemoSourceCaretPos: integer;
    FPrevSourceText: string;
    FPrevTargetText: string;
    FLangPairs: TStringList;
    FTranslateThread: TTranslateThread;
    FMouseHook: TGlobalMouseHook;
    FKeyHook: TGlobalKeyboardHook;
    FPopupOpen: boolean;
    FHint: THintWindow;
    FFontPopup: TFont;
    FUnapplyCtrl: boolean;
    FUnapplyC: boolean;
    FUnapplyV: boolean;
    FLastKeyTime: DWORD;
    FLastCtrlTime: DWORD;
    FLastCTime: DWORD;
    FLastXTime: DWORD;
    FLastVTime: DWORD;
    FAutoHeightAfter: boolean;
    FPrevMouseDown: TMouseEventInfo;
    FDoubleClickPending: boolean;

    // Non sorted combo named languages
    FLanguages: TStringList;
    FLanguagesTarget: TStringList;

    // Settings
    FFormSettingsLoaded: boolean;
    FConfigFile: string;
    FConfigFiles: TStringList;
    FConfigTitles: TStringList;
    FConfigColors: TStringList;
    FConfigImages: TStringList;
    FConfigLangDetect: string;
    FLangSource: string;
    FLangTarget: string;
    FMaxLangPairs: integer;
    FRealTimeDelay: integer;
    FSmartSwap: boolean;
    FSmartHard: boolean;
    FPrimaryLang: string;
    FSecondaryLang: string;
    FMouseMode: TMouseMode;
    FStayOnTop: boolean;
    FAutoHeight: boolean;
    FMaxHeight: integer;
    FOpacityHover: integer;
    FOpacityIdle: integer;
    FAutoCheckUpdates: boolean;
    FUpdatesChecked: boolean;
    FSplitRatio: double;
    FFormConfigLeft: integer;
    FFormConfigTop: integer;
    FFormConfigWidth: integer;
    FFormConfigHeight: integer;
    FFormPopupLeft: integer;
    FFormPopupTop: integer;
    FFormPopupWidth: integer;
    FFormPopupHeight: integer;
    FFormAboutWidth: integer;
    FFormAboutHeight: integer;
    FFormSettingsLeft: integer;
    FFormSettingsTop: integer;
    FFormSettingsWidth: integer;
    FFormSettingsHeight: integer;
    FFormSettingsSplit: integer;
    FCustomPoFile: string;
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

    // TrayIcon
    FAutoStart: boolean;
    FIconBackgroundColor: TColor;
    FIconFontColor: TColor;
    FIconFontName: string;
    FIconTwoLang: boolean;

    procedure SetAutoStart(Value: boolean);
    procedure SetAutoAddLangPairs(Value: boolean);
    procedure SetAutoSwap(Value: boolean);
    procedure SetAllowHotkeys(Value: boolean);
    procedure SetEnableMouseMode(Value: boolean);
    procedure SetHideControls(Value: boolean);
    procedure SetMouseModeCtrl(Value: boolean);
    procedure SetRealTime(Value: boolean);
    procedure SetVerticalSplit(Value: boolean);
    procedure SetProxy(Value: TProxy);

    procedure ChangeSourceLang(NewLang: string; AddRecentPairs: boolean = True);
    procedure ChangeTargetLang(NewLang: string; AddRecentPairs: boolean = True);
    function SwapLanguages(ASwapTranslate: boolean = False; AddRecentPairs: boolean = True): boolean;
    procedure AddLangPair(const Pair: string; ToEnd: boolean = True);
    procedure SelectPair(const Pair: string; RunTranslate: boolean = True);
    procedure SelectPairConfig(const LangPairIndex: integer; RunTranslate: boolean = True);
    procedure GlobalCtrlC;
    procedure GlobalCtrlV;
    procedure SetLanguage(aLanguage: string = string.Empty);
  protected
    {$IFDEF WINDOWS}
    procedure WMActivate(var Message: TLMActivate); message LM_ACTIVATE;
    procedure WndProc(var TheMessage: TLMessage); override;
    {$ENDIF}
  public
    FAutoAddLangPairs: boolean;
    FAllowHotKeys: boolean;
    FRealTime: boolean;
    FAutoSwap: boolean;
    FEnableMouseMode: boolean;
    FMouseModeCtrl: boolean;
    FHideControls: boolean;
    FVerticalSplit: boolean;

    procedure LoadConfig(SetDefault: boolean = True);
    procedure SetDefaultSettings;
    procedure SetDefaultHotKeys;
    procedure BuildConfigMenu;
    procedure RebuildLangPairsPanel(Data: PtrInt);
    procedure SetIcon;
    procedure SetHints;
    procedure SetAnimate(Angle: integer);
    procedure DoRealign(Data: PtrInt);
    procedure DoRealignSplit(Data: PtrInt);
    procedure UpdateCheckConfigMenu;
    procedure UpdateCheckMenuPair;
    function UpdateSourceLanguage(const Lang: string): string;
    function UpdateTargetLanguage(const Lang: string): string;
    function UpdatePairLanguage(const Pair: string): string;
    procedure DoCheckUpdates(Data: PtrInt);
    procedure ShowCustomHint(const AText: string; X: integer = 0; Y: integer = 0; Duration: integer = 3000);
    procedure AdjustPopupHeight(AText: string);
    procedure ShowPopup(const SourceText: string; X: integer = 0; Y: integer = 0);
    procedure ShowButton(const SourceText: string; X: integer = 0; Y: integer = 0);
    procedure SetVerticalMode;
    function GetLangCodeFromPoFile(const AFileName: string): string;
    function LoadCustomPoFile(const AFileName: string): string;

    {$IFDEF WINDOWS}
    procedure RegisterHotKeys;
    procedure UnregisterHotKeys;
    {$ENDIF}

    function TranslateThread(ATrans: TTranslate; AText: string; AMemo: TMemo = nil): string;
    procedure ThreadDone(Sender: TObject);
    procedure CancelTranslate;
    procedure DetectLanguage(AText: string);
    procedure TranslateMemo(ADetectLanguage: boolean = True);
    procedure TranslatePopup(AText: string; X: integer = 0; Y: integer = 0);
    procedure TranslateFromClipboard;
    procedure TranslateClipboard;
    procedure TranslateClipboardPopup(NearMouse: boolean = False);
    procedure TranslateFromControl(Data: PtrInt);
    procedure TranslateControl(Data: PtrInt);
    procedure TranslateControlPopup(Data: PtrInt);
    procedure TranslateMouseMode(ACursorPos: TPoint);

    // Base properties
    property Trans: TTranslate read FTrans write FTrans;
    property TransDetect: TTranslate read FTransDetect write FTransDetect;
    property TopMost: boolean read FTopMost write FTopMost;

    // Settings properties
    property ConfigFile: string read FConfigFile write FConfigFile;
    property ConfigFiles: TStringList read FConfigFiles write FConfigFiles;
    property ConfigTitles: TStringList read FConfigTitles write FConfigTitles;
    property ConfigColors: TStringList read FConfigColors write FConfigColors;
    property ConfigImages: TStringList read FConfigImages write FConfigImages;
    property ConfigLangDetect: string read FConfigLangDetect write FConfigLangDetect;
    property Proxy: TProxy read FProxy write SetProxy;
    property Timeout: TTimeout read FTimeout write FTimeout;
    property AutoStart: boolean read FAutoStart write SetAutoStart;
    property IconBackgroundColor: TColor read FIconBackgroundColor write FIconBackgroundColor;
    property IconFontColor: TColor read FIconFontColor write FIconFontColor;
    property IconFontName: string read FIconFontName write FIconFontName;
    property IconTwoLang: boolean read FIconTwoLang write FIconTwoLang;
    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property LangPairs: TStringList read FLangPairs write FLangPairs;
    property MaxLangPairs: integer read FMaxLangPairs write FMaxLangPairs;
    property AutoAddLangPairs: boolean read FAutoAddLangPairs write SetAutoAddLangPairs;
    property AllowHotKeys: boolean read FAllowHotKeys write SetAllowHotKeys;
    property RealTime: boolean read FRealTime write SetRealTime;
    property RealTimeDelay: integer read FRealTimeDelay write FRealTimeDelay;
    property AutoSwap: boolean read FAutoSwap write SetAutoSwap;
    property SmartSwap: boolean read FSmartSwap write FSmartSwap;
    property SmartHard: boolean read FSmartHard write FSmartHard;
    property PrimaryLang: string read FPrimaryLang write FPrimaryLang;
    property SecondaryLang: string read FSecondaryLang write FSecondaryLang;
    property EnableMouseMode: boolean read FEnableMouseMode write SetEnableMouseMode;
    property MouseModeCtrl: boolean read FMouseModeCtrl write SetMouseModeCtrl;
    property MouseMode: TMouseMode read FMouseMode write FMouseMode;
    property VerticalSplit: boolean read FVerticalSplit write SetVerticalSplit;
    property StayOnTop: boolean read FStayOnTop write FStayOnTop;
    property FontPopup: TFont read FFontPopup write FFontPopup;
    property HideControls: boolean read FHideControls write SetHideControls;
    property AutoHeight: boolean read FAutoHeight write FAutoHeight;
    property MaxHeight: integer read FMaxHeight write FMaxHeight;
    property OpacityHover: integer read FOpacityHover write FOpacityHover;
    property OpacityIdle: integer read FOpacityIdle write FOpacityIdle;
    property AutoCheckUpdates: boolean read FAutoCheckUpdates write FAutoCheckUpdates;
    property SplitRatio: double read FSplitRatio write FSplitRatio;
    property FormConfigLeft: integer read FFormConfigLeft write FFormConfigLeft;
    property FormConfigTop: integer read FFormConfigTop write FFormConfigTop;
    property FormConfigWidth: integer read FFormConfigWidth write FFormConfigWidth;
    property FormConfigHeight: integer read FFormConfigHeight write FFormConfigHeight;
    property FormPopupLeft: integer read FFormPopupLeft write FFormPopupLeft;
    property FormPopupTop: integer read FFormPopupTop write FFormPopupTop;
    property FormPopupWidth: integer read FFormPopupWidth write FFormPopupWidth;
    property FormPopupHeight: integer read FFormPopupHeight write FFormPopupHeight;
    property FormSettingsLeft: integer read FFormSettingsLeft write FFormSettingsLeft;
    property FormSettingsTop: integer read FFormSettingsTop write FFormSettingsTop;
    property FormSettingsWidth: integer read FFormSettingsWidth write FFormSettingsWidth;
    property FormSettingsHeight: integer read FFormSettingsHeight write FFormSettingsHeight;
    property FormSettingsSplit: integer read FFormSettingsSplit write FFormSettingsSplit;
    property FormAboutWidth: integer read FFormAboutWidth write FFormAboutWidth;
    property FormAboutHeight: integer read FFormAboutHeight write FFormAboutHeight;
    property CustomPoFile: string read FCustomPoFile write FCustomPoFile;
    property MouseHook: TGlobalMouseHook read FMouseHook write FMouseHook;
    property KeyHook: TGlobalKeyboardHook read FKeyHook write FKeyHook;
    property HotKeyApp: THotKeyData read FHotKeyApp write FHotKeyApp;
    property HotKeyTransSwap: THotKeyData read FHotKeyTransSwap write FHotKeyTransSwap;
    property HotKeyTransFromClipboard: THotKeyData read FHotKeyTransFromClipboard write FHotKeyTransFromClipboard;
    property HotKeyTransClipboard: THotKeyData read FHotKeyTransClipboard write FHotKeyTransClipboard;
    property HotKeyTransClipboardPopup: THotKeyData read FHotKeyTransClipboardPopup write FHotKeyTransClipboardPopup;
    property HotKeyTransFromControl: THotKeyData read FHotKeyTransFromControl write FHotKeyTransFromControl;
    property HotKeyTransControl: THotKeyData read FHotKeyTransControl write FHotKeyTransControl;
    property HotKeyTransControlPopup: THotKeyData read FHotKeyTransControlPopup write FHotKeyTransControlPopup;
    property HotKeyRecent1: THotKeyData read FHotKeyRecent1 write FHotKeyRecent1;
    property HotKeyRecent2: THotKeyData read FHotKeyRecent2 write FHotKeyRecent2;
    property HotKeyRecent3: THotKeyData read FHotKeyRecent3 write FHotKeyRecent3;
    property HotKeyRecent4: THotKeyData read FHotKeyRecent4 write FHotKeyRecent4;
    property HotKeyRecent5: THotKeyData read FHotKeyRecent5 write FHotKeyRecent5;
    property HotKeyRecent6: THotKeyData read FHotKeyRecent6 write FHotKeyRecent6;
    property HotKeyRecent7: THotKeyData read FHotKeyRecent7 write FHotKeyRecent7;
    property HotKeyRecent8: THotKeyData read FHotKeyRecent8 write FHotKeyRecent8;
    property HotKeyRecent9: THotKeyData read FHotKeyRecent9 write FHotKeyRecent9;
  end;

var
  formTrayslate: TformTrayslate;

const
  DOUBLE_ENTER_INTERVAL = 200; // ms
  HOTKEY_INTERVAL = 500; // ms
  MOUSE_MODE_INTERVAL = 100; // ms
  MOUSE_MODE_DELTA = 20; // pixel
  MOUSE_DBL_INTERVAL = 500; // ms
  BUTTON_DELTA = 10;

  MIDDLE_MOUSE = 'Middle-Click';
  DEF_LANGDETECT = 'languagedetect.ini';

resourcestring
  rtrayslate = 'Trayslate';
  rswap = 'Swap (%s) with text (%s)';
  rnoconfig = 'Configuration file not found! Create it in the configuration editor.';
  rtoremovepair = ' to remove pair';
  ropenpofiletr = 'Language File (*.po)|*.po';

implementation

uses formdonate, formabout, formsettings, formconfig, formpopup, formbutton, settings, languages, formattool;

  {$R *.lfm}

  { TformTrayslate }

  { Form Events }

procedure TformTrayslate.FormCreate(Sender: TObject);
begin
  // Default values
  SetDefaultSettings;

  FConfigFile := string.Empty;
  FUpdatesChecked := False;
  FAutoCheckUpdates := True;
  FLangTarget := Language;
  FFormConfigLeft := 0;
  FFormConfigTop := 0;
  FFormConfigWidth := 0;
  FFormConfigHeight := 0;
  FFormPopupLeft := 0;
  FFormPopupTop := 0;
  FFormPopupWidth := 0;
  FFormPopupHeight := 0;
  FFormSettingsLeft := 0;
  FFormSettingsTop := 0;
  FFormSettingsWidth := 0;
  FFormSettingsHeight := 0;
  FFormSettingsSplit := 0;
  FFormAboutWidth := 0;
  FFormAboutHeight := 0;
  FLastEnterTime := 0;
  FLastHotkeyTime := 0;
  FTranslateThread := nil;
  FCustomPoFile := string.Empty;
  FSplitRatio := 0.5;
  FCancelled := False;
  FPopupOpen := False;
  FUnapplyCtrl := False;
  FUnapplyC := False;
  FUnapplyV := False;
  FLastKeyTime := 0;
  FLastCtrlTime := 0;
  FLastXTime := 0;
  FLastCTime := 0;
  FLastVTime := 0;
  FillChar(FPrevMouseDown, SizeOf(FPrevMouseDown), 0);
  FDoubleClickPending := False;

  // Components config
  Left := Screen.WorkAreaRect.Right - Width - 30;
  Top := Screen.WorkAreaRect.Bottom - Height - 50;

  aNewTranslate.ImageIndex := ThemeValue(8, 9);
  aSwap.ImageIndex := ThemeValue(0, 1);
  aTranslate.ImageIndex := ThemeValue(2, 3);
  aAddPair.ImageIndex := ThemeValue(4, 5);
  aMenu.ImageIndex := ThemeValue(6, 7);
  aCopySource.ImageIndex := ThemeValue(10, 11);
  aCopyTarget.ImageIndex := ThemeValue(10, 11);
  SbCopySource.PressedImageIndex := ThemeValue(12, 13);
  SbCopyTarget.PressedImageIndex := ThemeValue(12, 13);
  FLeftButton := True;

  FTrans := TTranslate.Create;
  FTransDetect := TTranslate.Create;
  FLanguages := TStringList.Create;
  FLanguagesTarget := TStringList.Create;
  FLangPairs := TStringList.Create;

  // Load form settings
  FFormSettingsLoaded := LoadFormSettings(Self);

  // Set cursor to end of text
  MemoSource.SelStart := Length(MemoSource.Text);
  MemoSource.SelLength := 0;

  // Components config after load settings
  SetProxy(Proxy);
  TimerTranslate.Interval := Max(RealTimeDelay, 1);
  aAutoCheckUpdates.Checked := FAutoCheckUpdates;
  aFastAllowHotKeys.Checked := FAllowHotKeys;
  aFastEnableMouseMode.Checked := FEnableMouseMode;
  aFastMouseModeCtrl.Checked := FMouseModeCtrl;
  aFastVerticalSplit.Checked := FVerticalSplit;
  aFastHideControls.Checked := FHideControls;
  aFastAutoSwap.Checked := FAutoSwap;
  aFastAutoAddLangPairs.Checked := FAutoAddLangPairs;
  aFastRealTime.Checked := FRealTime;

  // Load config files
  FConfigFiles := TStringList.Create;
  FConfigTitles := TStringList.Create;
  FConfigColors := TStringList.Create;
  FConfigImages := TStringList.Create;
  GetIniFiles(FConfigFiles);
  BuildConfigMenu;
  FConfigLangDetect := GetConfigFullPath(FConfigLangDetect, FConfigFiles);

  if (FConfigFiles.IndexOf(FConfigFile) < 0) then
  begin
    if FConfigFiles.Count > 0 then
      FConfigFile := FConfigFiles[0]
    else
    begin
      FConfigFile := string.Empty;
      ShowMessage(rnoconfig);
    end;
  end;

  // Load current config
  LoadConfig;

  // Build Recent Lang Pairs Panel
  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);

  // Set tray icon
  SetIcon;
  SetHints;

  // Events assign
  Screen.OnActiveFormChange := @ScreenActiveFormChanged;

  {$IFDEF WINDOWS}
  RegisterHotKeys;

  FMouseHook := TGlobalMouseHook.Create;
  FMouseHook.OnLeftDown := @OnHookLeftDown;
  FMouseHook.OnLeftUp := @OnHookLeftUp;
  FMouseHook.Enabled := FEnableMouseMode;
  FMouseHook.EditFieldOnly := True;

  FKeyHook:=TGlobalKeyboardHook.Create;
  FKeyHook.OnKeyEvent := @OnKeyboardEvent;
  FKeyHook.Enabled := FEnableMouseMode;
  {$ENDIF}

  // Set language
  SetLanguage(Language);

  FTopMost := False;
end;

procedure TformTrayslate.FormDestroy(Sender: TObject);
begin
  TimerAnimate.Enabled := False;
  TimerActive.Enabled := False;
  TimerTranslate.Enabled := False;
  TimerClick.Enabled := False;
  if TimerUnapply.Enabled then
    TimerUnapplyTimer(Self);

  {$IFDEF WINDOWS}
  UnregisterHotKeys;

  FMouseHook.Enabled := False;
  FreeAndNil(FMouseHook);
  FKeyHook.Enabled:=False;
  FreeAndNil(FKeyHook);
  {$ENDIF}
  if FFormSettingsLoaded then
    SaveFormSettings(Self);
  FreeAndNil(FLangPairs);
  FreeAndNil(FLanguages);
  FreeAndNil(FLanguagesTarget);
  FreeAndNil(FConfigFiles);
  FreeAndNil(FConfigTitles);
  FreeAndNil(FConfigColors);
  FreeAndNil(FConfigImages);
  FreeAndNil(FTrans);
  FreeAndNil(FTransDetect);
  FreeAndNil(FHint);
  FreeAndNil(FFontPopup);
end;

procedure TformTrayslate.FormShow(Sender: TObject);
begin
  SetHints;

  // Check new version if needed
  if not FUpdatesChecked and AutoCheckUpdates then
  begin
    // Delay execution until UI is ready
    Application.QueueAsyncCall(@DoCheckUpdates, 0);
    FUpdatesChecked := True;
  end;

  // Calc Splitter position
  case PanelTarget.Align of
    alBottom:
      PanelTarget.Height := Round((PanelSource.Height + PanelTarget.Height) * FSplitRatio);

    alRight:
      PanelTarget.Width := Round((PanelSource.Width + PanelTarget.Width) * FSplitRatio);
    else
      ;
  end;
  SetVerticalMode;
end;

procedure TformTrayslate.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := False;
  Hide;
end;

procedure TformTrayslate.FormActivate(Sender: TObject);
begin
  FTopMost := True;
end;

procedure TformTrayslate.FormResize(Sender: TObject);
begin
  PanelLang.Top := 0;

  Application.QueueAsyncCall(@DoRealignSplit, 0);
end;

procedure TformTrayslate.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Hide;
end;

procedure TformTrayslate.FormWindowStateChange(Sender: TObject);
begin
  if WindowState = wsMinimized then
  begin
    if TopMost then Hide;
    WindowState := wsNormal;
  end;
end;

{$IFDEF WINDOWS}

procedure TformTrayslate.WMActivate(var Message: TLMActivate);
begin
  inherited;
  if Message.Active <> WA_INACTIVE then
    FTopMost := True;
end;

procedure TformTrayslate.WndProc(var TheMessage: TLMessage);
var
  LangIndex: Integer;
begin
  if TheMessage.msg = WM_HOTKEY then
  begin
    if GetTickCountXp - FLastHotkeyTime < HOTKEY_INTERVAL then
      exit;

    FLastHotkeyTime := GetTickCountXp;

    case TheMessage.WParam of

      HOTKEY_APP:
      begin
        if Showing then Hide
        else
          Show;
        BringToFront;
        FTopMost := True;
      end;

      HOTKEY_TRANS_SWAP:
      begin
        aSwap.Execute;
        ShowCustomHint(TrayIcon.Hint);
      end;

      HOTKEY_TRANS_FROM_CLIPBOARD:
      begin
        TranslateFromClipboard;
      end;

      HOTKEY_TRANS_CLIPBOARD:
      begin
        TranslateClipboard;
      end;

      HOTKEY_TRANS_CLIPBOARD_POPUP:
      begin
        TranslateClipboardPopup(True);
      end;

      HOTKEY_TRANS_FROM_CONTROL:
      begin
        Application.QueueAsyncCall(@TranslateFromControl, 0);
      end;

      HOTKEY_TRANS_CONTROL:
      begin
        Application.QueueAsyncCall(@TranslateControl, 0);
      end;

      HOTKEY_TRANS_CONTROL_POPUP:
      begin
        Application.QueueAsyncCall(@TranslateControlPopup, 0);
      end;

      else
        if (TheMessage.WParam >= HOTKEY_RECENT1) and (TheMessage.WParam <= HOTKEY_RECENT9) then
        begin
          LangIndex := TheMessage.WParam - 11;

          if (LangIndex >= 0) and (LangIndex < MenuLangPairs.Count) then
          begin
            MenuLangPairs.Items[LangIndex].Click;
            ShowCustomHint(TrayIcon.Hint);
          end;
        end;
    end;
  end;

  inherited WndProc(TheMessage);
end;

{$ENDIF}

procedure TformTrayslate.ScreenActiveFormChanged(Sender: TObject);
begin
  if Assigned(formConfigTrayslate) and formConfigTrayslate.HandleAllocated and (Screen.ActiveForm = formConfigTrayslate) then
    formConfigTrayslate.Invalidate;
end;

{ Application Events }

procedure TformTrayslate.ApplicationPropActivate(Sender: TObject);
begin
  FTopMost := True;
  if Assigned(formConfigTrayslate) and formConfigTrayslate.HandleAllocated then
    formConfigTrayslate.Invalidate;
end;

procedure TformTrayslate.ApplicationPropDeactivate(Sender: TObject);
begin
  TimerActive.Enabled := True;
end;

procedure TformTrayslate.ApplicationPropShowHint(var HintStr: string; var CanShow: boolean; var HintInfo: THintInfo);
begin
  TimerHideHintTimer(Self);
end;

procedure TformTrayslate.ApplicationPropException(Sender: TObject; E: Exception);
begin
  MessageDlg(rtrayslate, E.Message, mtWarning, [mbOK], 0);
end;

procedure TformTrayslate.ApplicationPropUserInput(Sender: TObject; Msg: cardinal);
var
  MousePos: TPoint;
  CtrlUnderMouse: TControl;
begin
  if Msg = LM_LBUTTONDOWN then
  begin
    MousePos := ScreenToClient(Mouse.CursorPos);
    CtrlUnderMouse := ControlAtPos(MousePos, [capfRecursive, capfAllowWinControls]);

    if (CtrlUnderMouse = ComboSource) or (CtrlUnderMouse = ComboTarget) then
      Exit;

    if (Screen.ActiveControl = ComboSource) then
    begin
      Self.ActiveControl := nil;
      ComboSource.SelLength := 0;
    end
    else if (Screen.ActiveControl = ComboTarget) then
    begin
      Self.ActiveControl := nil;
      ComboTarget.SelLength := 0;
    end;
  end;
end;

{ MouseHook Events}

procedure TFormTrayslate.OnKeyboardEvent(Sender: TObject; const Info: TKeyboardEventInfo);
var
  packedCoords: PtrInt;
  Tick: DWORD;
begin
  Tick := GetTickCountXp;

  if not Info.IsDown then Exit;
  if Info.IsInjected then Exit;

  // Signals about pressing physical keys
  FLastKeyTime := Tick;
  if Info.KeyCode = VK_CONTROL then
    FLastCtrlTime := Tick;
  if Info.KeyCode = Ord('C') then
    FLastCTime := Tick;
  if Info.KeyCode = Ord('X') then
    FLastXTime := Tick;
  if Info.KeyCode = Ord('V') then
    FLastVTime := Tick;

  // Detecting select all for mouse mode
  if (Info.CtrlDown) and (Info.KeyCode = Ord('A')) and (MouseMode = mmShowTranslateButton) then
  begin
    packedCoords := Mouse.CursorPos.Y shl 16 + Mouse.CursorPos.X;
    Application.QueueAsyncCall(@OnTranslateMouseMode, packedCoords);
  end;
end;

procedure TFormTrayslate.OnHookLeftDown(Sender: TObject; const Info: TMouseEventInfo);
var
  TimeDiff: DWORD;
  dx, dy: integer;
begin
  // Store current down info for later use in OnHookLeftUp (existing code)
  FLastMouseInfo := Info;

  // Double-click detection using previous down event
  TimeDiff := Info.Time - FPrevMouseDown.Time;
  dx := Info.X - FPrevMouseDown.X;
  dy := Info.Y - FPrevMouseDown.Y;

  if (TimeDiff <= MOUSE_DBL_INTERVAL) and (dx * dx + dy * dy <= MOUSE_MODE_DELTA * MOUSE_MODE_DELTA) then
    FDoubleClickPending := True
  else
    FDoubleClickPending := False;

  // Store this down as previous for future comparisons
  FPrevMouseDown := Info;
end;

procedure TFormTrayslate.OnHookLeftUp(Sender: TObject; const Info: TMouseEventInfo);
var
  packedCoords: PtrInt;
  dx, dy: integer;
  TimeDiff: DWORD;
  DistanceSq: integer;
begin
  // Case 1: double-click (detected on previous down)
  if FDoubleClickPending then
  begin
    if (not MouseModeCtrl) or (FLastMouseInfo.CtrlDown and Info.CtrlDown) then
    begin
      packedCoords := Info.Y shl 16 + Info.X;
      Application.QueueAsyncCall(@OnTranslateMouseMode, packedCoords);
    end;
    FDoubleClickPending := False;
    Exit;
  end;

  // Case 2: old logic (long press with movement)
  TimeDiff := Info.Time - FLastMouseInfo.Time;
  dx := Info.X - FLastMouseInfo.X;
  dy := Info.Y - FLastMouseInfo.Y;
  DistanceSq := dx * dx + dy * dy;

  if (TimeDiff > MOUSE_MODE_INTERVAL) and (DistanceSq > MOUSE_MODE_DELTA * MOUSE_MODE_DELTA) then
  begin
    if (not MouseModeCtrl) or (FLastMouseInfo.CtrlDown and Info.CtrlDown) then
    begin
      packedCoords := Info.Y shl 16 + Info.X;
      Application.QueueAsyncCall(@OnTranslateMouseMode, packedCoords);
    end;
  end;
end;

procedure TFormTrayslate.OnTranslateMouseMode(Data: PtrInt);
begin
  TranslateMouseMode(Point(Data and $FFFF, Data shr 16));
end;

{ Actions Events }

procedure TformTrayslate.aShowExecute(Sender: TObject);
begin
  if Showing then
  begin
    FTopMost := True;
    BringToFront;
  end
  else
    Show;
end;

procedure TformTrayslate.aConfigEditorExecute(Sender: TObject);
begin
  if not Assigned(formConfigTrayslate) then
    formConfigTrayslate := TformConfigTrayslate.Create(Application);

  formConfigTrayslate.Position := poDesigned;

  if FormConfigLeft > 0 then
    formConfigTrayslate.Left := FormConfigLeft
  else
    formConfigTrayslate.Position := poDesktopCenter;

  if FormConfigTop > 0 then
    formConfigTrayslate.Top := FormConfigTop
  else
    formConfigTrayslate.Position := poDesktopCenter;

  if FormConfigWidth > 0 then
    formConfigTrayslate.Width := FormConfigWidth;

  if FormConfigHeight > 0 then
    formConfigTrayslate.Height := FormConfigHeight;

  formConfigTrayslate.Show;
  formConfigTrayslate.BringToFront;
end;

procedure TformTrayslate.aSettingsExecute(Sender: TObject);
begin
  if Assigned(formSettingsTrayslate) then
  begin
    if formSettingsTrayslate.Visible and formSettingsTrayslate.CanSetFocus then
      formSettingsTrayslate.SetFocus;
    exit;
  end;

  formSettingsTrayslate := TformSettingsTrayslate.Create(Application);
  try
    formSettingsTrayslate.Position := poDesigned;
    if FormSettingsLeft > 0 then
      formSettingsTrayslate.Left := FormSettingsLeft
    else
      formSettingsTrayslate.Position := poDesktopCenter;
    if FormSettingsTop > 0 then
      formSettingsTrayslate.Top := FormSettingsTop
    else
      formSettingsTrayslate.Position := poDesktopCenter;
    if FormSettingsWidth > 0 then
      formSettingsTrayslate.Width := FormSettingsWidth;
    if FormSettingsHeight > 0 then
      formSettingsTrayslate.Height := FormSettingsHeight;
    if FormSettingsSplit > 0 then
      formSettingsTrayslate.ListPages.Width := FormSettingsSplit;

    UnregisterHotKeys;
    FMouseHook.Enabled := False;
    FKeyHook.Enabled := False;

    formSettingsTrayslate.ShowModal;
  finally
    FreeAndNil(formSettingsTrayslate);
    RegisterHotKeys;
    SetHints;
    FMouseHook.Enabled := FEnableMouseMode;
    FKeyHook.Enabled := FEnableMouseMode;

    FTrans.Proxy := FProxy;
    FTrans.Timeout := FTimeout;
    FTransDetect.Proxy := FProxy;
    FTransDetect.Timeout := FTimeout;

    if Assigned(formPopupTrayslate) then
      formPopupTrayslate.UpdateStayOnTop(0);
  end;
end;

procedure TformTrayslate.aNewTranslateExecute(Sender: TObject);
begin
  CancelTranslate;
  MemoSource.Clear;
  MemoTarget.Clear;
end;

procedure TformTrayslate.aTranslateExecute(Sender: TObject);
begin
  TranslateMemo;
end;

procedure TformTrayslate.aTranslateClipboardExecute(Sender: TObject);
begin
  TranslateFromClipboard;
end;

procedure TformTrayslate.aPopupTranslateExecute(Sender: TObject);
begin
  TranslateClipboardPopup;
end;

procedure TformTrayslate.aSwapExecute(Sender: TObject);
begin
  if SwapLanguages and not Trans.ServiceOnlyButton then
    TranslateMemo(False);
end;

procedure TformTrayslate.aCopySourceExecute(Sender: TObject);
begin
  Clipboard.AsText := MemoSource.Text;
end;

procedure TformTrayslate.aCopyTargetExecute(Sender: TObject);
begin
  Clipboard.AsText := MemoTarget.Text;
end;

procedure TformTrayslate.aAddPairExecute(Sender: TObject);
begin
  if (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) then
  begin
    AddLangPair(FLangSource + ':' + FLangTarget);
    Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
  end;
end;

procedure TformTrayslate.aMenuExecute(Sender: TObject);
var
  P: TPoint;
begin
  if FPopupOpen then
  begin
    PopupTray.Close;
    Exit;
  end;

  PopupTray.Alignment := paRight;
  aShow.Visible := False;
  MenuLangPairs.Visible := False;

  // Bottom-right of button in screen coords
  P := SbMenu.ClientToScreen(Point(SbMenu.Width, SbMenu.Height));

  PopupTray.PopUp(P.X, P.Y);
end;

procedure TformTrayslate.aAutoCheckUpdatesExecute(Sender: TObject);
begin
  FAutoCheckUpdates := aAutoCheckUpdates.Checked;
  FUpdatesChecked := False;
end;

procedure TformTrayslate.aCheckForUpdatesExecute(Sender: TObject);
var
  LatestVersion: string;
begin
  CheckGithubLatestVersion(LatestVersion, REPO);
  FUpdatesChecked := True;
end;

procedure TformTrayslate.aDonateExecute(Sender: TObject);
begin
  formDonateTrayslate := TformDonateTrayslate.Create(Application);
  try
    formDonateTrayslate.ShowModal;
  finally
    formDonateTrayslate.Free;
  end;
end;

procedure TformTrayslate.aAboutExecute(Sender: TObject);
begin
  formAboutTrayslate := TformAboutTrayslate.Create(Application);

  if FormAboutWidth > 0 then
    formAboutTrayslate.Width := FormAboutWidth;
  if FormAboutHeight > 0 then
    formAboutTrayslate.Height := FormAboutHeight;

  try
    formAboutTrayslate.ShowModal;
  finally
    FreeAndNil(formAboutTrayslate);
  end;
end;

procedure TformTrayslate.aExitExecute(Sender: TObject);
begin
  CancelTranslate;

  Self.Enabled := False;
  Self.Cursor := crHourGlass;
  Screen.Cursor := crHourGlass;

  Application.Terminate;
end;

{ Actions Fast Settings }

procedure TformTrayslate.aFastAllowHotKeysExecute(Sender: TObject);
begin
  AllowHotKeys := aFastAllowHotKeys.Checked;
end;

procedure TformTrayslate.aFastAutoAddLangPairsExecute(Sender: TObject);
begin
  AutoAddLangPairs := aFastAutoAddLangPairs.Checked;
end;

procedure TformTrayslate.aFastAutoSwapExecute(Sender: TObject);
begin
  AutoSwap := aFastAutoSwap.Checked;
end;

procedure TformTrayslate.aFastEnableMouseModeExecute(Sender: TObject);
begin
  EnableMouseMode := aFastEnableMouseMode.Checked;
end;

procedure TformTrayslate.aFastHideControlsExecute(Sender: TObject);
begin
  HideControls := aFastHideControls.Checked;
end;

procedure TformTrayslate.aFastMouseModeCtrlExecute(Sender: TObject);
begin
  MouseModeCtrl := aFastMouseModeCtrl.Checked;
end;

procedure TformTrayslate.aFastRealTimeExecute(Sender: TObject);
begin
  RealTime := aFastRealTime.Checked;
end;

procedure TformTrayslate.aFastVerticalSplitExecute(Sender: TObject);
begin
  VerticalSplit := aFastVerticalSplit.Checked;
end;

{ Control Events }

procedure TformTrayslate.ComboSourceCloseUp(Sender: TObject);
var
  P: TPoint;
begin
  // If value not changed - do nothing
  if ComboSource.Text = FPrevSourceText then
    Exit;

  if ComboSource.Items.IndexOf(ComboSource.Text) = -1 then
  begin
    if ComboSource.Text = string.Empty then
    begin
      FLangSource := string.Empty;
      FTrans.LangSource := string.Empty;
      SetIcon;
    end
    else
    if (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) then
      SelectPair(FLangSource + ':' + FLangTarget, False)
    else
    if FLangSource <> string.Empty then
      ChangeSourceLang(FPrevSourceText)
    else
      ComboSource.Text := string.Empty;
  end
  else
  begin
    ChangeSourceLang(ComboSource.Text);
    if Pos('(', ComboSource.Text) = 0 then
    begin
      P := ComboSource.ClientToScreen(Point(0, -ComboSource.Height div 2));
      ShowCustomHint(FLangSource, Mouse.CursorPos.X, P.Y);
    end;
    if not Trans.ServiceOnlyButton then
      TranslateMemo(False);
  end;
end;

procedure TformTrayslate.ComboTargetCloseUp(Sender: TObject);
var
  P: TPoint;
begin
  // If value not changed - do nothing
  if ComboTarget.Text = FPrevTargetText then
    Exit;

  if ComboTarget.Items.IndexOf(ComboTarget.Text) = -1 then
  begin
    if ComboTarget.Text = string.Empty then
    begin
      FLangTarget := string.Empty;
      FTrans.LangTarget := string.Empty;
      SetIcon;
    end
    else
    if (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) then
      SelectPair(FLangSource + ':' + FLangTarget, False)
    else
    if FLangTarget <> string.Empty then
      ChangeTargetLang(FPrevTargetText)
    else
      ComboTarget.Text := string.Empty;
  end
  else
  begin
    ChangeTargetLang(ComboTarget.Text);
    if Pos('(', ComboTarget.Text) = 0 then
    begin
      P := ComboTarget.ClientToScreen(Point(0, -ComboTarget.Height div 2));
      ShowCustomHint(FLangTarget, Mouse.CursorPos.X, P.Y);
    end;
    if not Trans.ServiceOnlyButton then
      TranslateMemo(False);
  end;
end;

procedure TformTrayslate.ComboSourceDropDown(Sender: TObject);
begin
  FPrevSourceText := ComboSource.Text;
end;

procedure TformTrayslate.ComboTargetDropDown(Sender: TObject);
begin
  FPrevTargetText := ComboTarget.Text;
end;

procedure TformTrayslate.ComboSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if not (Key in [VK_RETURN, VK_TAB]) then
    ComboSource.DroppedDown := True;
end;

procedure TformTrayslate.ComboTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if not (Key in [VK_RETURN, VK_TAB]) then
    ComboTarget.DroppedDown := True;
end;

procedure TformTrayslate.MemoSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  NowTime: DWORD;
begin
  if (ssCtrl in Shift) and (Key = VK_V) then
  begin
    PasteWithLineEnding(Sender as TMemo);
    Key := 0;
    Exit;
  end;

  if ((ssCtrl in Shift) or (ssShift in Shift)) and (Key = VK_RETURN) then
  begin
    aTranslate.Execute;
    Key := 0;
    Exit;
  end;

  // Check double Enter
  if (Key = VK_RETURN) and not (ssCtrl in Shift) and not (ssShift in Shift) then
  begin
    FMemoSourceCaretPos := MemoSource.SelStart; // save current caret

    NowTime := GetTickCountXp;
    if NowTime - FLastEnterTime <= DOUBLE_ENTER_INTERVAL then
    begin
      // Delete the previous Enter inserted
      if FMemoSourceCaretPos >= 2 then
      begin
        MemoSource.SelStart := FMemoSourceCaretPos - 2;
        MemoSource.SelLength := 2;
        if MemoSource.SelText = sLineBreak then
          MemoSource.SelText := string.Empty; // remove the line break
      end;

      // Restore caret to original position
      MemoSource.SelStart := FMemoSourceCaretPos - 2;
      MemoSource.SelLength := 0;

      aTranslate.Execute; // double Enter detected
      FLastEnterTime := 0; // reset
      TimerTranslate.Enabled := False;
      Key := 0;
    end
    else
      FLastEnterTime := NowTime;
  end;
end;

procedure TformTrayslate.MemoSourceKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  // Check if real-time translation is enabled
  if not FRealTime or not Trans.ServiceRealTime then
    Exit;

  // Ignore KeyUp if it happened right after a global hotkey
  if GetTickCountXp - FLastHotkeyTime < HOTKEY_INTERVAL then
  begin
    TimerTranslate.Enabled := False;
    Exit;
  end;

  // List of keys that do not modify text content (Navigation, System, Modifiers)
  // We include VK_RETURN here as per your requirement to ignore it for translation triggers
  if IsSystemKey(Key) and not (Key in [VK_RETURN, VK_DELETE, VK_BACK, VK_SHIFT, VK_LSHIFT, VK_RSHIFT]) then
  begin
    TimerTranslate.Enabled := False;
    Exit;
  end;

  // If a text-modifying key is pressed, reset the translation timer
  if TimerTranslate.Enabled then
  begin
    TimerTranslate.Enabled := False;

    // Cancel the current translation thread if it is still running
    if Assigned(FTranslateThread) then
      FTranslateThread.Cancel;
  end;

  // Start the timer to trigger translation after a short delay (debounce)
  TimerTranslate.Enabled := True;
end;

procedure TformTrayslate.MemoTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_V) then // Ctrl + V
  begin
    PasteWithLineEnding(Sender as TMemo);
    Key := 0;
  end;
end;

procedure TformTrayslate.PanelLangResize(Sender: TObject);
begin
  if PanelLang.Tag = 1 then Exit;
  PanelLang.Tag := 1;

  Application.QueueAsyncCall(@DoRealign, 0);
end;

procedure TformTrayslate.SplitterMoved(Sender: TObject);
begin
  case PanelTarget.Align of
    alBottom:
      FSplitRatio := PanelTarget.Height / (PanelSource.Height + PanelTarget.Height);

    alRight:
      FSplitRatio := PanelTarget.Width / (PanelSource.Width + PanelTarget.Width);
    else
      ;
  end;
end;

procedure TformTrayslate.SbSwapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if Button = mbMiddle then
  begin
    if SwapLanguages(True) and not Trans.ServiceOnlyButton then
      TranslateMemo(False);
  end;
end;

procedure TformTrayslate.TimerActiveTimer(Sender: TObject);
begin
  TimerActive.Enabled := False;

  if (not TimerClick.Enabled) and (TimerClick.Tag = 0) then
    FTopMost := False;
end;

procedure TformTrayslate.TimerAnimateStopTimer(Sender: TObject);
begin
  SetIcon;
end;

procedure TformTrayslate.TimerAnimateTimer(Sender: TObject);
begin
  TimerAnimate.Tag := TimerAnimate.Tag + 5;
  if TimerAnimate.Tag >= 360 then
    TimerAnimate.Tag := TimerAnimate.Tag - 360;

  SetAnimate(TimerAnimate.Tag);
end;

procedure TformTrayslate.TimerHideHintTimer(Sender: TObject);
begin
  TimerHideHint.Enabled := False;
  if Assigned(FHint) then
    FHint.ReleaseHandle; // Correct way to hide THintWindow
end;

procedure TformTrayslate.TimerUnapplyTimer(Sender: TObject);
begin
  TimerUnapply.Enabled := False;

  if FUnapplyCtrl then
  begin
    KeyInput.Unapply([ssCtrl]);
    FUnapplyCtrl := False;
  end;
  if FUnapplyC then
  begin
    KeyInput.Up(Ord('C'));
    FUnapplyC := False;
  end;
  if FUnapplyV then
  begin
    KeyInput.Up(Ord('V'));
    FUnapplyV := False;
  end;
end;

procedure TformTrayslate.TimerTranslateTimer(Sender: TObject);
begin
  TimerTranslate.Enabled := False;
  if FRealTime and Trans.ServiceRealTime then
  begin
    TranslateMemo(False);
    if MemoSource.Text = string.Empty then
      MemoTarget.Clear;
  end;
end;

procedure TformTrayslate.TimerClickTimer(Sender: TObject);
begin
  TimerClick.Enabled := False;
  if (TimerClick.Tag = 1) then
  begin
    TimerClick.Tag := 0;
    exit;
  end;

  // Single click action
  if Showing then
  begin
    Hide;
    FTopMost := False;
  end
  else
  begin
    Show;
    FTopMost := True;
  end;
end;

procedure TformTrayslate.TrayIconMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  TimerHideHintTimer(Self);
end;

procedure TformTrayslate.TrayIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  FLeftButton := Button = mbLeft;

  if Button = mbMiddle then
    aSwap.Execute;
end;

procedure TformTrayslate.TrayIconClick(Sender: TObject);
begin
  if not FLeftButton then
  begin
    FLeftButton := True;
    Exit;
  end;

  // DblClick
  if Showing then
  begin
    if TimerClick.Enabled or (TimerClick.Tag = 1) then
    begin
      TimerClick.Enabled := False; // cancel single click action
      TimerClick.Tag := 0;

      aTranslateClipboard.Execute;

      // Important after translation, otherwise changes to false
      FTopMost := True;
      TimerActive.Enabled := False;
      Exit;
    end;
  end
  else
  begin
    TimerClick.Enabled := False;
    TimerClick.Tag := 0;
  end;

  if Showing then
  begin
    if FTopMost then
    begin
      TimerClick.Enabled := True;
      TimerClick.Tag := 0;
    end
    else
    begin
      BringToFront;
      TimerClick.Enabled := True;
      TimerClick.Tag := 1;
      FTopMost := True;
    end;
  end
  else
  begin
    Show;
    TimerClick.Enabled := True;
    TimerClick.Tag := 1;
    FTopMost := True;
  end;
end;

procedure TformTrayslate.LabelMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style + [fsUnderline];
end;

procedure TformTrayslate.LabelMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style - [fsUnderline];
end;

procedure TformTrayslate.LabelLangMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if Button = mbMiddle then
  begin
    // Remove pair from list
    FLangPairs.Delete((Sender as TLabel).Tag);
    // Rebuild panel
    Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
    Exit;
  end;

  SelectPairConfig((Sender as TLabel).Tag);
end;

procedure TFormTrayslate.MenuConfigItemClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  if (Assigned(formConfigTrayslate)) and formConfigTrayslate.HandleAllocated and formConfigTrayslate.Showing and
    (not formConfigTrayslate.TestChanges) then
    Exit;

  Item := TMenuItem(Sender);

  // Update current config and load it
  FConfigFile := FConfigFiles[Item.Tag];
  LoadConfig(False);

  if (Assigned(formConfigTrayslate)) and formConfigTrayslate.HandleAllocated and (formConfigTrayslate.Showing) then
  begin
    formConfigTrayslate.UpdateConfigList;
    formConfigTrayslate.UpdateConfig;
  end;

  if (FAutoAddLangPairs) and (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) and (FLangSource <> FLangTarget) then
  begin
    AddLangPair(FLangSource + ':' + FLangTarget);
    Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
  end;

  if not Trans.ServiceOnlyButton then
    TranslateMemo;
end;

procedure TformTrayslate.MenuPairClick(Sender: TObject);
begin
  SelectPairConfig((Sender as TMenuItem).Tag);
end;

procedure TformTrayslate.PopupTrayPopup(Sender: TObject);
begin
  FPopupOpen := True;
end;

procedure TformTrayslate.PopupTrayClose(Sender: TObject);
begin
  FPopupOpen := False;
  PopupTray.Alignment := paLeft;
  aShow.Visible := True;
  MenuLangPairs.Visible := True;
end;

{ Methods }

procedure TformTrayslate.LoadConfig(SetDefault: boolean = True);
var
  List: TStringList;
  Id: integer;
begin
  UpdateCheckConfigMenu;

  // Load settings from INI
  LoadIniSettings(FTrans, FConfigFile);

  // Load language detection config settings
  if (FConfigLangDetect <> string.Empty) then
    LoadIniSettings(FTransDetect, FConfigLangDetect)
  else
  begin
    FreeAndNil(FTransDetect);
    FTransDetect := TTranslate.Create;
  end;

  // Loading source languages from the config
  FLanguages.Clear;
  List := GetDisplayNamesFromCodeMap(Trans.Languages, Trans.ValueType);
  try
    FLanguages.Assign(List); // Assign available source languages
  finally
    List.Free;
  end;

  // Loading target languages from the config
  FLanguagesTarget.Clear;
  if (Assigned(Trans.LanguagesTarget)) and (Trans.LanguagesTarget.Count > 0) then
  begin
    List := GetDisplayNamesFromCodeMap(Trans.LanguagesTarget, Trans.ValueType);
    try
      FLanguagesTarget.Assign(List); // Assign available target languages
    finally
      List.Free;
    end;
  end;

  // Fill ComboSource with display names
  List := GetDisplayNamesFromCodeMap(Trans.Languages, Trans.ValueType, True);
  try
    ComboSource.Items.Assign(List); // Text with large letter
  finally
    List.Free;
  end;

  // Check if current ComboSource text is still valid
  if ComboSource.Items.IndexOf(ComboSource.Text) < 0 then
  begin
    Id := FindSubstringIndex(Trans.Languages, LangSource);
    if (Id >= 0) and (Id < FLanguages.Count) then
    begin
      ComboSource.Text := FLanguages.ValueFromIndex[Id];
      ChangeSourceLang(ComboSource.Text, False);
    end
    else
    if (Trans.Languages.Count = 1) then
    begin
      ComboSource.ItemIndex := 0; // Single item as default
      ChangeSourceLang(ComboSource.Text, False);
    end;
  end;
  // If the text is not in the list, clear it
  if ComboSource.Items.IndexOf(ComboSource.Text) < 0 then
  begin
    ComboSource.Text := string.Empty; // Clear if not in new list
    LangSource := string.Empty;
    Trans.LangSource := string.Empty;
  end
  else
  begin
    // Update the matched language in case of case change
    id := GetIndexByValue(Trans.Languages, FLangSource);
    if Id < 0 then
      Trans.LangSource := Trans.Languages.Values[FLangSource]
    else
      Trans.LangSource := Trans.Languages.ValueFromIndex[Id];
    FLangSource := Trans.LangSource;
  end;

  // Fill ComboTarget with display names
  if (Assigned(Trans.LanguagesTarget)) and (Trans.LanguagesTarget.Count > 0) then
  begin
    List := GetDisplayNamesFromCodeMap(Trans.LanguagesTarget, Trans.ValueType, True);
    try
      ComboTarget.Items.Assign(List); // Text with large letter
    finally
      List.Free;
    end;
  end
  else
    ComboTarget.Items.Assign(ComboSource.Items); // Use source if target list empty

  // Check if current ComboTarget text is still valid
  if ComboTarget.Items.IndexOf(ComboTarget.Text) < 0 then
  begin
    // If there are target languages
    if Trans.LanguagesTarget.Count > 0 then
    begin
      Id := FindSubstringIndex(Trans.LanguagesTarget, LangTarget);
      if (Id >= 0) and (Id < FLanguagesTarget.Count) then
      begin
        ComboTarget.Text := FLanguagesTarget.ValueFromIndex[Id];
        ChangeTargetLang(ComboTarget.Text, False);
      end
      else
      if (Trans.LanguagesTarget.Count = 1) then
      begin
        ComboTarget.ItemIndex := 0; // Single item as default
        ChangeTargetLang(ComboTarget.Text, False);
      end;
    end
    else
    begin
      // If the languages are identical to sources
      Id := FindSubstringIndex(Trans.Languages, LangTarget);
      if (Id >= 0) and (Id < FLanguages.Count) then
      begin
        ComboTarget.Text := FLanguages.ValueFromIndex[Id];
        ChangeTargetLang(ComboTarget.Text, False);
      end
      else
      if (Trans.Languages.Count = 1) then
      begin
        ComboTarget.ItemIndex := 0; // Single item as default
        ChangeTargetLang(ComboTarget.Text, False);
      end;
    end;
  end;

  // If the text is not in the list, clear it
  if ComboTarget.Items.IndexOf(ComboTarget.Text) < 0 then
  begin
    ComboTarget.Text := string.Empty; // Clear if not in new list
    LangTarget := string.Empty;
    Trans.LangTarget := string.Empty;
  end
  else
  begin
    // Update the matched language in case of case change
    if Trans.LanguagesTarget.Count > 0 then
    begin
      id := GetIndexByValue(Trans.LanguagesTarget, FLangTarget);
      if Id < 0 then
        Trans.LangTarget := Trans.LanguagesTarget.Values[FLangTarget]
      else
        Trans.LangTarget := Trans.LanguagesTarget.ValueFromIndex[Id];
    end
    else
    begin
      id := GetIndexByValue(Trans.Languages, FLangTarget);
      if Id < 0 then
        Trans.LangTarget := Trans.Languages.Values[FLangTarget]
      else
        Trans.LangTarget := Trans.Languages.ValueFromIndex[Id];
    end;
    FLangTarget := Trans.LangTarget;
  end;

  if SetDefault then
  begin
    // Set default or saved languages
    if LangSource <> string.Empty then
      Trans.LangSource := LangSource
    else
    begin
      ComboSource.ItemIndex := 0; // First item as default
      ChangeSourceLang(ComboSource.Text);
    end;

    if LangTarget <> string.Empty then
      Trans.LangTarget := LangTarget
    else
    begin
      // if system language in lists
      if (((FLanguagesTarget.Count > 0) and (FindInStringList(FLanguagesTarget, '(' + Language + ')') >= 0)) or
        ((FLanguagesTarget.Count = 0) and (FindInStringList(FLanguages, '(' + Language + ')') >= 0))) then
      begin
        FTrans.LangTarget := Language; // Default system language
        FLangTarget := Language;
      end
      else
      if (FLanguagesTarget.Count = 1) then
      begin
        ComboTarget.ItemIndex := 0; // Single item as default
        ChangeTargetLang(ComboTarget.Text);
      end;
    end;
  end;

  // Set combobox selection by language code
  SetComboBoxByCode(ComboSource, Trans.LangSource);
  SetComboBoxByCode(ComboTarget, Trans.LangTarget);

  if ComboTarget.ItemIndex = -1 then
    ComboTarget.Text := string.Empty;

  if MemoSource.Visible and MemoSource.CanFocus and MemoSource.CanSetFocus then
    MemoSource.SetFocus;

  UpdateCheckMenuPair;
  SetIcon;
  SetHints;
end;

procedure TFormTrayslate.SetDefaultSettings;
begin
  FAutoStart := True;
  FConfigLangDetect := DEF_LANGDETECT;
  if IsWindows7 then
    FIconBackgroundColor := $00905000
  else
    FIconBackgroundColor := clNone;
  {$IFDEF WINDOWS}
  if IsTaskbarDark then
    FIconFontColor := clWhite
  else
    FIconFontColor := clBlack;
  {$ELSE}
  FIconFontColor := clWhite;
  {$ENDIF}
  FIconFontName := DEF_FONT;
  FFontPopup := TFont.Create;
  FIconTwoLang := True;
  FMaxLangPairs := 10;
  FAutoAddLangPairs := True;
  FAllowHotKeys := True;
  FRealTime := False;
  FRealTimeDelay := 1000;
  FAutoSwap := False;
  FSmartSwap := False;
  FSmartHard := False;
  FPrimaryLang := GetOSLanguage;
  FSecondaryLang := DEFAULT_LANG;
  FEnableMouseMode := False;
  FMouseModeCtrl := False;
  FMouseMode := mmShowTranslateButton;
  FVerticalSplit := False;
  FStayOnTop := True;
  FHideControls := True;
  FAutoHeight := True;
  FMaxHeight := 0;
  FOpacityHover := 70;
  FOpacityIdle := 40;

  FTimeout.Connection := CONNECT_TIMEOUT;
  FTimeout.Request := REQUEST_TIMEOUT;
  FProxy.ProxyMode := pmNone;
  FProxy.ProxyType := ptHTTP;
  FProxy.Authentication := False;
  FProxy.Host := string.Empty;
  FProxy.Port := string.Empty;
  FProxy.Login := string.Empty;
  FProxy.Password := string.Empty;

  SetDefaultHotKeys;

  if (Assigned(FConfigFiles)) then
    FConfigLangDetect := GetConfigFullPath(FConfigLangDetect, FConfigFiles);
end;

procedure TFormTrayslate.SetDefaultHotKeys;
begin
  // Ctrl+Shift+A
  FHotKeyApp.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyApp.Key := Ord('A');

  // Ctrl+Shift+S
  FHotKeyTransSwap.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyTransSwap.Key := Ord('S');

  // Ctrl+Shift+T
  FHotKeyTransFromClipboard.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyTransFromClipboard.Key := Ord('T');

  // Ctrl+Shift+R
  FHotKeyTransClipboard.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyTransClipboard.Key := Ord('R');

  // Ctrl+Shift+P
  FHotKeyTransClipboardPopup.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyTransClipboardPopup.Key := Ord('P');

  // Ctrl+Shift+C
  FHotKeyTransFromControl.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyTransFromControl.Key := Ord('C');

  // Ctrl+Shift+V
  FHotKeyTransControl.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyTransControl.Key := Ord('V');

  // Ctrl+Shift+X
  FHotKeyTransControlPopup.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyTransControlPopup.Key := Ord('X');

  // Ctrl+Shift+1
  FHotKeyRecent1.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyRecent1.Key := Ord('1');

  // Ctrl+Shift+2
  FHotKeyRecent2.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyRecent2.Key := Ord('2');

  // Ctrl+Shift+3
  FHotKeyRecent3.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyRecent3.Key := Ord('3');

  // Ctrl+Shift+4
  FHotKeyRecent4.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyRecent4.Key := Ord('4');

  // Ctrl+Shift+5
  FHotKeyRecent5.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyRecent5.Key := Ord('5');

  // Ctrl+Shift+6
  FHotKeyRecent6.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyRecent6.Key := Ord('6');

  // Ctrl+Shift+7
  FHotKeyRecent7.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyRecent7.Key := Ord('7');

  // Ctrl+Shift+8
  FHotKeyRecent8.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyRecent8.Key := Ord('8');

  // Ctrl+Shift+9
  FHotKeyRecent9.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyRecent9.Key := Ord('9');
end;

procedure TFormTrayslate.BuildConfigMenu;
var
  i: integer;
  Item: TMenuItem;
  FileName, FilePath: string;
  Ini: TIniFile;
  SL: TStringList;
  Data: PConfigData;
begin
  MenuConfig.Clear;
  MenuConfig.Visible := FConfigFiles.Count > 0;

  SL := TStringList.Create;
  ImageConfig.Clear;

  try
    for i := 0 to FConfigFiles.Count - 1 do
    begin
      New(Data);

      FilePath := FConfigFiles[i];
      FileName := ExtractFileName(FilePath);

      // defaults
      Data^.Name := string.Empty;
      Data^.Color := clBlue;
      Data^.Visible := True;
      Data^.Order := 0;
      Data^.ImageIndex := -1;
      Data^.PathOnly := ExtractFilePath(FilePath);

      if FileExists(FilePath) then
      begin
        Ini := TIniFile.Create(FilePath);
        try
          Data^.Name := Trim(Ini.ReadString('Service', 'Name', string.Empty));
          Data^.Color := Ini.ReadInteger('Service', 'ColorRecent', clBlue);
          Data^.Visible := Ini.ReadBool('Service', 'Visible', True);
          Data^.Order := Ini.ReadInteger('Service', 'Order', 0);

          Data^.ImageIndex := AddBase64ToImageList(Ini.ReadString('Service', 'Icon', string.Empty), ImageConfig);
        finally
          Ini.Free;
        end;
      end;

      SL.AddObject(FilePath, TObject(Data));
    end;

    SL.CustomSort(@ConfigSortByOrderPathName);

    // rebuild original list order
    FConfigFiles.Clear;
    for i := 0 to SL.Count - 1 do
      FConfigFiles.Add(SL[i]);

    // clear caches
    FConfigTitles.Clear;
    FConfigColors.Clear;
    FConfigImages.Clear;

    for i := 0 to SL.Count - 1 do
    begin
      Data := PConfigData(SL.Objects[i]);
      FileName := ExtractFileName(SL[i]);

      // caches
      FConfigTitles.Add(SL[i] + '=' + Data^.Name);
      FConfigColors.Add(SL[i] + '=' + IntToStr(Data^.Color));
      FConfigImages.Add(SL[i] + '=' + IntToStr(Data^.ImageIndex));

      // MenuFastEnableMouseMode item
      Item := TMenuItem.Create(MenuConfig);

      if Data^.Name <> string.Empty then
        Item.Caption := Data^.Name
      else
        Item.Caption := FileName;

      Item.Hint := SL[i];
      Item.Tag := i;
      Item.OnClick := @MenuConfigItemClick;
      Item.Checked := SameText(SL[i], FConfigFile);
      Item.Visible := Data^.Visible;

      if Item.Checked then
        Item.ImageIndex := -1
      else
        Item.ImageIndex := Data^.ImageIndex;

      MenuConfig.Add(Item);

      Dispose(Data);
      SL.Objects[i] := nil;
    end;

  finally
    SL.Free;
  end;
end;

procedure TformTrayslate.RebuildLangPairsPanel(Data: PtrInt);

  procedure Build(Target: TFlowPanel; AFont: TFont; FillMenu: boolean = True);
  var
    pnl: TPanel;
    lbl: TLabel;
    img: TImage;
    mi: TMenuItem;
    totalWidth: integer;
    ColorRecent: TColor;
    ServiceIcon: integer;
    i: integer;
  begin
    Target.DisableAlign;
    try
      // Clear FlowPairs
      for i := Target.ControlCount - 1 downto 0 do
        Target.Controls[i].Free;

      // Clear MenuLangPairs
      if FillMenu then
        MenuLangPairs.Clear;

      // Hide panel and MenuFastEnableMouseMode if no pairs
      if (FMaxLangPairs <= 0) then
      begin
        Target.Visible := False;
        if FillMenu then
          MenuLangPairs.Visible := False;
        Exit;
      end
      else
      begin
        Target.Visible := True;
        if FillMenu then
          MenuLangPairs.Visible := True;
      end;

      // Calculate total width
      totalWidth := 0;
      for i := 0 to FLangPairs.Count - 1 do
        totalWidth := totalWidth + Target.Canvas.TextWidth(FLangPairs.ValueFromIndex[i]) + 10;
      Target.Width := totalWidth;

      // Create Panels (with Image + Label) and MenuFastEnableMouseMode Items
      for i := 0 to FLangPairs.Count - 1 do
      begin
        Target.BorderSpacing.Top := Max(0, Min(4, 13 - AFont.Size));

        pnl := TPanel.Create(Target);
        pnl.Parent := Target;
        pnl.BevelOuter := bvNone;
        pnl.AutoSize := True;
        pnl.BorderSpacing.Right := 12;

        if not TryStrToInt(FConfigImages.Values[FLangPairs.Names[i]], ServiceIcon) then
          ServiceIcon := -1;

        if ServiceIcon >= 0 then
        begin
          // Image
          img := TImage.Create(pnl);
          img.Parent := pnl;
          ImageConfig.GetBitmap(ServiceIcon, img.Picture.Bitmap);
          img.Hint := FConfigTitles.Values[FLangPairs.Names[i]];
          img.ShowHint := True;
          img.Align := alLeft;
          img.Width := 16;
          img.Proportional := True;
          img.Center := True;
        end;

        // Label
        lbl := TLabel.Create(pnl);
        lbl.Parent := pnl;
        lbl.Caption := FLangPairs.ValueFromIndex[i];
        lbl.Hint := FConfigTitles.Values[FLangPairs.Names[i]];
        lbl.ShowHint := True;
        lbl.Cursor := crHandPoint;
        lbl.Layout := tlCenter;
        if ServiceIcon >= 0 then
          lbl.BorderSpacing.Left := 20;
        lbl.BorderSpacing.Bottom := 3;
        lbl.Top := 0;
        lbl.Left := 0;
        lbl.Tag := i;

        if not TryStrToInt(FConfigColors.Values[FLangPairs.Names[i]], ColorRecent) then
          ColorRecent := clBlue;
        lbl.Font.Color := ThemeColor(ColorRecent, DarkThemeColor(ColorRecent));

        // Events only on label
        lbl.OnMouseEnter := @LabelMouseEnter;
        lbl.OnMouseLeave := @LabelMouseLeave;
        lbl.OnMouseDown := @LabelLangMouseDown;

        // MenuLangPairs Item
        if FillMenu then
        begin
          mi := TMenuItem.Create(MenuLangPairs);
          mi.Caption := lbl.Caption + ' - ' + lbl.Hint;
          mi.Hint := FLangPairs[i];
          if AllowHotKeys and (i < 9) then
          begin
            case i of
              0: mi.ShortCut := HotKeyToShortCut(HotKeyRecent1);
              1: mi.ShortCut := HotKeyToShortCut(HotKeyRecent2);
              2: mi.ShortCut := HotKeyToShortCut(HotKeyRecent3);
              3: mi.ShortCut := HotKeyToShortCut(HotKeyRecent4);
              4: mi.ShortCut := HotKeyToShortCut(HotKeyRecent5);
              5: mi.ShortCut := HotKeyToShortCut(HotKeyRecent6);
              6: mi.ShortCut := HotKeyToShortCut(HotKeyRecent7);
              7: mi.ShortCut := HotKeyToShortCut(HotKeyRecent8);
              8: mi.ShortCut := HotKeyToShortCut(HotKeyRecent9);
              else
                ;
            end;
          end;
          mi.Tag := i;
          mi.OnClick := @MenuPairClick;
          mi.Checked := SameText(mi.Hint, LangSource + ':' + LangTarget);
          if mi.Checked then
            mi.ImageIndex := -1
          else
            mi.ImageIndex := ServiceIcon;
          MenuLangPairs.Add(mi);
        end;
      end;
    finally
      Target.EnableAlign;
    end;
  end;

begin
  try
    Build(FlowPairs, Font);
    if Assigned(formPopupTrayslate) then
      Build(formPopupTrayslate.FlowPairs, FontPopup, False);
  finally
    UpdateCheckMenuPair;
    Repaint;
  end;
end;

procedure TformTrayslate.SetIcon;
var
  Bitmap: TBitmap;
  hintText: string;
begin
  Bitmap := CreateTrayIconLang(Self, ifthen(FIconTwoLang, UpperCase(UpdateSourceLanguage(Trans.LangSource)),
    UpperCase(UpdateTargetLanguage(Trans.LangTarget))), ifthen(FIconTwoLang, UpperCase(Trans.LangTarget), string.Empty),
    FIconBackgroundColor, FIconFontColor, FIconFontName);
  try
    TrayIcon.Icon.Assign(Bitmap);
    TrayIcon.Visible := True;
  finally
    Bitmap.Free;
  end;

  // Set tray icon hint
  hintText := string.Empty;
  if ComboSource.Text <> string.Empty then
    hintText += ComboSource.Text;
  if ComboTarget.Text <> string.Empty then
    hintText += ' : ' + ComboTarget.Text;
  if FConfigTitles.Values[FConfigFile] <> string.Empty then
    hintText += sLineBreak + FConfigTitles.Values[FConfigFile];
  TrayIcon.Hint := rtrayslate + ' - ' + hintText;

  // Set popup window caption
  if (Assigned(formPopupTrayslate)) then
    formPopupTrayslate.Caption := hintText.Replace(LineEnding, ' - ');
end;

procedure TformTrayslate.SetHints;
begin
  if Assigned(Trans) then
    Caption := rtrayslate + ifthen(Trans.ServiceName <> string.Empty, ' - ' + Trans.ServiceName,
      ifthen(FConfigFile <> string.Empty, ' - ' + ExtractFileName(FConfigFile), string.Empty))
  else
    Caption := rtrayslate + ifthen(FConfigFile <> string.Empty, ' - ' + ExtractFileName(FConfigFile), string.Empty);

  aSwap.Hint := Format(rswap, [HotKeyToText(HotKeyTransSwap), MIDDLE_MOUSE]).Replace('() ', string.Empty);

  FlowPairs.Hint := MIDDLE_MOUSE + rtoremovepair;

  ComboSource.Hint := LongestString([FLangSource, ComboSource.Text]);
  ComboTarget.Hint := LongestString([FLangTarget, ComboTarget.Text]);

  OpenPo.Filter := ropenpofiletr;

  if Assigned(formConfigTrayslate) then
  begin
    with formConfigTrayslate do
    begin
      ComboValueType.Items.Clear;
      ComboValueType.Items.Add(rvaluetype1);
      ComboValueType.Items.Add(rvaluetype2);
      ComboValueType.Items.Add(rvaluetype3);
      ComboValueType.Items.Add(rvaluetype4);
      ComboValueType.Items.Add(rvaluetype5);
      ComboValueType.Items.Add(rvaluetype6);
      ComboValueType.ItemIndex := Ord(Trans.ValueType);
    end;
  end;

  if Assigned(formAboutTrayslate) then
    formAboutTrayslate.MemoAbout.Text := formAboutTrayslate.LblAbout.Caption;

  if Assigned(formSettingsTrayslate) then
  begin
    formSettingsTrayslate.FillListPages;
    formSettingsTrayslate.FillGridHotkeys;
    formSettingsTrayslate.FillMouseMode;
  end;
end;

procedure TformTrayslate.SetAnimate(Angle: integer);
var
  Bitmap: TBitmap;
begin
  if not TrayIcon.Visible then Exit;

  Bitmap := CreateTrayIconProgress(Angle, FIconBackgroundColor, FIconFontColor);
  try
    TrayIcon.Icon.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TformTrayslate.DoRealign(Data: PtrInt);
var
  Available, Border: integer;
begin
  Border := 3;

  PanelLang.DisableAlign;
  try
    Available := PanelLang.ClientWidth - sbSwap.Width - sbTranslate.Width - SbNewTranslate.Width - 15;

    sbNewTranslate.SetBounds(
      0,
      Border,
      sbNewTranslate.Width,
      ComboSource.Height);

    ComboSource.SetBounds(
      SbNewTranslate.Width + Border,
      Border,
      Available div 2,
      ComboSource.Height);

    sbSwap.SetBounds(
      ComboSource.Left + ComboSource.Width + Border,
      Border,
      sbSwap.Width,
      ComboSource.Height);

    ComboTarget.SetBounds(
      sbSwap.Left + sbSwap.Width + Border,
      Border,
      Available - ComboSource.Width - Border * 2,
      ComboTarget.Height);

    sbTranslate.SetBounds(
      PanelLang.ClientWidth - sbTranslate.Width - Border * 2,
      Border,
      sbTranslate.Width,
      ComboTarget.Height);
  finally
    PanelLang.EnableAlign;
    PanelLang.Tag := 0;
  end;
end;

procedure TformTrayslate.DoRealignSplit(Data: PtrInt);
begin
  // Restore splitter ratio
  case PanelTarget.Align of
    alBottom:
    begin
      PanelTarget.Height := Round((PanelSource.Height + PanelTarget.Height) * FSplitRatio);
      // Force the splitter to be strictly above the bottom panel
      Splitter.Top := PanelTarget.Top - 1;
    end;

    alRight:
    begin
      PanelTarget.Width := Round((PanelSource.Width + PanelTarget.Width) * FSplitRatio);
      // Force the splitter to be strictly to the left of the right panel
      Splitter.Left := PanelTarget.Left - 1;
    end;
    else
      ;
  end;
end;

procedure TFormTrayslate.UpdateCheckConfigMenu;
var
  i: integer;
begin
  for i := 0 to MenuConfig.Count - 1 do
  begin
    if (FConfigFiles.Count > i) and SameText(FConfigFiles[i], FConfigFile) then
      MenuConfig.Items[i].Checked := True
    else
      MenuConfig.Items[i].Checked := False;

    if MenuConfig.Items[i].Checked then
      MenuConfig.Items[i].ImageIndex := -1
    else
      MenuConfig.Items[i].ImageIndex := StrToInt(FConfigImages.ValueFromIndex[MenuConfig.Items[i].Tag]);
  end;
end;

procedure TformTrayslate.UpdateCheckMenuPair;
var
  currentPair: string;
  lbl: TLabel;
  pnl: TPanel;
  targetTag: integer;
  ServiceIcon: integer;
  i: integer;

  procedure UpdateLbl(Target: TFlowPanel);
  var
    j, k: integer;
  begin
    targetTag := i;
    lbl := nil;

    // Find Panel -> then Label inside it
    for j := 0 to Target.ControlCount - 1 do
    begin
      if Target.Controls[j] is TPanel then
      begin
        pnl := TPanel(Target.Controls[j]);

        for k := 0 to pnl.ControlCount - 1 do
        begin
          if (pnl.Controls[k] is TLabel) and (pnl.Controls[k].Tag = targetTag) then
          begin
            lbl := TLabel(pnl.Controls[k]);
            Break;
          end;
        end;

        if Assigned(lbl) then Break;
      end;
    end;

    // Update label font style
    if Assigned(lbl) then
    begin
      if MenuLangPairs.Items[i].Checked then
        lbl.Font.Style := lbl.Font.Style + [fsBold]
      else
        lbl.Font.Style := lbl.Font.Style - [fsBold];
    end;
  end;

begin
  if (FlowPairs = nil) or (MenuLangPairs = nil) then Exit;

  // Format the current pair for comparison (e.g., "en:ru")
  currentPair := UpdatePairLanguage(LangSource + ':' + LangTarget);

  for i := 0 to MenuLangPairs.Count - 1 do
  begin
    // Update MenuFastEnableMouseMode item check state
    MenuLangPairs.Items[i].Checked :=
      SameText(MenuLangPairs.Items[i].Hint, FConfigFile + '=' + currentPair);

    if not TryStrToInt(FConfigImages.Values[FLangPairs.Names[i]], ServiceIcon) then
      ServiceIcon := -1;
    if MenuLangPairs.Items[i].Checked then
      MenuLangPairs.Items[i].ImageIndex := -1
    else
      MenuLangPairs.Items[i].ImageIndex := ServiceIcon;

    UpdateLbl(FlowPairs);
    if Assigned(formPopupTrayslate) and (formPopupTrayslate.FlowPairs <> nil) then
      UpdateLbl(formPopupTrayslate.FlowPairs);
  end;
end;

function TformTrayslate.UpdateSourceLanguage(const Lang: string): string;
var
  i: integer;
begin
  Result := Lang;

  if Pos('(', ComboSource.Text) = 0 then
  begin
    i := GetIndexByValue(Trans.Languages, Result);
    if (i >= 0) and (i < FLanguages.Count) then
      Result := FLanguages[i];
  end;
end;

function TformTrayslate.UpdateTargetLanguage(const Lang: string): string;
var
  i: integer;
begin
  Result := Lang;

  if Pos('(', ComboTarget.Text) = 0 then
  begin
    if FLanguagesTarget.Count > 0 then
    begin
      i := GetIndexByValue(Trans.LanguagesTarget, Result);
      if (i >= 0) and (i < FLanguagesTarget.Count) then
        Result := FLanguagesTarget[i];
    end
    else
    begin
      i := GetIndexByValue(Trans.Languages, Result);
      if (i >= 0) and (i < FLanguages.Count) then
        Result := FLanguages[i];
    end;
  end;
end;

function TformTrayslate.UpdatePairLanguage(const Pair: string): string;
var
  Src, Tar: string;
  ColonPos: integer;
begin
  Result := Pair;
  ColonPos := PosExReverse(':', unicodestring(Pair));
  if (ColonPos > 0) then
  begin
    // Get text before ':'
    Src := Copy(Pair, 1, ColonPos - 1);
    Src := UpdateSourceLanguage(Src);

    // Get text after ':'
    Tar := Copy(Pair, ColonPos + 1, Length(Pair) - ColonPos);
    Tar := UpdateSourceLanguage(Tar);

    Result := Src + ':' + Tar;
  end;
end;

procedure TformTrayslate.DoCheckUpdates(Data: PtrInt);
var
  Th: TCheckUpdateThread;
begin
  Th := TCheckUpdateThread.Create(False);
  Th.FreeOnTerminate := True;
end;

procedure TformTrayslate.ShowCustomHint(const AText: string; X: integer = 0; Y: integer = 0; Duration: integer = 3000);
var
  HintRect: TRect;
  DisplayPos: TPoint;
begin
  if not Assigned(FHint) then
    FHint := THintWindow.Create(Self);

  // Calculate the size of the hint window based on text
  HintRect := FHint.CalcHintRect(Screen.Width, AText, nil);

  // Position the hint near the system tray (bottom-right)
  // Note: This is a generic position.
  // Finding the exact coordinates of the icon is OS-specific and complex.
  DisplayPos.X := ifthen(X = 0, Screen.Width - (HintRect.Right - HintRect.Left) - 20, X);
  DisplayPos.Y := ifthen(Y = 0, Screen.WorkAreaHeight - (HintRect.Bottom - HintRect.Top) - 5, Y);

  OffsetRect(HintRect, DisplayPos.X, DisplayPos.Y);

  // Show the hint window
  FHint.ActivateHint(HintRect, AText);

  // Set timer to hide it
  TimerHideHint.Enabled := False;
  TimerHideHint.Interval := Duration;
  TimerHideHint.Enabled := True;
end;

procedure TformTrayslate.AdjustPopupHeight(AText: string);
var
  R: TRect;
  NewHeight: integer;
  MaxH: integer;
  TextWidth: integer;
begin
  if FAutoHeight and (AText <> string.Empty) then
  begin
    // Maximum allowed height
    if FMaxHeight = 0 then
      MaxH := Screen.WorkAreaRect.Height
    else
      MaxH := Min(FMaxHeight, Screen.WorkAreaRect.Height);

    // Use current form font
    formPopupTrayslate.Canvas.Font.Assign(formPopupTrayslate.Font);

    // Available text width inside form
    TextWidth := formPopupTrayslate.ClientWidth - formPopupTrayslate.BorderSpacing.Left - formPopupTrayslate.BorderSpacing.Right - 30;

    // Calculate text rectangle height
    R := Rect(0, 0, TextWidth, 0);

    DrawTextW(
      formPopupTrayslate.Canvas.Handle,
      pwidechar(UTF8Decode(AText)),
      Length(UTF8Decode(AText)),
      R,
      DT_WORDBREAK or DT_CALCRECT or DT_NOPREFIX
      );

    // Add top/bottom padding + controls
    NewHeight := R.Height + formPopupTrayslate.PanelPairs.Height + 10;

    // Limit height
    if NewHeight > MaxH then
      NewHeight := MaxH;

    formPopupTrayslate.Height := NewHeight;
  end;

  // Keep inside screen always
  if formPopupTrayslate.Position <> poDesktopCenter then
  begin
    if formPopupTrayslate.Left + formPopupTrayslate.Width > Screen.WorkAreaRect.Right then
      formPopupTrayslate.Left := Screen.WorkAreaRect.Right - formPopupTrayslate.Width - 10;

    if formPopupTrayslate.Top + formPopupTrayslate.Height > Screen.WorkAreaRect.Bottom then
      formPopupTrayslate.Top := Screen.WorkAreaRect.Bottom - formPopupTrayslate.Height + 8;
  end;
end;

procedure TformTrayslate.ShowPopup(const SourceText: string; X: integer = 0; Y: integer = 0);
var
  PrevForm: TCustomForm;
begin
  // Save current active form
  PrevForm := Screen.ActiveForm;

  if not Assigned(formPopupTrayslate) then
    formPopupTrayslate := TformPopupTrayslate.Create(Application);

  if not formPopupTrayslate.Visible then
  begin
    formPopupTrayslate.Position := poDesigned;
    if X > 0 then
      formPopupTrayslate.Left := X
    else
    if FormPopupLeft > 0 then
      formPopupTrayslate.Left := FormPopupLeft
    else
      formPopupTrayslate.Position := poDesktopCenter;
    if Y > 0 then
      formPopupTrayslate.Top := Y
    else
    if FormPopupTop > 0 then
      formPopupTrayslate.Top := FormPopupTop
    else
      formPopupTrayslate.Position := poDesktopCenter;
    if FormPopupWidth > 0 then
      formPopupTrayslate.Width := FormPopupWidth;
    if FormPopupHeight > 0 then
      formPopupTrayslate.Height := FormPopupHeight;

    AdjustPopupHeight(SourceText);
    FAutoHeightAfter := True;

    formPopupTrayslate.Font.Assign(FontPopup);
    formPopupTrayslate.PanelWatermark.Font.Size := FontPopup.Size;
    formPopupTrayslate.PanelWatermark.Font.Name := FontPopup.Name;
    formPopupTrayslate.AlphaBlendValue := OpacityIdle;
    formPopupTrayslate.UpdateStayOnTop(0);
  end;

  formPopupTrayslate.SourceText := SourceText;

  SetIcon;
  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);

  if not formPopupTrayslate.Visible then
    formPopupTrayslate.Visible := True;
  if not StayOnTop then
    BringToFrontNoFocus(formPopupTrayslate);

  // Restore focus
  if Assigned(PrevForm) and PrevForm.Visible and PrevForm.CanFocus then
    PrevForm.SetFocus;
end;

procedure TformTrayslate.ShowButton(const SourceText: string; X: integer = 0; Y: integer = 0);
var
  PrevForm: TCustomForm;
begin
  // Save current active form
  PrevForm := Screen.ActiveForm;

  if not Assigned(formButtonTrayslate) then
    formButtonTrayslate := TformButtonTrayslate.Create(Application);

  formButtonTrayslate.Position := poDesigned;
  if X > 0 then
    formButtonTrayslate.Left := X + BUTTON_DELTA
  else
    formButtonTrayslate.Position := poDesktopCenter;
  if Y > 0 then
    formButtonTrayslate.Top := Y + BUTTON_DELTA
  else
    formButtonTrayslate.Position := poDesktopCenter;

  formButtonTrayslate.SourceText := SourceText;
  formButtonTrayslate.TimerHide.Enabled := False;
  formButtonTrayslate.TimerHide.Enabled := True;

  if not formButtonTrayslate.Visible then
    formButtonTrayslate.Visible := True;

  // Restore focus
  if Assigned(PrevForm) and PrevForm.Visible and PrevForm.CanFocus then
    PrevForm.SetFocus;
end;

procedure TformTrayslate.SetVerticalMode;
begin
  SplitterMoved(Splitter);
  if FVerticalSplit then
  begin
    // Switch to vertical layout
    PanelSource.Align := alClient;
    PanelTarget.Align := alRight;
    Splitter.Align := alRight;
    Splitter.Left := PanelSource.Width;

    PanelSource.BorderSpacing.Right := 0;
    PanelSource.BorderSpacing.Bottom := 3;
    PanelTarget.BorderSpacing.Left := 0;

    PanelSource.Width := Round((PanelSource.Width + PanelTarget.Width) * FSplitRatio);
  end
  else
  begin
    // Switch to horizontal layout
    PanelSource.Align := alClient;
    PanelTarget.Align := alBottom;
    Splitter.Align := alBottom;
    Splitter.Top := PanelSource.Height + PanelPairs.Height;

    PanelSource.BorderSpacing.Right := 3;
    PanelSource.BorderSpacing.Bottom := 0;
    PanelTarget.BorderSpacing.Left := 3;

    PanelSource.Height := Round((PanelSource.Height + PanelTarget.Height) * FSplitRatio);
  end;
end;

procedure TformTrayslate.SetAutoStart(Value: boolean);
var
  AppName: string;
  AppPath: string;
begin
  FAutoStart := Value;

  // Normalize install path
  AppPath := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));

  // Build unique registry key per installation path
  AppName := 'Trayslate (' + AppPath + ')';

  RegAutoStart(FAutoStart, AppName);
end;

procedure TformTrayslate.SetAutoAddLangPairs(Value: boolean);
begin
  aFastAutoAddLangPairs.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
    formSettingsTrayslate.CheckAutoAddLangPairs.Checked := Value
  else
    FAutoAddLangPairs := Value;
end;

procedure TformTrayslate.SetAutoSwap(Value: boolean);
begin
  aFastAutoSwap.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
    formSettingsTrayslate.CheckAutoSwap.Checked := Value
  else
    FAutoSwap := Value;
end;

procedure TformTrayslate.SetAllowHotkeys(Value: boolean);
begin
  aFastAllowHotkeys.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
    formSettingsTrayslate.CheckAllowHotkeys.Checked := Value
  else
  begin
    FAllowHotkeys := Value;
    RegisterHotKeys;
  end;
end;

procedure TformTrayslate.SetEnableMouseMode(Value: boolean);
begin
  aFastEnableMouseMode.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
    formSettingsTrayslate.CheckEnableMouseMode.Checked := Value
  else
  begin
    FEnableMouseMode := Value;
    FMouseHook.Enabled := EnableMouseMode;
    FKeyHook.Enabled := EnableMouseMode;
  end;
end;

procedure TformTrayslate.SetHideControls(Value: boolean);
begin
  aFastHideControls.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
    formSettingsTrayslate.CheckHideControls.Checked := Value
  else
    FHideControls := Value;
end;

procedure TformTrayslate.SetMouseModeCtrl(Value: boolean);
begin
  aFastMouseModeCtrl.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
    formSettingsTrayslate.CheckMouseModeCtrl.Checked := Value
  else
    FMouseModeCtrl := Value;
end;

procedure TformTrayslate.SetRealTime(Value: boolean);
begin
  aFastRealTime.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
    formSettingsTrayslate.CheckRealTime.Checked := Value
  else
    FRealTime := Value;
end;

procedure TformTrayslate.SetVerticalSplit(Value: boolean);
begin
  aFastVerticalSplit.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
    formSettingsTrayslate.CheckVerticalSplit.Checked := Value
  else
  begin
    FVerticalSplit := Value;
    formTrayslate.SetVerticalMode;
    Application.QueueAsyncCall(@DoRealignSplit, 0);
  end;
end;

procedure TformTrayslate.SetProxy(Value: TProxy);
begin
  FProxy := Value;
  FTrans.Proxy := FProxy;
  FTrans.Timeout := FTimeout;
  FTransDetect.Proxy := FProxy;
  FTransDetect.Timeout := FTimeout;
end;

procedure TformTrayslate.ChangeSourceLang(NewLang: string; AddRecentPairs: boolean = True);
var
  id, idnative: integer;
begin
  if NewLang = string.Empty then
  begin
    LangSource := string.Empty;
    Trans.LangSource := string.Empty;
    exit;
  end;

  // try to find typed text in items
  id := ComboSource.Items.IndexOf(NewLang);
  idnative := FLanguages.IndexOf(NewLang);
  if (id < 0) or (idnative < 0) then Exit;

  // assign the found index
  ComboSource.ItemIndex := id;
  ComboSource.Text := NewLang;

  // now safe to use ItemIndex
  NewLang := Trans.Languages.ValueFromIndex[idnative];
  if NewLang <> FLangSource then
  begin
    FLangSource := NewLang;

    if (FAutoAddLangPairs) and (AddRecentPairs) and (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) and
      (FLangSource <> FLangTarget) then
    begin
      AddLangPair(FLangSource + ':' + FLangTarget);
      Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
    end;

    ComboSource.Hint := LongestString([FLangSource, ComboSource.Text]);
    Trans.LangSource := FLangSource;
    UpdateCheckMenuPair;
    if FIconTwoLang then SetIcon;
  end;
end;

procedure TformTrayslate.ChangeTargetLang(NewLang: string; AddRecentPairs: boolean = True);
var
  id, idnative: integer;
begin
  if NewLang = string.Empty then
  begin
    LangTarget := string.Empty;
    Trans.LangTarget := string.Empty;
    exit;
  end;

  // try to find typed text in items
  id := ComboTarget.Items.IndexOf(NewLang);
  if FLanguagesTarget.Count > 0 then
    idnative := FLanguagesTarget.IndexOf(NewLang)
  else
    idnative := FLanguages.IndexOf(NewLang);
  if (id < 0) or (idnative < 0) then Exit;

  // assign the found index
  ComboTarget.ItemIndex := id;
  ComboTarget.Text := NewLang;

  // now safe to use ItemIndex
  if (idnative >= 0) then
  begin
    if FLanguagesTarget.Count > 0 then
      NewLang := Trans.LanguagesTarget.ValueFromIndex[idnative]
    else
      NewLang := Trans.Languages.ValueFromIndex[idnative];
  end;
  if NewLang <> FLangTarget then
  begin
    FLangTarget := NewLang;

    if (FAutoAddLangPairs) and (AddRecentPairs) and (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) and
      (FLangSource <> FLangTarget) then
    begin
      AddLangPair(FLangSource + ':' + FLangTarget);
      Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
    end;

    ComboTarget.Hint := LongestString([FLangTarget, ComboTarget.Text]);
    Trans.LangTarget := FLangTarget;
    UpdateCheckMenuPair;
    SetIcon;
  end;
end;

function TformTrayslate.SwapLanguages(ASwapTranslate: boolean = False; AddRecentPairs: boolean = True): boolean;
var
  srcIndex: integer;
  tarIndex: integer;
  srcMemoText: string;
begin
  Result := False;
  srcIndex := ComboSource.Items.IndexOf(ComboTarget.Text);
  tarIndex := ComboTarget.Items.IndexOf(ComboSource.Text);

  if (srcIndex < 0) or (tarIndex < 0) then Exit;

  ComboSource.ItemIndex := srcIndex;
  ComboTarget.ItemIndex := tarIndex;
  ChangeSourceLang(ComboSource.Text, False);
  ChangeTargetLang(ComboTarget.Text, AddRecentPairs);

  if ASwapTranslate and ((MemoSource.Text <> string.Empty) or (MemoTarget.Text <> string.Empty)) then
  begin
    srcMemoText := MemoSource.Text;
    MemoSource.Text := MemoTarget.Text;
    MemoTarget.Text := srcMemoText;
  end;

  Result := True;
end;

procedure TformTrayslate.AddLangPair(const Pair: string; ToEnd: boolean = True);
var
  idx: integer;
  RealPair: string;
begin
  RealPair := UpdatePairLanguage(Pair);

  // Remove if already exists
  idx := FLangPairs.IndexOf(FConfigFile + '=' + RealPair);
  if (idx >= 0) and (FLangPairs.Names[idx] = FConfigFile) then
    FLangPairs.Delete(idx);

  if ToEnd then
    // Add to end
    FLangPairs.Add(FConfigFile + '=' + RealPair)
  else
    // Insert as first
    FLangPairs.Insert(0, FConfigFile + '=' + RealPair);

  // Limit to 10 items
  while FLangPairs.Count > FMaxLangPairs do
    FLangPairs.Delete(0);
end;

procedure TformTrayslate.SelectPair(const Pair: string; RunTranslate: boolean = True);
var
  fromLang, toLang: string;
  p, idxnative: integer;
begin
  p := Pos(':', Pair);
  if p > 0 then
  begin
    fromLang := Copy(Pair, 1, p - 1);
    toLang := Copy(Pair, p + 1, Length(Pair));
  end
  else
  begin
    fromLang := string.Empty;
    toLang := string.Empty;
  end;

  idxnative := FindInStringList(FLanguages, '(' + fromLang + ')');
  if idxnative < 0 then
    idxnative := FindInStringList(FLanguages, fromLang);

  if idxnative >= 0 then
    ChangeSourceLang(FLanguages[idxnative], False)
  else
    RunTranslate := False;

  if FLanguagesTarget.Count > 0 then
  begin
    idxnative := FindInStringList(FLanguagesTarget, '(' + toLang + ')');
    if idxnative < 0 then
      idxnative := FindInStringList(FLanguagesTarget, toLang);

    if idxnative >= 0 then
      ChangeTargetLang(FLanguagesTarget[idxnative], False)
    else
      RunTranslate := False;
  end
  else
  begin
    idxnative := FindInStringList(FLanguages, '(' + toLang + ')');
    if idxnative < 0 then
      idxnative := FindInStringList(FLanguages, toLang);

    if idxnative >= 0 then
      ChangeTargetLang(FLanguages[idxnative], False)
    else
      RunTranslate := False;
  end;

  UpdateCheckMenuPair;

  if RunTranslate and not Trans.ServiceOnlyButton then
    TranslateMemo(False);
end;

procedure TformTrayslate.SelectPairConfig(const LangPairIndex: integer; RunTranslate: boolean = True);
var
  Config: string;
  ApplyChanges: boolean;
begin
  // Check config form state and ask to save changes
  ApplyChanges := True;

  if Assigned(formConfigTrayslate) and formConfigTrayslate.HandleAllocated then
    ApplyChanges := formConfigTrayslate.TestChanges;

  if not ApplyChanges then
    Exit;

  // Validate index
  if (LangPairIndex < 0) or (LangPairIndex >= FLangPairs.Count) then
    Exit;

  Config := FLangPairs.Names[LangPairIndex];

  // If config changed - reload
  if FConfigFile <> Config then
  begin
    FConfigFile := Config;
    LoadConfig(False);

    if Assigned(formConfigTrayslate) and formConfigTrayslate.HandleAllocated then
    begin
      try
        formConfigTrayslate.UpdateConfigList;
        formConfigTrayslate.UpdateConfig;
      except
        formConfigTrayslate.Close;
      end;
    end;
  end;

  // Always select pair
  SelectPair(FLangPairs.ValueFromIndex[LangPairIndex], RunTranslate);
end;

procedure TformTrayslate.GlobalCtrlC;
var
  ctrl, shift, alt: boolean;
begin
  TimerUnapply.Enabled := False;
  ctrl := GetAsyncKeyState(VK_CONTROL) < 0;
  shift := GetAsyncKeyState(VK_SHIFT) < 0;
  alt := GetAsyncKeyState(VK_MENU) < 0;

  if not ctrl then
    KeyInput.Apply([ssCtrl]);
  if shift then
    KeyInput.Unapply([ssShift]);
  if alt then
    KeyInput.Unapply([ssAlt]);

  KeyInput.Down(Ord('C'));
  SleepLoop(5, 1);

  FUnapplyC := True;
  if not ctrl then
    FUnapplyCtrl := True;
  TimerUnapply.Enabled := True;

  if shift then
    KeyInput.Apply([ssShift]);
  if alt then
    KeyInput.Apply([ssAlt]);
end;

procedure TformTrayslate.GlobalCtrlV;
var
  ctrl, shift, alt: boolean;
begin
  TimerUnapply.Enabled := False;
  ctrl := GetAsyncKeyState(VK_CONTROL) < 0;
  shift := GetAsyncKeyState(VK_SHIFT) < 0;
  alt := GetAsyncKeyState(VK_MENU) < 0;

  if not ctrl then
    KeyInput.Apply([ssCtrl]);
  if shift then
    KeyInput.Unapply([ssShift]);
  if alt then
    KeyInput.Unapply([ssAlt]);

  KeyInput.Down(Ord('V'));
  SleepLoop(5, 1);

  FUnapplyV := True;
  if not ctrl then
    FUnapplyCtrl := True;
  TimerUnapply.Enabled := True;

  if shift then
    KeyInput.Apply([ssShift]);
  if alt then
    KeyInput.Apply([ssAlt]);
end;

{$IFDEF WINDOWS}

procedure TformTrayslate.UnregisterHotKeys;
var
  i:integer;
begin
  UnregisterHotKey(Handle, HOTKEY_APP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_SWAP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_FROM_CLIPBOARD);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CLIPBOARD);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CLIPBOARD_POPUP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_FROM_CONTROL);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CONTROL);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CONTROL_POPUP);
  for i := 0 to 8 do
    UnregisterHotKey(Handle, HOTKEY_RECENT1 + i);
end;

procedure TformTrayslate.RegisterHotKeys;
begin
  // Unregister first to avoid duplicate registration
  UnregisterHotKeys;

  if not AllowHotKeys then Exit;

  // Register AllowHotKeys if key is assigned
  if FHotKeyApp.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_APP, FHotKeyApp.Modifiers, FHotKeyApp.Key);

  if FHotKeyTransSwap.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_SWAP, FHotKeyTransSwap.Modifiers, FHotKeyTransSwap.Key);

  if FHotKeyTransFromClipboard.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_FROM_CLIPBOARD, FHotKeyTransFromClipboard.Modifiers, FHotKeyTransFromClipboard.Key);

  if FHotKeyTransClipboard.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_CLIPBOARD, FHotKeyTransClipboard.Modifiers, FHotKeyTransClipboard.Key);

  if FHotKeyTransClipboardPopup.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_CLIPBOARD_POPUP, FHotKeyTransClipboardPopup.Modifiers, FHotKeyTransClipboardPopup.Key);

    if FHotKeyTransFromControl.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_FROM_CONTROL, FHotKeyTransFromControl.Modifiers, FHotKeyTransFromControl.Key);

  if FHotKeyTransControl.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_CONTROL, FHotKeyTransControl.Modifiers, FHotKeyTransControl.Key);

  if FHotKeyTransControlPopup.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_CONTROL_POPUP, FHotKeyTransControlPopup.Modifiers, FHotKeyTransControlPopup.Key);

  if FHotKeyRecent1.Key <> 0 then
      RegisterHotKey(Handle, HOTKEY_RECENT1, FHotKeyRecent1.Modifiers, FHotKeyRecent1.Key);
  if FHotKeyRecent2.Key <> 0 then
      RegisterHotKey(Handle, HOTKEY_RECENT2, FHotKeyRecent2.Modifiers, FHotKeyRecent2.Key);
  if FHotKeyRecent3.Key <> 0 then
      RegisterHotKey(Handle, HOTKEY_RECENT3, FHotKeyRecent3.Modifiers, FHotKeyRecent3.Key);
  if FHotKeyRecent4.Key <> 0 then
      RegisterHotKey(Handle, HOTKEY_RECENT4, FHotKeyRecent4.Modifiers, FHotKeyRecent4.Key);
  if FHotKeyRecent5.Key <> 0 then
      RegisterHotKey(Handle, HOTKEY_RECENT5, FHotKeyRecent5.Modifiers, FHotKeyRecent5.Key);
  if FHotKeyRecent6.Key <> 0 then
      RegisterHotKey(Handle, HOTKEY_RECENT6, FHotKeyRecent6.Modifiers, FHotKeyRecent6.Key);
  if FHotKeyRecent7.Key <> 0 then
      RegisterHotKey(Handle, HOTKEY_RECENT7, FHotKeyRecent7.Modifiers, FHotKeyRecent7.Key);
  if FHotKeyRecent8.Key <> 0 then
      RegisterHotKey(Handle, HOTKEY_RECENT8, FHotKeyRecent8.Modifiers, FHotKeyRecent8.Key);
  if FHotKeyRecent9.Key <> 0 then
      RegisterHotKey(Handle, HOTKEY_RECENT9, FHotKeyRecent9.Modifiers, FHotKeyRecent9.Key);
end;

{$ENDIF}

{ Methods Translate }

function TformTrayslate.TranslateThread(ATrans: TTranslate; AText: string; AMemo: TMemo = nil): string;
var
  Th: TTranslateThread;
begin
  Result := string.Empty;
  if FCancelled then
  begin
    Screen.Cursor := crDefault;
    TimerAnimate.Enabled := False;
    Exit;
  end;

  try
    //if (LangSource = string.Empty) or (LangTarget = string.Empty) then Exit;

    // Cancel old translation
    if Assigned(FTranslateThread) then
      FTranslateThread.Cancel;

    // Create translation thread (it will handle exceptions itself)
    ATrans.TextToTranslate := AText;
    Th := TTranslateThread.Create(ATrans, AMemo, TimerAnimate, Assigned(AMemo));
    FTranslateThread := Th;

    if Assigned(AMemo) then
      Th.OnTerminate := @ThreadDone
    else
    begin
      try
        // Wait for thread to finish
        while not Th.Finished do
        begin
          if FCancelled then Exit;

          Application.ProcessMessages;
          Sleep(1); // reduce CPU usage
        end;

        // Set translated text to clipboard
        if Assigned(Th) and not FCancelled and (Th.ResultTextSync <> string.Empty) then
          Result := Th.ResultTextSync;
      finally
        if Assigned(Th) then
          Th.Free;
        if FTranslateThread = Th then
          FTranslateThread := nil;
      end;
    end;
  finally
    if not Assigned(AMemo) and (ATrans <> TransDetect) then
    begin
      Screen.Cursor := crDefault;
      TimerAnimate.Enabled := False;
    end;
  end;
end;

procedure TformTrayslate.ThreadDone(Sender: TObject);
begin
  FTranslateThread := nil;

  if Assigned(formPopupTrayslate) and (formPopupTrayslate.Visible) and (FAutoHeightAfter) then
  begin
    FAutoHeightAfter := False;
    AdjustPopupHeight(formPopupTrayslate.MemoTarget.Text);
  end;

  if not Visible and (not Assigned(formPopupTrayslate) or not formPopupTrayslate.Visible) then
    ShowCustomHint(TrayIcon.Hint);
end;

procedure TformTrayslate.CancelTranslate;
begin
  FCancelled := True;
  try
    if Assigned(FTranslateThread) then
      FTranslateThread.Cancel;
  finally
    TimerAnimate.Enabled := False;
    Screen.Cursor := crDefault;
    {$IFDEF WINDOWS}
    SystemParametersInfo(SPI_SETCURSORS, 0, nil, 0);
    {$ENDIF}
  end;
end;

procedure TformTrayslate.DetectLanguage(AText: string);
var
  langSrc, langTar, langDetect, langPrimary, langSecondary: string;
  idxSrc, idxTar: integer;
  NeedHint: boolean = False;
begin
  if FCancelled then Exit;
  if not FAutoSwap or not Trans.ServiceAutoSwap or not Assigned(FTransDetect) then Exit;

  langSrc := string.Empty;
  langTar := string.Empty;
  idxSrc := FLanguages.IndexOf(ComboSource.Text);
  idxTar := FLanguages.IndexOf(ComboTarget.Text);
  //  if (idxSrc < 0) or (idxTar < 0) then Exit;

  Screen.Cursor := crAppStart;
  TimerAnimate.Enabled := True;

  // Detect language in source memo
  langDetect := LowerCase(TranslateThread(TransDetect, ExtractTextSample(AText)));

  if FCancelled or (langDetect = string.Empty) or (Length(langDetect) > 5) then Exit;

  langPrimary := LowerCase(PrimaryLang);
  langSecondary := LowerCase(SecondaryLang);

  // Check selected languages
  if (idxSrc >= 0) then
    langSrc := LowerCase(Trans.Languages.Names[idxSrc]);
  if (idxTar >= 0) then
    langTar := LowerCase(Trans.Languages.Names[idxTar]);

  // Swap if needed
  if not SmartSwap then
  begin
    // Ordinary swap
    if ((langSrc = langDetect) or (langTar = langDetect)) and (not IsSpecialCode(langSrc)) and (not IsSpecialCode(langTar)) then
    begin
      if (langTar = langDetect) then
      begin
        SwapLanguages;
        ShowCustomHint(TrayIcon.Hint);
      end;
    end;
  end
  else
  begin
    // Smart swap
    if ((langSrc = langDetect) or (langTar = langDetect)) and (not IsSpecialCode(langSrc)) and
      (not IsSpecialCode(langTar)) and ((not SmartHard) or (((langSrc = langPrimary) and (langTar = langSecondary)) or
      ((langSrc = langSecondary) and (langTar = langPrimary)))) then
    begin
      if (langTar = langDetect) then
      begin
        SwapLanguages;
        ShowCustomHint(TrayIcon.Hint);
      end;
    end
    else
    begin
      if (langSrc <> langDetect) or (IsSpecialCode(langSrc)) then
      begin
        if (langDetect = langPrimary) then
        begin
          if (langSrc <> langPrimary) and (not IsSpecialCode(langSrc)) then
          begin
            ChangeSourceLang(FLanguages[Trans.Languages.IndexOfName(langPrimary)], False);
            NeedHint := True;
          end;
          if (langTar <> langSecondary) and (SmartHard) then
          begin
            ChangeTargetLang(FLanguages[Trans.Languages.IndexOfName(langSecondary)]);
            NeedHint := True;
          end;
          if NeedHint then
            ShowCustomHint(TrayIcon.Hint);
        end
        else
        begin
          if (langSrc <> langDetect) and (not IsSpecialCode(langSrc)) then
          begin
            ChangeSourceLang(FLanguages[Trans.Languages.IndexOfName(langDetect)], False);
            NeedHint := True;
          end;
          if (langTar <> langPrimary) and (SmartHard) then
          begin
            ChangeTargetLang(FLanguages[Trans.Languages.IndexOfName(langPrimary)]);
            NeedHint := True;
          end;
          if NeedHint then
            ShowCustomHint(TrayIcon.Hint);
        end;
      end;
    end;
  end;
end;

procedure TformTrayslate.TranslateMemo(ADetectLanguage: boolean = True);
begin
  FCancelled := False;

  if TimerTranslate.Enabled then
    TimerTranslate.Enabled := False;

  if Assigned(formPopupTrayslate) and formPopupTrayslate.Visible and formPopupTrayslate.Active then
  begin
    if Trim(formPopupTrayslate.SourceText) = string.Empty then
    begin
      formPopupTrayslate.MemoTarget.Clear;
      Exit;
    end;

    if (ADetectLanguage) then
      DetectLanguage(formPopupTrayslate.SourceText);

    // Create translation thread for popup
    TranslateThread(Trans, formPopupTrayslate.SourceText, formPopupTrayslate.MemoTarget);
  end
  else
  begin
    if (Trim(MemoSource.Text) = string.Empty) then
    begin
      Screen.Cursor := crDefault;
      TimerAnimate.Enabled := False;
      MemoTarget.Clear;
      Exit;
    end;

    if (ADetectLanguage) then
      DetectLanguage(MemoSource.Text);

    // Create translation thread
    TranslateThread(Trans, MemoSource.Text, MemoTarget);
  end;
end;

procedure TformTrayslate.TranslatePopup(AText: string; X: integer = 0; Y: integer = 0);
begin
  FCancelled := False;

  Screen.Cursor := crAppStart;
  TimerAnimate.Enabled := True;

  if TimerTranslate.Enabled then
    TimerTranslate.Enabled := False;

  ShowPopup(AText, ifthen(X > 0, X, Mouse.CursorPos.X), ifthen(Y > 0, Y, Mouse.CursorPos.Y));

  DetectLanguage(AText);

  // Create translation thread (it will handle exceptions itself)
  TranslateThread(Trans, AText, formPopupTrayslate.MemoTarget);
end;

procedure TformTrayslate.TranslateFromClipboard;
begin
  FCancelled := False;

  if not Showing then
    Show;
  BringToFront;
  FTopMost := True;
  SleepLoop(0, 1);
  if (Clipboard.AsText <> string.empty) then
  begin
    MemoSource.Text := Clipboard.AsText;
    TranslateMemo;
  end;
end;

procedure TformTrayslate.TranslateClipboard;
var
  TranslatedText: string;
begin
  FCancelled := False;

  {$IFDEF WINDOWS}
  SetSystemCursor(LoadCursor(0, IDC_APPSTARTING), OCR_IBEAM);
  Application.ProcessMessages;
  {$ELSE}
  Screen.Cursor := crAppStart;
  {$ENDIF}
  try
    if TimerTranslate.Enabled then
      TimerTranslate.Enabled := False;

    if Clipboard.AsText = string.Empty then Exit;

    DetectLanguage(Clipboard.AsText);

    TranslatedText := TranslateThread(Trans, Clipboard.AsText);

    if Trim(TranslatedText) <> string.Empty then
      Clipboard.AsText := TranslatedText;
  finally
    {$IFDEF WINDOWS}
    SystemParametersInfo(SPI_SETCURSORS, 0, nil, 0);
    {$ELSE}
    Screen.Cursor := crDefault;
    {$ENDIF}
  end;
end;

procedure TformTrayslate.TranslateClipboardPopup(NearMouse: boolean = False);
var
  ClipboardText: string;
begin
  FCancelled := False;

  {$IFDEF WINDOWS}
  SetSystemCursor(LoadCursor(0, IDC_APPSTARTING), OCR_IBEAM);
  Application.ProcessMessages;
  {$ELSE}
  Screen.Cursor := crAppStart;
  {$ENDIF}
  try
    if TimerTranslate.Enabled then
      TimerTranslate.Enabled := False;

    ClipboardText := Trim(Clipboard.AsText);

    if NearMouse then
      ShowPopup(ClipboardText, Mouse.CursorPos.X, Mouse.CursorPos.Y)
    else
      ShowPopup(ClipboardText);
    if ClipboardText = string.Empty then Exit;

    DetectLanguage(ClipboardText);

    // Create translation thread (it will handle exceptions itself)
    TranslateThread(Trans, ClipboardText, formPopupTrayslate.MemoTarget);
  finally
    {$IFDEF WINDOWS}
    SystemParametersInfo(SPI_SETCURSORS, 0, nil, 0);
    {$ELSE}
    Screen.Cursor := crDefault;
    {$ENDIF}
  end;
end;

procedure TformTrayslate.TranslateFromControl(Data: PtrInt);
var
  OriginalClip, SelectedText: string;
begin
  FCancelled := False;

  Screen.Cursor := crAppStart;
  TimerAnimate.Enabled := True;

  // Save current clipboard to restore later
  OriginalClip := Clipboard.AsText;
  Clipboard.AsText := string.Empty;
  try
    // Copy selection from active window (Ctrl+C)
    GlobalCtrlC;

    SelectedText := Clipboard.AsText;

    if (not Showing) then
      Show;
    BringToFront;
    FTopMost := True;
    SleepLoop(0, 1);
    MemoSource.Text := SelectedText;
    TranslateMemo;
  finally
    // Restore original clipboard
    Clipboard.AsText := OriginalClip;
  end;
end;

procedure TformTrayslate.TranslateControl(Data: PtrInt);
var
  OriginalClip: string;
  TranslatedText: string;
begin
  FCancelled := False;

  {$IFDEF WINDOWS}
  SetSystemCursor(LoadCursor(0, IDC_APPSTARTING), OCR_IBEAM);
  Application.ProcessMessages;
  {$ELSE}
  Screen.Cursor := crAppStart;
  {$ENDIF}
  try
    if TimerTranslate.Enabled then
      TimerTranslate.Enabled := False;

    // Save current clipboard to restore later
    OriginalClip := Clipboard.AsText;
    Clipboard.AsText := string.Empty;
    try

      // Copy selection from active window (Ctrl+C)
      GlobalCtrlC;

      if Clipboard.AsText <> string.Empty then
      begin
        DetectLanguage(Clipboard.AsText);

        TranslatedText := TranslateThread(Trans, Clipboard.AsText);
        if Trim(TranslatedText) <> string.Empty then
        begin
          Clipboard.AsText := TranslatedText;

          // Paste clipboard to active window (Ctrl+V)
          GlobalCtrlV;
        end;
      end;
    finally
      // Restore original clipboard
      Clipboard.AsText := OriginalClip;
    end;
  finally
    {$IFDEF WINDOWS}
    SystemParametersInfo(SPI_SETCURSORS, 0, nil, 0);
    {$ELSE}
    Screen.Cursor := crDefault;
    {$ENDIF}
  end;
end;

procedure TformTrayslate.TranslateControlPopup(Data: PtrInt);
var
  OriginalClip, SelectedText: string;
begin
  FCancelled := False;

  Screen.Cursor := crAppStart;
  TimerAnimate.Enabled := True;

  // Save current clipboard to restore later
  OriginalClip := Clipboard.AsText;
  Clipboard.AsText := string.Empty;
  try
    if TimerTranslate.Enabled then
      TimerTranslate.Enabled := False;

    // Copy selection from active window (Ctrl+C)
    GlobalCtrlC;

    SelectedText := Clipboard.AsText;

    ShowPopup(SelectedText, Mouse.CursorPos.X, Mouse.CursorPos.Y);

    DetectLanguage(SelectedText);

    // Create translation thread (it will handle exceptions itself)
    TranslateThread(Trans, SelectedText, formPopupTrayslate.MemoTarget);
  finally
    // Restore original clipboard
    Clipboard.AsText := OriginalClip;
  end;
end;

procedure TformTrayslate.TranslateMouseMode(ACursorPos: TPoint);
var
  OriginalClip, SelectedText, TranslatedText: string;
begin
  FCancelled := False;
  FMouseHook.Enabled := False;
  try
    // Save current clipboard to restore later
    OriginalClip := Clipboard.AsText;
    Clipboard.AsText := string.Empty;
    try
      // Copy selection from active window (Ctrl+C)
      GlobalCtrlC;
      SelectedText := Clipboard.AsText;
    finally
      // Restore original clipboard only if one of the copy combination keys is not pressed
      if (((GetTickCountXp - FLastCtrlTime) <= 100) and ((GetTickCountXp - FLastVTime) <= 100)) then
        Clipboard.AsText := OriginalClip
      else
      if (((GetTickCountXp - FLastCtrlTime) > 100) and ((GetTickCountXp - FLastCTime) > 100) and
        ((GetTickCountXp - FLastXTime) > 100)) then
        Clipboard.AsText := OriginalClip;

      if (GetTickCountXp - FLastKeyTime) > 200 then
        TimerUnapplyTimer(Self);
    end;

    if (Trim(SelectedText) <> string.Empty) then
    begin
      if TimerTranslate.Enabled then
        TimerTranslate.Enabled := False;

      case MouseMode of
        mmShowTranslateButton:
        begin
          ShowButton(SelectedText, ACursorPos.X, ACursorPos.Y);
        end;

        mmShowBalloonTranslation:
        begin
          DetectLanguage(SelectedText);

          TranslatedText := TranslateThread(Trans, SelectedText);
          if Trim(TranslatedText) <> string.Empty then
          begin
            TrayIcon.BalloonTitle := TrayIcon.Hint;
            TrayIcon.BalloonHint := TranslatedText;
            TrayIcon.ShowBalloonHint;
          end;
        end;

        mmShowPopupTranslation:
        begin
          ShowPopup(SelectedText, ACursorPos.X, ACursorPos.Y);

          DetectLanguage(SelectedText);

          // Create translation thread (it will handle exceptions itself)
          TranslateThread(Trans, SelectedText, formPopupTrayslate.MemoTarget);
        end;

        mmShowMainWindow:
        begin
          if (not Showing) then
            Show;
          BringToFront;
          FTopMost := True;
          SleepLoop(0, 1);
          MemoSource.Text := SelectedText;
          TranslateMemo;
        end;
        else
          ;
      end;
    end
    else
      TimerUnapplyTimer(Self);
  finally
    FMouseHook.Enabled := FEnableMouseMode;
  end;
end;

{ Action Languages }

procedure TformTrayslate.SetLanguage(aLanguage: string = string.Empty);
var
  OldAutoDetect: string = string.Empty;
  LangCode: string;
  PoText: string;
begin
  LangCode := aLanguage;
  PoText := string.Empty;

  aLangArabic.Checked := False;
  aLangBelarusian.Checked := False;
  aLangBulgarian.Checked := False;
  aLangChinese.Checked := False;
  aLangCzech.Checked := False;
  aLangDanish.Checked := False;
  aLangDutch.Checked := False;
  aLangEnglish.Checked := False;
  aLangFinnish.Checked := False;
  aLangFrench.Checked := False;
  aLangGerman.Checked := False;
  aLangGreek.Checked := False;
  aLangHebrew.Checked := False;
  aLangHindi.Checked := False;
  aLangIndonesian.Checked := False;
  aLangItalian.Checked := False;
  aLangJapanese.Checked := False;
  aLangKorean.Checked := False;
  aLangPolish.Checked := False;
  aLangPortuguese.Checked := False;
  aLangRomanian.Checked := False;
  aLangRussian.Checked := False;
  aLangSpanish.Checked := False;
  aLangSwedish.Checked := False;
  aLangTurkish.Checked := False;
  aLangUkrainian.Checked := False;
  aLangCustom.Checked := False;

  if FCustomPoFile <> string.Empty then
  begin
    PoText := LoadCustomPoFile(FCustomPoFile);
    if PoText = string.Empty then
    begin
      FCustomPoFile := string.Empty;
      LangCode := GetOSLanguage;
    end
    else
      LangCode := GetLangCodeFromPoFile(FCustomPoFile);
  end;

  if (LangCode <> string.Empty) then
  begin
    OldAutoDetect := rautodetect;
    Language := LangCode;
    ApplicationTranslate(DEFAULT_LANG);
    if not ApplicationTranslate(Language, nil, PoText) then
      Language := DEFAULT_LANG;
  end;

  // Update Language Names
  if OldAutoDetect <> string.Empty then
  begin
    ReplaceInStrings(FLanguages, OldAutoDetect, rautodetect);
    ReplaceInStrings(FLanguagesTarget, OldAutoDetect, rautodetect);
    ReplaceInStrings(ComboSource.Items, OldAutoDetect, rautodetect);
    ReplaceInStrings(ComboTarget.Items, OldAutoDetect, rautodetect);
  end;

  // Update form text
  SetHints;
  SetIcon;

  if FCustomPoFile = string.Empty then
  begin
    case Language of
      'ar': aLangArabic.Checked := True;
      'be': aLangBelarusian.Checked := True;
      'bg': aLangBulgarian.Checked := True;
      'zh': aLangChinese.Checked := True;
      'cs': aLangCzech.Checked := True;
      'da': aLangDanish.Checked := True;
      'nl': aLangDutch.Checked := True;
      'en': aLangEnglish.Checked := True;
      'fi': aLangFinnish.Checked := True;
      'fr': aLangFrench.Checked := True;
      'de': aLangGerman.Checked := True;
      'el': aLangGreek.Checked := True;
      'he': aLangHebrew.Checked := True;
      'hi': aLangHindi.Checked := True;
      'id': aLangIndonesian.Checked := True;
      'it': aLangItalian.Checked := True;
      'ja': aLangJapanese.Checked := True;
      'ko': aLangKorean.Checked := True;
      'pl': aLangPolish.Checked := True;
      'pt': aLangPortuguese.Checked := True;
      'ro': aLangRomanian.Checked := True;
      'ru': aLangRussian.Checked := True;
      'es': aLangSpanish.Checked := True;
      'sv': aLangSwedish.Checked := True;
      'tr': aLangTurkish.Checked := True;
      'uk': aLangUkrainian.Checked := True;
      else
      // nolang
    end;
  end
  else
    aLangCustom.Checked := True;
end;

function TformTrayslate.GetLangCodeFromPoFile(const AFileName: string): string;
var
  BaseName: string;
  ExtPos: integer;
  c1, c2: char;
begin
  Result := DEFAULT_LANG;

  if AFileName = string.Empty then
    Exit;

  BaseName := ExtractFileName(AFileName);

  // Find ".po"
  ExtPos := Pos('.po', LowerCase(BaseName));
  if ExtPos = 0 then
    Exit;

  BaseName := Copy(BaseName, 1, ExtPos - 1);

  if Length(BaseName) < 2 then
    Exit;

  // Take last 2 chars
  c1 := BaseName[Length(BaseName) - 1];
  c2 := BaseName[Length(BaseName)];

  // Check if both are latin letters
  if (c1 in ['a'..'z', 'A'..'Z']) and (c2 in ['a'..'z', 'A'..'Z']) then
    Result := LowerCase(c1 + c2)
  else
    Result := DEFAULT_LANG;
end;

function TformTrayslate.LoadCustomPoFile(const AFileName: string): string;
var
  FileContent: TStringList;
begin
  Result := string.Empty;

  if AFileName = string.Empty then
    Exit;

  FileContent := TStringList.Create;
  try
    try
      FileContent.LoadFromFile(AFileName); // Unicode-safe
      Result := FileContent.Text;
    except
      // On any error return empty string
      Result := string.Empty;
    end;
  finally
    FileContent.Free;
  end;
end;

procedure TformTrayslate.aLangCustomExecute(Sender: TObject);
begin
  if not OpenPo.Execute then
    Exit;

  FCustomPoFile := OpenPo.FileName;
  SetLanguage;
end;

procedure TformTrayslate.aLangArabicExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('ar');
end;

procedure TformTrayslate.aLangBelarusianExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('be');
end;

procedure TformTrayslate.aLangBulgarianExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('bg');
end;

procedure TformTrayslate.aLangChineseExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('zh');
end;

procedure TformTrayslate.aLangCzechExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('cs');
end;

procedure TformTrayslate.aLangDanishExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('da');
end;

procedure TformTrayslate.aLangDutchExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('nl');
end;

procedure TformTrayslate.aLangEnglishExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('en');
end;

procedure TformTrayslate.aLangFinnishExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('fi');
end;

procedure TformTrayslate.aLangFrenchExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('fr');
end;

procedure TformTrayslate.aLangGermanExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('de');
end;

procedure TformTrayslate.aLangGreekExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('el');
end;

procedure TformTrayslate.aLangHebrewExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('he');
end;

procedure TformTrayslate.aLangHindiExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('hi');
end;

procedure TformTrayslate.aLangIndonesianExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('id');
end;

procedure TformTrayslate.aLangItalianExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('it');
end;

procedure TformTrayslate.aLangJapaneseExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('ja');
end;

procedure TformTrayslate.aLangKoreanExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('ko');
end;

procedure TformTrayslate.aLangPolishExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('pl');
end;

procedure TformTrayslate.aLangPortugueseExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('pt');
end;

procedure TformTrayslate.aLangRomanianExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('ro');
end;

procedure TformTrayslate.aLangRussianExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('ru');
end;

procedure TformTrayslate.aLangSpanishExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('es');
end;

procedure TformTrayslate.aLangSwedishExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('sv');
end;

procedure TformTrayslate.aLangTurkishExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('tr');
end;

procedure TformTrayslate.aLangUkrainianExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('uk');
end;

end.
