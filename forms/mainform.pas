//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit mainform;

{$mode ObjFPC}{$H+}
{$codepage utf8}
{$modeswitch typehelpers}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  Messages,
  {$ENDIF}
  {$IFDEF DEBUG}
  heaptrc,
  {$ENDIF}
  Types,
  Classes,
  SysUtils,
  DateUtils,
  Forms,
  Controls,
  Graphics,
  IntfGraphics,
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
  MouseAndKeyInput,
  RichMemo,
  RichSpellChecker,
  SpellUtils,
  OneShotTimer,
  globalkeyboardhook,
  globalmousehook,
  translate,
  network,
  Consts,
  osutils,
  stringhelper,
  hotkeyhelper,
  stringshelper,
  clipboardhelper,
  oneshothint,
  textdroptarget;

type

  { TformTrayslate }

  TformTrayslate = class(TForm)
    {%Region -fold Form Common}
    aAbout: TAction;
    aConfigEditor: TAction;
    aCheckForUpdates: TAction;
    aAddPair: TAction;
    aAutoCheckUpdates: TAction;
    aCopySource: TAction;
    aCopyTarget: TAction;
    aCopy: TAction;
    aDefaultZoom: TAction;
    aFastSpellCheck: TAction;
    aTargetBidiRightToLeft: TAction;
    aSourceBidiRightToLeft: TAction;
    aSelectAll: TAction;
    aClear: TAction;
    aPaste: TAction;
    aUndo: TAction;
    aCut: TAction;
    aFastAutoHeight: TAction;
    aLangVietnamese: TAction;
    aDeletePair: TAction;
    aMoveLast: TAction;
    aMoveRight: TAction;
    aMoveFirst: TAction;
    aMoveLeft: TAction;
    aLangPortugueseBrazil: TAction;
    aFastAutoCopy: TAction;
    aFastMouseModeCtrl: TAction;
    aFastAllowHotKeys: TAction;
    aFastEnableMouseMode: TAction;
    aFastAutoSwap: TAction;
    aFastRealTime: TAction;
    aFastAutoAddLangPairs: TAction;
    aFastAutoHidePopup: TAction;
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
    MenuFastSpellCheck: TMenuItem;
    MenuSourceDefaultZoom: TMenuItem;
    MenuTargetDefaultZoom: TMenuItem;
    MenuSourceBidiMode: TMenuItem;
    MenuTargetUndo: TMenuItem;
    MenuTargetCut: TMenuItem;
    MenuTargetCopy: TMenuItem;
    MenuTargetPaste: TMenuItem;
    MenuTargetClear: TMenuItem;
    MenuTargetSelectAll: TMenuItem;
    MenuTargetBidiMode: TMenuItem;
    MenuItem2: TMenuItem;
    MenuFastSettings: TMenuItem;
    MenuFastAllowHotKeys: TMenuItem;
    MenuFastEnableMouseMode: TMenuItem;
    MenuFastVerticalSplit: TMenuItem;
    MenuFastAutoSwap: TMenuItem;
    MenuFastRealTime: TMenuItem;
    MenuFastAutoAddLangPairs: TMenuItem;
    MenuFastAutoHide: TMenuItem;
    MenuItem3: TMenuItem;
    MenuFastAutoHeight: TMenuItem;
    MenuSourceUndo: TMenuItem;
    MenuSourceCut: TMenuItem;
    MenuSourceCopy: TMenuItem;
    MenuSourcePaste: TMenuItem;
    MenuSourceClear: TMenuItem;
    MenuSourceSelectAll: TMenuItem;
    MenuRecentConfigEditor: TMenuItem;
    MenuVietnamese: TMenuItem;
    MenuMoveLeft: TMenuItem;
    MenuMoveRight: TMenuItem;
    MenuMoveFirst: TMenuItem;
    MenuMoveLast: TMenuItem;
    MenuDeletePair: TMenuItem;
    MenuPortugueseBrazil: TMenuItem;
    OpenPo: TOpenDialog;
    PopupSource: TPopupMenu;
    PopupRecentPair: TPopupMenu;
    PopupTarget: TPopupMenu;
    SbCopySource: TSpeedButton;
    SbCopyTarget: TSpeedButton;
    ComboSource: TComboBox;
    ComboTarget: TComboBox;
    FlowPairs: TFlowPanel;
    ImageButtons: TImageList;
    MemoSource: TRichMemo;
    MemoTarget: TRichMemo;
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
    Separator10: TMenuItem;
    Separator11: TMenuItem;
    Separator12: TMenuItem;
    Separator13: TMenuItem;
    Separator14: TMenuItem;
    Separator15: TMenuItem;
    Separator16: TMenuItem;
    Separator2: TMenuItem;
    SbSwap: TSpeedButton;
    SbTranslate: TSpeedButton;
    Separator3: TMenuItem;
    Separator4: TMenuItem;
    Separator5: TMenuItem;
    Separator6: TMenuItem;
    Separator7: TMenuItem;
    Separator8: TMenuItem;
    Separator9: TMenuItem;
    Splitter: TSplitter;
    TimerUnapply: TTimer;
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
    procedure ComboDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ApplicationPropActivate(Sender: TObject);
    procedure ApplicationPropDeactivate(Sender: TObject);
    procedure ApplicationPropShowHint(var HintStr: string; var CanShow: boolean; var HintInfo: THintInfo);
    procedure ApplicationPropException(Sender: TObject; E: Exception);
    procedure ApplicationPropUserInput(Sender: TObject; Msg: cardinal);
    procedure ApplicationPropEndSession(Sender: TObject);
    procedure PopupRecentPairPopup(Sender: TObject);
    procedure OnTextDroppedHandler(Sender: TObject; const AText: string);
    procedure ScreenActiveFormChanged(Sender: TObject);
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
    procedure aDeletePairExecute(Sender: TObject);
    procedure aMenuExecute(Sender: TObject);
    procedure aMoveFirstExecute(Sender: TObject);
    procedure aMoveLastExecute(Sender: TObject);
    procedure aMoveLeftExecute(Sender: TObject);
    procedure aMoveRightExecute(Sender: TObject);
    procedure aUndoExecute(Sender: TObject);
    procedure aCutExecute(Sender: TObject);
    procedure aCopyExecute(Sender: TObject);
    procedure aPasteExecute(Sender: TObject);
    procedure aClearExecute(Sender: TObject);
    procedure aSelectAllExecute(Sender: TObject);
    procedure aSourceBidiRightToLeftExecute(Sender: TObject);
    procedure aTargetBidiRightToLeftExecute(Sender: TObject);
    procedure aDefaultZoomExecute(Sender: TObject);
    procedure aAutoCheckUpdatesExecute(Sender: TObject);
    procedure aCheckForUpdatesExecute(Sender: TObject);
    procedure aDonateExecute(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure aFastAllowHotKeysExecute(Sender: TObject);
    procedure aFastEnableMouseModeExecute(Sender: TObject);
    procedure aFastMouseModeCtrlExecute(Sender: TObject);
    procedure aFastAutoAddLangPairsExecute(Sender: TObject);
    procedure aFastAutoSwapExecute(Sender: TObject);
    procedure aFastAutoHidePopupExecute(Sender: TObject);
    procedure aFastRealTimeExecute(Sender: TObject);
    procedure aFastVerticalSplitExecute(Sender: TObject);
    procedure aFastAutoCopyExecute(Sender: TObject);
    procedure aFastAutoHeightExecute(Sender: TObject);
    procedure aFastSpellCheckExecute(Sender: TObject);
    procedure ComboSourceCloseUp(Sender: TObject);
    procedure ComboTargetCloseUp(Sender: TObject);
    procedure ComboSourceDropDown(Sender: TObject);
    procedure ComboTargetDropDown(Sender: TObject);
    procedure ComboSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ComboTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoSourceChange(Sender: TObject);
    procedure MemoSourceContextPopup(Sender: TObject; MousePos: TPoint; var Handled: boolean);
    procedure MemoSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoSourceKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoTargetChange(Sender: TObject);
    procedure SettingsFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure PanelLangResize(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure SbSwapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure TimerActiveTimer(Sender: TObject);
    procedure TimerAnimateStopTimer(Sender: TObject);
    procedure TimerAnimateTimer(Sender: TObject);
    procedure TimerUnapplyTimer(Sender: TObject);
    procedure TimerTranslateTimer(Sender: TObject);
    procedure TimerClickTimer(Sender: TObject);
    procedure TrayIconMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure TrayIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure TrayIconClick(Sender: TObject);
    procedure FlowPairsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FlowPairsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure ButtonLangMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure ButtonLangMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure ButtonLangMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure MenuConfigItemClick(Sender: TObject);
    procedure MenuPairClick(Sender: TObject);
    procedure PopupTrayClose(Sender: TObject);
    procedure PopupTrayPopup(Sender: TObject);
    procedure aLangCustomExecute(Sender: TObject);
    procedure aLangBulgarianExecute(Sender: TObject);
    procedure aLangPortugueseBrazilExecute(Sender: TObject);
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
    procedure aLangVietnameseExecute(Sender: TObject);
    {%EndRegion}
  private
    FTrans: TTranslate;
    FTransDetect: TTranslate;
    FTranslateThread: TTranslateThread;
    FTranslateTarget: TWinControl;
    FFormSmallIcon: TIcon;
    FDropTarget: TTextDropTarget;
    FRawTranslate: string;
    FActiveThreads: TList;
    FProxy: TProxy;
    FTimeout: TTimeout;
    FCancelled: boolean;
    FTopMost: boolean;
    FLeftButton: boolean;
    FLastEnterTime: DWORD;
    FEnterCount: integer;
    FLastHotkeyTime: DWORD;
    FLastMouseInfo: TMouseEventInfo;
    FClickCount: integer;
    FClickTimer: TTimer;
    FClickPoint: TPoint;
    FMemoSourceCaretPos: integer;
    FPrevSourceText: string;
    FPrevTargetText: string;
    FUserParameters: TStringList;
    FLangPairs: TStringList;
    FLangPairsHint: TStringList;
    FMouseHook: TGlobalMouseHook;
    FKeyHook: TGlobalKeyboardHook;
    FPopupOpen: boolean;
    FHint: TOneShotHint;
    FFontPopup: TFont;
    FUnapplyCtrl: boolean;
    FUnapplyShift: boolean;
    FUnapplyInsert: boolean;
    FUnapplyC: boolean;
    FUnapplyV: boolean;
    FLastKeyTime: DWORD;
    FLastCtrlTime: DWORD;
    FLastCTime: DWORD;
    FLastXTime: DWORD;
    FLastVTime: DWORD;
    FPrevMouseDown: TMouseEventInfo;
    FPopupRecentPair: TComponent;
    FSettingsPage: integer;
    FSettingTrayIcon: boolean;
    FBlockTrayUpdate: boolean;
    FProcessingPairClick: boolean;
    FNeedRebuildPairs: boolean;
    FSpellChecker: TRichSpellChecker;
    FSpellTimer: TTimer;
    FUpdatingSpellCheck: boolean;
    FSpellErrors: TSpellErrorArray;
    FSpellText: string;
    FIgnoreKeyUpCode: word;

    // Non sorted combo named languages
    FLanguages: TStringList;
    FLanguagesTarget: TStringList;

    // Settings
    FFormSettingsLoaded: boolean;
    FPortable: boolean;
    FFirstRun: boolean;
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
    FBuiltInDetect: boolean;
    FSmartSwap: boolean;
    FSmartHard: boolean;
    FPrimaryLang: string;
    FSecondaryLang: string;
    FMouseMode: TMouseMode;
    FInsertKey: boolean;
    FHideControls: boolean;
    FStayOnTop: boolean;
    FAutoHeightAfter: boolean;
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
    FFormConfigSep1: integer;
    FFormConfigSep2: integer;
    FFormPopupLeft: integer;
    FFormPopupTop: integer;
    FFormPopupWidth: integer;
    FFormPopupHeight: integer;
    FFormPopupZoomFactor: double;
    FFormPopupBidiMode: TBiDiMode;
    FFormAboutWidth: integer;
    FFormAboutHeight: integer;
    FFormSettingsLeft: integer;
    FFormSettingsTop: integer;
    FFormSettingsWidth: integer;
    FFormSettingsHeight: integer;
    FFormSettingsSplit: integer;
    FLastDarkMode: boolean;
    FCustomPoFile: string;
    FProxiedConfigs: TStringList;
    FEnabledLanguages: TStringList;
    // HotKeys Common
    FHotKeyApp: THotKeyData;
    FHotKeyTransSwap: THotKeyData;
    FHotKeyTransFromClipboard: THotKeyData;
    FHotKeyTransClipboard: THotKeyData;
    FHotKeyTransClipboardPopup: THotKeyData;
    FHotKeyTransFromControl: THotKeyData;
    FHotKeyTransControl: THotKeyData;
    FHotKeyTransControlPopup: THotKeyData;
    // HotKeys Fastsettings
    FHotKeyFastAllowHotKeys: THotKeyData;
    FHotKeyFastEnableMouseMode: THotKeyData;
    FHotKeyFastMouseModeCtrl: THotKeyData;
    FHotKeyFastAutoSwap: THotKeyData;
    FHotKeyFastAutoAddLangPairs: THotKeyData;
    FHotKeyFastRealTime: THotKeyData;
    FHotKeyFastAutoCopy: THotKeyData;
    FHotKeyFastVerticalSplit: THotKeyData;
    FHotKeyFastAutoHeight: THotKeyData;
    FHotKeyFastAutoHide: THotKeyData;
    FHotKeyFastSpellCheck: THotKeyData;
    // HotKey Recent Pairs
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
    FIconMouseModeFrameColor: TColor;
    FIconFontColor: TColor;
    FIconFontName: string;
    FIconTwoLang: boolean;
    FIconCircular: boolean;

    // Drag recent button
    FDragBtnIndex: integer;    // Index of the button being dragged
    FDragBtnStartX: integer;   // X coordinate when mouse button was pressed
    FDragBtnStartY: integer;   // Y coordinate when mouse button was pressed
    FDragBtnLastX: integer;    // Last X coordinate during drag, used for direction detection
    FDragBtnLastY: integer;    // Last Y coordinate of the last successful move
    FDragMoved: boolean;

    procedure SetAutoStart(Value: boolean);
    procedure SetAutoAddLangPairs(Value: boolean);
    procedure SetAutoSwap(Value: boolean);
    procedure SetAllowHotkeys(Value: boolean);
    procedure SetEnableMouseMode(Value: boolean);
    procedure SetMouseModeCtrl(Value: boolean);
    procedure SetAutoHeight(Value: boolean);
    procedure SetAutoHide(Value: boolean);
    procedure SetRealTime(Value: boolean);
    procedure SetSpellCheck(Value: boolean);
    procedure SetVerticalSplit(Value: boolean);
    procedure SetAutoCopy(Value: boolean);
    procedure SetProxy(Value: TProxy);
    procedure SetTranslateTarget(Value: TWinControl);
    procedure SetBuiltInDetect(Value: boolean);

    procedure ChangeSourceLang(NewLang: string; AddRecentPairs: boolean = True);
    procedure ChangeTargetLang(NewLang: string; AddRecentPairs: boolean = True);
    function SwapLanguages(ASwapTranslate: boolean = False; AddRecentPairs: boolean = True): boolean;
    procedure AddLangPair(const Pair: string; ToEnd: boolean = True);
    procedure SelectPair(const Pair: string; RunTranslate: boolean = True);
    procedure SelectPairConfig(const LangPairIndex: integer; RunTranslate: boolean = True);
    procedure UpdateTranslateButtonState(ForceTranslateButton: boolean = False);
    procedure UpdatePopupState(SetWindowParam: boolean = True);
    procedure UpdateMemoState(AMemo: TRichMemo);
    procedure MoveButtonTo(AFromIndex, AToIndex: integer);

    function GetConfigIndex: integer;
    function GetIconIndex: integer;
    function GetLangCode(ComboValue: string; Target: boolean = False): string;

    // Tray Icon
    function CreateTrayIconLang(const ALang1: string; const ALang2: string = string.Empty): Graphics.TBitmap;
    function CreateTrayIconProgress(AAngle: integer; ABackgroundColor: TColor = clNone; APenColor: TColor = clWhite): Graphics.TBitmap;

    procedure GlobalCopy(MouseMode: boolean = False);
    procedure GlobalPaste;
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
    FVerticalSplit: boolean;
    FAutoCopy: boolean;
    FAutoHeight: boolean;
    FAutoHidePopup: boolean;
    FSpellCheck: boolean;
    FSpellCheckEmptySuggestions: boolean;

    {$IFDEF WINDOWS}
    procedure OnAppInstanceMessage(Sender: TObject; const AMessage: string);
    procedure DestroyWnd; override;
    // MouseHook Events
    procedure OnKeyboardEvent(Sender: TObject; var Info: TKeyboardEventInfo);
    procedure OnHookLeftDown(Sender: TObject; const Info: TMouseEventInfo);
    procedure OnHookLeftUp(Sender: TObject; const Info: TMouseEventInfo);
    procedure OnTranslateMouseMode(Data: PtrInt);
    procedure OnTranslateMouseModeTimer;
    // HotKeys Events
    procedure RegisterHotKeys;
    procedure UnregisterHotKeys;
    procedure ReleaseHotKeyModifiers(const AHotKey: THotKeyData);
    {$ENDIF}

    // Methods
    procedure LoadConfig(ASetDefault: boolean = True; AUpdateComboState: boolean = True);
    procedure LoadTranslate;
    procedure LoadLanguages;
    procedure RestrictTranslate;
    procedure LoadLangDetect;
    procedure UpdateProxyState;
    procedure UpdateComboState(ASetDefault: boolean = True);
    procedure SetDefaultSettings;
    procedure SetDefaultHotKeys;
    procedure BuildConfigMenu;
    procedure RebuildLangPairsPanel(Data: PtrInt);
    procedure SetTrayIcon;
    procedure SetHints;
    procedure SetAnimate(Angle: integer);
    procedure DoRealign(Data: PtrInt);
    procedure DoRealignSplit(Data: PtrInt);
    procedure UpdateAutoDetect(Old, New: string);
    procedure UpdateCheckConfigMenu;
    procedure UpdateCheckMenuPair;
    function UpdateSourceLanguage(const Lang: string): string;
    function UpdateTargetLanguage(const Lang: string): string;
    function UpdatePairLanguage(const Pair: string): string;
    procedure UpdateInputState(AEnabled: boolean; ReenableHotKeys: boolean = True);
    procedure UpdateSpellCheck;
    procedure DoSpellCheck;
    procedure ApplySpellCheck;
    procedure SpellCheckNeeded(Sender: TObject);
    procedure DoCheckUpdates(Data: PtrInt);
    procedure ShowCustomHint(const AText: string; X: integer = 0; Y: integer = 0; Duration: integer = 3000);
    function GetParameterValue(AName: string; out ResultOk: boolean): string;
    procedure AdjustPopupHeight(AText: string; Force: boolean = False);
    procedure ShowPopup(const SourceText: string; X: integer = 0; Y: integer = 0);
    procedure ClosePopupAsync(Data: PtrInt);
    procedure ShowButton(const SourceText: string; X: integer = 0; Y: integer = 0);
    procedure SetVerticalMode;

    // Translate Methods
    function TranslateThread(ATrans: TTranslate; AText: string; AMemo: TRichMemo = nil): string;
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
    procedure TranslateFromControlPopup(Data: PtrInt);
    procedure TranslateMouseMode(ACursorPos: TPoint);

    // Action Languages
    procedure SetLanguage(ALangCode: string = string.Empty);

    // Base properties
    property Trans: TTranslate read FTrans write FTrans;
    property TransDetect: TTranslate read FTransDetect write FTransDetect;
    property TopMost: boolean read FTopMost write FTopMost;
    property IndexConfig: integer read GetConfigIndex;
    property IndexIcon: integer read GetIconIndex;

    // Settings properties
    property ConfigFile: string read FConfigFile write FConfigFile;
    property ConfigFiles: TStringList read FConfigFiles write FConfigFiles;
    property ConfigTitles: TStringList read FConfigTitles write FConfigTitles;
    property ConfigColors: TStringList read FConfigColors write FConfigColors;
    property ConfigImages: TStringList read FConfigImages write FConfigImages;
    property ConfigLangDetect: string read FConfigLangDetect write FConfigLangDetect;
    property Proxy: TProxy read FProxy write SetProxy;
    property ProxiedConfigs: TStringList read FProxiedConfigs write FProxiedConfigs;
    property Timeout: TTimeout read FTimeout write FTimeout;
    property AutoStart: boolean read FAutoStart write SetAutoStart;
    property IconBackgroundColor: TColor read FIconBackgroundColor write FIconBackgroundColor;
    property IconMouseModeFrameColor: TColor read FIconMouseModeFrameColor write FIconMouseModeFrameColor;
    property IconFontColor: TColor read FIconFontColor write FIconFontColor;
    property IconFontName: string read FIconFontName write FIconFontName;
    property IconTwoLang: boolean read FIconTwoLang write FIconTwoLang;
    property IconCircular: boolean read FIconCircular write FIconCircular;
    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property LangPairs: TStringList read FLangPairs write FLangPairs;
    property LangPairsHint: TStringList read FLangPairsHint write FLangPairsHint;
    property EnabledLanguages: TStringList read FEnabledLanguages write FEnabledLanguages;
    property UserParameters: TStringList read FUserParameters write FUserParameters;
    property MaxLangPairs: integer read FMaxLangPairs write FMaxLangPairs;
    property AutoAddLangPairs: boolean read FAutoAddLangPairs write SetAutoAddLangPairs;
    property AllowHotKeys: boolean read FAllowHotKeys write SetAllowHotKeys;
    property RealTime: boolean read FRealTime write SetRealTime;
    property RealTimeDelay: integer read FRealTimeDelay write FRealTimeDelay;
    property AutoSwap: boolean read FAutoSwap write SetAutoSwap;
    property BuiltInDetect: boolean read FBuiltInDetect write SetBuiltInDetect;
    property SmartSwap: boolean read FSmartSwap write FSmartSwap;
    property SmartHard: boolean read FSmartHard write FSmartHard;
    property PrimaryLang: string read FPrimaryLang write FPrimaryLang;
    property SecondaryLang: string read FSecondaryLang write FSecondaryLang;
    property EnableMouseMode: boolean read FEnableMouseMode write SetEnableMouseMode;
    property MouseModeCtrl: boolean read FMouseModeCtrl write SetMouseModeCtrl;
    property InsertKey: boolean read FInsertKey write FInsertKey;
    property MouseMode: TMouseMode read FMouseMode write FMouseMode;
    property SpellCheck: boolean read FSpellCheck write SetSpellCheck;
    property SpellCheckEmptySuggestions: boolean read FSpellCheckEmptySuggestions write FSpellCheckEmptySuggestions;
    property VerticalSplit: boolean read FVerticalSplit write SetVerticalSplit;
    property AutoCopy: boolean read FAutoCopy write SetAutoCopy;
    property StayOnTop: boolean read FStayOnTop write FStayOnTop;
    property FontPopup: TFont read FFontPopup write FFontPopup;
    property HideControls: boolean read FHideControls write FHideControls;
    property AutoHidePopup: boolean read FAutoHidePopup write SetAutoHide;
    property AutoHeight: boolean read FAutoHeight write SetAutoHeight;
    property MaxHeight: integer read FMaxHeight write FMaxHeight;
    property OpacityHover: integer read FOpacityHover write FOpacityHover;
    property OpacityIdle: integer read FOpacityIdle write FOpacityIdle;
    property AutoCheckUpdates: boolean read FAutoCheckUpdates write FAutoCheckUpdates;
    property SplitRatio: double read FSplitRatio write FSplitRatio;
    property FormConfigLeft: integer read FFormConfigLeft write FFormConfigLeft;
    property FormConfigTop: integer read FFormConfigTop write FFormConfigTop;
    property FormConfigWidth: integer read FFormConfigWidth write FFormConfigWidth;
    property FormConfigHeight: integer read FFormConfigHeight write FFormConfigHeight;
    property FormConfigSep1: integer read FFormConfigSep1 write FFormConfigSep1;
    property FormConfigSep2: integer read FFormConfigSep2 write FFormConfigSep2;
    property FormPopupLeft: integer read FFormPopupLeft write FFormPopupLeft;
    property FormPopupTop: integer read FFormPopupTop write FFormPopupTop;
    property FormPopupWidth: integer read FFormPopupWidth write FFormPopupWidth;
    property FormPopupHeight: integer read FFormPopupHeight write FFormPopupHeight;
    property FormPopupZoomFactor: double read FFormPopupZoomFactor write FFormPopupZoomFactor;
    property FormPopupBidiMode: TBiDiMode read FFormPopupBidiMode write FFormPopupBidiMode;
    property FormSettingsLeft: integer read FFormSettingsLeft write FFormSettingsLeft;
    property FormSettingsTop: integer read FFormSettingsTop write FFormSettingsTop;
    property FormSettingsWidth: integer read FFormSettingsWidth write FFormSettingsWidth;
    property FormSettingsHeight: integer read FFormSettingsHeight write FFormSettingsHeight;
    property FormSettingsSplit: integer read FFormSettingsSplit write FFormSettingsSplit;
    property FormAboutWidth: integer read FFormAboutWidth write FFormAboutWidth;
    property FormAboutHeight: integer read FFormAboutHeight write FFormAboutHeight;
    property LastDarkMode: boolean read FLastDarkMode write FLastDarkMode;
    property CustomPoFile: string read FCustomPoFile write FCustomPoFile;
    property RawTranslate: string read FRawTranslate write FRawTranslate;
    property TranslateTarget: TWinControl read FTranslateTarget write SetTranslateTarget;
    property MouseHook: TGlobalMouseHook read FMouseHook write FMouseHook;
    property KeyHook: TGlobalKeyboardHook read FKeyHook write FKeyHook;
    // HotKeys Common
    property HotKeyApp: THotKeyData read FHotKeyApp write FHotKeyApp;
    property HotKeyTransSwap: THotKeyData read FHotKeyTransSwap write FHotKeyTransSwap;
    property HotKeyTransFromClipboard: THotKeyData read FHotKeyTransFromClipboard write FHotKeyTransFromClipboard;
    property HotKeyTransClipboard: THotKeyData read FHotKeyTransClipboard write FHotKeyTransClipboard;
    property HotKeyTransClipboardPopup: THotKeyData read FHotKeyTransClipboardPopup write FHotKeyTransClipboardPopup;
    property HotKeyTransFromControl: THotKeyData read FHotKeyTransFromControl write FHotKeyTransFromControl;
    property HotKeyTransControl: THotKeyData read FHotKeyTransControl write FHotKeyTransControl;
    property HotKeyTransControlPopup: THotKeyData read FHotKeyTransControlPopup write FHotKeyTransControlPopup;
    // HotKeys Fast Settings
    property HotKeyFastAllowHotKeys: THotKeyData read FHotKeyFastAllowHotKeys write FHotKeyFastAllowHotKeys;
    property HotKeyFastEnableMouseMode: THotKeyData read FHotKeyFastEnableMouseMode write FHotKeyFastEnableMouseMode;
    property HotKeyFastMouseModeCtrl: THotKeyData read FHotKeyFastMouseModeCtrl write FHotKeyFastMouseModeCtrl;
    property HotKeyFastAutoSwap: THotKeyData read FHotKeyFastAutoSwap write FHotKeyFastAutoSwap;
    property HotKeyFastAutoAddLangPairs: THotKeyData read FHotKeyFastAutoAddLangPairs write FHotKeyFastAutoAddLangPairs;
    property HotKeyFastRealTime: THotKeyData read FHotKeyFastRealTime write FHotKeyFastRealTime;
    property HotKeyFastAutoCopy: THotKeyData read FHotKeyFastAutoCopy write FHotKeyFastAutoCopy;
    property HotKeyFastVerticalSplit: THotKeyData read FHotKeyFastVerticalSplit write FHotKeyFastVerticalSplit;
    property HotKeyFastAutoHeight: THotKeyData read FHotKeyFastAutoHeight write FHotKeyFastAutoHeight;
    property HotKeyFastAutoHidePopup: THotKeyData read FHotKeyFastAutoHide write FHotKeyFastAutoHide;
    property HotKeyFastSpellCheck: THotKeyData read FHotKeyFastSpellCheck write FHotKeyFastSpellCheck;
    // Hotkeys Recent Pairs
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

implementation

uses formdonate, formabout, formsettings, formconfig, formpopup, formbutton, settings, languages, langdetect,
  checkupdates, base64utils, localize, colorhelper, controlshelper, darkutils, pascalutils, flatbutton,
  RichMemoHelper, OneShotThread;

  {$R *.lfm}

  { TformTrayslate }

  {%Region -fold Form Events}

procedure TformTrayslate.FormCreate(Sender: TObject);
begin
  // Check if the application is portable
  FPortable := TOS.IsPortable;

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
  FFormConfigSep1 := 0;
  FFormConfigSep2 := 0;
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
  FEnterCount := 0;
  FLastHotkeyTime := 0;
  FTranslateThread := nil;
  FCustomPoFile := string.Empty;
  FSplitRatio := 0.5;
  FCancelled := False;
  FPopupOpen := False;
  FUnapplyCtrl := False;
  FUnapplyShift := False;
  FUnapplyInsert := False;
  FUnapplyC := False;
  FUnapplyV := False;
  FLastKeyTime := 0;
  FLastCtrlTime := 0;
  FLastXTime := 0;
  FLastCTime := 0;
  FLastVTime := 0;
  FillChar(FPrevMouseDown, SizeOf(FPrevMouseDown), 0);
  FClickCount := 0;
  FSettingsPage := 0;
  FActiveThreads := TList.Create;
  FDragBtnIndex := -1;
  FDragMoved := False;
  FSettingTrayIcon := False;
  FBlockTrayUpdate := False;
  FProcessingPairClick := False;
  FNeedRebuildPairs := False;
  FFormSmallIcon := TIcon.Create;
  FSpellChecker := TRichSpellChecker.Create(MemoSource);
  FSpellChecker.OnSpellCheckNeeded := @SpellCheckNeeded;
  FUpdatingSpellCheck := False;
  FIgnoreKeyUpCode := 0;

  // Components config
  Left := Screen.WorkAreaRect.Right - Width - 30;
  Top := Screen.WorkAreaRect.Bottom - Height - 50;

  aNewTranslate.ImageIndex := TDarkUtils.ThemeValue(8, 9);
  aSwap.ImageIndex := TDarkUtils.ThemeValue(0, 1);
  aTranslate.ImageIndex := TDarkUtils.ThemeValue(2, 3);
  aAddPair.ImageIndex := TDarkUtils.ThemeValue(4, 5);
  aMenu.ImageIndex := TDarkUtils.ThemeValue(6, 7);
  aCopySource.ImageIndex := TDarkUtils.ThemeValue(10, 11);
  aCopyTarget.ImageIndex := TDarkUtils.ThemeValue(10, 11);
  SbCopySource.PressedImageIndex := TDarkUtils.ThemeValue(12, 13);
  SbCopyTarget.PressedImageIndex := TDarkUtils.ThemeValue(12, 13);
  FLeftButton := True;
  //PanelLang.Color := TDarkUtils.ThemeValue(clBtnFace, clBtnHighlight);
  //PanelPairs.Color := TDarkUtils.ThemeValue(clBtnFace, clBtnHighlight);
  //Splitter.Color := TDarkUtils.ThemeValue(clBtnFace, clBtnHighlight);

  FTrans := TTranslate.Create;
  FTransDetect := TTranslate.Create;
  FLanguages := TStringList.Create;
  FLanguagesTarget := TStringList.Create;
  FLangPairs := TStringList.Create;
  FLangPairsHint := TStringList.Create;
  FUserParameters := TStringList.Create;
  FProxiedConfigs := TStringList.Create;
  FEnabledLanguages := TStringList.Create;

  // Load form settings
  FFormSettingsLoaded := LoadFormSettings(Self, FFirstRun);

  // Invert color if mode chanded
  if FLastDarkMode <> TDarkUtils.IsDarkMode then
  begin
    Font.Color := InvertColor(Font.Color);
    FontPopup.Color := InvertColor(FontPopup.Color);
  end;

  // RichMemo Setup
  UpdateMemoState(MemoSource);
  UpdateMemoState(MemoTarget);

  PanelSource.SetComposited(True);
  PanelTarget.SetComposited(True);

  MemoSource.EnableScrollbarFix(PanelSource);
  MemoTarget.EnableScrollbarFix(PanelTarget);

  // Set cursor to end of text
  if MemoSource.GetBottomSpace > 0 then
  begin
    MemoSource.SelStart := Length(MemoSource.Text);
    MemoSource.SelLength := 0;
  end;

  // Components config after load settings
  SetProxy(Proxy);
  TimerTranslate.Interval := Max(RealTimeDelay, 1);
  aAutoCheckUpdates.Checked := FAutoCheckUpdates;
  aFastAllowHotKeys.Checked := FAllowHotKeys;
  aFastEnableMouseMode.Checked := FEnableMouseMode;
  aFastMouseModeCtrl.Checked := FMouseModeCtrl;
  aFastSpellCheck.Checked := FSpellCheck;
  aFastVerticalSplit.Checked := FVerticalSplit;
  aFastAutoHidePopup.Checked := FAutoHidePopup;
  aFastAutoSwap.Checked := FAutoSwap;
  aFastAutoAddLangPairs.Checked := FAutoAddLangPairs;
  aFastRealTime.Checked := FRealTime;
  aFastAutoCopy.Checked := FAutoCopy;

  // Load config files
  FConfigFiles := TStringList.Create;
  FConfigTitles := TStringList.Create;
  FConfigColors := TStringList.Create;
  FConfigImages := TStringList.Create;
  TTranslate.GetIniFiles(FConfigFiles);
  BuildConfigMenu;
  FConfigLangDetect := TTranslate.GetConfigFullPath(FConfigLangDetect, FConfigFiles);

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
  SetTrayIcon;
  SetHints;

  // Events assign
  Screen.OnActiveFormChange := @ScreenActiveFormChanged;

  {$IFDEF WINDOWS}
  // Mouse hooks
  FMouseHook := TGlobalMouseHook.Create;
  FMouseHook.OnLeftDown := @OnHookLeftDown;
  FMouseHook.OnLeftUp := @OnHookLeftUp;
  FMouseHook.EditFieldOnly := True;

  // Keyboard hooks
  FKeyHook:=TGlobalKeyboardHook.Create;
  FKeyHook.OnKeyEvent := @OnKeyboardEvent;

  // Global hotkeys
  UpdateInputState(True);

  // Drop target
  MemoSource.DisableBuiltInDragDrop;
  MemoTarget.DisableBuiltInDragDrop;
  FDropTarget := TTextDropTarget.Create(Self);
  FDropTarget.Target := MemoSource;
  FDropTarget.InsertText := True;
  FDropTarget.OnTextDropped := @OnTextDroppedHandler;
  {$ENDIF}

  // Set language
  SetLanguage(Language);

  // Load LangDetect Profiles
  if BuiltInDetect then
    TLangDetect.LoadProfiles;

  FTopMost := False;
  FFirstRun := False;
end;

procedure TformTrayslate.FormDestroy(Sender: TObject);
var
  TotalDeadline: DWORD;
  i: integer;
  Th: TTranslateThread;
begin
  TimerAnimate.Enabled := False;
  TimerActive.Enabled := False;
  TimerTranslate.Enabled := False;
  TimerClick.Enabled := False;
  if TimerUnapply.Enabled then
    TimerUnapplyTimer(Self);
  ClearTimeout(FClickTimer);
  ClearTimeout(FSpellTimer);

  {$IFDEF WINDOWS}
  UpdateInputState(False);
  FreeAndNil(FMouseHook);
  FreeAndNil(FKeyHook);
  {$ENDIF}

  try
    // Wait for the thread
    //if Assigned(FActiveThreads) then
    //begin
    //  for i := FActiveThreads.Count - 1 downto 0 do
    //  begin
    //    Th := TTranslateThread(FActiveThreads[i]);
    //    if Assigned(Th) and not Th.Finished and not Th.IsTerminated then Th.WaitFor;
    //    FActiveThreads.Delete(i);
    //  end;
    //  FreeAndNil(FActiveThreads);
    //end;

    // Wait for all active translation threads to finish, with a single global timeout.
    if Assigned(FActiveThreads) then
    begin
      TotalDeadline := TOS.GetTickCountXp + THREADS_WAIT_TIME;
      repeat
        // Remove finished threads from the list (iterate backwards)
        for i := FActiveThreads.Count - 1 downto 0 do
        begin
          Th := TTranslateThread(FActiveThreads[i]);
          if not Assigned(Th) or Th.IsTerminated then
            FActiveThreads.Delete(i);
        end;
        // All threads have finished – exit the wait loop
        if FActiveThreads.Count = 0 then Break;
        // Total timeout expired – abandon any remaining threads
        if TOS.GetTickCountXp >= TotalDeadline then
        begin
          {$IFDEF DEBUG}
          UseHeapTrace := False;
          {$ENDIF}
          Break;
        end;
        // Keep the message loop alive so threads can post Synchronize calls
        Application.ProcessMessages;
        Sleep(1);
      until False;

      // Any threads still left are stuck; they will be reclaimed by the OS when the process exits.
      FreeAndNil(FActiveThreads);
    end;
  finally
    if FFormSettingsLoaded then
      SaveFormSettings(Self);

    ShutdownThreads;
    WaitForThreads;

    FreeAndNil(FLangPairs);
    FreeAndNil(FLangPairsHint);
    FreeAndNil(FUserParameters);
    FreeAndNil(FProxiedConfigs);
    FreeAndNil(FEnabledLanguages);
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
    FreeAndNil(FFormSmallIcon);
    FreeAndNil(FDropTarget);
    FreeAndNil(FSpellChecker);
  end;
end;

procedure TformTrayslate.FormShow(Sender: TObject);
begin
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

  // Configure state
  FDropTarget.ForceRegister;
  SetHints;
  SetVerticalMode;
  UpdatePopupState;

  // Apply comboboxes font and height
  ComboSource.Font.Assign(Font);
  ComboTarget.Font.Assign(Font);
  ComboSource.AdjustComboHeight;
  ComboTarget.AdjustComboHeight;

  // Ensure the window is within the screen
  Self.FitToScreen;
end;

procedure TformTrayslate.FormHide(Sender: TObject);
begin
  FDropTarget.Unregister;
end;

procedure TformTrayslate.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if Application.Terminated then Exit;

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
  begin
    if ComboSource.DroppedDown then
    begin
      ComboSource.DroppedDown := False;
      Key := 0;
      Exit;
    end;

    if ComboTarget.DroppedDown then
    begin
      ComboTarget.DroppedDown := False;
      Key := 0;
      Exit;
    end;

    if aTranslate.Tag = 1 then
      aTranslate.Execute
    else
      Hide;
  end;
end;

procedure TformTrayslate.FormWindowStateChange(Sender: TObject);
begin
  if WindowState = wsMinimized then
  begin
    if TopMost then Hide;
    WindowState := wsNormal;
  end;
end;

{%EndRegion}

{%Region -fold Application Events}

procedure TformTrayslate.ScreenActiveFormChanged(Sender: TObject);
begin
  if Assigned(formConfigTrayslate) and formConfigTrayslate.HandleAllocated and (Screen.ActiveForm = formConfigTrayslate) then
    formConfigTrayslate.Invalidate;
end;

procedure TformTrayslate.ApplicationPropActivate(Sender: TObject);
begin
  if Screen.ActiveForm = Self then
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
  if Assigned(FHint) then
    FHint.ReleaseHandle;
end;

procedure TformTrayslate.ApplicationPropException(Sender: TObject; E: Exception);
begin
  {$IFDEF DEBUG}
  TOS.Log(APP_NAME,
    'Unhandled exception (' + E.ClassName + '): ' + E.Message + LineEnding + TOS.GetExceptionStackTrace(E));
  {$ENDIF}
  MessageDlg(rappname, E.Message, mtWarning, [mbOK], 0);
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

procedure TformTrayslate.ApplicationPropEndSession(Sender: TObject);
begin
  if FFormSettingsLoaded then
    SaveFormSettings(Self);
end;

{%EndRegion}

{%Region -fold Windows Specific Events}
{$IFDEF WINDOWS}

{ Protected }

procedure TformTrayslate.WMActivate(var Message: TLMActivate);
begin
  inherited;
  if Message.Active <> WA_INACTIVE then
    FTopMost := True;
end;

procedure TformTrayslate.WndProc(var TheMessage: TLMessage);
var
  LangIndex: integer;
begin
  if TheMessage.msg = WM_HOTKEY then
  begin
    if TOS.GetTickCountXp - FLastHotkeyTime < HOTKEY_INTERVAL then
      exit;

    FLastHotkeyTime := TOS.GetTickCountXp;

    case TheMessage.WParam of

      // HotKeys Common
      HOTKEY_APP:
      try
        if Showing then Hide
        else
          Show;
        BringToFront;
        FTopMost := True;
      finally
        // Release modifiers used in the "App" hotkey (e.g. Ctrl+Shift+A)
        ReleaseHotKeyModifiers(FHotKeyApp);
      end;

      HOTKEY_TRANS_SWAP:
      try
        aSwap.Execute;
        ShowCustomHint(TrayIcon.Hint);
      finally
        ReleaseHotKeyModifiers(FHotKeyTransSwap);
      end;

      HOTKEY_TRANS_FROM_CLIPBOARD:
      try
        TranslateFromClipboard;
      finally
        ReleaseHotKeyModifiers(FHotKeyTransFromClipboard);
      end;

      HOTKEY_TRANS_CLIPBOARD:
      try
        TranslateClipboard;
      finally
        ReleaseHotKeyModifiers(FHotKeyTransClipboard);
      end;

      HOTKEY_TRANS_CLIPBOARD_POPUP:
      try
        TranslateClipboardPopup(True);
      finally
        ReleaseHotKeyModifiers(FHotKeyTransClipboardPopup);
      end;

      HOTKEY_TRANS_FROM_CONTROL:
      try
        Application.QueueAsyncCall(@TranslateFromControl, 0);
      finally
        ReleaseHotKeyModifiers(FHotKeyTransFromControl);
      end;

      HOTKEY_TRANS_CONTROL:
      try
        Application.QueueAsyncCall(@TranslateControl, 0);
      finally
        ReleaseHotKeyModifiers(FHotKeyTransControl);
      end;

      HOTKEY_TRANS_CONTROL_POPUP:
      try
        Application.QueueAsyncCall(@TranslateFromControlPopup, 0);
      finally
        ReleaseHotKeyModifiers(FHotKeyTransControlPopup);
      end;

      // HotKeys Fast Settings
      HOTKEY_FAST_ALLOW_HOTKEYS:
      try
        aFastAllowHotKeys.Execute;
        ShowCustomHint(rfastallowhotkeys + ' - '+ iif(aFastAllowHotKeys.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastAllowHotKeys);
      end;

      HOTKEY_FAST_ENABLE_MOUSEMODE:
      try
        aFastEnableMouseMode.Execute;
        ShowCustomHint(rfastenablemousemode + ' - '+ iif(aFastEnableMouseMode.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastEnableMouseMode);
      end;

      HOTKEY_FAST_MOUSEMODE_CTRL:
      try
        aFastMouseModeCtrl.Execute;
        ShowCustomHint(rfastmousemodectrl + ' - '+ iif(aFastMouseModeCtrl.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastMouseModeCtrl);
      end;

      HOTKEY_FAST_AUTO_SWAP:
      try
        aFastAutoSwap.Execute;
        ShowCustomHint(rfastautoswap + ' - '+ iif(aFastAutoSwap.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastAutoSwap);
      end;

      HOTKEY_FAST_AUTO_ADD_LANG_PAIRS:
      try
        aFastAutoAddLangPairs.Execute;
        ShowCustomHint(rfastautoaddlangpairs + ' - '+ iif(aFastAutoAddLangPairs.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastAutoAddLangPairs);
      end;

      HOTKEY_FAST_REAL_TIME:
      try
        aFastRealTime.Execute;
        ShowCustomHint(rfastrealtime + ' - '+ iif(aFastRealTime.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastRealTime);
      end;

      HOTKEY_FAST_AUTO_COPY:
      try
        aFastAutoCopy.Execute;
        ShowCustomHint(rfastautocopy + ' - '+ iif(aFastAutoCopy.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastAutoCopy);
      end;

      HOTKEY_FAST_VERTICAL_SPLIT:
      try
        aFastVerticalSplit.Execute;
        ShowCustomHint(rfastverticalsplit + ' - '+ iif(aFastVerticalSplit.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastVerticalSplit);
      end;

      HOTKEY_FAST_AUTO_HEIGHT:
      try
        aFastAutoHeight.Execute;
        ShowCustomHint(rfastautoheight + ' - '+ iif(aFastAutoHeight.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastAutoHeight);
      end;

      HOTKEY_FAST_HIDE_CONTROLS:
      try
        aFastAutoHidePopup.Execute;
        ShowCustomHint(rfastautohidepopup + ' - '+ iif(aFastAutoHidePopup.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastAutoHide);
      end;

      HOTKEY_FAST_SPELL_CHECK:
      try
        aFastSpellCheck.Execute;
        ShowCustomHint(rfastspellcheck + ' - '+ iif(aFastSpellCheck.Checked, ron, roff));
      finally
        ReleaseHotKeyModifiers(FHotKeyFastSpellCheck);
      end;

      else
        if (TheMessage.WParam >= HOTKEY_RECENT1) and (TheMessage.WParam <= HOTKEY_RECENT9) then
        begin
          LangIndex := TheMessage.WParam - 11;

          if (LangIndex >= 0) and (LangIndex < MenuLangPairs.Count) then
          try
            SelectPairConfig(MenuLangPairs.Items[LangIndex].Tag, Showing and TopMost);
            ShowCustomHint(TrayIcon.Hint);
          finally
            // Release modifiers for the specific recent pair hotkey that was pressed
            case TheMessage.WParam of
              HOTKEY_RECENT1: ReleaseHotKeyModifiers(FHotKeyRecent1);
              HOTKEY_RECENT2: ReleaseHotKeyModifiers(FHotKeyRecent2);
              HOTKEY_RECENT3: ReleaseHotKeyModifiers(FHotKeyRecent3);
              HOTKEY_RECENT4: ReleaseHotKeyModifiers(FHotKeyRecent4);
              HOTKEY_RECENT5: ReleaseHotKeyModifiers(FHotKeyRecent5);
              HOTKEY_RECENT6: ReleaseHotKeyModifiers(FHotKeyRecent6);
              HOTKEY_RECENT7: ReleaseHotKeyModifiers(FHotKeyRecent7);
              HOTKEY_RECENT8: ReleaseHotKeyModifiers(FHotKeyRecent8);
              HOTKEY_RECENT9: ReleaseHotKeyModifiers(FHotKeyRecent9);
            end;
          end;
        end;
    end;
  end;

  inherited WndProc(TheMessage);
end;

{ Public }

procedure TformTrayslate.OnAppInstanceMessage(Sender: TObject; const AMessage: string);
begin
  if Application.Terminated or not Self.Enabled then
  begin
     if FFormSettingsLoaded then
      SaveFormSettings(Self);
    TOS.ForceRestartApp;
    Exit;
  end;

  TopMost := False;
  Show;
end;

procedure TformTrayslate.DestroyWnd;
begin
  if Assigned(FDropTarget) then
    FDropTarget.Unregister;
  inherited DestroyWnd;
end;

{ MouseHook Events }

procedure TFormTrayslate.OnKeyboardEvent(Sender: TObject; var Info: TKeyboardEventInfo);
var
  // packedCoords: PtrInt;
  Tick: DWORD;
begin
  Tick := TOS.GetTickCountXp;

  // Turn off the mouse mode if Ctrl is not pressed and it requires Ctrl
  if MouseModeCtrl and (Info.KeyCode in [VK_CONTROL, VK_LCONTROL, VK_RCONTROL]) then
  begin
    MouseHook.Enabled := Info.IsDown;
    SetTrayIcon;
  end;

  if not Info.IsDown then Exit;
  if Info.IsInjected then Exit;

  if Assigned(formPopupTrayslate) and formPopupTrayslate.Visible and formPopupTrayslate.InWindow then
  begin
    if Info.KeyCode = VK_ESCAPE then
    begin
      Application.QueueAsyncCall(@ClosePopupAsync, 0);
      Info.Handled := True;
    end
    else
    if Info.CtrlDown and (Info.KeyCode = VK_A) then
    begin
      formPopupTrayslate.MemoTarget.SelectAll;
      Info.Handled := True;
    end
    else
    if Info.CtrlDown and (Info.KeyCode = VK_C) then
    begin
      formPopupTrayslate.MemoTarget.CopyToClipboard;
      Info.Handled := True;
    end
    else
    if Info.CtrlDown and (Info.KeyCode = VK_V) then
    begin
      formPopupTrayslate.MemoTarget.PasteFromClipboard;
      UpdateMemoState(formPopupTrayslate.MemoTarget);
      Info.Handled := True;
    end
    else
    if Info.CtrlDown and (Info.KeyCode = VK_Z) then
    begin
      formPopupTrayslate.MemoTarget.Undo;
      Info.Handled := True;
    end;
    Exit;
  end;

  // Signals about pressing physical keys
  FLastKeyTime := Tick;
  if Info.KeyCode in [VK_CONTROL, VK_LCONTROL, VK_RCONTROL] then
    FLastCtrlTime := Tick;
  if Info.KeyCode = Ord('C') then
    FLastCTime := Tick;
  if Info.KeyCode = Ord('X') then
    FLastXTime := Tick;
  if Info.KeyCode = Ord('V') then
    FLastVTime := Tick;

  // TODO Removed, may need to be create as setting
  // Detecting select all for mouse mode
  //if (Info.CtrlDown) and (Info.KeyCode = Ord('A')) and (MouseMode = mmShowTranslateButton) then
  //begin
  //  packedCoords := Mouse.CursorPos.Y shl 16 + Mouse.CursorPos.X;
  //  Application.QueueAsyncCall(@OnTranslateMouseMode, packedCoords);
  //end;
end;

procedure TFormTrayslate.OnHookLeftDown(Sender: TObject; const Info: TMouseEventInfo);
var
  TimeDiff: DWORD;
  dx, dy: integer;
  Pt: TPoint;
  DetectionRect: TRect;
begin
  // Store current down info for later use in OnHookLeftUp
  FLastMouseInfo := Info;

  // Hide popup window if user clicks outside its expanded area
  if FAutoHidePopup and Assigned(formPopupTrayslate) and formPopupTrayslate.Visible and (not formPopupTrayslate.PopupOpen) then
  begin
    Pt := formPopupTrayslate.ScreenToClient(Point(Info.X, Info.Y));
    DetectionRect := formPopupTrayslate.ClientRect;
    // Expand detection area to cover title bar and invisible borders
    DetectionRect.Left := DetectionRect.Left - 15;    // MARGIN_LEFT
    DetectionRect.Top := DetectionRect.Top - 45;      // MARGIN_TOP
    DetectionRect.Right := DetectionRect.Right + 10;  // MARGIN_RIGHT
    DetectionRect.Bottom := DetectionRect.Bottom + 15; // MARGIN_BOTTOM

    if not PtInRect(DetectionRect, Pt) then
    begin
      formPopupTrayslate.Hide;
      Exit;
    end;
  end;

  // Click sequence detection
  TimeDiff := Info.Time - FPrevMouseDown.Time;
  dx := Info.X - FPrevMouseDown.X;
  dy := Info.Y - FPrevMouseDown.Y;

  if (TimeDiff <= MOUSE_DBL_INTERVAL) and (dx * dx + dy * dy <= MOUSE_MODE_DELTA * MOUSE_MODE_DELTA) then
    Inc(FClickCount)
  else
    FClickCount := 1;

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
  dx := Info.X - FLastMouseInfo.X;
  dy := Info.Y - FLastMouseInfo.Y;
  DistanceSq := dx * dx + dy * dy;

  // Case 1: double-click or triple-click (triggers immediately on both)
  if (FClickCount >= 2) and (DistanceSq < MOUSE_MODE_DELTA * MOUSE_MODE_DELTA) then
  begin
    if (not MouseModeCtrl) or (FLastMouseInfo.CtrlDown and Info.CtrlDown) then
    begin
      packedCoords := Info.Y shl 16 + Info.X;
      Application.QueueAsyncCall(@OnTranslateMouseMode, packedCoords);
    end;
    // We don't reset FClickCount here, it resets in OnHookLeftDown by timeout
    Exit;
  end;

  // Case 2: old logic (long press with movement)
  if Info.Time >= FLastMouseInfo.Time then
    TimeDiff := Info.Time - FLastMouseInfo.Time
  else
    TimeDiff := 0;

  if (TimeDiff > MOUSE_MODE_INTERVAL) and (DistanceSq > MOUSE_MODE_DELTA * MOUSE_MODE_DELTA) then
  begin
    FClickCount := 0; // Break sequence on long press
    if (not MouseModeCtrl) or (FLastMouseInfo.CtrlDown and Info.CtrlDown) then
    begin
      packedCoords := Info.Y shl 16 + Info.X;
      Application.QueueAsyncCall(@OnTranslateMouseMode, packedCoords);
    end;
  end;
end;

procedure TFormTrayslate.OnTranslateMouseMode(Data: PtrInt);
begin
  if FClickCount > 4 then Exit;
  FClickPoint := Point(Data and $FFFF, Data shr 16);
  ClearTimeout(FClickTimer);
  if (FClickCount >= 1) and (FClickCount < 4) then
    SetTimeout(FClickTimer, 100, @OnTranslateMouseModeTimer)
  else
    OnTranslateMouseModeTimer;
end;

procedure TFormTrayslate.OnTranslateMouseModeTimer;
begin
  TranslateMouseMode(FClickPoint);
end;

{ HotKeys Events }

procedure TformTrayslate.RegisterHotKeys;
begin
  // Unregister first to avoid duplicate registration
  UnregisterHotKeys;

  if not AllowHotKeys then Exit;

  // HotKeys Common
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

  // HotKeys Fast Settings
  if FHotKeyFastAllowHotKeys.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_ALLOW_HOTKEYS, FHotKeyFastAllowHotKeys.Modifiers, FHotKeyFastAllowHotKeys.Key);

  if FHotKeyFastEnableMouseMode.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_ENABLE_MOUSEMODE, FHotKeyFastEnableMouseMode.Modifiers, FHotKeyFastEnableMouseMode.Key);

  if FHotKeyFastMouseModeCtrl.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_MOUSEMODE_CTRL, FHotKeyFastMouseModeCtrl.Modifiers, FHotKeyFastMouseModeCtrl.Key);

  if FHotKeyFastAutoSwap.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_AUTO_SWAP, FHotKeyFastAutoSwap.Modifiers, FHotKeyFastAutoSwap.Key);

  if FHotKeyFastAutoAddLangPairs.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_AUTO_ADD_LANG_PAIRS, FHotKeyFastAutoAddLangPairs.Modifiers, FHotKeyFastAutoAddLangPairs.Key);

  if FHotKeyFastRealTime.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_REAL_TIME, FHotKeyFastRealTime.Modifiers, FHotKeyFastRealTime.Key);

  if FHotKeyFastAutoCopy.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_AUTO_COPY, FHotKeyFastAutoCopy.Modifiers, FHotKeyFastAutoCopy.Key);

  if FHotKeyFastVerticalSplit.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_VERTICAL_SPLIT, FHotKeyFastVerticalSplit.Modifiers, FHotKeyFastVerticalSplit.Key);

  if FHotKeyFastAutoHeight.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_AUTO_HEIGHT, FHotKeyFastAutoHeight.Modifiers, FHotKeyFastAutoHeight.Key);

  if FHotKeyFastAutoHide.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_HIDE_CONTROLS, FHotKeyFastAutoHide.Modifiers, FHotKeyFastAutoHide.Key);

  if FHotKeyFastSpellCheck.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_FAST_SPELL_CHECK, FHotKeyFastSpellCheck.Modifiers, FHotKeyFastSpellCheck.Key);

  // HotKeys Recent Pairs
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

procedure TformTrayslate.UnregisterHotKeys;
var
  i: integer;
begin
  // HotsKeys Common
  UnregisterHotKey(Handle, HOTKEY_APP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_SWAP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_FROM_CLIPBOARD);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CLIPBOARD);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CLIPBOARD_POPUP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_FROM_CONTROL);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CONTROL);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CONTROL_POPUP);

  // HotKeys Fast Settings
  UnregisterHotKey(Handle, HOTKEY_FAST_ALLOW_HOTKEYS);
  UnregisterHotKey(Handle, HOTKEY_FAST_ENABLE_MOUSEMODE);
  UnregisterHotKey(Handle, HOTKEY_FAST_MOUSEMODE_CTRL);
  UnregisterHotKey(Handle, HOTKEY_FAST_AUTO_SWAP);
  UnregisterHotKey(Handle, HOTKEY_FAST_AUTO_ADD_LANG_PAIRS);
  UnregisterHotKey(Handle, HOTKEY_FAST_REAL_TIME);
  UnregisterHotKey(Handle, HOTKEY_FAST_AUTO_COPY);
  UnregisterHotKey(Handle, HOTKEY_FAST_VERTICAL_SPLIT);
  UnregisterHotKey(Handle, HOTKEY_FAST_AUTO_HEIGHT);
  UnregisterHotKey(Handle, HOTKEY_FAST_HIDE_CONTROLS);

  // HotKeys Recent Pairs
  for i := 0 to 8 do
    UnregisterHotKey(Handle, HOTKEY_RECENT1 + i);
