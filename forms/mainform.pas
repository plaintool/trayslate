//-----------------------------------------------------------------------------------
//  Trayslate © 2024 by Alexander Tverskoy
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
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuConfig: TMenuItem;
    MenuHelp: TMenuItem;
    MenuDonate: TMenuItem;
    MenuCheckForUpdates: TMenuItem;
    MenuAbout: TMenuItem;
    MenuLangPairs: TMenuItem;
    MenuShow: TMenuItem;
    MenuShowTranslate: TMenuItem;
    PanelLang: TPanel;
    PopupTray: TPopupMenu;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    SbSwap: TSpeedButton;
    SbTranslate: TSpeedButton;
    Separator3: TMenuItem;
    SplitterMemo: TSplitter;
    TimerClick: TTimer;
    TimerActive: TTimer;
    TrayIcon: TTrayIcon;
    procedure aCheckForUpdatesExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ApplicationOnActivate(Sender: TObject);
    procedure ApplicationOnDeactivate(Sender: TObject);
    procedure ApplicationOnException(Sender: TObject; E: Exception);
    procedure aConfigEditorExecute(Sender: TObject);
    procedure aSettingsExecute(Sender: TObject);
    procedure aTranslateClipboardExecute(Sender: TObject);
    procedure aSwapExecute(Sender: TObject);
    procedure aShowExecute(Sender: TObject);
    procedure aDonateExecute(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure aTranslateExecute(Sender: TObject);
    procedure ComboSourceChange(Sender: TObject);
    procedure ComboTargetChange(Sender: TObject);
    procedure ComboSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ComboTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoSourceChange(Sender: TObject);
    procedure MemoSourceEnter(Sender: TObject);
    procedure MemoTargetEnter(Sender: TObject);
    procedure MemoSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ConfigItemClick(Sender: TObject);
    procedure PanelLangResize(Sender: TObject);
    procedure TrayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure TrayIconClick(Sender: TObject);
    procedure TimerClickTimer(Sender: TObject);
    procedure TimerActiveTimer(Sender: TObject);
    procedure LabelMouseEnter(Sender: TObject);
    procedure LabelMouseLeave(Sender: TObject);
    procedure LabelLangMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure MenuPairClick(Sender: TObject);
  private
    FTrans: TTranslate;
    FTopMost: boolean;
    FLeftButton: boolean;
    FLastEnterTime: DWORD;
    FMemoSourceCaretPos: integer;
    FLangPairs: TStringList;
    FLanguages: TStringList;
    FLanguagesSorted: TStringList;
    FLanguagesTarget: TStringList;
    FLanguagesTargetSorted: TStringList;

    // Settings
    FConfigFile: string;
    FConfigFiles: TStringList;
    FLangSource: string;
    FLangTarget: string;
    FMaxLangPairs: integer;
    FSwapTranslate: boolean;
    FTranslateAsYouType: boolean;
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
    FIconTwoLang: boolean;

    procedure Translate;
    procedure TranslateFromClipboard;
    procedure TranslateClipboard;
    procedure TranslateFromControl(Data: PtrInt);
    procedure TranslateControl(Data: PtrInt);

    procedure ChangeSourceLang(NewLang: string);
    procedure ChangeTargetLang(NewLang: string);
    procedure ProcessMessages;
    procedure SetAutoStart(Value: boolean);
    procedure AddLangPair(const Pair: string);
    procedure SelectPair(const Pair: string);
  protected
    {$IFDEF WINDOWS}
    procedure WMActivate(var Message: TLMActivate); message LM_ACTIVATE;
    procedure WndProc(var TheMessage: TLMessage); override;
    {$ENDIF}
  public
    procedure SetIcon;
    procedure LoadConfig;
    procedure BuildConfigMenu;
    procedure UpdateCheckConfigMenu;
    procedure DoRealign(Data: PtrInt);
    procedure RebuildLangPairsPanel(Data: PtrInt);
    {$IFDEF WINDOWS}
    procedure RegisterHotKeys;
    procedure UnregisterHotKeys;
    {$ENDIF}

    // Base properties
    property Trans: TTranslate read FTrans write FTrans;

    // Settings properties
    property ConfigFile: string read FConfigFile write FConfigFile;
    property ConfigFiles: TStringList read FConfigFiles write FConfigFiles;
    property AutoStart: boolean read FAutoStart write SetAutoStart;
    property IconBackgroundColor: TColor read FIconBackgroundColor write FIconBackgroundColor;
    property IconFontColor: TColor read FIconFontColor write FIconFontColor;
    property IconTwoLang: boolean read FIconTwoLang write FIconTwoLang;
    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property LangPairs: TStringList read FLangPairs write FLangPairs;
    property MaxLangPairs: integer read FMaxLangPairs write FMaxLangPairs;
    property SwapTranslate: boolean read FSwapTranslate write FSwapTranslate;
    property TranslateAsYouType: boolean read FTranslateAsYouType write FTranslateAsYouType;
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

resourcestring
  rtrayslate = 'Trayslate';
  noconfig = 'Configuration file not found! Create it in the configuration editor.';

implementation

uses formdonate, formabout, formsettings, formconfig, settings, languages, systemtool, formattool;

  {$R *.lfm}

  { TformTrayslate }

  {Form Events}

procedure TformTrayslate.FormCreate(Sender: TObject);
begin
  // Default values
  FConfigFile := string.Empty;
  FIconBackgroundColor := $00C07000;
  FIconFontColor := clWhite;
  FIconTwoLang := True;
  FMaxLangPairs := 10;
  FSwapTranslate := True;
  FTranslateAsYouType := False;
  FAutoStart := True;
  FLangTarget := Language;
  FFormConfigLeft := 0;
  FFormConfigTop := 0;
  FFormConfigWidth := 0;
  FFormConfigHeight := 0;
  FLastEnterTime := 0;

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

  Trans := TTranslate.Create;
  FLanguages := TStringList.Create;
  FLanguagesSorted := TStringList.Create;
  FLanguagesTarget := TStringList.Create;
  FLanguagesTargetSorted := TStringList.Create;
  FLangPairs := TStringList.Create;

  // Load form settings
  LoadFormSettings(Self);

  // Load config files
  FConfigFiles := TStringList.Create;
  GetIniFiles(FConfigFiles);
  BuildConfigMenu;

  if (FConfigFiles.IndexOf(FConfigFile) < 0) then
  begin
    if FConfigFiles.Count > 0 then
      FConfigFile := FConfigFiles[0]
    else
    begin
      FConfigFile := string.Empty;
      ShowMessage(noconfig);
    end;
  end;

  // Load current config
  LoadConfig;

  // Build Recent Lang Pairs Panel
  Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);

  // Set tray icon
  SetIcon;

  // Events assign
  Application.OnDeactivate := @ApplicationOnDeactivate;
  Application.OnActivate := @ApplicationOnActivate;
  Application.OnException := @ApplicationOnException;

  {$IFDEF WINDOWS}
  RegisterHotKeys;
  {$ENDIF}

  FTopMost := False;
