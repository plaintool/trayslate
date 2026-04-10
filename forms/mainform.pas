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
  IniFiles,
  LCLType,
  LMessages,
  mouseandkeyinput,
  translate,
  langtool;

type

  { TformTrayslate }

  TformTrayslate = class(TForm)
    aAbout: TAction;
    aConfigEditor: TAction;
    aCheckForUpdates: TAction;
    aAddPair: TAction;
    aAutoCheckUpdates: TAction;
    aNewTranslate: TAction;
    aSettings: TAction;
    aTranslateClipboard: TAction;
    aSwap: TAction;
    aTranslate: TAction;
    aShow: TAction;
    aDonate: TAction;
    aExit: TAction;
    ActionList: TActionList;
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
    PanelLang: TPanel;
    PopupTray: TPopupMenu;
    SbNewTranslate: TSpeedButton;
    SbAddPair: TSpeedButton;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    SbSwap: TSpeedButton;
    SbTranslate: TSpeedButton;
    Separator3: TMenuItem;
    Separator9: TMenuItem;
    SplitterMemo: TSplitter;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ApplicationOnActivate(Sender: TObject);
    procedure ApplicationOnDeactivate(Sender: TObject);
    procedure ApplicationOnException(Sender: TObject; E: Exception);
    procedure ScreenActiveFormChanged(Sender: TObject);
    procedure aConfigEditorExecute(Sender: TObject);
    procedure aSettingsExecute(Sender: TObject);
    procedure aTranslateClipboardExecute(Sender: TObject);
    procedure aNewTranslateExecute(Sender: TObject);
    procedure aTranslateExecute(Sender: TObject);
    procedure aSwapExecute(Sender: TObject);
    procedure aShowExecute(Sender: TObject);
    procedure aAddPairExecute(Sender: TObject);
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
    procedure MemoTargetEnter(Sender: TObject);
    procedure MemoSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoSourceKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure PanelLangResize(Sender: TObject);
    procedure SbSwapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure TimerActiveTimer(Sender: TObject);
    procedure TimerAnimateStopTimer(Sender: TObject);
    procedure TimerAnimateTimer(Sender: TObject);
    procedure TimerTranslateTimer(Sender: TObject);
    procedure TimerClickTimer(Sender: TObject);
    procedure TrayIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure TrayIconClick(Sender: TObject);
    procedure LabelMouseEnter(Sender: TObject);
    procedure LabelMouseLeave(Sender: TObject);
    procedure LabelLangMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure MenuConfigItemClick(Sender: TObject);
    procedure MenuPairClick(Sender: TObject);
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
    FTopMost: boolean;
    FLeftButton: boolean;
    FLastEnterTime: DWORD;
    FMemoSourceCaretPos: integer;
    FPrevSourceText: string;
    FPrevTargetText: string;
    FLangPairs: TStringList;
    FTranslateThread: TTranslateThread;

    // Non sorted combo named languages
    FLanguages: TStringList;
    FLanguagesTarget: TStringList;

    // Settings
    FConfigFile: string;
    FConfigFiles: TStringList;
    FConfigFileTitles: TStringList;
    FConfigLangDetect: string;
    FLangSource: string;
    FLangTarget: string;
    FMaxLangPairs: integer;
    FAutoAddLangPairs: boolean;
    FRecentPairHotKeys: boolean;
    FRealTime: boolean;
    FRealTimeDelay: integer;
    FAutoSwap: boolean;
    FAutoCheckUpdates: boolean;
    FUpdatesChecked: boolean;
    FFormConfigLeft: integer;
    FFormConfigTop: integer;
    FFormConfigWidth: integer;
    FFormConfigHeight: integer;
    FHotKeyApp: THotKeyData;
    FHotKeyTransSwap: THotKeyData;
    FHotKeyTransFromClipboard: THotKeyData;
    FHotKeyTransClipboard: THotKeyData;
    FHotKeyTransFromControl: THotKeyData;
    FHotKeyTransControl: THotKeyData;

    // TrayIcon
    FAutoStart: boolean;
    FIconBackgroundColor: TColor;
    FIconFontColor: TColor;
    FIconFontName: string;
    FIconTwoLang: boolean;

    procedure ProcessMessages;
    procedure SetAutoStart(Value: boolean);
    procedure ChangeSourceLang(NewLang: string; AddPairs: boolean = True);
    procedure ChangeTargetLang(NewLang: string; AddPairs: boolean = True);
    function SwapLanguages(ASwapTranslate: boolean = False): boolean;
    procedure AddLangPair(const Pair: string);
    procedure SelectPair(const Pair: string; RunTranslate: boolean = True);
    procedure SelectPairConfig(const LangPairIndex: integer; RunTranslate: boolean = True);
    procedure GlobalCtrlC;
    procedure GlobalCtrlV;
    function TranslateThread(ATrans: TTranslate; AText: string; AMemo: TMemo = nil): string;
    procedure ThreadDone(Sender: TObject);
    procedure DetectLanguage(AText: string);
    procedure TranslateMemo(ADetectLanguage: boolean = True);
    procedure TranslateFromClipboard;
    procedure TranslateClipboard;
    procedure TranslateFromControl(Data: PtrInt);
    procedure TranslateControl(Data: PtrInt);
    procedure SetLanguage(aLanguage: string = string.Empty);
  protected
    {$IFDEF WINDOWS}
    procedure WMActivate(var Message: TLMActivate); message LM_ACTIVATE;
    procedure WndProc(var TheMessage: TLMessage); override;
    {$ENDIF}
  public
    procedure LoadConfig(SetDefault: boolean = True);
    procedure SetIcon;
    procedure SetHints;
    procedure SetAnimate(Angle: integer);
    procedure DoRealign(Data: PtrInt);
    procedure BuildConfigMenu;
    procedure UpdateCheckConfigMenu;
    procedure UpdateCheckMenuPair;
    procedure RebuildLangPairsPanel(Data: PtrInt);
    procedure DoCheckUpdates(Data: PtrInt);
    {$IFDEF WINDOWS}
    procedure RegisterHotKeys;
    procedure UnregisterHotKeys;
    {$ENDIF}

    // Base properties
    property Trans: TTranslate read FTrans write FTrans;
    property TransDetect: TTranslate read FTransDetect write FTransDetect;
    property TopMost: boolean read FTopMost write FTopMost;

    // Settings properties
    property ConfigFile: string read FConfigFile write FConfigFile;
    property ConfigFiles: TStringList read FConfigFiles write FConfigFiles;
    property ConfigFileTitles: TStringList read FConfigFileTitles write FConfigFileTitles;
    property ConfigLangDetect: string read FConfigLangDetect write FConfigLangDetect;
    property AutoStart: boolean read FAutoStart write SetAutoStart;
    property IconBackgroundColor: TColor read FIconBackgroundColor write FIconBackgroundColor;
    property IconFontColor: TColor read FIconFontColor write FIconFontColor;
    property IconFontName: string read FIconFontName write FIconFontName;
    property IconTwoLang: boolean read FIconTwoLang write FIconTwoLang;
    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property LangPairs: TStringList read FLangPairs write FLangPairs;
    property MaxLangPairs: integer read FMaxLangPairs write FMaxLangPairs;
    property AutoAddLangPairs: boolean read FAutoAddLangPairs write FAutoAddLangPairs;
    property RecentPairHotKeys: boolean read FRecentPairHotKeys write FRecentPairHotKeys;
    property RealTime: boolean read FRealTime write FRealTime;
    property RealTimeDelay: integer read FRealTimeDelay write FRealTimeDelay;
    property AutoSwap: boolean read FAutoSwap write FAutoSwap;
    property AutoCheckUpdates: boolean read FAutoCheckUpdates write FAutoCheckUpdates;
    property FormConfigLeft: integer read FFormConfigLeft write FFormConfigLeft;
    property FormConfigTop: integer read FFormConfigTop write FFormConfigTop;
    property FormConfigWidth: integer read FFormConfigWidth write FFormConfigWidth;
    property FormConfigHeight: integer read FFormConfigHeight write FFormConfigHeight;

    property HotKeyApp: THotKeyData read FHotKeyApp write FHotKeyApp;
    property HotKeyTransSwap: THotKeyData read FHotKeyTransSwap write FHotKeyTransSwap;
    property HotKeyTransFromClipboard: THotKeyData read FHotKeyTransFromClipboard write FHotKeyTransFromClipboard;
    property HotKeyTransClipboard: THotKeyData read FHotKeyTransClipboard write FHotKeyTransClipboard;
    property HotKeyTransFromControl: THotKeyData read FHotKeyTransFromControl write FHotKeyTransFromControl;
    property HotKeyTransControl: THotKeyData read FHotKeyTransControl write FHotKeyTransControl;
  end;