end;

procedure TformTrayslate.ReleaseHotKeyModifiers(const AHotKey: THotKeyData);
begin
  if (AHotKey.Modifiers and MOD_SHIFT) <> 0 then
    if GetAsyncKeyState(VK_SHIFT) >= 0 then   // >= 0 means not physically pressed
      KeyInput.Unapply([ssShift]);

  if (AHotKey.Modifiers and MOD_CONTROL) <> 0 then
    if GetAsyncKeyState(VK_CONTROL) >= 0 then
      KeyInput.Unapply([ssCtrl]);

  if (AHotKey.Modifiers and MOD_ALT) <> 0 then
    if GetAsyncKeyState(VK_MENU) >= 0 then
      KeyInput.Unapply([ssAlt]);
end;

{$ENDIF}
{%EndRegion}

{%Region -fold Actions Events}

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

  if FormConfigSep1 > 0 then
    formConfigTrayslate.GroupBoxCustomParameters.Height := FormConfigSep1;

  if FormConfigSep2 > 0 then
    formConfigTrayslate.GroupResponse.Height := FormConfigSep2;

  formConfigTrayslate.Show;
  formConfigTrayslate.BringToFront;

  // Remove TopMost since the main form is not on the top
  if Visible then FTopMost := False;
end;

procedure TformTrayslate.aSettingsExecute(Sender: TObject);
begin
  // If the settings form is visible, just raise it up
  if Assigned(formSettingsTrayslate) and formSettingsTrayslate.Visible then
  begin
    formSettingsTrayslate.BringToFront;
    if formSettingsTrayslate.CanSetFocus then
      formSettingsTrayslate.SetFocus;
    Exit;
  end;

  formSettingsTrayslate := TformSettingsTrayslate.Create(Application);
  formSettingsTrayslate.OnClose := @SettingsFormClose;

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

  formSettingsTrayslate.PagesSettings.ActivePageIndex := FSettingsPage;
  formSettingsTrayslate.ListPages.ItemIndex := FSettingsPage;

  formSettingsTrayslate.Show;

  // Remove TopMost since the main form is not on the top
  if Visible then FTopMost := False;