end;

procedure TformTrayslate.FormDestroy(Sender: TObject);
begin
  if Assigned(formConfigTrayslate) then
    FreeAndNil(formConfigTrayslate);
  {$IFDEF WINDOWS}
  UnregisterHotKeys;
  {$ENDIF}
  SaveFormSettings(Self);
  FLangPairs.Free;
  FLanguages.Free;
  FLanguagesSorted.Free;
  FLanguagesTarget.Free;
  FLanguagesTargetSorted.Free;
  FConfigFiles.Free;
  Trans.Free;
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
    WindowState := wsNormal;
end;

{$IFDEF WINDOWS}

procedure TformTrayslate.WMActivate(var Message: TLMActivate);
begin
  inherited;
  if Message.Active <> WA_INACTIVE then
    FTopMost := True;
end;

procedure TformTrayslate.WndProc(var TheMessage: TLMessage);
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
    end;
  end;

  inherited WndProc(TheMessage);
end;

{$ENDIF}

{Application Events}

procedure TformTrayslate.ApplicationOnActivate(Sender: TObject);
begin
  FTopMost := True;
end;

procedure TformTrayslate.ApplicationOnDeactivate(Sender: TObject);
begin
  TimerActive.Enabled := True;
end;

procedure TformTrayslate.ApplicationOnException(Sender: TObject; E: Exception);
begin
  MessageDlg(rtrayslate, E.Message, mtWarning, [mbOK], 0);
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