var
  formTrayslate: TformTrayslate;

const
  DOUBLE_ENTER_INTERVAL = 200; // ms
  MIDDLE_MOUSE = 'Middle-Click';

  DEF_LANGDETECT = 'languagedetect.ini';

resourcestring
  rtrayslate = 'Trayslate';
  rswap = 'Swap (%s) with text (%s)';
  rnoconfig = 'Configuration file not found! Create it in the configuration editor.';
  rtoremovepair = ' to remove pair';

implementation

uses formdonate, formabout, formsettings, formconfig, settings, languages, systemtool, formattool;

  {$R *.lfm}

  { TformTrayslate }

  {Form Events}

procedure TformTrayslate.FormCreate(Sender: TObject);
begin
  // Default values
  FConfigFile := string.Empty;
  FConfigLangDetect := DEF_LANGDETECT;
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
  FIconTwoLang := True;
  FMaxLangPairs := 10;
  FAutoAddLangPairs := True;
  FRecentPairHotKeys := True;
  FRealTime := False;
  FRealTimeDelay := 1000;
  FAutoSwap := False;
  FAutoCheckUpdates := True;
  FUpdatesChecked := False;
  FAutoStart := True;
  FLangTarget := Language;
  FFormConfigLeft := 0;
  FFormConfigTop := 0;
  FFormConfigWidth := 0;
  FFormConfigHeight := 0;
  FLastEnterTime := 0;
  FTranslateThread := nil;

  // HotKeys Initialize
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

  // Ctrl+Shift+Z
  FHotKeyTransFromControl.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyTransFromControl.Key := Ord('C');

  // Ctrl+Shift+X
  FHotKeyTransControl.Modifiers := MOD_CONTROL or MOD_SHIFT;
  FHotKeyTransControl.Key := Ord('V');

  // Components config
  Left := Screen.WorkAreaRect.Right - Width - 30;
  Top := Screen.WorkAreaRect.Bottom - Height - 50;

  SbSwap.ImageIndex := ThemeValue(0, 1);
  SbTranslate.ImageIndex := ThemeValue(2, 3);
  SbAddPair.ImageIndex := ThemeValue(4, 5);
  FLeftButton := True;

  FTrans := TTranslate.Create;
  FTransDetect := TTranslate.Create;
  FLanguages := TStringList.Create;
  FLanguagesTarget := TStringList.Create;
  FLangPairs := TStringList.Create;

  // Load form settings
  LoadFormSettings(Self);

  // Components config after load settings
  TimerTranslate.Interval := Max(RealTimeDelay, 1);
  aAutoCheckUpdates.Checked := FAutoCheckUpdates;

  // Load config files
  FConfigFiles := TStringList.Create;
  FConfigFileTitles := TStringList.Create;
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
  Application.OnDeactivate := @ApplicationOnDeactivate;
  Application.OnActivate := @ApplicationOnActivate;
  Application.OnException := @ApplicationOnException;
  Screen.OnActiveFormChange := @ScreenActiveFormChanged;

  {$IFDEF WINDOWS}
  RegisterHotKeys;
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

  if Assigned(FTranslateThread) then
  begin
    FTranslateThread.Cancel;

    // if thread is NOT auto-free, wait and free it
    if not FTranslateThread.FreeOnTerminate then
    begin
      FTranslateThread.WaitFor;
      FreeAndNil(FTranslateThread);
    end
    else
    begin
      // thread will free itself
      FTranslateThread := nil;
    end;
  end;

  {$IFDEF WINDOWS}
  UnregisterHotKeys;
  {$ENDIF}
  SaveFormSettings(Self);
  FreeAndNil(FLangPairs);
  FreeAndNil(FLanguages);
  FreeAndNil(FLanguagesTarget);
  FreeAndNil(FConfigFiles);
  FreeAndNil(FConfigFileTitles);
  FreeAndNil(FTrans);
  FreeAndNil(FTransDetect);
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
      end;

      HOTKEY_TRANS_FROM_CLIPBOARD:
      begin
        TranslateFromClipboard;
      end;

      HOTKEY_TRANS_CLIPBOARD:
      begin
        TranslateClipboard;
      end;

      HOTKEY_TRANS_FROM_CONTROL:
      begin
        Application.QueueAsyncCall(@TranslateFromControl, 0);
      end;

      HOTKEY_TRANS_CONTROL:
      begin
        Application.QueueAsyncCall(@TranslateControl, 0);
      end;

      else
        if (TheMessage.WParam > HOTKEY_LANG_BASE) and (TheMessage.WParam <= HOTKEY_LANG_BASE + 9) then
        begin
          LangIndex := TheMessage.WParam - 11;

          if LangIndex < MenuLangPairs.Count then
            MenuLangPairs.Items[LangIndex].Click;
        end;
    end;
  end;

  inherited WndProc(TheMessage);