end;

procedure TformTrayslate.aNewTranslateExecute(Sender: TObject);
begin
  CancelTranslate;
  MemoSource.ClearWithUndo;
  MemoTarget.ClearWithUndo;
end;

procedure TformTrayslate.aTranslateExecute(Sender: TObject);
begin
  if aTranslate.Tag = 0 then
    TranslateMemo
  else
  begin
    UpdateTranslateButtonState(True);
    CancelTranslate;
  end;
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
var
  pairKey: string;
begin
  if (FLangSource = '') or (FLangTarget = '') then
    Exit;

  // Build the exact string that AddLangPair looks for ("ConfigFile=pair")
  pairKey := FConfigFile + '=' + UpdatePairLanguage(FLangSource + ':' + FLangTarget);

  // If the pair already exists – do nothing, keep its position
  if FLangPairs.IndexOf(pairKey) >= 0 then
    Exit;

  AddLangPair(FLangSource + ':' + FLangTarget);
  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
end;

procedure TformTrayslate.aDeletePairExecute(Sender: TObject);
var
  Index: integer;
  Pair: string;
  Dlg: boolean;
begin
  if (Sender is TFlatButton) then
  begin
    Index := (Sender as TFlatButton).Tag;
    Pair := (Sender as TFlatButton).Caption;
    Dlg := False;
  end
  else
  if (FPopupRecentPair is TFlatButton) then
  begin
    Index := (FPopupRecentPair as TFlatButton).Tag;
    Pair := (FPopupRecentPair as TFlatButton).Caption;
    Dlg := True;
  end
  else
    Exit;

  if (Index < 0) or (Index >= FLangPairs.Count) then
    Exit;

  if Dlg and (MessageDlg(Format(rremovepair, [Pair]), mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
    Exit;

  FLangPairs.Delete(Index);
  FLangPairsHint.Delete(Index);

  // Rebuild panel
  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
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

  PopupTray.Alignment := TPopupAlignment.paRight;
  aShow.Visible := False;
  MenuLangPairs.Visible := False;
  SbMenu.GroupIndex := 2;
  SbMenu.Down := True;

  // Bottom-right of button in screen coords
  P := SbMenu.ClientToScreen(Classes.Point(SbMenu.Width, SbMenu.Height));

  PopupTray.PopUp(P.X, P.Y);
end;

procedure TformTrayslate.aMoveFirstExecute(Sender: TObject);
var
  Index: integer;
begin
  if not (FPopupRecentPair is TFlatButton) then
    Exit;

  Index := TFlatButton(FPopupRecentPair).Tag;

  if (Index < 0) or (Index >= FLangPairs.Count) then
    Exit;

  while Index > 0 do
  begin
    FLangPairs.Exchange(Index, Index - 1);
    FLangPairsHint.Exchange(Index, Index - 1);
    Dec(Index);
  end;

  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
end;

procedure TformTrayslate.aMoveLastExecute(Sender: TObject);
var
  Index: integer;
begin
  if not (FPopupRecentPair is TFlatButton) then
    Exit;

  Index := TFlatButton(FPopupRecentPair).Tag;

  if (Index < 0) or (Index >= FLangPairs.Count) then
    Exit;

  while Index < FLangPairs.Count - 1 do
  begin
    FLangPairs.Exchange(Index, Index + 1);
    FLangPairsHint.Exchange(Index, Index + 1);
    Inc(Index);
  end;

  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
end;

procedure TformTrayslate.aMoveLeftExecute(Sender: TObject);
var
  Index: integer;
begin
  if not (FPopupRecentPair is TFlatButton) then
    Exit;

  Index := TFlatButton(FPopupRecentPair).Tag;

  if (Index < 0) or (Index >= FLangPairs.Count) then
    Exit;

  if Index > 0 then
  begin
    FLangPairs.Exchange(Index, Index - 1);
    FLangPairsHint.Exchange(Index, Index - 1);
  end;

  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
end;

procedure TformTrayslate.aMoveRightExecute(Sender: TObject);
var
  Index: integer;
begin
  if not (FPopupRecentPair is TFlatButton) then
    Exit;

  Index := TFlatButton(FPopupRecentPair).Tag;

  if (Index < 0) or (Index >= FLangPairs.Count) then
    Exit;

  if Index < FLangPairs.Count - 1 then
  begin
    FLangPairs.Exchange(Index, Index + 1);
    FLangPairsHint.Exchange(Index, Index + 1);
  end;

  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
end;

procedure TformTrayslate.aUndoExecute(Sender: TObject);
var
  Memo: TRichMemo;
begin
  if Self.ActiveControl is TRichMemo then
  begin
    Memo := Self.ActiveControl as TRichMemo;
    Memo.Undo;
  end;
end;

procedure TformTrayslate.aCutExecute(Sender: TObject);
var
  Memo: TRichMemo;
begin
  if Self.ActiveControl is TRichMemo then
  begin
    Memo := Self.ActiveControl as TRichMemo;
    Memo.CutToClipboard;
  end;
end;

procedure TformTrayslate.aCopyExecute(Sender: TObject);
var
  Memo: TRichMemo;
begin
  if Self.ActiveControl is TRichMemo then
  begin
    Memo := Self.ActiveControl as TRichMemo;
    Memo.CopyToClipboard;
  end;
end;

procedure TformTrayslate.aPasteExecute(Sender: TObject);
var
  Memo: TRichMemo;
begin
  if Self.ActiveControl is TRichMemo then
  begin
    Memo := Self.ActiveControl as TRichMemo;
    Memo.PasteFromClipboard;
    UpdateMemoState(Memo);
  end;
end;

procedure TformTrayslate.aClearExecute(Sender: TObject);
var
  Memo: TRichMemo;
begin
  if Self.ActiveControl is TRichMemo then
  begin
    Memo := Self.ActiveControl as TRichMemo;
    Memo.ClearSelection;
  end;
end;

procedure TformTrayslate.aSelectAllExecute(Sender: TObject);
var
  Memo: TRichMemo;
begin
  if Self.ActiveControl is TRichMemo then
  begin
    Memo := Self.ActiveControl as TRichMemo;
    Memo.SelectAll;
  end;
end;

procedure TformTrayslate.aSourceBidiRightToLeftExecute(Sender: TObject);
var
  Memo: TRichMemo;
begin
  if Self.ActiveControl is TRichMemo then
  begin
    Memo := Self.ActiveControl as TRichMemo;

    if aSourceBidiRightToLeft.Checked then
      Memo.BiDiMode := bdRightToLeft
    else
      Memo.BiDiMode := bdLeftToRight;

    Memo.ApplyBidiMode;
  end;
end;

procedure TformTrayslate.aTargetBidiRightToLeftExecute(Sender: TObject);
var
  Memo: TRichMemo;
begin
  if Self.ActiveControl is TRichMemo then
  begin
    Memo := Self.ActiveControl as TRichMemo;

    if aTargetBidiRightToLeft.Checked then
      Memo.BiDiMode := bdRightToLeft
    else
      Memo.BiDiMode := bdLeftToRight;

    Memo.ApplyBidiMode;
  end;
end;

procedure TformTrayslate.aDefaultZoomExecute(Sender: TObject);
var
  Memo: TRichMemo;
begin
  if Self.ActiveControl is TRichMemo then
  begin
    Memo := Self.ActiveControl as TRichMemo;
    Memo.ZoomFactor := 1;
  end;
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
  CheckGithubLatestVersion(LatestVersion, REPO, rappname);
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
  if Application.Terminated or not Self.Enabled then Exit;

  if Assigned(formPopupTrayslate) then
    formPopupTrayslate.Close;

  if not FCancelled then
    CancelTranslate;

  Self.Enabled := False;
  Self.Visible := False;
  TrayIcon.Hide;
  Self.Cursor := crHourGlass;
  Screen.Cursor := crHourGlass;

  Application.Terminate;
end;

{%EndRegion}

{%Region -fold Actions Fast Settings}

procedure TformTrayslate.aFastAllowHotKeysExecute(Sender: TObject);
begin
  AllowHotKeys := aFastAllowHotKeys.Checked;
end;

procedure TformTrayslate.aFastEnableMouseModeExecute(Sender: TObject);
begin
  EnableMouseMode := aFastEnableMouseMode.Checked;
end;

procedure TformTrayslate.aFastMouseModeCtrlExecute(Sender: TObject);
begin
  MouseModeCtrl := aFastMouseModeCtrl.Checked;
end;

procedure TformTrayslate.aFastAutoAddLangPairsExecute(Sender: TObject);
begin
  AutoAddLangPairs := aFastAutoAddLangPairs.Checked;
end;

procedure TformTrayslate.aFastAutoSwapExecute(Sender: TObject);
begin
  AutoSwap := aFastAutoSwap.Checked;
end;

procedure TformTrayslate.aFastAutoHidePopupExecute(Sender: TObject);
begin
  AutoHidePopup := aFastAutoHidePopup.Checked;
end;

procedure TformTrayslate.aFastAutoHeightExecute(Sender: TObject);
begin
  AutoHeight := aFastAutoHeight.Checked;
end;

procedure TformTrayslate.aFastRealTimeExecute(Sender: TObject);
begin
  RealTime := aFastRealTime.Checked;
end;

procedure TformTrayslate.aFastVerticalSplitExecute(Sender: TObject);
begin
  VerticalSplit := aFastVerticalSplit.Checked;
end;

procedure TformTrayslate.aFastAutoCopyExecute(Sender: TObject);
begin
  AutoCopy := aFastAutoCopy.Checked;
end;

procedure TformTrayslate.aFastSpellCheckExecute(Sender: TObject);
begin
  SpellCheck := aFastSpellCheck.Checked;
end;

{%EndRegion}

{%Region -fold Control Events}

procedure TformTrayslate.ComboDrawItem(Control: TWinControl; Index: integer; ARect: TRect; State: TOwnerDrawState);
var
  Combo: TComboBox;
  ItemText: string;
  LangCode: string;
  Flag: TBitmap;
  TextRect: TRect;
  FlagRect: TRect;
  FlagWidth: integer;
  FlagHeight: integer;
  Spacing: integer;
  BgColor: TColor;
  TextColor: TColor;
begin
  // Get the combo box and item text
  Combo := Control as TComboBox;
  ItemText := Combo.Items[Index];

  if Trans.LangType = vtLanguage then
  begin
    // Get language code from item text
    LangCode := GetLangCode(ItemText, Combo = ComboTarget);

    // Load the flag bitmap if available
    Flag := TLanguages.GetFlag(LangCode);
  end
  else
    Flag := nil;

  // Fixed flag dimensions
  FlagWidth := 16;
  FlagHeight := 11;
  Spacing := 4;

  // Set background and text colors based on selection state
  if odSelected in State then
  begin
    BgColor := clHighlight;
    TextColor := clHighlightText;
  end
  else
  begin
    BgColor := clWindow;
    TextColor := clWindowText;
  end;

  // Draw the background of the item
  Combo.Canvas.Brush.Color := BgColor;
  Combo.Canvas.FillRect(ARect);

  if Assigned(Flag) then
  begin
    // Calculate flag drawing rectangle: 16x11 centered vertically
    FlagRect := Rect(ARect.Left + Spacing, ARect.Top + (ARect.Height - FlagHeight) div 2, ARect.Left +
      Spacing + FlagWidth, ARect.Top + (ARect.Height - FlagHeight) div 2 + FlagHeight);

    // Draw flag
    Combo.Canvas.StretchDraw(FlagRect, Flag);

    // Text rectangle starts after flag
    TextRect := Rect(FlagRect.Right + Spacing, ARect.Top, ARect.Right - Spacing, ARect.Bottom);

    // Free flag after drawing
    Flag.Free;
  end
  else
  begin
    // No flag, text uses full rect with left padding
    TextRect := Rect(ARect.Left + Spacing, ARect.Top, ARect.Right - Spacing, ARect.Bottom);
  end;

  // Draw item text with correct colors
  Combo.Canvas.Font.Assign(Combo.Font);
  Combo.Canvas.Font.Color := TextColor;
  Combo.Canvas.Brush.Style := bsClear; // Prevent text background from covering item background
  Combo.Canvas.TextRect(TextRect, TextRect.Left, TextRect.Top, ItemText);
end;

procedure TformTrayslate.ComboSourceCloseUp(Sender: TObject);
//var
//  P: TPoint;
begin
  // Clearing to prevent false clicks
  FClickCount := 0;
  FMouseHook.Resume;

  // If value not changed - do nothing
  if ComboSource.Text = FPrevSourceText then
    Exit;

  if ComboSource.Items.IndexOf(ComboSource.Text) = -1 then
  begin
    if ComboSource.Text = string.Empty then
    begin
      FLangSource := string.Empty;
      FTrans.LangSource := string.Empty;
      SetTrayIcon;
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
    //if Pos('(', ComboSource.Text) = 0 then
    //begin
    //  P := ComboSource.ClientToScreen(Point(0, -ComboSource.Height div 2));
    //  ShowCustomHint(FLangSource, Mouse.CursorPos.X, P.Y);
    //end;
    if not Trans.ServiceOnlyButton then
      TranslateMemo(False);
  end;

  UpdateSpellCheck;
end;

procedure TformTrayslate.ComboTargetCloseUp(Sender: TObject);
//var
//  P: TPoint;
begin
  // Clearing to prevent false clicks
  FClickCount := 0;
  FMouseHook.Resume;

  // If value not changed - do nothing
  if ComboTarget.Text = FPrevTargetText then
    Exit;

  if ComboTarget.Items.IndexOf(ComboTarget.Text) = -1 then
  begin
    if ComboTarget.Text = string.Empty then
    begin
      FLangTarget := string.Empty;
      FTrans.LangTarget := string.Empty;
      SetTrayIcon;
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
    //if Pos('(', ComboTarget.Text) = 0 then
    //begin
    //  P := ComboTarget.ClientToScreen(Point(0, -ComboTarget.Height div 2));
    //  ShowCustomHint(FLangTarget, Mouse.CursorPos.X, P.Y);
    //end;
    if not Trans.ServiceOnlyButton then
      TranslateMemo(False);
  end;
end;

procedure TformTrayslate.ComboSourceDropDown(Sender: TObject);
begin
  FPrevSourceText := ComboSource.Text;
  FMouseHook.Pause;
end;

procedure TformTrayslate.ComboTargetDropDown(Sender: TObject);
begin
  FPrevTargetText := ComboTarget.Text;
  FMouseHook.Pause;
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

procedure TformTrayslate.MemoSourceChange(Sender: TObject);
begin
  if FSpellCheck and not FUpdatingSpellCheck then
  begin
    ClearTimeout(FSpellTimer);
    SetTimeout(FSpellTimer, 1000, @UpdateSpellCheck);
  end;
  if MemoSource.Lines.Count = 0 then
    UpdateMemoState(MemoSource);
end;

procedure TformTrayslate.MemoSourceContextPopup(Sender: TObject; MousePos: TPoint; var Handled: boolean);
var
  P: TPoint;
begin
  P := MemoSource.ClientToScreen(MousePos);
  if not FSpellChecker.ShowContextMenu(MousePos.X, MousePos.Y) then
    PopupSource.PopUp(P.X, P.Y);
  Handled := True;
end;

procedure TformTrayslate.MemoSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  NowTime: DWORD;
begin
  // On pasting with Ctrl+V
  if (ssCtrl in Shift) and (Key = VK_V) then
  begin
    (Sender as TRichMemo).PasteFromClipboard;
    UpdateMemoState((Sender as TRichMemo));
    Key := 0;
    Exit;
  end;

  // Remember key code if this is a Ctrl combination that does not edit text
  if (ssCtrl in Shift) and not (Key in [VK_V, VK_X, VK_Z, VK_Y, VK_BACK, VK_DELETE]) then
    FIgnoreKeyUpCode := Key
  else
    FIgnoreKeyUpCode := 0;

  // Ctrl+Enter or Shift+Enter triggers immediate translation
  if ((ssCtrl in Shift) or (ssShift in Shift)) and (Key = VK_RETURN) then
  begin
    aTranslate.Execute;
    FEnterCount := 0;      // reset triple-Enter counter
    Key := 0;
    Exit;
  end;

  // Any key other than plain Enter resets the triple-Enter sequence
  if (Key <> VK_RETURN) then
    FEnterCount := 0;

  // Triple-Enter logic: three quick presses of plain Enter trigger translation
  if (Key = VK_RETURN) and not (ssCtrl in Shift) and not (ssShift in Shift) then
  begin
    NowTime := TOS.GetTickCountXp;

    case FEnterCount of
      0:
      begin
        // First plain Enter – remember the original caret position and start counting
        FMemoSourceCaretPos := MemoSource.SelStart;
        FEnterCount := 1;
        FLastEnterTime := NowTime;
      end;
      1:
      begin
        if NowTime - FLastEnterTime <= DOUBLE_ENTER_INTERVAL then
        begin
          // Second plain Enter within interval – advance to count 2 and update last time
          FEnterCount := 2;
          FLastEnterTime := NowTime;       // ← crucial: use time of this press for the next check
        end
        else
        begin
          // Interval expired – restart the count from this Enter
          FMemoSourceCaretPos := MemoSource.SelStart;
          FEnterCount := 1;
          FLastEnterTime := NowTime;
        end;
      end;
      2:
      begin
        if NowTime - FLastEnterTime <= DOUBLE_ENTER_INTERVAL then
        begin
          // Third plain Enter within interval – translate and suppress the newline
          Key := 0;

          // Remove the two line breaks inserted by the first two presses
          MemoSource.SelStart := FMemoSourceCaretPos;
          MemoSource.SelLength := 2 * Length(sLineBreak);
          MemoSource.SelText := '';

          // Restore caret to where it was before the first Enter
          MemoSource.SelStart := FMemoSourceCaretPos;
          MemoSource.SelLength := 0;

          // Trigger translation
          aTranslate.Execute;

          // Reset the sequence and disable real-time timer
          FEnterCount := 0;
          FLastEnterTime := 0;
          TimerTranslate.Enabled := False;
        end
        else
        begin
          // Interval expired – restart the count from this Enter
          FMemoSourceCaretPos := MemoSource.SelStart;
          FEnterCount := 1;
          FLastEnterTime := NowTime;
        end;
      end;
    end; // case
  end;
end;

procedure TformTrayslate.MemoSourceKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  // Check if real-time translation is enabled
  if FRealTime and Trans.ServiceRealTime then
  begin
    // Ignore KeyUp if it happened right after a global hotkey
    if TOS.GetTickCountXp - FLastHotkeyTime < HOTKEY_INTERVAL then
    begin
      TimerTranslate.Enabled := False;
      Exit;
    end;

    // If this KeyUp corresponds to a previously detected non-editing Ctrl combo, ignore it
    if (FIgnoreKeyUpCode <> 0) and (Key = FIgnoreKeyUpCode) then
    begin
      FIgnoreKeyUpCode := 0;
      TimerTranslate.Enabled := False;
      Exit;
    end;

    // Ignore key combinations with Ctrl that do not modify text, like Ctrl+C
    if (ssCtrl in Shift) and not (Key in [VK_V, VK_X, VK_Z, VK_Y, VK_BACK, VK_DELETE]) then
    begin
      TimerTranslate.Enabled := False;
      Exit;
    end;

    // List of keys that do not modify text content (Navigation, System, Modifiers)
    // We include VK_RETURN here as per your requirement to ignore it for translation triggers
    if THotKeyData.Create(Key).IsSystemKey and not (Key in [VK_RETURN, VK_DELETE, VK_BACK, VK_SHIFT, VK_LSHIFT, VK_RSHIFT]) then
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
end;

procedure TformTrayslate.MemoTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_V) then // Ctrl + V
  begin
    (Sender as TRichMemo).PasteWithLineEnding;
    Key := 0;
  end;
end;

procedure TformTrayslate.MemoTargetChange(Sender: TObject);
begin
  if MemoTarget.BiDiMode = bdRightToLeft then
    MemoTarget.ApplyBidiMode;
  if MemoTarget.Lines.Count = 0 then
    MemoTarget.SetLeftIndent;
end;

procedure TformTrayslate.SettingsFormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  try
    // Save changes immediately
    SaveFormSettings(Self);

    FSettingsPage := formSettingsTrayslate.PagesSettings.ActivePageIndex;

    UpdateInputState(True);
    SetHints;

    FTrans.Proxy := FProxy;
    FTrans.Timeout := FTimeout;
    FTransDetect.Proxy := FProxy;
    FTransDetect.Timeout := FTimeout;

    UpdatePopupState;
    UpdateSpellCheck;
  finally
    CloseAction := caFree;
    formSettingsTrayslate := nil;
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
  if FBlockTrayUpdate then
    Exit;
  SetTrayIcon;
end;

procedure TformTrayslate.TimerAnimateTimer(Sender: TObject);
begin
  TimerAnimate.Tag := TimerAnimate.Tag + 5;
  if TimerAnimate.Tag >= 360 then
    TimerAnimate.Tag := TimerAnimate.Tag - 360;

  SetAnimate(TimerAnimate.Tag);
end;

procedure TformTrayslate.TimerUnapplyTimer(Sender: TObject);
begin
  TimerUnapply.Enabled := False;

  if FUnapplyCtrl then
  begin
    KeyInput.Unapply([ssCtrl]);
    FUnapplyCtrl := False;
  end;
  if FUnapplyShift then
  begin
    KeyInput.Unapply([ssShift]);
    FUnapplyShift := False;
  end;
  if FUnapplyInsert then
  begin
    KeyInput.Up(VK_INSERT);
    FUnapplyInsert := False;
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
  if Assigned(FHint) then
    FHint.ReleaseHandle;
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

procedure TformTrayslate.FlowPairsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  panel: TFlowPanel;
  ctrl: TControl;
  targetIndex: integer;
  threshold: integer;
  allowMove: boolean;
begin
  if not (ssLeft in Shift) or (FDragBtnIndex < 0) then
    Exit;

  if not (Sender is TFlowPanel) then Exit;
  panel := TFlowPanel(Sender);

  threshold := 5; // pixels threshold to avoid jitter

  if (Screen.Cursor <> crDrag) and (Abs(X - FDragBtnStartX) >= 10) then
    Screen.Cursor := crDrag;

  // Process only when moved beyond horizontal or vertical threshold
  if (Abs(X - FDragBtnLastX) < threshold) and (Abs(Y - FDragBtnLastY) < threshold) then
    Exit;

  ctrl := panel.ControlAtPos(Point(X, Y), []);
  if (ctrl is TFlatButton) then
  begin
    targetIndex := TFlatButton(ctrl).Tag;
    if targetIndex <> FDragBtnIndex then
    begin
      allowMove := False;

      // If cursor moved significantly vertically, allow move regardless of horizontal direction
      if Abs(Y - FDragBtnLastY) > ctrl.Height div 2 then
        allowMove := True
      else
      begin
        // Otherwise apply horizontal direction check
        if X > FDragBtnLastX then
          allowMove := targetIndex > FDragBtnIndex
        else if X < FDragBtnLastX then
          allowMove := targetIndex < FDragBtnIndex;
      end;

      if allowMove then
      begin
        if targetIndex > FDragBtnIndex then
          MoveButtonTo(FDragBtnIndex, targetIndex + 1)
        else
          MoveButtonTo(FDragBtnIndex, targetIndex);
        FDragMoved := True;

        // Remember point of successful move to avoid immediate re-trigger
        FDragBtnLastX := X;
        FDragBtnLastY := Y;
      end;
    end;
  end;

  // Always update last X to track horizontal direction
  FDragBtnLastX := X;
end;

procedure TformTrayslate.FlowPairsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if Button = mbLeft then
  begin
    FDragBtnIndex := -1;
    Screen.Cursor := crDefault;
  end;
end;

procedure TformTrayslate.ButtonLangMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  CurPair: integer;
  pt: TPoint;
begin
  if not (Sender is TFlatButton) then Exit;

  // Middle button - delete pair
  if Button = mbMiddle then
  begin
    aDeletePairExecute(Sender);
    Exit;
  end;

  // Right button - select pair if not already active
  if Button = mbRight then
  begin
    CurPair := (Sender as TFlatButton).Tag;
    if (CurPair < 0) or (CurPair >= MenuLangPairs.Count) then Exit;
    if (MenuLangPairs.Items[CurPair].Checked) then
      Exit;
    SelectPairConfig(CurPair);
    Exit;
  end;

  // Left button - prepare for possible drag, do not select pair here
  if Button = mbLeft then
    with (Sender as TFlatButton) do
    begin
      pt := ClientToParent(Point(X, Y), Parent);
      FDragBtnIndex := Tag;
      FDragBtnStartX := pt.X;
      FDragBtnStartY := pt.Y;
      FDragBtnLastX := pt.X;
      FDragBtnLastY := pt.Y;
      FDragMoved := False;
    end;
end;

procedure TformTrayslate.ButtonLangMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  btn: TFlatButton;
begin
  if Button = mbLeft then
  begin
    if FProcessingPairClick then Exit; // Prevent reentry during pair processing
    FProcessingPairClick := True;
    try
      // If no drag occurred and mouse didn't move much, treat as a click
      btn := Sender as TFlatButton;
      if (FDragBtnIndex >= 0) and (not FDragMoved) and (Abs(btn.ClientToParent(Point(X, Y), btn.Parent).X - FDragBtnStartX) < 5) then
      begin
        if not MenuLangPairs.Items[FDragBtnIndex].Checked then
        begin
          // Immediately show the button as pressed
          TFlatButton(Sender).Down := True;
          TFlatButton(Sender).Parent.Repaint;

          if (FDragBtnIndex >= 0) and (FDragBtnIndex < FLangPairs.Count) then
            SelectPairConfig(FDragBtnIndex);
        end
        else
        begin
          // Click on already active button: keep it pressed, prevent unpress
          TFlatButton(Sender).Down := True;
          TFlatButton(Sender).Parent.Repaint;
        end;
      end;
      // Reset drag state
      FDragBtnIndex := -1;
      FDragMoved := False;
      Screen.Cursor := crDefault;
    finally
      FProcessingPairClick := False;
      // If a panel rebuild was requested during the operation, process it now
      if FNeedRebuildPairs then
      begin
        FNeedRebuildPairs := False;
        Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
      end;
    end;
  end;
end;

procedure TformTrayslate.ButtonLangMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  pt: TPoint;
  btn: TFlatButton;
begin
  if FDragBtnIndex < 0 then Exit;
  if Sender is TFlatButton then
  begin
    btn := TFlatButton(Sender);
    // Convert to parent panel coordinates and forward the event
    pt := btn.ClientToParent(Point(X, Y), btn.Parent);
    FlowPairsMouseMove(btn.Parent, Shift, pt.X, pt.Y);
  end;
end;

procedure TFormTrayslate.MenuConfigItemClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  if (Assigned(formConfigTrayslate)) and formConfigTrayslate.HandleAllocated and formConfigTrayslate.Showing and
    (not formConfigTrayslate.TestChanges) then
    Exit;

  Item := TMenuItem(Sender);
  if (Item.Tag < 0) or (Item.Tag >= FConfigFiles.Count) then Exit;

  // Update current config and load it
  FConfigFile := FConfigFiles[Item.Tag];
  LoadConfig;

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
  if FProcessingPairClick then Exit;
  FProcessingPairClick := True;
  try
    SelectPairConfig((Sender as TMenuItem).Tag);
  finally
    FProcessingPairClick := False;
    if FNeedRebuildPairs then
    begin
      FNeedRebuildPairs := False;
      Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
    end;
  end;
end;

procedure TformTrayslate.PopupTrayPopup(Sender: TObject);
begin
  FPopupOpen := True;
end;

procedure TformTrayslate.PopupTrayClose(Sender: TObject);
begin
  FPopupOpen := False;
  PopupTray.Alignment := TPopupAlignment.paLeft;
  aShow.Visible := True;
  MenuLangPairs.Visible := True;
  SbMenu.Down := False;
end;

procedure TformTrayslate.PopupRecentPairPopup(Sender: TObject);
begin
  FPopupRecentPair := PopupRecentPair.PopupComponent;
end;

procedure TformTrayslate.OnTextDroppedHandler(Sender: TObject; const AText: string);
begin
  BringToFront;
end;

{%EndRegion}

{%Region -fold Setters}

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

  TOS.RegAutoStart(FAutoStart, AppName, 'Trayslate');
end;

procedure TformTrayslate.SetAutoAddLangPairs(Value: boolean);
begin
  aFastAutoAddLangPairs.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckAutoAddLangPairs.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
    FAutoAddLangPairs := Value;
end;

procedure TformTrayslate.SetAutoSwap(Value: boolean);
begin
  aFastAutoSwap.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckAutoSwap.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
    FAutoSwap := Value;

  if FBuiltInDetect and FAutoSwap then
    TLangDetect.LoadProfiles
  else
    TLangDetect.UnloadProfiles;
end;

procedure TformTrayslate.SetAllowHotkeys(Value: boolean);
begin
  aFastAllowHotkeys.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckAllowHotkeys.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
  begin
    FAllowHotkeys := Value;
    RegisterHotKeys;
  end;
end;

procedure TformTrayslate.SetEnableMouseMode(Value: boolean);
var
  OldValue: boolean;
begin
  aFastEnableMouseMode.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckEnableMouseMode.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
  begin
    OldValue := FEnableMouseMode;
    FEnableMouseMode := Value;
    if OldValue <> Value then
    begin
      FMouseHook.Enabled := EnableMouseMode and not FMouseModeCtrl;
      FKeyHook.Enabled := EnableMouseMode;
      SetTrayIcon;
    end;
  end;
end;

procedure TformTrayslate.SetMouseModeCtrl(Value: boolean);
var
  OldValue: boolean;
begin
  aFastMouseModeCtrl.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckMouseModeCtrl.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
  begin
    OldValue := FMouseModeCtrl;
    FMouseModeCtrl := Value;
    if OldValue <> Value then
    begin
      FMouseHook.Enabled := EnableMouseMode and not FMouseModeCtrl;
      FKeyHook.Enabled := EnableMouseMode;
      SetTrayIcon;
    end;
  end;
end;

procedure TformTrayslate.SetAutoHeight(Value: boolean);
begin
  aFastAutoHeight.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckAutoHeight.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
    FAutoHeight := Value;
end;

procedure TformTrayslate.SetAutoHide(Value: boolean);
begin
  aFastAutoHidePopup.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckAutoHidePopup.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
    FAutoHidePopup := Value;
end;

procedure TformTrayslate.SetRealTime(Value: boolean);
begin
  aFastRealTime.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckRealTime.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
    FRealTime := Value;
end;

procedure TformTrayslate.SetSpellCheck(Value: boolean);
begin
  aFastSpellCheck.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckSpellCheck.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
  begin
    FSpellCheck := Value;
    UpdateSpellCheck;
  end;
end;

procedure TformTrayslate.SetVerticalSplit(Value: boolean);
begin
  aFastVerticalSplit.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckVerticalSplit.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
  begin
    FVerticalSplit := Value;
    formTrayslate.SetVerticalMode;
    Application.QueueAsyncCall(@DoRealignSplit, 0);
  end;
end;

procedure TformTrayslate.SetAutoCopy(Value: boolean);
begin
  aFastAutoCopy.Checked := Value;
  if Assigned(formSettingsTrayslate) and (not formSettingsTrayslate.ApplySettings) then
  begin
    formSettingsTrayslate.CheckAutoCopy.Checked := Value;
    formSettingsTrayslate.BringToFront;
  end
  else
    FAutoCopy := Value;
end;

procedure TformTrayslate.SetProxy(Value: TProxy);
begin
  FProxy := Value;
  FTrans.Proxy := FProxy;
  FTrans.Timeout := FTimeout;
  FTransDetect.Proxy := FProxy;
  FTransDetect.Timeout := FTimeout;
end;

procedure TformTrayslate.SetTranslateTarget(Value: TWinControl);
begin
  if Assigned(Value) then
  begin
    FTranslateTarget := Value;
    if FTranslateTarget is TCustomEdit then
    begin
      FTranslateTarget.Color := clBtnFace;
      (FTranslateTarget as TCustomEdit).ReadOnly := True;
    end;
  end
  else
  begin
    if FTranslateTarget is TCustomEdit then
    begin
      FTranslateTarget.Color := clWindow;
      (FTranslateTarget as TCustomEdit).ReadOnly := False;
    end;
    FTranslateTarget := nil;
  end;
end;

procedure TformTrayslate.SetBuiltInDetect(Value: boolean);
begin
  FBuiltInDetect := Value;
  if FBuiltInDetect and FAutoSwap then
    TLangDetect.LoadProfiles
  else
    TLangDetect.UnloadProfiles;
end;

{%EndRegion}

{%Region -fold Methods}

procedure TformTrayslate.LoadConfig(ASetDefault: boolean = True; AUpdateComboState: boolean = True);
begin
  UpdateCheckConfigMenu;
  LoadTranslate;
  RestrictTranslate;
  LoadLanguages;
  LoadLangDetect;
  UpdateProxyState;
  if AUpdateComboState then
    UpdateComboState(ASetDefault);
  UpdateAutoDetect(AutoDetect, rautodetect);
  UpdateCheckMenuPair;
  SetTrayIcon;
  SetHints;
end;

procedure TFormTrayslate.LoadTranslate;
begin
  // Load settings from INI
  FTrans.LoadIniSettings(FConfigFile);
end;

procedure TFormTrayslate.RestrictTranslate;
begin
  // Restrict Languages to Languages Settings
  if FTrans.LangType = vtLanguage then
  begin
    if FTrans.Languages.MaxValueLength <= MAX_LANG_LENGTH then
    begin
      FTrans.Languages.RestrictToNames(FEnabledLanguages.ToStringArray, SpecialCodes, False);
      FTrans.LanguageCodes := TLanguages.GetCodeArrayFromStringList(FTrans.Languages);
    end;
    if FTrans.LanguagesTarget.MaxValueLength <= MAX_LANG_LENGTH then
      FTrans.LanguagesTarget.RestrictToNames(FEnabledLanguages.ToStringArray, SpecialCodes, False);
  end;
end;

procedure TFormTrayslate.LoadLanguages;
var
  List: TStringList;
begin
  // Loading source languages from the config
  FLanguages.Clear;
  List := TLanguages.GetDisplayNamesFromCodeMap(Trans.Languages, Trans.LangType);
  try
    FLanguages.Assign(List); // Assign available source languages
  finally
    List.Free;
  end;

  // Loading target languages from the config
  FLanguagesTarget.Clear;
  if (Assigned(Trans.LanguagesTarget)) and (Trans.LanguagesTarget.Count > 0) then
  begin
    List := TLanguages.GetDisplayNamesFromCodeMap(Trans.LanguagesTarget, Trans.LangType);
    try
      FLanguagesTarget.Assign(List); // Assign available target languages
    finally
      List.Free;
    end;
  end;
end;

procedure TFormTrayslate.LoadLangDetect;
begin
  // Load language detection config settings
  if (not FBuiltInDetect) and (FConfigLangDetect <> string.Empty) then
    FTransDetect.LoadIniSettings(FConfigLangDetect)
  else
  begin
    FreeAndNil(FTransDetect);
    FTransDetect := TTranslate.Create;
  end;
end;

procedure TFormTrayslate.UpdateProxyState;
begin
  // Disable proxy if not in the proxied list
  if ProxiedConfigs.Count > 0 then
  begin
    if not ProxiedConfigs.Contains(FConfigFile) then
      FTrans.AllowProxy := False
    else
      FTrans.AllowProxy := FTrans.ServiceProxy;

    // LangDetect Proxy
    if not ProxiedConfigs.Contains(FConfigLangDetect) then
      FTransDetect.AllowProxy := False
    else
      FTransDetect.AllowProxy := FTransDetect.ServiceProxy;
  end
  else
  begin
    FTrans.AllowProxy := FTrans.ServiceProxy;
    FTransDetect.AllowProxy := FTransDetect.ServiceProxy;
  end;
end;

procedure TFormTrayslate.UpdateComboState(ASetDefault: boolean = True);
var
  List: TStringList;
  Id: integer;
begin
  UpdateInputState(False, False);
  try
    // Fill ComboSource with display names
    List := TLanguages.GetDisplayNamesFromCodeMap(Trans.Languages, Trans.LangType, True);
    try
      ComboSource.Items.Assign(List); // Text with large letter
    finally
      List.Free;
    end;

    // Check if current ComboSource text is still valid
    if ComboSource.Items.IndexOf(ComboSource.Text) < 0 then
    begin
      if Trans.Languages.MaxValueLength > MAX_LANG_LENGTH then
        Id := Trans.Languages.FindSubstringIndex(LangSource)
      else
        Id := Trans.Languages.FindSubstringIndex(LangSource, []);
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
      id := Trans.Languages.FindEqualIndex(FLangSource);
      if Id < 0 then
        Trans.LangSource := Trans.Languages.Values[FLangSource]
      else
        Trans.LangSource := Trans.Languages.ValueFromIndex[Id];
      FLangSource := Trans.LangSource;
    end;

    // Fill ComboTarget with display names
    if (Assigned(Trans.LanguagesTarget)) and (Trans.LanguagesTarget.Count > 0) then
    begin
      List := TLanguages.GetDisplayNamesFromCodeMap(Trans.LanguagesTarget, Trans.LangType, True);
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
        if Trans.LanguagesTarget.MaxValueLength > MAX_LANG_LENGTH then
          Id := Trans.LanguagesTarget.FindSubstringIndex(LangTarget)
        else
          Id := Trans.LanguagesTarget.FindSubstringIndex(LangTarget, []);
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
        if Trans.Languages.MaxValueLength > MAX_LANG_LENGTH then
          Id := Trans.Languages.FindSubstringIndex(LangTarget)
        else
          Id := Trans.Languages.FindSubstringIndex(LangTarget, []);
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
        id := Trans.LanguagesTarget.FindEqualIndex(FLangTarget);
        if Id < 0 then
          Trans.LangTarget := Trans.LanguagesTarget.Values[FLangTarget]
        else
          Trans.LangTarget := Trans.LanguagesTarget.ValueFromIndex[Id];
      end
      else
      begin
        id := Trans.Languages.FindEqualIndex(FLangTarget);
        if Id < 0 then
          Trans.LangTarget := Trans.Languages.Values[FLangTarget]
        else
          Trans.LangTarget := Trans.Languages.ValueFromIndex[Id];
      end;
      FLangTarget := Trans.LangTarget;
    end;

    if ASetDefault then
    begin
      // Set default or saved languages
      if LangSource <> string.Empty then
        Trans.LangSource := LangSource
      else
      begin
        // Secondary language
        if (not FFirstRun) and (FLanguages.FindIndex('(' + SecondaryLang + ')', False) >= 0) then
        begin
          FTrans.LangSource := SecondaryLang;
          FLangSource := SecondaryLang;
        end
        else
        // Primary language
        if (not FFirstRun) and (FLanguages.FindIndex('(' + PrimaryLang + ')', False) >= 0) then
        begin
          FTrans.LangSource := PrimaryLang;
          FLangSource := PrimaryLang;
        end
        else
          // First item as default
        begin
          ComboSource.ItemIndex := 0;
          ChangeSourceLang(ComboSource.Text);
        end;
      end;

      if LangTarget <> string.Empty then
        Trans.LangTarget := LangTarget
      else
      begin
        // Primary language
        if (((FLanguagesTarget.Count > 0) and (FLanguagesTarget.FindIndex('(' + PrimaryLang + ')', False) >= 0)) or
          ((FLanguagesTarget.Count = 0) and (FLanguages.FindIndex('(' + PrimaryLang + ')', False) >= 0))) then
        begin
          FTrans.LangTarget := PrimaryLang;
          FLangTarget := PrimaryLang;
        end
        else
        // Secondary language
        if (((FLanguagesTarget.Count > 0) and (FLanguagesTarget.FindIndex('(' + SecondaryLang + ')', False) >= 0)) or
          ((FLanguagesTarget.Count = 0) and (FLanguages.FindIndex('(' + SecondaryLang + ')', False) >= 0))) then
        begin
          FTrans.LangTarget := SecondaryLang;
          FLangTarget := SecondaryLang;
        end
        else
        // if system language in lists
        if (((FLanguagesTarget.Count > 0) and (FLanguagesTarget.FindIndex('(' + Language + ')', False) >= 0)) or
          ((FLanguagesTarget.Count = 0) and (FLanguages.FindIndex('(' + Language + ')', False) >= 0))) then
        begin
          FTrans.LangTarget := Language; // Default system language
          FLangTarget := Language;
        end
        else
        begin
          ComboTarget.ItemIndex := 0; // Single item as default
          ChangeTargetLang(ComboTarget.Text);
        end;
      end;
    end;

    // Set combobox selection by language code
    TLanguages.SetComboBoxByCode(ComboSource, Trans.LangSource);
    TLanguages.SetComboBoxByCode(ComboTarget, Trans.LangTarget);

    if ComboTarget.ItemIndex = -1 then
      ComboTarget.Text := string.Empty;

    if Visible and Focused and Active and MemoSource.Visible and MemoSource.CanFocus and MemoSource.CanSetFocus then
      MemoSource.SetFocus;
  finally
    UpdateInputState(True, False);
  end;
end;

procedure TFormTrayslate.SetDefaultSettings;
begin
  AutoStart := not FPortable;
  FConfigLangDetect := DEF_LANGDETECT;
  if TOS.IsWindows7 then
    FIconBackgroundColor := $00905000
  else
    FIconBackgroundColor := clNone;
  {$IFDEF WINDOWS}
  if TDarkUtils.IsTaskbarDark then
    FIconFontColor := clWhite
  else
    FIconFontColor := clBlack;
  {$ELSE}
  FIconFontColor := clWhite;
  {$ENDIF}
  FIconMouseModeFrameColor := clNone;
  FIconFontName := DEF_FONT;
  if Assigned(FFontPopup) then
    FreeAndNil(FFontPopup);
  FFontPopup := TFont.Create;
  FIconTwoLang := True;
  FIconCircular := False;
  FMaxLangPairs := 10;
  FAutoAddLangPairs := True;
  FAllowHotKeys := True;
  FRealTime := False;
  FRealTimeDelay := 1000;
  FAutoSwap := False;
  FBuiltInDetect := True;
  FSmartSwap := False;
  FSmartHard := False;
  FPrimaryLang := TLocalize.GetOSLanguage;
  FSecondaryLang := DEFAULT_LANG;
  FEnableMouseMode := False;
  FMouseModeCtrl := False;
  FMouseMode := mmShowTranslateButton;
  FInsertKey := True;
  FVerticalSplit := False;
  FSpellCheck := True;
  FSpellCheckEmptySuggestions := True;
  FStayOnTop := True;
  FHideControls := True;
  FAutoHidePopup := False;
  FAutoHeight := True;
  FMaxHeight := 0;
  FOpacityHover := 70;
  FOpacityIdle := 40;
  if Assigned(FEnabledLanguages) then
    FEnabledLanguages.Clear;
  if Assigned(FProxiedConfigs) then
    FProxiedConfigs.Clear;

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
    FConfigLangDetect := TTranslate.GetConfigFullPath(FConfigLangDetect, FConfigFiles);
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

  // Alt+F1
  FHotKeyFastAllowHotKeys.Modifiers := MOD_SHIFT;
  FHotKeyFastAllowHotKeys.Key := VK_F1;

  // Alt+F2
  FHotKeyFastEnableMouseMode.Modifiers := MOD_SHIFT;
  FHotKeyFastEnableMouseMode.Key := VK_F2;

  // Alt+F3
  FHotKeyFastMouseModeCtrl.Modifiers := MOD_SHIFT;
  FHotKeyFastMouseModeCtrl.Key := VK_F3;

  // Alt+F4
  FHotKeyFastAutoSwap.Modifiers := MOD_SHIFT;
  FHotKeyFastAutoSwap.Key := VK_F4;

  // Alt+F5
  FHotKeyFastAutoAddLangPairs.Modifiers := MOD_SHIFT;
  FHotKeyFastAutoAddLangPairs.Key := VK_F5;

  // Alt+F6
  FHotKeyFastRealTime.Modifiers := MOD_SHIFT;
  FHotKeyFastRealTime.Key := VK_F6;

  // Alt+F7
  FHotKeyFastAutoCopy.Modifiers := MOD_SHIFT;
  FHotKeyFastAutoCopy.Key := VK_F7;

  // Alt+F8
  FHotKeyFastVerticalSplit.Modifiers := MOD_SHIFT;
  FHotKeyFastVerticalSplit.Key := VK_F8;

  // Alt+F9
  FHotKeyFastAutoHide.Modifiers := MOD_SHIFT;
  FHotKeyFastAutoHide.Key := VK_F9;

  // Alt+F10
  FHotKeyFastAutoHeight.Modifiers := MOD_SHIFT;
  FHotKeyFastAutoHeight.Key := VK_F10;

  // Alt+F11
  FHotKeyFastSpellCheck.Modifiers := MOD_SHIFT;
  FHotKeyFastSpellCheck.Key := VK_F11;

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
          Data^.ImageIndex := TBase64.AddBase64ToImageList(Ini.ReadString('Service', 'Icon', string.Empty), ImageConfig);
        finally
          Ini.Free;
        end;
      end;

      SL.AddObject(FilePath, TObject(Data));
    end;

    SL.CustomSort(@TTranslate.ConfigSortByOrderPathName);

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
    btn: TFlatButton;
    mi: TMenuItem;
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

      // Create SpeedButtons (flat, group, allow all up) with icons from ImageList
      for i := 0 to FLangPairs.Count - 1 do
      begin
        btn := TFlatButton.Create(Target);
        btn.Tag := i;
        btn.Parent := Target;
        btn.Flat := True;
        btn.GroupIndex := 1;
        btn.AllowAllUp := True;
        btn.AutoSize := True;
        btn.Alignment := taCenter;
        btn.Transparent := False;
        btn.Caption := FLangPairs.ValueFromIndex[i];
        btn.Hint := FConfigTitles.Values[FLangPairs.Names[i]] + iif(FLangPairsHint[i] = string.Empty, '', ' - ' + FLangPairsHint[i]);
        btn.ShowHint := True;
        btn.PopupMenu := PopupRecentPair;

        if not TryStrToInt(FConfigImages.Values[FLangPairs.Names[i]], ServiceIcon) then
          ServiceIcon := -1;

        // Use shared ImageList (must exist in the form, e.g. ImageList1) – no memory leak
        if ServiceIcon >= 0 then
        begin
          btn.Images := ImageConfig;
          btn.ImageIndex := ServiceIcon;
          btn.Layout := blGlyphLeft;
          btn.Margin := -1;
          btn.OffsetY := -1;
        end;

        if not TryStrToInt(FConfigColors.Values[FLangPairs.Names[i]], ColorRecent) then
          ColorRecent := clBlue;
        btn.Font.Color := TDarkUtils.ThemeColor(ColorRecent, ColorRecent.ToDarkTheme);

        // Set Down state for the currently active pair
        if SameText(FLangPairs[i], LangSource + ':' + LangTarget) then
          btn.Down := True;

        // Mouse handler adapted for TFlatButton
        btn.OnMouseDown := @ButtonLangMouseDown;
        btn.OnMouseUp := @ButtonLangMouseUp;
        btn.OnMouseMove := @ButtonLangMouseMove;

        // MenuLangPairs Item
        if FillMenu then
        begin
          mi := TMenuItem.Create(MenuLangPairs);
          mi.Caption := btn.Caption + ' - ' + btn.Hint;
          mi.Hint := FLangPairs[i];
          if AllowHotKeys and (i < 9) then
          begin
            case i of
              0: mi.ShortCut := HotKeyRecent1.ToShortCut;
              1: mi.ShortCut := HotKeyRecent2.ToShortCut;
              2: mi.ShortCut := HotKeyRecent3.ToShortCut;
              3: mi.ShortCut := HotKeyRecent4.ToShortCut;
              4: mi.ShortCut := HotKeyRecent5.ToShortCut;
              5: mi.ShortCut := HotKeyRecent6.ToShortCut;
              6: mi.ShortCut := HotKeyRecent7.ToShortCut;
              7: mi.ShortCut := HotKeyRecent8.ToShortCut;
              8: mi.ShortCut := HotKeyRecent9.ToShortCut;
              else;
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
  if FProcessingPairClick then
  begin
    FNeedRebuildPairs := True;
    Exit;
  end;

  try
    Build(FlowPairs, Font);
    if Assigned(formPopupTrayslate) then
      Build(formPopupTrayslate.FlowPairs, FontPopup, False);
  finally
    UpdateCheckMenuPair;
    Repaint;
  end;
end;

procedure TformTrayslate.SetTrayIcon;
var
  Bitmap: TBitmap;
  hintText: string;
begin
  if (csDestroying in ComponentState) or not Assigned(FTrans) or not Assigned(TrayIcon) then Exit;
  if FSettingTrayIcon then Exit;
  FSettingTrayIcon := True;
  try
    Bitmap := CreateTrayIconLang(ifthen(FIconTwoLang, UpperCase(UpdateSourceLanguage(Trans.LangSource)),
      UpperCase(UpdateTargetLanguage(Trans.LangTarget))), ifthen(FIconTwoLang, UpperCase(Trans.LangTarget)));
    try
      TrayIcon.Icon.Assign(Bitmap);
      TrayIcon.Visible := True;
    finally
      Bitmap.Free;
    end;

    // Set tray AIcon hint
    hintText := string.Empty;
    if ComboSource.Text <> string.Empty then
      hintText += ComboSource.Text;
    if ComboTarget.Text <> string.Empty then
      hintText += ' : ' + ComboTarget.Text;
    if FConfigTitles.Values[FConfigFile] <> string.Empty then
      hintText += sLineBreak + FConfigTitles.Values[FConfigFile];
    TrayIcon.Hint := rappname + ' - ' + hintText;

    // Set popup window caption
    if (Assigned(formPopupTrayslate)) then
      formPopupTrayslate.Caption := hintText.Replace(LineEnding, ' - ');

    // Set form small icon to config icon
    if IndexIcon >= 0 then
      ImageConfig.GetIcon(IndexIcon, FFormSmallIcon)
    else
      FFormSmallIcon.Clear;
    TOS.SetFormSmallIcon(Self, FFormSmallIcon);
  finally
    FSettingTrayIcon := False;
  end;
end;

procedure TformTrayslate.SetHints;
begin
  if Assigned(Trans) then
    Caption := rappname + ifthen(Trans.ServiceName <> string.Empty, ' - ' + Trans.ServiceName,
      ifthen(FConfigFile <> string.Empty, ' - ' + ExtractFileName(FConfigFile), string.Empty))
  else
    Caption := rappname + ifthen(FConfigFile <> string.Empty, ' - ' + ExtractFileName(FConfigFile), string.Empty);

  aSwap.Hint := Format(rswap, [HotKeyTransSwap.ToText, MIDDLE_MOUSE]).Replace('() ', string.Empty);

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
      ComboValueType.ItemIndex := Ord(Trans.LangType);
      LabelSort.Left := LabelFillLanguages.BoundsRect.Right + 10;
      LabelTargetSort.Left := LabelFillTargetLanguages.BoundsRect.Right + 10;
    end;
  end;

  if Assigned(formAboutTrayslate) then
    formAboutTrayslate.MemoAbout.Text := formAboutTrayslate.LblAbout.Caption;

  if Assigned(formSettingsTrayslate) then
  begin
    formSettingsTrayslate.FillListPages;
    formSettingsTrayslate.FillMouseMode;
    formSettingsTrayslate.FillUserParameters;
    formSettingsTrayslate.FillGridHotkeys;
    formSettingsTrayslate.FillProxyMode;
    formSettingsTrayslate.SetState;
  end;

  // Assign shortcuts to Fast Settings menu items
  aFastAllowHotKeys.ShortCut := FHotKeyFastAllowHotKeys.ToShortCut;
  aFastEnableMouseMode.ShortCut := FHotKeyFastEnableMouseMode.ToShortCut;
  aFastMouseModeCtrl.ShortCut := FHotKeyFastMouseModeCtrl.ToShortCut;
  aFastAutoSwap.ShortCut := FHotKeyFastAutoSwap.ToShortCut;
  aFastAutoAddLangPairs.ShortCut := FHotKeyFastAutoAddLangPairs.ToShortCut;
  aFastRealTime.ShortCut := FHotKeyFastRealTime.ToShortCut;
  aFastAutoCopy.ShortCut := FHotKeyFastAutoCopy.ToShortCut;
  aFastVerticalSplit.ShortCut := FHotKeyFastVerticalSplit.ToShortCut;
  aFastAutoHeight.ShortCut := FHotKeyFastAutoHeight.ToShortCut;
  aFastAutoHidePopup.ShortCut := FHotKeyFastAutoHide.ToShortCut;
  aFastSpellCheck.ShortCut := FHotKeyFastSpellCheck.ToShortCut;
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

procedure TformTrayslate.UpdateAutoDetect(Old, New: string);
begin
  if (Old <> string.Empty) and (New <> string.Empty) then
  begin
    FLanguages.Replace(Old, New);
    FLanguagesTarget.Replace(Old, New);
    ComboSource.Items.Replace(Old, New);
    ComboTarget.Items.Replace(Old, New);
    ComboSource.Text := ComboSource.Text.Replace(Old, New);
    ComboTarget.Text := ComboTarget.Text.Replace(Old, New);
  end;
end;

procedure TFormTrayslate.UpdateCheckConfigMenu;
var
  i: integer;
begin
  for i := 0 to MenuConfig.Count - 1 do
  begin
    if i >= FConfigFiles.Count then Break;

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
  ServiceIcon: integer;
  i: integer;

  procedure UpdateButton(Target: TFlowPanel);
  var
    j: integer;
    btn: TFlatButton;
  begin
    // Find SpeedButton with Tag matching current pair index i
    btn := nil;
    for j := 0 to Target.ControlCount - 1 do
      if (Target.Controls[j] is TFlatButton) and (Target.Controls[j].Tag = i) then
      begin
        btn := TFlatButton(Target.Controls[j]);
        Break;
      end;

    // Update Down state according to menu item checked
    if Assigned(btn) then
      btn.Down := MenuLangPairs.Items[i].Checked;
  end;

begin
  if (FlowPairs = nil) or (MenuLangPairs = nil) then Exit;

  // Format the current pair for comparison (e.g., "en:ru")
  currentPair := UpdatePairLanguage(LangSource + ':' + LangTarget);

  for i := 0 to MenuLangPairs.Count - 1 do
  begin
    if i >= FLangPairs.Count then Break;

    // Update MenuFastEnableMouseMode item check state
    MenuLangPairs.Items[i].Checked :=
      SameText(MenuLangPairs.Items[i].Hint, FConfigFile + '=' + currentPair);

    if not TryStrToInt(FConfigImages.Values[FLangPairs.Names[i]], ServiceIcon) then
      ServiceIcon := -1;
    if MenuLangPairs.Items[i].Checked then
      MenuLangPairs.Items[i].ImageIndex := -1
    else
      MenuLangPairs.Items[i].ImageIndex := ServiceIcon;

    UpdateButton(FlowPairs);
    if Assigned(formPopupTrayslate) and (formPopupTrayslate.FlowPairs <> nil) then
      UpdateButton(formPopupTrayslate.FlowPairs);
  end;
end;

function TformTrayslate.UpdateSourceLanguage(const Lang: string): string;
var
  i: integer;
begin
  Result := Lang;

  if Pos('(', ComboSource.Text) = 0 then
  begin
    i := Trans.Languages.FindEqualIndex(Result);
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
      i := Trans.LanguagesTarget.FindEqualIndex(Result);
      if (i >= 0) and (i < FLanguagesTarget.Count) then
        Result := FLanguagesTarget[i];
    end
    else
    begin
      i := Trans.Languages.FindEqualIndex(Result);
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

procedure TFormTrayslate.UpdateInputState(AEnabled: boolean; ReenableHotKeys: boolean = True);
begin
  if not Assigned(KeyHook) or not Assigned(MouseHook) then Exit;

  if AEnabled then
  begin
    KeyHook.Enabled := FEnableMouseMode;
    MouseHook.Enabled := FEnableMouseMode and not FMouseModeCtrl;
    if ReenableHotKeys then
      RegisterHotKeys;
  end
  else
  begin
    KeyHook.Enabled := False;
    MouseHook.Enabled := False;
    if ReenableHotKeys then
      UnregisterHotKeys;
  end;

  SetTrayIcon;
end;

procedure TformTrayslate.UpdateSpellCheck;
begin
  // If spell checking is disabled, clear underlines immediately in the main thread
  if not FSpellCheck then
  begin
    if Assigned(FSpellChecker) then
      FSpellChecker.Clear;
    Exit;
  end;

  if FUpdatingSpellCheck then Exit;
  FUpdatingSpellCheck := True;
  // Copy text in the main thread before starting the background task
  FSpellText := MemoSource.Text;
  // Run spell check in background and apply results in the main thread
  RunAsync(@DoSpellCheck, @ApplySpellCheck);
end;

procedure TformTrayslate.DoSpellCheck;
begin
  // This method runs in a background thread and must not touch GUI
  FSpellErrors := TSpell.CheckText(FSpellText, FLangSource, [scoSpelling], FSpellCheckEmptySuggestions);
end;

procedure TformTrayslate.ApplySpellCheck;
begin
  // This method is called in the main thread via Synchronize
  if not Assigned(FSpellChecker) then
  begin
    FUpdatingSpellCheck := False;
    Exit;
  end;

  // Apply the collected errors using the shared utility method
  TSpell.ApplyErrors(FSpellChecker, FSpellErrors);
  FUpdatingSpellCheck := False;
end;

procedure TformTrayslate.SpellCheckNeeded(Sender: TObject);
begin
  UpdateSpellCheck;

  if FRealTime and Trans.ServiceRealTime then
    TimerTranslate.Enabled := True;
end;

procedure TformTrayslate.DoCheckUpdates(Data: PtrInt);
var
  Th: TCheckUpdateThread;
begin
  Th := TCheckUpdateThread.Create(REPO, rappname, False);
  Th.FreeOnTerminate := True;
end;

procedure TformTrayslate.ShowCustomHint(const AText: string; X: integer = 0; Y: integer = 0; Duration: integer = 3000);
begin
  if not Assigned(FHint) then
    FHint := TOneShotHint.Create(Self);
  FHint.ShowHintText(AText, X, Y, 0, 0, Duration);
end;

function TformTrayslate.GetParameterValue(AName: string; out ResultOk: boolean): string;
var
  Value: string;
  SavedCursor: TCursor;
  SavedTimer: boolean;
begin
  Result := string.Empty;
  ResultOk := True;

  // Check if application or form is destroying
  if Application.Terminated or (Self = nil) or (UserParameters = nil) then
    Exit;

  Value := UserParameters.Values[AName];

  if Value = string.Empty then
  begin
    SavedCursor := Screen.Cursor;
    Screen.Cursor := crDefault;
    SavedTimer := TimerAnimate.Enabled;
    TimerAnimate.Enabled := False;
    try
      if not InputQueryLite(renterparameter, renter + ' ' + AName, Value) then
      begin
        ResultOk := False;
        Exit;
      end;

      // Double check after modal dialog closed
      if Application.Terminated or (Self = nil) or (UserParameters = nil) then
      begin
        ResultOk := False;
        Exit;
      end;

      Value := Trim(Value);
      if Value <> string.Empty then
        UserParameters.Values[AName] := Value;
    finally
      // Restore cursor only if Screen object is still valid
      if not Application.Terminated then
      begin
        Screen.Cursor := SavedCursor;
        TimerAnimate.Enabled := SavedTimer;
      end;
    end;
  end;

  Result := Value;
end;

procedure TformTrayslate.AdjustPopupHeight(AText: string; Force: boolean = False);
var
  NewHeight: integer;
  MaxH: integer;
begin
  if not Assigned(formPopupTrayslate) then Exit;

  if (FAutoHeight or Force) and (AText <> string.Empty) then
  begin
    // Maximum allowed height
    if FMaxHeight = 0 then
      MaxH := Screen.WorkAreaRect.Height
    else
      MaxH := Min(FMaxHeight, Screen.WorkAreaRect.Height);

    // Get actual text height from RichMemo
    NewHeight := formPopupTrayslate.MemoTarget.GetTextHeight(AText);

    // Add top/bottom padding + controls
    NewHeight := NewHeight + formPopupTrayslate.PanelPairs.Height;

    // Limit height
    if NewHeight > MaxH then
      NewHeight := MaxH;

    formPopupTrayslate.Height := NewHeight;
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

    // Auto-height by source text only when form is hidden
    AdjustPopupHeight(SourceText);

    formPopupTrayslate.Font.Assign(FontPopup);
    formPopupTrayslate.PanelWatermark.Font.Size := FontPopup.Size;
    formPopupTrayslate.PanelWatermark.Font.Name := FontPopup.Name;
    formPopupTrayslate.AlphaBlendValue := OpacityIdle;
  end;

  formPopupTrayslate.SourceText := SourceText;
  if SourceText <> string.Empty then
    formpopupTrayslate.MemoTarget.SetTextSafe(SourceText);

  SetTrayIcon;
  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);

  if not formPopupTrayslate.Visible then
    formPopupTrayslate.Visible := True;
  if not StayOnTop then
    TOS.BringToFrontNoFocus(formPopupTrayslate);

  UpdatePopupState;

  // Set auto-height after translate in any case
  FAutoHeightAfter := True;

  // Restore focus
  if Assigned(PrevForm) and PrevForm.Visible and PrevForm.CanFocus then
    PrevForm.SetFocus;

  // Remove TopMost since the main form is not on the top
  if Visible then FTopMost := False;