procedure TformTrayslate.aTranslateExecute(Sender: TObject);
begin
  Translate;
end;

procedure TformTrayslate.aSettingsExecute(Sender: TObject);
begin
  if Assigned(formSettingsTrayslate) then
  begin
    if formSettingsTrayslate.Visible and formSettingsTrayslate.CanSetFocus then
      formSettingsTrayslate.SetFocus;
    exit;
  end;

  formSettingsTrayslate := TformSettingsTrayslate.Create(nil);
  try
    UnregisterHotKeys;
    formSettingsTrayslate.ShowModal;
  finally
    FreeAndNil(formSettingsTrayslate);
    RegisterHotKeys;
  end;
end;

procedure TformTrayslate.aConfigEditorExecute(Sender: TObject);
begin
  if not Assigned(formConfigTrayslate) then
    formConfigTrayslate := TformConfigTrayslate.Create(nil);
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

procedure TformTrayslate.aSwapExecute(Sender: TObject);
var
  srcIndex: integer;
  srcText: string;
begin
  srcIndex := ComboSource.ItemIndex;
  ComboSource.ItemIndex := ComboTarget.ItemIndex;
  ComboTarget.ItemIndex := srcIndex;
  ChangeSourceLang(ComboSource.Text);
  ChangeTargetLang(ComboTarget.Text);

  if (FSwapTranslate) and ((MemoSource.Text <> string.Empty) or (MemoTarget.Text <> string.Empty)) then
  begin
    srcText := MemoSource.Text;
    MemoSource.Text := MemoTarget.Text;
    MemoTarget.Text := srcText;
    Translate;
  end;
end;

procedure TformTrayslate.aCheckForUpdatesExecute(Sender: TObject);
begin
  CheckGithubLatestVersion();
end;

procedure TformTrayslate.aDonateExecute(Sender: TObject);
begin
  formDonateTrayslate := TformDonateTrayslate.Create(nil);
  try
    formDonateTrayslate.ShowModal;
  finally
    formDonateTrayslate.Free;
  end;
end;

procedure TformTrayslate.aAboutExecute(Sender: TObject);
begin
  formAboutTrayslate := TformAboutTrayslate.Create(nil);
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

procedure TformTrayslate.ComboSourceChange(Sender: TObject);
begin
  ChangeSourceLang(ComboSource.Text);
end;

procedure TformTrayslate.ComboTargetChange(Sender: TObject);
begin
  ChangeTargetLang(ComboTarget.Text);
end;

procedure TformTrayslate.ComboSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then ComboSourceChange(Self);
end;

procedure TformTrayslate.ComboTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then ComboTargetChange(Self);
end;

procedure TformTrayslate.MemoSourceChange(Sender: TObject);
begin
  if FTranslateAsYouType then
  begin
    Translate;
    if MemoSource.Text = string.Empty then
      MemoTarget.Clear;
  end;
end;

procedure TformTrayslate.MemoSourceEnter(Sender: TObject);
begin
  //MemoSource.SelStart := 0;
  //MemoSource.SelLength := Length(MemoSource.Text);
end;

procedure TformTrayslate.MemoTargetEnter(Sender: TObject);
begin
  MemoTarget.SelStart := 0;
  MemoTarget.SelLength := Length(MemoTarget.Text);
  Clipboard.AsText := MemoTarget.Text;
end;