end;

{$ENDIF}

{Application Events}

procedure TformTrayslate.ApplicationOnActivate(Sender: TObject);
begin
  FTopMost := True;
  if Assigned(formConfigTrayslate) and formConfigTrayslate.HandleAllocated then
    formConfigTrayslate.Invalidate;
end;

procedure TformTrayslate.ApplicationOnDeactivate(Sender: TObject);
begin
  TimerActive.Enabled := True;
end;

procedure TformTrayslate.ApplicationOnException(Sender: TObject; E: Exception);
begin
  MessageDlg(rtrayslate, E.Message, mtWarning, [mbOK], 0);
end;

procedure TformTrayslate.ScreenActiveFormChanged(Sender: TObject);
begin
  if Assigned(formConfigTrayslate) and formConfigTrayslate.HandleAllocated and (Screen.ActiveForm = formConfigTrayslate) then
    formConfigTrayslate.Invalidate;
end;

{Actions Events}

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

procedure TformTrayslate.aTranslateClipboardExecute(Sender: TObject);
begin
  TranslateFromClipboard;
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
    UnregisterHotKeys;
    formSettingsTrayslate.ShowModal;
  finally
    FreeAndNil(formSettingsTrayslate);
    RegisterHotKeys;
    SetHints;
  end;
end;

procedure TformTrayslate.aConfigEditorExecute(Sender: TObject);
begin
  if not Assigned(formConfigTrayslate) then
    formConfigTrayslate := TformConfigTrayslate.Create(Application);
  if FormConfigLeft > 0 then
    formConfigTrayslate.Left := FormConfigLeft;
  if FormConfigTop > 0 then
    formConfigTrayslate.Top := FormConfigTop;
  if FormConfigWidth > 0 then
    formConfigTrayslate.Width := FormConfigWidth;
  if FormConfigHeight > 0 then
    formConfigTrayslate.Height := FormConfigHeight;
  formConfigTrayslate.Show;
  formConfigTrayslate.BringToFront;