end;

procedure TformTrayslate.ClosePopupAsync(Data: PtrInt);
begin
  if Assigned(formPopupTrayslate) and formPopupTrayslate.Visible then
    formPopupTrayslate.Close;
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

  // Keep button inside screen always (same as AdjustPopupHeight)
  formButtonTrayslate.FitToScreen;

  formButtonTrayslate.SourceText := SourceText;
  formButtonTrayslate.TimerHide.Enabled := False;
  formButtonTrayslate.TimerHide.Enabled := True;

  if not formButtonTrayslate.Visible then
    formButtonTrayslate.Visible := True;

  // Restore focus
  if Assigned(PrevForm) and PrevForm.Visible and PrevForm.CanFocus then
    PrevForm.SetFocus;

  // Remove TopMost since the main form is not on the top
  if Visible then FTopMost := False;
end;

procedure TformTrayslate.SetVerticalMode;
var
  TotalSize: integer;
begin
  if FVerticalSplit then
  begin
    // Switch to vertical layout
    TotalSize := PanelSource.Width + PanelTarget.Width;

    PanelSource.Align := alClient;
    PanelTarget.Align := alRight;
    Splitter.Align := alRight;

    PanelSource.BorderSpacing.Right := 0;
    PanelSource.BorderSpacing.Bottom := 3;
    PanelTarget.BorderSpacing.Left := 0;

    PanelSource.Width := Round(TotalSize * (1 - FSplitRatio));
  end
  else
  begin
    // Switch to horizontal layout
    TotalSize := PanelSource.Height + PanelTarget.Height;

    PanelSource.Align := alClient;
    PanelTarget.Align := alBottom;
    Splitter.Align := alBottom;

    PanelSource.BorderSpacing.Right := 3;
    PanelSource.BorderSpacing.Bottom := 0;
    PanelTarget.BorderSpacing.Left := 3;

    PanelSource.Height := Round(TotalSize * (1 - FSplitRatio));
  end;
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
    if FIconTwoLang then SetTrayIcon;
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
    SetTrayIcon;
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
    MemoSource.SetTextSafe(MemoTarget.Text);
    UpdateMemoState(MemoSource);
    MemoTarget.SetTextSafe(srcMemoText);
    UpdateMemoState(MemoTarget);
  end;

  Result := True;