procedure TformTrayslate.MemoTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_V) then // Ctrl + V
  begin
    PasteWithLineEnding(Sender as TMemo);
    Key := 0;
  end;
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
      // delete the previous Enter inserted
      if FMemoSourceCaretPos >= 2 then
      begin
        MemoSource.SelStart := FMemoSourceCaretPos - 2;
        MemoSource.SelLength := 2;
        if MemoSource.SelText = sLineBreak then
          MemoSource.SelText := ''; // remove the line break
      end;

      // restore caret to original position
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

procedure TFormTrayslate.ConfigItemClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  if (Assigned(formConfigTrayslate)) and (formConfigTrayslate.Showing) and (not formConfigTrayslate.TestChanges) then
    Exit;

  Item := TMenuItem(Sender);

  // Update current config and load it
  FConfigFile := FConfigFiles[Item.Tag];
  LoadConfig;

  if (Assigned(formConfigTrayslate)) and (formConfigTrayslate.Showing) then
  begin
    formConfigTrayslate.UpdateConfigList;
    formConfigTrayslate.UpdateConfig;
  end;
end;

procedure TformTrayslate.PanelLangResize(Sender: TObject);
begin
  if PanelLang.Tag = 1 then Exit;
  PanelLang.Tag := 1;

  Application.QueueAsyncCall(@DoRealign, 0);
end;

procedure TformTrayslate.TrayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  FLeftButton := Button = mbLeft;

  if Button = mbMiddle then
    aSwap.Execute;
end;

procedure TformTrayslate.TrayIconClick(Sender: TObject);
begin
  if not FLeftButton then exit;

  // DblClick
  if TimerClick.Enabled or (TimerClick.Tag = 1) then
  begin
    TimerClick.Enabled := False; // cancel single click action
    TimerClick.Tag := 0;
    FTopMost := True;

    MemoSource.OnChange := nil;
    try
      aTranslateClipboard.Execute;
    finally
      MemoSource.OnChange := @MemoSourceChange;
    end;
    Exit;
  end;

  TimerClick.Enabled := False;
  if Visible and Showing then
  begin
    if FTopMost then
    begin
      TimerClick.Enabled := True;
      TimerClick.Tag := 0;
    end
    else
    begin
      BringToFront;
      FTopMost := True;
      TimerClick.Tag := 1;
      TimerClick.Enabled := True;
    end;
  end
  else
  begin
    Show;
    FTopMost := True;
    TimerClick.Enabled := True;
    TimerClick.Tag := 1;
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
  if Visible and Showing then
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

procedure TformTrayslate.TimerActiveTimer(Sender: TObject);
begin
  TimerActive.Enabled := False;

  if (not TimerClick.Enabled) and (not TimerClick.Tag = 1) then
    FTopMost := False;
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

  SelectPair((Sender as TLabel).Caption);
end;

procedure TformTrayslate.MenuPairClick(Sender: TObject);
begin
  SelectPair((Sender as TMenuItem).Caption);
end;

{Methods}

procedure TformTrayslate.SetIcon;
var
  Ico: TIcon;
begin
  Ico := CreateTrayIconLang(Self, ifthen(FIconTwoLang, UpperCase(Trans.LangSource), UpperCase(Trans.LangTarget)),
    ifthen(FIconTwoLang, UpperCase(Trans.LangTarget), string.Empty), FIconBackgroundColor, FIconFontColor);
  try
    TrayIcon.Icon.Assign(Ico);
    TrayIcon.Visible := True;
  finally
    Ico.Free;
  end;
end;

procedure TformTrayslate.LoadConfig;
var
  List: TStringList;