end;

procedure TformTrayslate.aNewTranslateExecute(Sender: TObject);
begin
  MemoSource.Clear;
  MemoTarget.Clear;
end;

procedure TformTrayslate.aTranslateExecute(Sender: TObject);
begin
  TranslateMemo;
end;

procedure TformTrayslate.aSwapExecute(Sender: TObject);
begin
  if SwapLanguages then
    TranslateMemo(False);
end;

procedure TformTrayslate.aAddPairExecute(Sender: TObject);
begin
  AddLangPair(FLangSource + ':' + FLangTarget);
  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
end;

procedure TformTrayslate.aAutoCheckUpdatesExecute(Sender: TObject);
begin
  FAutoCheckUpdates := aAutoCheckUpdates.Checked;
  FUpdatesChecked := False;
end;

procedure TformTrayslate.aCheckForUpdatesExecute(Sender: TObject);
begin
  CheckGithubLatestVersion();
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
  try
    formAboutTrayslate.ShowModal;
  finally
    formAboutTrayslate.Free;
  end;
end;

procedure TformTrayslate.aExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

{Control Events}

procedure TformTrayslate.ComboSourceCloseUp(Sender: TObject);
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
      SelectPair(FLangSource + ':' + FLangTarget, False);
  end
  else
  begin
    ChangeSourceLang(ComboSource.Text);
    TranslateMemo(False);
  end;
end;

procedure TformTrayslate.ComboTargetCloseUp(Sender: TObject);
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
      SelectPair(FLangSource + ':' + FLangTarget, False);
  end
  else
  begin
    ChangeTargetLang(ComboTarget.Text);
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

procedure TformTrayslate.MemoTargetEnter(Sender: TObject);
begin
  //MemoTarget.SelStart := 0;
  //MemoTarget.SelLength := Length(MemoTarget.Text);
  //Clipboard.AsText := MemoTarget.Text;
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

    NowTime := GetTickCount64;
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
      Key := 0;
    end
    else
      FLastEnterTime := NowTime;
  end;
end;

procedure TformTrayslate.MemoSourceKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  // Check if real-time translation is enabled
  if not FRealTime then
    Exit;

  // List of keys that do not modify text content (Navigation, System, Modifiers)
  // We include VK_RETURN here as per your requirement to ignore it for translation triggers
  if IsSystemKey(Key) then
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

procedure TformTrayslate.SbSwapMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if Button = mbMiddle then
  begin
    if SwapLanguages(True) then
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

procedure TformTrayslate.TimerTranslateTimer(Sender: TObject);
begin
  TimerTranslate.Enabled := False;
  if FRealTime then
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
  (Sender as TLabel).Font.Style := [fsUnderline];
end;

procedure TformTrayslate.LabelMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := [];
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

  TranslateMemo;
end;

procedure TformTrayslate.MenuPairClick(Sender: TObject);
begin
  SelectPairConfig((Sender as TMenuItem).Tag);
end;

{Methods}

procedure TformTrayslate.LoadConfig(SetDefault: boolean = True);
var
  List: TStringList;
  Id: integer;
begin
  UpdateCheckConfigMenu;

  // Load settings from INI
  LoadIniSettings(FTrans, FConfigFile);

  if (FConfigLangDetect <> string.Empty) then
    LoadIniSettings(FTransDetect, FConfigLangDetect);

  // Init language lists
  FLanguages.Clear;
  List := GetDisplayNamesFromCodeMap(Trans.Languages, Trans.ValueType);
  try
    FLanguages.Assign(List); // Assign available source languages
  finally
    List.Free;
  end;

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
    Id := Trans.Languages.IndexOfName(LangSource);
    if (Id >= 0) and (Id < FLanguages.Count) then
      ComboSource.Text := FLanguages.ValueFromIndex[Id];
  end;
  if ComboSource.Items.IndexOf(ComboSource.Text) < 0 then
  begin
    ComboSource.Text := string.Empty; // Clear if not in new list
    LangSource := string.Empty;
    Trans.LangSource := string.Empty;
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
    if Trans.LanguagesTarget.Count > 0 then
    begin
      Id := Trans.LanguagesTarget.IndexOfName(LangTarget);
      if (Id >= 0) and (Id < FLanguagesTarget.Count) then
        ComboTarget.Text := FLanguagesTarget.ValueFromIndex[Id];
    end
    else
    begin
      Id := Trans.Languages.IndexOfName(LangTarget);
      if (Id >= 0) and (Id < FLanguages.Count) then
        ComboTarget.Text := FLanguages.ValueFromIndex[Id];
    end;
  end;
  if ComboTarget.Items.IndexOf(ComboTarget.Text) < 0 then
  begin
    ComboTarget.Text := string.Empty; // Clear if not in new list
    LangTarget := string.Empty;
    Trans.LangTarget := string.Empty;
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
      end;
    end;
  end;

  // Set combobox selection by language code
  SetComboBoxByCode(ComboSource, Trans.LangSource);
  SetComboBoxByCode(ComboTarget, Trans.LangTarget);

  if ComboTarget.ItemIndex = -1 then
    ComboTarget.Text := string.Empty;

  SetIcon;
  SetHints;