end;

procedure TformTrayslate.AddLangPair(const Pair: string; ToEnd: boolean = True);
var
  idx: integer;
  RealPair, PairHint: string;
begin
  RealPair := UpdatePairLanguage(Pair);
  PairHint := LongestString(Pair.SplitIntoTwoParts(':', True), MAX_LANG_LENGTH);

  // Remove if already exists
  idx := FLangPairs.IndexOf(FConfigFile + '=' + RealPair);
  if (idx >= 0) and (FLangPairs.Names[idx] = FConfigFile) then
    FLangPairs.Delete(idx);

  if ToEnd then
  begin
    // Add to end
    FLangPairs.Add(FConfigFile + '=' + RealPair);
    FLangPairsHint.Add(PairHint);
  end
  else
  begin
    // Insert as first
    FLangPairs.Insert(0, FConfigFile + '=' + RealPair);
    FLangPairsHint.Insert(0, PairHint);
  end;

  // Limit to FMaxLangPairs count
  while FLangPairs.Count > FMaxLangPairs do
  begin
    FLangPairs.Delete(0);
    FLangPairsHint.Delete(0);
  end;
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

  idxnative := FLanguages.FindIndex('(' + fromLang + ')');
  if idxnative < 0 then
    idxnative := FLanguages.FindIndex(fromLang);

  if idxnative >= 0 then
    ChangeSourceLang(FLanguages[idxnative], False)
  else
    RunTranslate := False;

  if FLanguagesTarget.Count > 0 then
  begin
    idxnative := FLanguagesTarget.FindIndex('(' + toLang + ')');
    if idxnative < 0 then
      idxnative := FLanguagesTarget.FindIndex(toLang);

    if idxnative >= 0 then
      ChangeTargetLang(FLanguagesTarget[idxnative], False)
    else
      RunTranslate := False;
  end
  else
  begin
    idxnative := FLanguages.FindIndex('(' + toLang + ')');
    if idxnative < 0 then
      idxnative := FLanguages.FindIndex(toLang);

    if idxnative >= 0 then
      ChangeTargetLang(FLanguages[idxnative], False)
    else
      RunTranslate := False;
  end;

  UpdateCheckMenuPair;
  UpdateSpellCheck;

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