begin
  UpdateCheckConfigMenu;

  // Load settings from INI
  LoadIniSettings(Trans, FConfigFile);

  // Form caption with config file name
  Caption := rtrayslate + ifthen(Trans.ServiceName <> string.Empty, ' - ' + Trans.ServiceName,
    ifthen(FConfigFile <> string.Empty, ' - ' + ExtractFileName(FConfigFile), string.Empty));

  // Init language lists
  FLanguages.Clear;
  List := GetDisplayNamesFromCodeMap(Trans.Languages);
  try
    FLanguages.Assign(List); // Assign available source languages
  finally
    List.Free;
  end;

  FLanguagesTarget.Clear;
  if (Assigned(Trans.LanguagesTarget)) and (Trans.LanguagesTarget.Count > 0) then
  begin
    List := GetDisplayNamesFromCodeMap(Trans.LanguagesTarget);
    try
      FLanguagesTarget.Assign(List); // Assign available target languages
    finally
      List.Free;
    end;
  end;

  // Fill ComboSource with display names
  List := GetDisplayNamesFromCodeMap(Trans.Languages, True);
  try
    ComboSource.Items.Assign(List); // Text with large letter
  finally
    List.Free;
  end;

  // Check if current ComboSource text is still valid
  if ComboSource.Items.IndexOf(ComboSource.Text) = -1 then
    ComboSource.Text := string.Empty; // Clear if not in new list

  // Fill ComboTarget with display names
  if (Assigned(Trans.LanguagesTarget)) and (Trans.LanguagesTarget.Count > 0) then
  begin
    List := GetDisplayNamesFromCodeMap(Trans.LanguagesTarget, True);
    try
      ComboTarget.Items.Assign(List); // Text with large letter
    finally
      List.Free;
    end;
  end
  else
    ComboTarget.Items.Assign(ComboSource.Items); // Use source if target list empty

  // Set default or saved languages
  if LangSource <> string.Empty then
    Trans.LangSource := LangSource
  else
  begin
    ComboSource.ItemIndex := 0; // First item as default
    ComboSourceChange(Self);
  end;

  if LangTarget <> string.Empty then
    Trans.LangTarget := LangTarget
  else
    Trans.LangTarget := Language; // Default system language

  // Set combobox selection by language code
  SetComboBoxByCode(ComboSource, Trans.LangSource);
  SetComboBoxByCode(ComboTarget, Trans.LangTarget);

  if ComboTarget.ItemIndex = -1 then
    ComboTarget.Text := string.Empty;
end;

procedure TFormTrayslate.BuildConfigMenu;
var
  i: integer;
  Item: TMenuItem;
  FileName, FullPath, ServiceName: string;
  Ini: TIniFile;
begin
  MenuConfig.Clear;
  MenuConfig.Visible := FConfigFiles.Count > 0;

  for i := 0 to FConfigFiles.Count - 1 do
  begin
    FullPath := FConfigFiles[i];
    FileName := ExtractFileName(FullPath);
    ServiceName := '';

    // Try read [Service] Name from ini
    if FileExists(FullPath) then
    begin
      Ini := TIniFile.Create(FullPath);
      try
        ServiceName := Trim(Ini.ReadString('Service', 'Name', ''));
      finally
        Ini.Free;
      end;
    end;

    Item := TMenuItem.Create(MenuConfig);

    // Use Service Name if exists, otherwise file name
    if ServiceName <> '' then
      Item.Caption := ServiceName
    else
      Item.Caption := FileName;

    Item.Hint := FullPath;
    Item.Tag := i;
    Item.OnClick := @ConfigItemClick;

    // Check the current config
    Item.Checked := SameText(FConfigFiles[i], FConfigFile);

    MenuConfig.Add(Item);
  end;
end;

procedure TFormTrayslate.UpdateCheckConfigMenu;
var
  i: integer;
begin
  for i := 0 to MenuConfig.Count - 1 do
  begin
    if SameText(FConfigFiles[i], FConfigFile) then
      MenuConfig.Items[i].Checked := True
    else
      MenuConfig.Items[i].Checked := False;
  end;
end;

procedure TformTrayslate.DoRealign(Data: PtrInt);
var
  Available, Border: integer;