end;

procedure TformTrayslate.SetIcon;
var
  Bitmap: TBitmap;
  hintText: string;
begin
  Bitmap := CreateTrayIconLang(Self, ifthen(FIconTwoLang, UpperCase(Trans.LangSource), UpperCase(Trans.LangTarget)),
    ifthen(FIconTwoLang, UpperCase(Trans.LangTarget), string.Empty), FIconBackgroundColor, FIconFontColor, FIconFontName);
  try
    TrayIcon.Icon.Assign(Bitmap);
    TrayIcon.Visible := True;
  finally
    Bitmap.Free;
  end;

  // Set tray icon hint
  hintText := rtrayslate;
  if ComboSource.Text <> string.Empty then
    hintText := hintText + ' - ' + ComboSource.Text;
  if ComboTarget.Text <> string.Empty then
    hintText := hintText + ' : ' + ComboTarget.Text;
  if FConfigFileTitles.Values[FConfigFile] <> string.Empty then
    hintText := hintText + sLineBreak + FConfigFileTitles.Values[FConfigFile];
  TrayIcon.Hint := hintText;
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

procedure TFormTrayslate.BuildConfigMenu;
var
  i: integer;
  Item: TMenuItem;
  FileName, ServiceName, FilePath: string;
  Ini: TIniFile;
  SL: TStringList;
  Data: PConfigData;
begin
  MenuConfig.Clear;
  MenuConfig.Visible := FConfigFiles.Count > 0;

  SL := TStringList.Create;
  try
    for i := 0 to FConfigFiles.Count - 1 do
    begin
      New(Data);

      FilePath := FConfigFiles[i];
      FileName := ExtractFileName(FilePath);
      ServiceName := '';

      if FileExists(FilePath) then
      begin
        Ini := TIniFile.Create(FilePath);
        try
          ServiceName := Trim(Ini.ReadString('Service', 'Name', string.Empty));
          Data^.Order := Ini.ReadInteger('Service', 'Order', 0);
        finally
          Ini.Free;
        end;
      end
      else
        Data^.Order := 0;

      Data^.Name := ServiceName;
      Data^.PathOnly := ExtractFilePath(FilePath); // second level of sorting
      SL.AddObject(FilePath, TObject(Data));
    end;

    SL.CustomSort(@ConfigSortByOrderPathName);

    // Update FConfigFiles in a new order
    FConfigFiles.Clear;
    for i := 0 to SL.Count - 1 do
      FConfigFiles.Add(SL[i]);

    // Build menu
    for i := 0 to SL.Count - 1 do
    begin
      Data := PConfigData(SL.Objects[i]);
      FileName := ExtractFileName(SL[i]);
      ServiceName := Data^.Name;

      FConfigFileTitles.Add(SL[i] + '=' + ServiceName);

      Item := TMenuItem.Create(MenuConfig);
      if ServiceName <> '' then
        Item.Caption := ServiceName
      else
        Item.Caption := FileName;

      Item.Hint := SL[i];
      Item.Tag := i;
      Item.OnClick := @MenuConfigItemClick;
      Item.Checked := SameText(SL[i], FConfigFile);

      MenuConfig.Add(Item);

      Dispose(Data);
      SL.Objects[i] := nil;
    end;
  finally
    SL.Free;
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
  end;
end;

procedure TformTrayslate.UpdateCheckMenuPair;
var
  i: integer;
  currentPair: string;
begin
  // Current pair in same format as Hint (e.g. "en:ru")
  currentPair := LangSource + ':' + LangTarget;

  for i := 0 to MenuLangPairs.Count - 1 do
  begin
    // Compare with Hint
    MenuLangPairs.Items[i].Checked :=
      SameText(MenuLangPairs.Items[i].Hint, FConfigFile + '=' + currentPair);
  end;
end;

procedure TformTrayslate.RebuildLangPairsPanel(Data: PtrInt);
var
  lbl: TLabel;
  mi: TMenuItem;
  totalWidth: integer;
  i: integer;