procedure TformTrayslate.UpdateTranslateButtonState(ForceTranslateButton: boolean = False);
begin
  if Assigned(FTranslateThread) and not FTranslateThread.Finished and not FTranslateThread.IsCancelled and not ForceTranslateButton then
  begin
    aTranslate.ImageIndex := TDarkUtils.ThemeValue(16, 17);
    aTranslate.Hint := rtranslatestop;
    aTranslate.Tag := 1;
  end
  else
  begin
    aTranslate.ImageIndex := TDarkUtils.ThemeValue(2, 3);
    aTranslate.Hint := rtranslate;
    aTranslate.Tag := 0;
  end;
end;

procedure TformTrayslate.UpdatePopupState(SetWindowParam: boolean = True);
begin
  if Assigned(formPopupTrayslate) and (formPopupTrayslate.Visible) then
  begin
    if FAutoHeightAfter then
    begin
      FAutoHeightAfter := False;
      AdjustPopupHeight(FRawTranslate);
    end;

    // Update StayOnTop NoFocus
    Application.QueueAsyncCall(@formPopupTrayslate.UpdateStayOnTop, iif(SetWindowParam, 1, 0));

    // Keep inside screen always
    formPopupTrayslate.FitToScreen;
  end;
end;

procedure TformTrayslate.UpdateMemoState(AMemo: TRichMemo);
begin
  AMemo.SetLeftIndent;
  AMemo.ApplyBidiMode;