begin
  Border := 3;

  PanelLang.DisableAlign;
  try
    Available := PanelLang.ClientWidth - sbSwap.Width - sbTranslate.Width - 15;

    // Fix Top to Border, not ComboSource.Top
    ComboSource.SetBounds(
      0,
      Border,
      Available div 2,
      ComboSource.Height);

    sbSwap.SetBounds(
      ComboSource.Width + Border,
      Border,
      sbSwap.Width,
      ComboSource.Height);

    ComboTarget.SetBounds(
      sbSwap.Left + sbSwap.Width + Border,
      Border,
      Available - ComboSource.Width,
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
      totalWidth := totalWidth + FlowPairs.Canvas.TextWidth(FLangPairs[i]) + 10;
    FlowPairs.Width := totalWidth;

    // Create Labels and Menu Items
    for i := 0 to FLangPairs.Count - 1 do
    begin
      // FlowPairs Label
      lbl := TLabel.Create(FlowPairs);
      lbl.Parent := FlowPairs;
      lbl.Caption := FLangPairs[i];
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
      mi.Caption := FLangPairs[i];
      mi.Tag := i; // same index as label
      mi.OnClick := @MenuPairClick; // separate handler for menu click
      MenuLangPairs.Add(mi);
    end;
  finally
    FlowPairs.EnableAlign;
    Repaint;
  end;
end;

{$IFDEF WINDOWS}

procedure TformTrayslate.UnregisterHotKeys;
begin
  UnregisterHotKey(Handle, HOTKEY_APP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_SWAP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_FROM_CLIPBOARD);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CLIPBOARD);
  UnregisterHotKey(Handle, HOTKEY_TRANS_FROM_CONTROL);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CONTROL);
end;

procedure TformTrayslate.RegisterHotKeys;
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
end;

{$ENDIF}

procedure TformTrayslate.Translate;
begin
  if Trim(MemoSource.Text) = string.Empty then Exit;

  Screen.Cursor := crAppStart;
  try
    // Create translation thread (it will handle exceptions itself)
    Trans.TextToTranslate := MemoSource.Text;
    TTranslateThread.Create(Trans, MemoTarget);
  finally
    Screen.Cursor := crDefault;
  end;
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
    Translate;
  end;
end;

procedure TformTrayslate.TranslateClipboard;
var
  Th: TTranslateThread;
begin
  Screen.Cursor := crAppStart;
  try
    if Clipboard.AsText = string.Empty then Exit;

    // Create translation thread (it will handle exceptions itself)
    Trans.TextToTranslate := Clipboard.AsText;
    Th := TTranslateThread.Create(Trans);
    try
      Th.FreeOnTerminate := False;

      // Wait for thread to finish
      while not Th.Finished do
        Application.ProcessMessages;

      // Set translated text to clipboard
      if Th.ResultTextSync <> string.Empty then
        Clipboard.AsText := Th.ResultTextSync;
    finally
      Th.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TformTrayslate.TranslateFromControl(Data: PtrInt);
var
  OriginalClip, SelectedText: string;
begin
  Screen.Cursor := crAppStart;
  try
    // Save current clipboard to restore later
    OriginalClip := Clipboard.AsText;

    // Copy selection from active window (Ctrl+C)
    Sleep(250);
    KeyInput.Apply([ssCtrl]);
    Sleep(10);
    KeyInput.Down(Ord('C'));
    Sleep(10);
    KeyInput.Up(Ord('C'));
    Sleep(10);
    KeyInput.Unapply([ssCtrl]);

    SelectedText := Clipboard.AsText;

    Show;
    BringToFront;
    FTopMost := True;
    ProcessMessages;
    MemoSource.Text := SelectedText;
    Translate;

    // Restore original clipboard
    Clipboard.AsText := OriginalClip;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TformTrayslate.TranslateControl(Data: PtrInt);
var
  OriginalClip: string;
  Th: TTranslateThread;