begin
  FlowPairs.DisableAlign;
  try
    // Clear FlowPairs
    for i := FlowPairs.ControlCount - 1 downto 0 do
      if FlowPairs.Controls[i] is TLabel then
        FlowPairs.Controls[i].Free;

    // Clear MenuLangPairs
    MenuLangPairs.Clear;

    // Hide panel and menu if no pairs
    if (FLangPairs.Count = 0) or (FMaxLangPairs <= 0) then
    begin
      FlowPairs.Visible := False;
      MenuLangPairs.Visible := False;
      Exit;
    end
    else
    begin
      FlowPairs.Visible := True;
      MenuLangPairs.Visible := True;
    end;

    // Calculate total width
    totalWidth := 0;
    for i := 0 to FLangPairs.Count - 1 do
      totalWidth := totalWidth + FlowPairs.Canvas.TextWidth(FLangPairs.ValueFromIndex[i]) + 10;
    FlowPairs.Width := totalWidth;

    // Create Labels and Menu Items
    for i := 0 to FLangPairs.Count - 1 do
    begin
      // FlowPairs Label
      lbl := TLabel.Create(FlowPairs);
      lbl.Parent := FlowPairs;
      lbl.Caption := FLangPairs.ValueFromIndex[i];
      lbl.Hint := FConfigFileTitles.Values[FLangPairs.Names[i]];

      lbl.ShowHint := True;
      lbl.Cursor := crHandPoint;
      lbl.Font.Color := ThemeColor(clBlue, clSkyBlue);
      lbl.Tag := i;
      lbl.AutoSize := True;
      lbl.BorderSpacing.Left := 3;
      lbl.BorderSpacing.Right := 10;
      lbl.BorderSpacing.Bottom := 5;

      lbl.OnMouseEnter := @LabelMouseEnter;
      lbl.OnMouseLeave := @LabelMouseLeave;
      lbl.OnMouseDown := @LabelLangMouseDown;

      // MenuLangPairs Item
      mi := TMenuItem.Create(MenuLangPairs);
      mi.Caption := lbl.Caption + ' - ' + lbl.Hint;
      mi.Hint := FLangPairs[i];
      if RecentPairHotKeys and (i < 9) then
        mi.ShortCut := Menus.ShortCut(Ord('1') + i, [ssCtrl, ssShift]);
      mi.Tag := i; // same index as label
      mi.OnClick := @MenuPairClick; // separate handler for menu click
      mi.Checked := SameText(mi.Hint, LangSource + ':' + LangTarget); // set checked immediately
      MenuLangPairs.Add(mi);
    end;
  finally
    FlowPairs.EnableAlign;
    UpdateCheckMenuPair;
    Repaint;
  end;
end;

procedure TformTrayslate.DoCheckUpdates(Data: PtrInt);
begin
  Screen.Cursor := crHourGlass;
  try
    CheckGithubLatestVersion(True);
  finally
    Screen.Cursor := crDefault;
  end;
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
  UnregisterHotKey(Handle, HOTKEY_TRANS_FROM_CONTROL);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CONTROL);
  for i := 1 to 9 do
    UnregisterHotKey(Handle, HOTKEY_LANG_BASE + i);
end;

procedure TformTrayslate.RegisterHotKeys;
var
  i:integer;
begin
  // Unregister first to avoid duplicate registration
  UnregisterHotKeys;

  // Register hotkeys if key is assigned
  if FHotKeyApp.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_APP, FHotKeyApp.Modifiers, FHotKeyApp.Key);

  if FHotKeyTransSwap.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_SWAP, FHotKeyTransSwap.Modifiers, FHotKeyTransSwap.Key);

  if FHotKeyTransFromClipboard.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_FROM_CLIPBOARD, FHotKeyTransFromClipboard.Modifiers, FHotKeyTransFromClipboard.Key);

  if FHotKeyTransClipboard.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_CLIPBOARD, FHotKeyTransClipboard.Modifiers, FHotKeyTransClipboard.Key);

    if FHotKeyTransFromControl.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_FROM_CONTROL, FHotKeyTransFromControl.Modifiers, FHotKeyTransFromControl.Key);

  if FHotKeyTransControl.Key <> 0 then
    RegisterHotKey(Handle, HOTKEY_TRANS_CONTROL, FHotKeyTransControl.Modifiers, FHotKeyTransControl.Key);

  if FRecentPairHotKeys then
    for i := 1 to 9 do
      RegisterHotKey(Handle, HOTKEY_LANG_BASE + i, MOD_CONTROL or MOD_SHIFT, Ord('0') + i);
end;

{$ENDIF}

procedure TformTrayslate.ProcessMessages;
begin
  Application.ProcessMessages;
  Repaint;
  Application.ProcessMessages;
end;

procedure TformTrayslate.SetAutoStart(Value: boolean);
begin
  FAutoStart := Value;
  RegAutoStart(FAutoStart, rtrayslate);
end;

procedure TformTrayslate.ChangeSourceLang(NewLang: string; AddPairs: boolean = True);
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

  // now safe to use ItemIndex
  NewLang := Trans.Languages.ValueFromIndex[idnative];
  if NewLang <> FLangSource then
  begin
    FLangSource := NewLang;

    if (FAutoAddLangPairs) and (AddPairs) and (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) and
      (FLangSource <> FLangTarget) then
    begin
      AddLangPair(FLangSource + ':' + FLangTarget);
      Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
    end;

    Trans.LangSource := FLangSource;
    UpdateCheckMenuPair;
    if FIconTwoLang then SetIcon;
  end;
end;

procedure TformTrayslate.ChangeTargetLang(NewLang: string; AddPairs: boolean = True);
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

    if (FAutoAddLangPairs) and (AddPairs) and (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) and
      (FLangSource <> FLangTarget) then
    begin
      AddLangPair(FLangSource + ':' + FLangTarget);
      Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
    end;

    Trans.LangTarget := FLangTarget;
    UpdateCheckMenuPair;
    SetIcon;
  end;