end;

procedure TformTrayslate.MoveButtonTo(AFromIndex, AToIndex: integer);
var
  Pair, PairHint: string;
begin
  if (AFromIndex < 0) or (AFromIndex >= FLangPairs.Count) or (AToIndex < 0) or (AToIndex > FLangPairs.Count) then Exit;
  if AFromIndex = AToIndex then Exit;

  // Remove the dragged pair from its current position
  Pair := FLangPairs[AFromIndex];
  PairHint := FLangPairsHint[AFromIndex];
  FLangPairs.Delete(AFromIndex);
  FLangPairsHint.Delete(AFromIndex);

  // Adjust target index because the list shifted after deletion
  if AToIndex > AFromIndex then
    Dec(AToIndex);

  // Insert the pair at the target position
  FLangPairs.Insert(AToIndex, Pair);
  FLangPairsHint.Insert(AToIndex, PairHint);

  FDragBtnIndex := AToIndex;
  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
  FDragMoved := True;
end;

function TformTrayslate.GetConfigIndex: integer;
begin
  Result := ConfigFiles.FindIndex(FConfigFile);
end;

function TformTrayslate.GetIconIndex: integer;
var
  idx: integer;
begin
  Result := -1;
  idx := IndexConfig;
  if (idx >= 0) and (idx < ConfigImages.Count) then
    Result := ConfigImages.ValueFromIndex[idx].ToInteger;
end;

function TformTrayslate.GetLangCode(ComboValue: string; Target: boolean = False): string;
var
  idnative: integer;
begin
  Result := string.Empty;
  if Target and (FLanguagesTarget.Count > 0) then
    idnative := FLanguagesTarget.IndexOf(ComboValue)
  else
    idnative := FLanguages.IndexOf(ComboValue);
  if (idnative < 0) then Exit;

  if Target and (Trans.LanguagesTarget.Count > 0) then
  begin
    if Trans.LanguagesTarget.Count > idnative then
      Result := Trans.LanguagesTarget.Names[idnative];
  end
  else
  begin
    if Trans.Languages.Count > idnative then
      Result := Trans.Languages.Names[idnative];
  end;
end;

{%EndRegion}

{%Region -fold Tray Icon}

function TformTrayslate.CreateTrayIconLang(const ALang1: string; const ALang2: string = string.Empty): Graphics.TBitmap;
var
  Bmp: TBitmap;
  IntfImg: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  rect, rect1, rect2: TRect;
  delta: integer;
  Value: string;

  function FormatValue(const Value: string; DefSize: integer = DEF_SMALL): string;
  begin
    Result := Value;
    if Result = string.Empty then Result := DEF_NA;

    if Pos('-', Result) > 0 then
      Result := LeftStr(Result, Pos('-', Result + '-') - 1);

    if (Length(Result) = 3) then
    begin
      Bmp.Canvas.Font.Size := ScaleScreenTo96(iif(FIconCircular, DEF_MICRO, DEF_TINY));
      if (Bmp.Canvas.TextWidth(Result) > ICON_SIZE + 1) then Bmp.Canvas.Font.Size := ScaleScreenTo96(DEF_MICRO);
    end
    else
    begin
      if (LowerCase(Result) = DEF_AUTO_TEXT) then
      begin
        Bmp.Canvas.Font.Size := ScaleScreenTo96(iif(FIconCircular, DEF_MINI, DEF_SMALL));
        Result := DEF_AUTO;
      end
      else
      begin
        Bmp.Canvas.Font.Size := ScaleScreenTo96(DefSize);
        Result := Result.Substring(0, 2);
      end;
    end;
  end;