begin
  Screen.Cursor := crAppStart;
  try
    // Save current clipboard to restore later
    OriginalClip := Clipboard.AsText;

    // Copy selection from active window (Ctrl+C)
    Sleep(250);
    KeyInput.Apply([ssCtrl]);
    Sleep(10);
    KeyInput.Down(Ord('C'));
    Sleep(10);
    KeyInput.Up(Ord('C'));
    Sleep(10);
    KeyInput.Unapply([ssCtrl]);

    // Create translation thread (it will handle exceptions itself)
    Trans.TextToTranslate := Clipboard.AsText;

    if Trans.TextToTranslate <> string.Empty then
    begin
      Th := TTranslateThread.Create(Trans);
      try
        Th.FreeOnTerminate := False;

        // Wait for thread to finish
        while not Th.Finished do
          Application.ProcessMessages;

        // Set translated text to clipboard
        if Th.ResultTextSync <> string.Empty then
          Clipboard.AsText := Th.ResultTextSync;
      finally
        Th.Free;
      end;

      // Paste clipboard to active window (Ctrl+V)
      Sleep(10);
      KeyInput.Apply([ssCtrl]);
      Sleep(10);
      KeyInput.Down(Ord('V'));
      Sleep(10);
      KeyInput.Up(Ord('V'));
      Sleep(10);
      KeyInput.Unapply([ssCtrl]);
    end;

    // Restore original clipboard
    Clipboard.AsText := OriginalClip;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TformTrayslate.ChangeSourceLang(NewLang: string);
var
  idx, idnative: integer;
begin
  // try to find typed text in items
  idx := ComboSource.Items.IndexOf(NewLang);
  idnative := FLanguages.IndexOf(NewLang);
  if idx < 0 then Exit;

  // assign the found index
  ComboSource.ItemIndex := idx;

  // now safe to use ItemIndex
  NewLang := Trans.Languages.ValueFromIndex[idnative];
  if NewLang <> FLangSource then
  begin
    FLangSource := NewLang;

    if (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) and (FLangSource <> FLangTarget) then
    begin
      AddLangPair(FLangSource + ':' + FLangTarget);
      Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
    end;

    Trans.LangSource := FLangSource;
    if FIconTwoLang then SetIcon;
  end;
end;

procedure TformTrayslate.ChangeTargetLang(NewLang: string);
var
  idx, idnative: integer;
begin
  // try to find typed text in items
  idx := ComboTarget.Items.IndexOf(NewLang);
  if FLanguagesTarget.Count > 0 then
    idnative := FLanguagesTarget.IndexOf(NewLang)
  else
    idnative := FLanguages.IndexOf(NewLang);
  if idx < 0 then Exit;

  // assign the found index
  ComboTarget.ItemIndex := idx;

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

    if (FLangSource <> string.Empty) and (FLangTarget <> string.Empty) and (FLangSource <> FLangTarget) then
    begin
      AddLangPair(FLangSource + ':' + FLangTarget);
      Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
    end;

    Trans.LangTarget := FLangTarget;
    SetIcon;
  end;
end;

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

procedure TformTrayslate.AddLangPair(const Pair: string);
var
  idx: integer;
begin
  idx := FLangPairs.IndexOf(Pair);

  // Remove if already exists
  if idx >= 0 then
    FLangPairs.Delete(idx);

  // Insert as first
  FLangPairs.Insert(0, Pair);

  // Limit to 10 items
  while FLangPairs.Count > FMaxLangPairs do
    FLangPairs.Delete(FLangPairs.Count - 1);
end;

procedure TformTrayslate.SelectPair(const Pair: string);
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
  if idxnative >= 0 then
    ChangeSourceLang(FLanguages[idxnative]);

  if FLanguagesTarget.Count > 0 then
  begin
    idxnative := FindInStringList(FLanguagesTarget, '(' + toLang + ')');
    if idxnative >= 0 then
      ChangeTargetLang(FLanguagesTarget[idxnative]);
  end
  else
  begin
    idxnative := FindInStringList(FLanguages, '(' + toLang + ')');
    if idxnative >= 0 then
      ChangeTargetLang(FLanguages[idxnative]);
  end;
end;

end.