end;

function TformTrayslate.SwapLanguages(ASwapTranslate: boolean = False): boolean;
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
  ChangeTargetLang(ComboTarget.Text, True);

  if ASwapTranslate and ((MemoSource.Text <> string.Empty) or (MemoTarget.Text <> string.Empty)) then
  begin
    srcMemoText := MemoSource.Text;
    MemoSource.Text := MemoTarget.Text;
    MemoTarget.Text := srcMemoText;
  end;

  Result := True;
end;

procedure TformTrayslate.AddLangPair(const Pair: string);
var
  idx: integer;
begin
  idx := GetIndexByValue(FLangPairs, Pair);

  // Remove if already exists
  if (idx >= 0) and (FLangPairs.Names[idx] = FConfigFile) then
    FLangPairs.Delete(idx);

  // Insert as first
  FLangPairs.Insert(0, FConfigFile + '=' + Pair);

  // Limit to 10 items
  while FLangPairs.Count > FMaxLangPairs do
    FLangPairs.Delete(FLangPairs.Count - 1);
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

  if RunTranslate then
    TranslateMemo(False);
end;

procedure TformTrayslate.SelectPairConfig(const LangPairIndex: integer; RunTranslate: boolean = True);
var
  config: string;
begin
  if (LangPairIndex >= 0) and (LangPairIndex < FLangPairs.Count) then
  begin
    config := FLangPairs.Names[LangPairIndex];
    if FConfigFile <> config then
    begin
      FConfigFile := config;
      LoadConfig(False);
    end;
  end;
  SelectPair(FLangPairs.ValueFromIndex[LangPairIndex], RunTranslate);
end;

procedure TformTrayslate.GlobalCtrlC;
begin
  Sleep(250);
  KeyInput.Unapply([ssCtrl, ssShift, ssAlt]);
  Sleep(5);
  KeyInput.Apply([ssCtrl]);
  Sleep(5);
  KeyInput.Down(Ord('C'));
  Sleep(5);
  KeyInput.Up(Ord('C'));
  Sleep(5);
  KeyInput.Unapply([ssCtrl]);
end;

procedure TformTrayslate.GlobalCtrlV;
begin
  Sleep(5);
  KeyInput.Unapply([ssCtrl, ssShift, ssAlt]);
  Sleep(5);
  KeyInput.Apply([ssCtrl]);
  Sleep(5);
  KeyInput.Down(Ord('V'));
  Sleep(5);
  KeyInput.Up(Ord('V'));
  Sleep(5);
  KeyInput.Unapply([ssCtrl]);
end;

{Methods Translate}

function TformTrayslate.TranslateThread(ATrans: TTranslate; AText: string; AMemo: TMemo = nil): string;
var
  Th: TTranslateThread;
begin
  Result := string.Empty;
  try
    if (LangSource = string.Empty) or (LangTarget = string.Empty) then Exit;

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
          Application.ProcessMessages;
          Sleep(1); // reduce CPU usage
        end;

        // Set translated text to clipboard
        if Th.ResultTextSync <> string.Empty then
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
end;

procedure TformTrayslate.DetectLanguage(AText: string);
var
  langSrc, langTar, langDetect: string;
begin
  if (not FAutoSwap) or (not Trans.ServiceAutoSwap) or (not Assigned(FTransDetect)) then exit;
  if (FLanguages.IndexOf(ComboSource.Text) < 0) or (FLanguages.IndexOf(ComboTarget.Text) < 0) then exit;

  Screen.Cursor := crAppStart;
  TimerAnimate.Enabled := True;

  // Detect language in source memo
  langDetect := TranslateThread(TransDetect, ExtractTextSample(AText));

  // Check selected languages
  langSrc := Trans.Languages.ValueFromIndex[FLanguages.IndexOf(ComboSource.Text)];
  langTar := Trans.Languages.ValueFromIndex[FLanguages.IndexOf(ComboTarget.Text)];

  // Swap if needed
  if (LowerCase(langSrc) <> LowerCase(langDetect)) and (LowerCase(langTar) = LowerCase(langDetect)) then
    SwapLanguages;
end;

procedure TformTrayslate.TranslateMemo(ADetectLanguage: boolean = True);
begin
  MemoTarget.Clear;

  if (Trim(MemoSource.Text) = string.Empty) then
  begin
    Screen.Cursor := crDefault;
    TimerAnimate.Enabled := False;
    Exit;
  end;

  if (ADetectLanguage) then
    DetectLanguage(MemoSource.Text);

  // Create translation thread (it will handle exceptions itself)
  TranslateThread(Trans, MemoSource.Text, MemoTarget);
end;

procedure TformTrayslate.TranslateFromClipboard;
begin
  if not Showing then
    Show;
  BringToFront;
  FTopMost := True;
  ProcessMessages;
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
  {$IFDEF WINDOWS}
  SetSystemCursor(LoadCursor(0, IDC_APPSTARTING), OCR_IBEAM);
  Application.ProcessMessages;
  {$ELSE}
  Screen.Cursor := crAppStart;
  {$ENDIF}
  try
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