begin
  IntfImg := TLazIntfImage.Create(ICON_SIZE, ICON_SIZE);
  Bmp := Graphics.TBitmap.Create;
  try
    Bmp.SetSize(ICON_SIZE, ICON_SIZE);  // standard tray icon size

    // Set background
    rect := Types.Rect(0, 0, Bmp.Width, Bmp.Height);

    if FIconCircular then
    begin
      // For circular icon use transparent color outside the circle
      Bmp.Canvas.Brush.Color := clFuchsia;
      Bmp.TransparentColor := clFuchsia;
      Bmp.Transparent := True;
      Bmp.Canvas.Brush.Style := bsSolid;
      Bmp.Canvas.FillRect(rect);
      if FIconBackgroundColor = clNone then
        Bmp.Canvas.Font.Quality := fqNonAntialiased;
      if FIconBackgroundColor <> clNone then
      begin
        Bmp.Canvas.Brush.Color := FIconBackgroundColor;
        Bmp.Canvas.Pen.Color := FIconBackgroundColor;
        Bmp.Canvas.Pen.Style := psSolid;
        Bmp.Canvas.CircleFilled(rect, FIconBackgroundColor);
      end;
    end
    else
    begin
      if FIconBackgroundColor = clNone then
      begin
        Bmp.Canvas.Brush.Color := clFuchsia;
        Bmp.Canvas.Font.Quality := fqNonAntialiased;
        Bmp.TransparentColor := clFuchsia;
        Bmp.Transparent := True;
      end
      else
        Bmp.Canvas.Brush.Color := FIconBackgroundColor;
      Bmp.Canvas.Brush.Style := bsSolid;
      Bmp.Canvas.FillRect(rect);
    end;

    // Draw mouse mode frame if enabled, before text so text stays on top
    if Assigned(MouseHook) and MouseHook.Enabled and FEnableMouseMode and (FIconMouseModeFrameColor <> clNone) then
    begin
      Bmp.Canvas.Pen.Color := FIconMouseModeFrameColor;
      Bmp.Canvas.Pen.Width := 1;
      Bmp.Canvas.Pen.Style := psSolid;
      Bmp.Canvas.Brush.Style := bsClear;
      if FIconCircular then
        Bmp.Canvas.CircleOutline(rect, FIconMouseModeFrameColor, FIconBackgroundColor)
      else
        Bmp.Canvas.Rectangle(rect);
    end;

    // Set text style
    Bmp.Canvas.Font.Name := ifthen(FIconFontName = string.Empty, DEF_FONT, FIconFontName);
    Bmp.Canvas.Font.Color := FIconFontColor;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Brush.Style := bsClear;

    if (ALang2 = string.Empty) then
    begin
      // Draw text centered
      Value := FormatValue(ALang1, iif(FIconCircular, DEF_MINI, DEF_SMALL));
      DrawText(Bmp.Canvas.Handle, PChar(Value), Length(Value), rect,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
    else
    begin
      // Upper half
      Value := FormatValue(ALang1, iif(FIconCircular, DEF_TINY, DEF_MINI));
      delta := 0;
      delta += iif(FIconCircular, 1, 0);
      rect1 := Types.Rect(rect.Left, rect.Top + delta, rect.Right, (rect.Top + rect.Bottom) div 2 + delta);
      DrawText(Bmp.Canvas.Handle, PChar(Value), Length(Value), rect1,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);

      // Lower half
      Value := FormatValue(ALang2, iif(FIconCircular, DEF_TINY, DEF_MINI));
      delta := ifthen(Value = DEF_AUTO, 3, 0);
      delta += iif(FIconCircular, -1, 0);
      rect2 := Types.Rect(rect.Left, (rect.Top + rect.Bottom) div 2 + delta, rect.Right, rect.Bottom + delta);
      DrawText(Bmp.Canvas.Handle, PChar(Value), Length(Value), rect2,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;

    IntfImg.LoadFromBitmap(Bmp.Handle, Bmp.MaskHandle);

    // Copy it to a TBitmap
    IntfImg.CreateBitmaps(ImgHandle, ImgMaskHandle, False);
    Bmp.Handle := ImgHandle;
    Bmp.MaskHandle := ImgMaskHandle;

    // Create icon from bitmap
    Result := Bmp;
  finally
    IntfImg.Free;
  end;
end;

function TformTrayslate.CreateTrayIconProgress(AAngle: integer; ABackgroundColor: TColor = clNone;
  APenColor: TColor = clWhite): Graphics.TBitmap;
var
  TempIntfImg: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  TempBitmap: Graphics.TBitmap;
  cx, cy, r: integer;
  p1x, p1y, p2x, p2y: integer;
  a1, a2: double;
  rect: TRect;
begin
  TempIntfImg := TLazIntfImage.Create(ICON_SIZE, ICON_SIZE);
  TempBitmap := Graphics.TBitmap.Create;

  try
    TempBitmap.SetSize(ICON_SIZE, ICON_SIZE);

    // transparent background
    TempBitmap.Canvas.AntialiasingMode := amOn;

    rect := Types.Rect(0, 0, ICON_SIZE, ICON_SIZE);

    if FIconCircular then
    begin
      // Use transparent color outside the circle
      TempBitmap.Canvas.Brush.Color := clFuchsia;
      TempBitmap.Transparent := True;
      TempBitmap.TransparentColor := clFuchsia;
      TempBitmap.Canvas.Brush.Style := bsSolid;
      TempBitmap.Canvas.FillRect(rect);
      if ABackgroundColor <> clNone then
        TempBitmap.Canvas.CircleFilled(rect, ABackgroundColor);
    end
    else
    begin
      if ABackgroundColor = clNone then
      begin
        TempBitmap.Canvas.Brush.Color := clFuchsia;
        TempBitmap.Transparent := True;
        TempBitmap.TransparentColor := clFuchsia;
      end
      else
        TempBitmap.Canvas.Brush.Color := ABackgroundColor;
      TempBitmap.Canvas.Brush.Style := bsSolid;
      TempBitmap.Canvas.FillRect(rect);
    end;

    // Draw mouse mode frame if enabled, before progress arc so arc stays on top
    if Assigned(MouseHook) and MouseHook.Enabled and FEnableMouseMode and (FIconMouseModeFrameColor <> clNone) then
    begin
      TempBitmap.Canvas.Pen.Color := FIconMouseModeFrameColor;
      TempBitmap.Canvas.Pen.Width := 1;
      TempBitmap.Canvas.Pen.Style := psSolid;
      TempBitmap.Canvas.Brush.Style := bsClear;
      if FIconCircular then
        TempBitmap.Canvas.CircleOutline(rect, FIconMouseModeFrameColor, ABackgroundColor)
      else
        TempBitmap.Canvas.Rectangle(rect);
    end;

    // Ensure the pen is solid for drawing the arc
    TempBitmap.Canvas.Pen.Style := psSolid;
    TempBitmap.Canvas.Pen.Color := APenColor;
    TempBitmap.Canvas.Pen.Width := 3;

    cx := ICON_SIZE div 2;
    cy := ICON_SIZE div 2;
    r := (ICON_SIZE div 2) - 2;

    a1 := DegToRad(AAngle);
    a2 := DegToRad(AAngle + 180);

    // arc points
    p1x := cx + Round(r * Cos(a1));
    p1y := cy + Round(r * Sin(a1));

    p2x := cx + Round(r * Cos(a2));
    p2y := cy + Round(r * Sin(a2));
    TempBitmap.Canvas.Arc(
      cx - r, cy - r,
      cx + r, cy + r,
      p1x, p1y,
      p2x, p2y
      );

    // create mask through TLazIntfImage
    TempIntfImg.LoadFromBitmap(TempBitmap.Handle, TempBitmap.MaskHandle);
    TempIntfImg.CreateBitmaps(ImgHandle, ImgMaskHandle, False);

    TempBitmap.Handle := ImgHandle;
    TempBitmap.MaskHandle := ImgMaskHandle;

    Result := TempBitmap;
  finally
    TempIntfImg.Free;
  end;
end;

{%EndRegion}

{%Region -fold Translate Methods}

function TformTrayslate.TranslateThread(ATrans: TTranslate; AText: string; AMemo: TRichMemo = nil): string;
var
  Th: TTranslateThread;
  ThDone: boolean;
  Zoom: double;
begin
  Result := string.Empty;
  if FCancelled then
  begin
    Screen.Cursor := crDefault;
    TimerAnimate.Enabled := False;
    Exit;
  end;

  // Ensure any previous translation is fully stopped and cleaned up
  if Assigned(FTranslateThread) then
    CancelTranslate;

  try
    FCancelled := False;
    ATrans.TextToTranslate := AText;
    FRawTranslate := string.Empty;
    ThDone := False;

    Th := TTranslateThread.Create(ATrans, @FRawTranslate, @ThDone, ATrans = TransDetect);
    FTranslateThread := Th;
    FActiveThreads.Add(Th);

    TranslateTarget := AMemo;
    UpdateTranslateButtonState;
    Screen.Cursor := crAppStart;
    TimerAnimate.Enabled := True;
    Th.OnTerminate := @ThreadDone;
    Th.Start;
    try
      while Assigned(Th) and not ThDone do
      begin
        // If the thread was replaced or freed externally, abandon local reference
        if FCancelled or (FTranslateThread <> Th) then
        begin
          Th := nil;
          Result := string.Empty;
          Break;
        end;
        Application.ProcessMessages;
        Sleep(1);
      end;
      // Result only if the thread is still ours and not cancelled
      if not FCancelled and (FRawTranslate.Trim <> string.Empty) then
      begin
        Result := FRawTranslate;
        if Assigned(AMemo) then
        begin
          Zoom := AMemo.ZoomFactor;
          AMemo.Text := FRawTranslate;
          UpdateMemoState(AMemo);
          AMemo.ZoomFactor := Zoom;
        end;
      end;
    finally
      if Assigned(Th) then
      begin
        FActiveThreads.Remove(Th);
        Th := nil;   // Th is nil if the thread was replaced/force-killed
      end;
    end;
  finally
    if ATrans <> TransDetect then
    begin
      UpdateTranslateButtonState;
      Screen.Cursor := crDefault;
      TimerAnimate.Enabled := False;
    end;
  end;
end;

procedure TformTrayslate.ThreadDone(Sender: TObject);
begin
  if (Sender <> FTranslateThread) then
    Exit;

  if Assigned(FTranslateThread) and FTranslateThread.IsCancelled then
  begin
    FTranslateThread := nil;
    TranslateTarget := nil;
    exit;
  end;

  if FAutoCopy then
    Clipboard.AsText := FRawTranslate;

  if not (Sender as TTranslateThread).LangDetect then
    UpdatePopupState;

  if not Visible and (not Assigned(formPopupTrayslate) or not formPopupTrayslate.Visible) then
    ShowCustomHint(TrayIcon.Hint);

  FTranslateThread := nil;
  TranslateTarget := nil;
end;

procedure TformTrayslate.CancelTranslate;
begin
  try
    FCancelled := True;

    if Assigned(FTranslateThread) then
      FTranslateThread.Cancel;

    TranslateTarget := nil;
  finally
    UpdateTranslateButtonState;

    FBlockTrayUpdate := True;
    try
      TimerAnimate.Enabled := False;
    finally
      FBlockTrayUpdate := False;
    end;

    Screen.Cursor := crDefault;
    SetTrayIcon;
  end;
end;

procedure TformTrayslate.DetectLanguage(AText: string);
var
  langSrc, langTar, langDetect, langPrimary, langSecondary: string;
  idxSrc, idxTar, idx: integer;
  NeedHint: boolean = False;
begin
  if FCancelled then Exit;
  if not FAutoSwap or not Trans.ServiceAutoSwap or not Assigned(FTransDetect) then Exit;

  langSrc := string.Empty;
  langTar := string.Empty;
  idxSrc := FLanguages.IndexOf(ComboSource.Text);
  idxTar := FLanguages.IndexOf(ComboTarget.Text);
  //  if (idxSrc < 0) or (idxTar < 0) then Exit;

  // Check selected languages
  if (idxSrc >= 0) then
    langSrc := LowerCase(Trans.Languages.Names[idxSrc]);
  if (idxTar >= 0) then
    langTar := LowerCase(Trans.Languages.Names[idxTar]);
  langPrimary := LowerCase(PrimaryLang);
  langSecondary := LowerCase(SecondaryLang);

  // Detect language in source memo
  if BuiltInDetect then
    langDetect := TLangDetect.DetectLanguageSafe(AText.ExtractTextSample(1000), langSrc, 0.5, Trans.LanguageCodes)
  else
    langDetect := LowerCase(TranslateThread(TransDetect, AText.ExtractTextSample));

  // Update deprecated codes
  langDetect := TLangDetect.NormalizeLanguageCode(langDetect);

  if FCancelled or (langDetect = string.Empty) or (Length(langDetect) > 5) or (langDetect = UNKNOWN) then Exit;

  // Swap if needed
  if not SmartSwap then
  begin
    // Ordinary swap
    if ((langSrc = langDetect) or (langTar = langDetect)) and (not TLanguages.IsSpecialCode(langSrc)) and
      (not TLanguages.IsSpecialCode(langTar)) then
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
    if ((langSrc = langDetect) or (langTar = langDetect)) and (not TLanguages.IsSpecialCode(langSrc)) and
      (not TLanguages.IsSpecialCode(langTar)) and ((not SmartHard) or (((langSrc = langPrimary) and (langTar = langSecondary)) or
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
      if (langSrc <> langDetect) or (TLanguages.IsSpecialCode(langSrc)) then
      begin
        if (langDetect = langPrimary) then
        begin
          if (langSrc <> langPrimary) and (not TLanguages.IsSpecialCode(langSrc)) then
          begin
            idx := Trans.Languages.IndexOfNameIgnoreCase(langPrimary);
            if (idx > 0) and (idx < FLanguages.Count) then
            begin
              ChangeSourceLang(FLanguages[idx], False);
              NeedHint := True;
            end;
          end;
          if (langTar <> langSecondary) and (SmartHard) then
          begin
            idx := Trans.Languages.IndexOfNameIgnoreCase(langSecondary);
            if (idx > 0) and (idx < FLanguages.Count) then
            begin
              ChangeTargetLang(FLanguages[idx]);
              NeedHint := True;
            end;
          end;
          if NeedHint then
            ShowCustomHint(TrayIcon.Hint);
        end
        else
        begin
          if (langSrc <> langDetect) and (not TLanguages.IsSpecialCode(langSrc)) then
          begin
            idx := Trans.Languages.IndexOfNameIgnoreCase(langDetect);
            if (idx > 0) and (idx < FLanguages.Count) then
            begin
              ChangeSourceLang(FLanguages[idx], False);
              NeedHint := True;
            end;
          end;
          if (langTar <> langPrimary) and (SmartHard) then
          begin
            idx := Trans.Languages.IndexOfNameIgnoreCase(langPrimary);
            if (idx > 0) and (idx < FLanguages.Count) then
            begin
              ChangeTargetLang(FLanguages[idx]);
              NeedHint := True;
            end;
          end;
          if NeedHint then
            ShowCustomHint(TrayIcon.Hint);
        end;
      end;
    end;
  end;

  UpdateSpellCheck;
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
  TOS.SleepLoop(0, 1);
  if (Clipboard.AsText <> string.empty) then
  begin
    MemoSource.SetTextSafe(Clipboard.AsText);
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

{ Key Press Emulate Methods }

procedure TformTrayslate.GlobalCopy(MouseMode: boolean = False);
var
  ctrl, shift, alt: boolean;
  Delay: integer = 10;
begin
  if MouseMode and (FPrevMouseDown.WindowClass = wckOutlookMain) then
    Delay := 20;

  TimerUnapply.Enabled := False;
  ctrl := GetAsyncKeyState(VK_CONTROL) < 0;
  shift := GetAsyncKeyState(VK_SHIFT) < 0;
  alt := GetAsyncKeyState(VK_MENU) < 0;

  if alt then
    KeyInput.Unapply([ssAlt]);
  if shift then
    KeyInput.Unapply([ssShift]);
  if not ctrl then
    KeyInput.Apply([ssCtrl]);

  if FInsertKey then
    KeyInput.Down(VK_INSERT)
  else
    KeyInput.Down(Ord('C'));

  Clipboard.AddExcludeFlag;
  TOS.SleepLoop(1, 1);
  Clipboard.AddExcludeFlag;
  TOS.SleepLoop(Delay - 1, 1);

  if (FInsertKey) then
    FUnapplyInsert := True
  else
    FUnapplyC := True;
  if not ctrl then
    FUnapplyCtrl := True;
  TimerUnapply.Enabled := True;

  //if shift then
  //  KeyInput.Apply([ssShift]);
  //if alt then
  //  KeyInput.Apply([ssAlt]);
end;

procedure TformTrayslate.GlobalPaste;
var
  ctrl, shift, alt: boolean;
begin
  TimerUnapply.Enabled := False;
  ctrl := GetAsyncKeyState(VK_CONTROL) < 0;
  shift := GetAsyncKeyState(VK_SHIFT) < 0;
  alt := GetAsyncKeyState(VK_MENU) < 0;

  if alt then
    KeyInput.Unapply([ssAlt]);

  if FInsertKey then
  begin
    if ctrl then
      KeyInput.Unapply([ssCtrl]);
    if not shift then
      KeyInput.Apply([ssShift]);

    KeyInput.Down(VK_INSERT);
  end
  else
  begin
    if not ctrl then
      KeyInput.Apply([ssCtrl]);
    if shift then
      KeyInput.Unapply([ssShift]);

    KeyInput.Down(Ord('V'));
  end;

  TOS.SleepLoop(10, 1);

  if FInsertKey then
  begin
    FUnapplyInsert := True;
    if not shift then
      FUnapplyShift := True;
  end
  else
  begin
    FUnapplyV := True;
    if not ctrl then
      FUnapplyCtrl := True;
  end;
  TimerUnapply.Enabled := True;

  //if shift then
  //  KeyInput.Apply([ssShift]);
  //if alt then
  //  KeyInput.Apply([ssAlt]);
end;

procedure TformTrayslate.TranslateFromControl(Data: PtrInt);
var
  SelectedText: string;
  SavedClip: TClipboardFormatDataArray;
  SavedTextClip: string;
  IsText: boolean;

  procedure SaveClipboad;
  begin
    IsText := Clipboard.IsText;
    if IsText then
      SavedTextClip := Clipboard.AsText
    else
      SavedClip := Clipboard.SaveAllFormats;
  end;

  procedure RestoreClipboard;
  begin
    if IsText then
      Clipboard.AsText := SavedTextClip
    else
      Clipboard.RestoreAllFormats(SavedClip);
    Clipboard.AddExcludeFlag;
  end;

begin
  FCancelled := False;

  // Save current clipboard to restore later
  SaveClipboad;
  try
    Clipboard.AsText := string.Empty;
    Clipboard.AddExcludeFlag;

    // Copy selection from active window (Ctrl+C)
    GlobalCopy;
    SelectedText := Clipboard.AsText;
  finally
    // Restore original clipboard
    RestoreClipboard;
  end;

  if Trim(SelectedText) <> string.Empty then
  begin
    if (not Showing) then
      Visible := True;
    TOS.BringToFrontNoFocus(Self);

    FTopMost := True;
    TOS.SleepLoop(0, 1);
    MemoSource.SetTextSafe(SelectedText);
    UpdateMemoState(MemoSource);
    TranslateMemo;
  end;
end;

procedure TformTrayslate.TranslateControl(Data: PtrInt);
var
  SelectedText: string;
  TranslatedText: string;
  SavedClip: TClipboardFormatDataArray;
  SavedTextClip: string;
  IsText: boolean;

  procedure SaveClipboad;
  begin
    IsText := Clipboard.IsText;
    if IsText then
      SavedTextClip := Clipboard.AsText
    else
      SavedClip := Clipboard.SaveAllFormats;
  end;

  procedure RestoreClipboard;
  begin
    if IsText then
      Clipboard.AsText := SavedTextClip
    else
      Clipboard.RestoreAllFormats(SavedClip);
    Clipboard.AddExcludeFlag;
  end;

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
    SaveClipboad;
    try
      Clipboard.AsText := string.Empty;
      Clipboard.AddExcludeFlag;
      // Copy selection from active window (Ctrl+C)
      GlobalCopy;
      SelectedText := Clipboard.AsText;
    finally
      // Restore original clipboard
      RestoreClipboard
    end;

    if SelectedText <> string.Empty then
    begin
      DetectLanguage(SelectedText);

      TranslatedText := TranslateThread(Trans, SelectedText);
      if Trim(TranslatedText) <> string.Empty then
      begin
        // Save current clipboard to restore later
        SaveClipboad;
        try
          Clipboard.AsText := TranslatedText;
          Clipboard.AddExcludeFlag;

          // Paste clipboard to active window (Ctrl+V)
          GlobalPaste;
        finally
          // Restore original clipboard
          RestoreClipboard
        end;
      end;
    end;
  finally
    {$IFDEF WINDOWS}
    SystemParametersInfo(SPI_SETCURSORS, 0, nil, 0);
    {$ELSE}
    Screen.Cursor := crDefault;
    {$ENDIF}
  end;
end;

procedure TformTrayslate.TranslateFromControlPopup(Data: PtrInt);
var
  SelectedText: string;
  SavedClip: TClipboardFormatDataArray;
  SavedTextClip: string;
  IsText: boolean;

  procedure SaveClipboad;
  begin
    IsText := Clipboard.IsText;
    if IsText then
      SavedTextClip := Clipboard.AsText
    else
      SavedClip := Clipboard.SaveAllFormats;
  end;

  procedure RestoreClipboard;
  begin
    if IsText then
      Clipboard.AsText := SavedTextClip
    else
      Clipboard.RestoreAllFormats(SavedClip);
    Clipboard.AddExcludeFlag;
  end;

begin
  FCancelled := False;

  // Save current clipboard to restore later
  SaveClipboad;
  try
    Clipboard.AsText := string.Empty;
    Clipboard.AddExcludeFlag;
    if TimerTranslate.Enabled then
      TimerTranslate.Enabled := False;

    // Copy selection from active window (Ctrl+C)
    GlobalCopy;
    SelectedText := Clipboard.AsText;
  finally
    // Restore original clipboard
    RestoreClipboard;
  end;

  if Trim(SelectedText) <> string.Empty then
  begin
    ShowPopup(SelectedText, Mouse.CursorPos.X, Mouse.CursorPos.Y);

    DetectLanguage(SelectedText);

    // Create translation thread (it will handle exceptions itself)
    TranslateThread(Trans, SelectedText, formPopupTrayslate.MemoTarget);
  end;
end;

procedure TformTrayslate.TranslateMouseMode(ACursorPos: TPoint);
var
  SavedClip: TClipboardFormatDataArray;
  SavedTextClip: string;
  IsText: boolean;
  SelectedText, TranslatedText: string;
  Ticks: DWORD;

  procedure SaveClipboad;
  begin
    IsText := Clipboard.IsText;
    if IsText then
      SavedTextClip := Clipboard.AsText
    else
      SavedClip := Clipboard.SaveAllFormats;
  end;

  procedure RestoreClipboard;
  begin
    if IsText then
      Clipboard.AsText := SavedTextClip
    else
      Clipboard.RestoreAllFormats(SavedClip);
  end;

begin
  FCancelled := False;
  FMouseHook.Enabled := False;
  try
    // Save current clipboard to restore later
    SaveClipboad;
    try
      Clipboard.AsText := string.Empty;
      Clipboard.AddExcludeFlag;
      // Copy selection from active window (Ctrl+C)
      GlobalCopy(True);
      SelectedText := Clipboard.AsText;
    finally
      Ticks := TOS.GetTickCountXp;

      // Restore original clipboard quickly if paste combination was pressed (Ctrl+V)
      if ((Ticks - FLastVTime) <= 100) then
        RestoreClipboard
      else
      // Restore original clipboard only if one of the cut / copy combination keys is not pressed (Ctrl+X, Ctrl+C)
      if ((Ticks - FLastCTime) > 100) and ((Ticks - FLastXTime) > 100) then
        RestoreClipboard;

      // In any case, add the system buffer flag
      Clipboard.AddExcludeFlag;

      if (Ticks - FLastKeyTime) > 200 then
        TimerUnapplyTimer(Self);
    end;

    if Trim(SelectedText) <> string.Empty then
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
          TOS.SleepLoop(0, 1);
          MemoSource.SetTextSafe(SelectedText);
          TranslateMemo;
        end;
        else
          ;
      end;
    end
    else
      TimerUnapplyTimer(Self);
  finally
    FMouseHook.Enabled := FEnableMouseMode and not FMouseModeCtrl;
  end;
end;

{%EndRegion}

{%Region -fold Action Languages}

procedure TformTrayslate.SetLanguage(ALangCode: string = string.Empty);
var
  OldAutoDetect: string = string.Empty;
  LangCode: string;
  PoText: string;
begin
  LangCode := ALangCode;
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
  aLangPortugueseBrazil.Checked := False;
  aLangRomanian.Checked := False;
  aLangRussian.Checked := False;
  aLangSpanish.Checked := False;
  aLangSwedish.Checked := False;
  aLangTurkish.Checked := False;
  aLangUkrainian.Checked := False;
  aLangVietnamese.Checked := False;
  aLangCustom.Checked := False;

  if FCustomPoFile <> string.Empty then
  begin
    PoText := TLocalize.LoadCustomPoFile(FCustomPoFile);
    if PoText = string.Empty then
    begin
      FCustomPoFile := string.Empty;
      LangCode := TLocalize.GetOSLanguage;
    end
    else
      LangCode := TLocalize.GetLangCodeFromPoFile(FCustomPoFile);
  end;

  if (LangCode <> string.Empty) then
  begin
    OldAutoDetect := ifthen(FLanguages.Any(rautodetect), rautodetect, AutoDetect);
    Language := LangCode;
    TLocalize.ApplicationTranslate(APP_NAME, DEFAULT_LANG);
    if not TLocalize.ApplicationTranslate(APP_NAME, Language, nil, PoText) then
      Language := DEFAULT_LANG;

    TLocalize.UpdatePackageTranslations(APP_NAME, 'checkupdates', Language, ['checkupdates']);
  end;

  UpdateAutoDetect(OldAutoDetect, rautodetect);

  // Update form text
  SetHints;
  SetTrayIcon;

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
      'pt-BR': aLangPortugueseBrazil.Checked := True;
      'ro': aLangRomanian.Checked := True;
      'ru': aLangRussian.Checked := True;
      'es': aLangSpanish.Checked := True;
      'sv': aLangSwedish.Checked := True;
      'tr': aLangTurkish.Checked := True;
      'uk': aLangUkrainian.Checked := True;
      'vi': aLangVietnamese.Checked := True;
      else
      // nolang
    end;
  end
  else
    aLangCustom.Checked := True;
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

procedure TformTrayslate.aLangPortugueseBrazilExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('pt-BR');
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

procedure TformTrayslate.aLangVietnameseExecute(Sender: TObject);
begin
  FCustomPoFile := string.empty;
  SetLanguage('vi');
end;

{%EndRegion}

end.