procedure TformTrayslate.TranslateFromControl(Data: PtrInt);
var
  OriginalClip, SelectedText: string;
begin
  Screen.Cursor := crAppStart;
  TimerAnimate.Enabled := True;

  // Save current clipboard to restore later
  OriginalClip := Clipboard.AsText;
  Clipboard.AsText := string.Empty;

  // Copy selection from active window (Ctrl+C)
  GlobalCtrlC;

  SelectedText := Clipboard.AsText;

  Show;
  BringToFront;
  FTopMost := True;
  ProcessMessages;
  MemoSource.Text := SelectedText;
  TranslateMemo;

  // Restore original clipboard
  Clipboard.AsText := OriginalClip;
end;

procedure TformTrayslate.TranslateControl(Data: PtrInt);
var
  OriginalClip: string;
  TranslatedText: string;
begin
  {$IFDEF WINDOWS}
  SetSystemCursor(LoadCursor(0, IDC_APPSTARTING), OCR_IBEAM);
  Application.ProcessMessages;
  {$ELSE}
  Screen.Cursor := crAppStart;
  {$ENDIF}
  try
    // Save current clipboard to restore later
    OriginalClip := Clipboard.AsText;
    Clipboard.AsText := string.Empty;

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

    // Restore original clipboard
    Clipboard.AsText := OriginalClip;
  finally
    {$IFDEF WINDOWS}
    SystemParametersInfo(SPI_SETCURSORS, 0, nil, 0);
    {$ELSE}
    Screen.Cursor := crDefault;
    {$ENDIF}
  end;
end;

{Action Languages}

procedure TformTrayslate.SetLanguage(aLanguage: string = string.Empty);
begin
  aLangArabic.Checked := False;
  aLangBelarusian.Checked := False;
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

  if (aLanguage <> string.Empty) then
  begin
    Language := aLanguage;
    if not ApplicationTranslate(Language) then
      Language := 'en';
  end;

  SetHints;

  case Language of
    'ar': aLangArabic.Checked := True;
    'be': aLangBelarusian.Checked := True;
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
end;

procedure TformTrayslate.aLangArabicExecute(Sender: TObject);
begin
  SetLanguage('ar');
end;

procedure TformTrayslate.aLangBelarusianExecute(Sender: TObject);
begin
  SetLanguage('be');
end;

procedure TformTrayslate.aLangChineseExecute(Sender: TObject);
begin
  SetLanguage('zh');
end;

procedure TformTrayslate.aLangCzechExecute(Sender: TObject);
begin
  SetLanguage('cs');
end;

procedure TformTrayslate.aLangDanishExecute(Sender: TObject);
begin
  SetLanguage('da');
end;

procedure TformTrayslate.aLangDutchExecute(Sender: TObject);
begin
  SetLanguage('nl');
end;

procedure TformTrayslate.aLangEnglishExecute(Sender: TObject);
begin
  SetLanguage('en');
end;

procedure TformTrayslate.aLangFinnishExecute(Sender: TObject);
begin
  SetLanguage('fi');
end;

procedure TformTrayslate.aLangFrenchExecute(Sender: TObject);
begin
  SetLanguage('fr');
end;

procedure TformTrayslate.aLangGermanExecute(Sender: TObject);
begin
  SetLanguage('de');
end;

procedure TformTrayslate.aLangGreekExecute(Sender: TObject);
begin
  SetLanguage('el');
end;

procedure TformTrayslate.aLangHebrewExecute(Sender: TObject);
begin
  SetLanguage('he');
end;

procedure TformTrayslate.aLangHindiExecute(Sender: TObject);
begin
  SetLanguage('hi');
end;

procedure TformTrayslate.aLangIndonesianExecute(Sender: TObject);
begin
  SetLanguage('id');
end;

procedure TformTrayslate.aLangItalianExecute(Sender: TObject);
begin
  SetLanguage('it');
end;

procedure TformTrayslate.aLangJapaneseExecute(Sender: TObject);
begin
  SetLanguage('ja');
end;

procedure TformTrayslate.aLangKoreanExecute(Sender: TObject);
begin
  SetLanguage('ko');
end;

procedure TformTrayslate.aLangPolishExecute(Sender: TObject);
begin
  SetLanguage('pl');
end;

procedure TformTrayslate.aLangPortugueseExecute(Sender: TObject);
begin
  SetLanguage('pt');
end;

procedure TformTrayslate.aLangRomanianExecute(Sender: TObject);
begin
  SetLanguage('ro');
end;

procedure TformTrayslate.aLangRussianExecute(Sender: TObject);
begin
  SetLanguage('ru');
end;

procedure TformTrayslate.aLangSpanishExecute(Sender: TObject);
begin
  SetLanguage('es');
end;

procedure TformTrayslate.aLangSwedishExecute(Sender: TObject);
begin
  SetLanguage('sv');
end;

procedure TformTrayslate.aLangTurkishExecute(Sender: TObject);
begin
  SetLanguage('tr');
end;

procedure TformTrayslate.aLangUkrainianExecute(Sender: TObject);
begin
  SetLanguage('uk');
end;

end.
