//-----------------------------------------------------------------------------------
//  Trayslator © 2024 by Alexander Tverskoy
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

  { TformTrayslator }

  TformTrayslator = class(TForm)
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
    MenuShow: TMenuItem;
    MenuShowTranslate: TMenuItem;
    PanelPairs: TPanel;
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
    procedure MemoSourceEnter(Sender: TObject);
    procedure MemoTargetEnter(Sender: TObject);
    procedure MemoSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ConfigItemClick(Sender: TObject);
    procedure PanelLangResize(Sender: TObject);
    procedure TrayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure TimerClickTimer(Sender: TObject);
    procedure TimerActiveTimer(Sender: TObject);
    procedure LabelMouseEnter(Sender: TObject);
    procedure LabelMouseLeave(Sender: TObject);
    procedure LabelLangMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
  private
    FTrans: TTranslate;
    FTopMost: boolean;
    FClicked: boolean;
    FDoubleClicked: boolean;
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
  formTrayslator: TformTrayslator;

const
  DOUBLE_ENTER_INTERVAL = 200; // ms

resourcestring
  rtrayslator = 'Trayslator';
  noconfig = 'Configuration file not found! Create it in the configuration editor.';

implementation

uses formdonate, formabout, formsettings, formconfig, settings, languages, systemtool, formattool;

  {$R *.lfm}

  { TformTrayslator }

  {Form Events}

procedure TformTrayslator.FormCreate(Sender: TObject);
begin
  // Default values
  FConfigFile := string.Empty;
  FIconBackgroundColor := $00FF9E2B;
  FIconFontColor := clWhite;
  FIconTwoLang := True;
  FMaxLangPairs := 10;
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

procedure TformTrayslator.FormDestroy(Sender: TObject);
begin
  if Assigned(formConfigTrayslator) then
    FreeAndNil(formConfigTrayslator);
  {$IFDEF WINDOWS}
  UnregisterHotKeys;
  {$ENDIF}
  SaveFormSettings(Self);
  FLanguages.Free;
  FLanguagesSorted.Free;
  FLanguagesTarget.Free;
  FLanguagesTargetSorted.Free;
  FConfigFiles.Free;
  Trans.Free;
end;

procedure TformTrayslator.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := False;
  Hide;
end;

procedure TformTrayslator.FormActivate(Sender: TObject);
begin
  FTopMost := True;
end;

{$IFDEF WINDOWS}

procedure TformTrayslator.WMActivate(var Message: TLMActivate);
begin
  inherited;
  if Message.Active <> WA_INACTIVE then
    FTopMost := True;
end;

procedure TformTrayslator.WndProc(var TheMessage: TLMessage);
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

procedure TformTrayslator.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Hide;
end;

procedure TformTrayslator.FormWindowStateChange(Sender: TObject);
begin
  if WindowState = wsMinimized then
    WindowState := wsNormal;
end;

{Application Events}

procedure TformTrayslator.ApplicationOnActivate(Sender: TObject);
begin
  FTopMost := True;
end;

procedure TformTrayslator.ApplicationOnDeactivate(Sender: TObject);
begin
  TimerActive.Enabled := True;
end;

procedure TformTrayslator.ApplicationOnException(Sender: TObject; E: Exception);
begin
  MessageDlg(rtrayslator, E.Message, mtWarning, [mbOK], 0);
end;

{Actions Events}

procedure TformTrayslator.aShowExecute(Sender: TObject);
begin
  if Showing then
  begin
    FTopMost := True;
    BringToFront;
  end
  else
    Show;
end;

procedure TformTrayslator.aTranslateClipboardExecute(Sender: TObject);
begin
  TranslateFromClipboard;
end;

procedure TformTrayslator.aTranslateExecute(Sender: TObject);
begin
  Translate;
end;

procedure TformTrayslator.aSettingsExecute(Sender: TObject);
begin
  if Assigned(formSettingsTrayslator) then
  begin
    if formSettingsTrayslator.Visible and formSettingsTrayslator.CanSetFocus then
      formSettingsTrayslator.SetFocus;
    exit;
  end;

  formSettingsTrayslator := TformSettingsTrayslator.Create(nil);
  try
    UnregisterHotKeys;
    formSettingsTrayslator.ShowModal;
  finally
    FreeAndNil(formSettingsTrayslator);
    RegisterHotKeys;
  end;
end;

procedure TformTrayslator.aConfigEditorExecute(Sender: TObject);
begin
  if not Assigned(formConfigTrayslator) then
    formConfigTrayslator := TformConfigTrayslator.Create(nil);
  if FormConfigLeft > 0 then
    formConfigTrayslator.Left := FormConfigLeft;
  if FormConfigTop > 0 then
    formConfigTrayslator.Top := FormConfigTop;
  if FormConfigWidth > 0 then
    formConfigTrayslator.Width := FormConfigWidth;
  if FormConfigHeight > 0 then
    formConfigTrayslator.Height := FormConfigHeight;
  formConfigTrayslator.Show;
  formConfigTrayslator.BringToFront;
end;

procedure TformTrayslator.aSwapExecute(Sender: TObject);
var
  srcIndex: integer;
  srcText: string;
begin
  srcIndex := ComboSource.ItemIndex;
  ComboSource.ItemIndex := ComboTarget.ItemIndex;
  ComboTarget.ItemIndex := srcIndex;
  ChangeSourceLang(ComboSource.Text);
  ChangeTargetLang(ComboTarget.Text);

  if (MemoSource.Text <> string.Empty) and (MemoTarget.Text <> string.Empty) then
  begin
    srcText := MemoSource.Text;
    MemoSource.Text := MemoTarget.Text;
    MemoTarget.Text := srcText;
    Translate;
  end;
end;

procedure TformTrayslator.aCheckForUpdatesExecute(Sender: TObject);
begin
  CheckGithubLatestVersion();
end;

procedure TformTrayslator.aDonateExecute(Sender: TObject);
begin
  formDonateTrayslator := TformDonateTrayslator.Create(nil);
  try
    formDonateTrayslator.ShowModal;
  finally
    formDonateTrayslator.Free;
  end;
end;

procedure TformTrayslator.aAboutExecute(Sender: TObject);
begin
  formAboutTrayslator := TformAboutTrayslator.Create(nil);
  try
    formAboutTrayslator.ShowModal;
  finally
    formAboutTrayslator.Free;
  end;
end;

procedure TformTrayslator.aExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

{Control Events}

procedure TformTrayslator.ComboSourceChange(Sender: TObject);
begin
  ChangeSourceLang(ComboSource.Text);
end;

procedure TformTrayslator.ComboTargetChange(Sender: TObject);
begin
  ChangeTargetLang(ComboTarget.Text);
end;

procedure TformTrayslator.ComboSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then ComboSourceChange(Self);
end;

procedure TformTrayslator.ComboTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then ComboTargetChange(Self);
end;

procedure TformTrayslator.MemoSourceEnter(Sender: TObject);
begin
  //MemoSource.SelStart := 0;
  //MemoSource.SelLength := Length(MemoSource.Text);
end;

procedure TformTrayslator.MemoTargetEnter(Sender: TObject);
begin
  MemoTarget.SelStart := 0;
  MemoTarget.SelLength := Length(MemoTarget.Text);
  Clipboard.AsText := MemoTarget.Text;
end;

procedure TformTrayslator.MemoTargetKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_V) then // Ctrl + V
  begin
    PasteWithLineEnding(Sender as TMemo);
    Key := 0;
  end;
end;

procedure TformTrayslator.MemoSourceKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
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

procedure TFormTrayslator.ConfigItemClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  if (Assigned(formConfigTrayslator)) and (formConfigTrayslator.Showing) and (not formConfigTrayslator.TestChanges) then
    Exit;

  Item := TMenuItem(Sender);

  // Update current config and load it
  FConfigFile := FConfigFiles[Item.Tag];
  LoadConfig;

  if (Assigned(formConfigTrayslator)) and (formConfigTrayslator.Showing) then
  begin
    formConfigTrayslator.UpdateConfigList;
    formConfigTrayslator.UpdateConfig;
  end;
end;

procedure TformTrayslator.PanelLangResize(Sender: TObject);
begin
  if PanelLang.Tag = 1 then Exit;
  PanelLang.Tag := 1;

  Application.QueueAsyncCall(@DoRealign, 0);
end;

procedure TformTrayslator.TrayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  FLeftButton := Button = mbLeft;

  if Button = mbMiddle then
    aSwap.Execute;
end;

procedure TformTrayslator.TrayIconClick(Sender: TObject);
begin
  if not FLeftButton then exit;

  TimerClick.Enabled := False;
  FClicked := False;
  if FDoubleClicked then
  begin
    FDoubleClicked := False;
    Exit;
  end;

  if Showing then
  begin
    if FTopMost then
      Hide
    else
    begin
      BringToFront;
      FTopMost := True;
    end;
    FClicked := True;
  end
  else
    TimerClick.Enabled := True; // start delay
end;

procedure TformTrayslator.TrayIconDblClick(Sender: TObject);
begin
  if not FLeftButton then exit;

  TimerClick.Enabled := False; // cancel single click action
  FDoubleClicked := True;
  if FClicked then
  begin
    FClicked := False;
    Exit;
  end;

  if not Visible then
  begin
    aTranslateClipboard.Execute;
  end
  else
  begin
    Hide;
    FTopMost := False;
  end;
end;

procedure TformTrayslator.TimerClickTimer(Sender: TObject);
begin
  TimerClick.Enabled := False;

  // Single click action
  if Showing then
  begin
    if not FTopMost then
    begin
      BringToFront;
      FTopMost := True;
    end
    else
    begin
      Hide;
      FTopMost := False;
    end;
  end
  else
  begin
    Show;
    FTopMost := True;
  end;
end;

procedure TformTrayslator.TimerActiveTimer(Sender: TObject);
begin
  TimerActive.Enabled := False;
  if (not FClicked) and (not FDoubleClicked) then
    FTopMost := False;
end;

procedure TformTrayslator.LabelMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := [fsUnderline];
end;

procedure TformTrayslator.LabelMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := [];
end;

procedure TformTrayslator.LabelLangMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  pair: string;
  fromLang, toLang: string;
  p, idxnative: integer;
begin
  if Button = mbMiddle then
  begin
    // Remove pair from list
    FLangPairs.Delete((Sender as TLabel).Tag);
    // Rebuild panel
    Application.QueueAsyncCall(@RebuildLangPairsPanel, 0);
    Exit;
  end;

  pair := (Sender as TLabel).Caption;

  p := Pos(':', pair);
  if p > 0 then
  begin
    fromLang := Copy(pair, 1, p - 1);
    toLang := Copy(pair, p + 1, Length(pair));
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

{Methods}

procedure TformTrayslator.SetIcon;
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

procedure TformTrayslator.LoadConfig;
var
  List: TStringList;
begin
  UpdateCheckConfigMenu;

  // Load settings from INI
  LoadIniSettings(Trans, FConfigFile);

  // Form caption with config file name
  Caption := rtrayslator + ifthen(Trans.ServiceName <> string.Empty, ' - ' + Trans.ServiceName,
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

procedure TFormTrayslator.BuildConfigMenu;
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

procedure TFormTrayslator.UpdateCheckConfigMenu;
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

procedure TformTrayslator.DoRealign(Data: PtrInt);
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

procedure TformTrayslator.RebuildLangPairsPanel(Data: PtrInt);
var
  i: integer;
  lbl: TLabel;
  rightPos: integer;
  totalWidth: integer;
  w: integer;
begin
  // Remove only labels
  for i := PanelPairs.ControlCount - 1 downto 0 do
    if PanelPairs.Controls[i] is TLabel then
      PanelPairs.Controls[i].Free;

  // Hide panel if no pairs
  if (FLangPairs.Count = 0) or (FMaxLangPairs <= 0) then
  begin
    PanelPairs.Visible := False;
    Exit;
  end;

  PanelPairs.Visible := True;
  PanelPairs.AutoSize := True;

  // Calculate total width
  totalWidth := 0;
  for i := 0 to FLangPairs.Count - 1 do
    totalWidth := totalWidth + PanelPairs.Canvas.TextWidth(FLangPairs[i]) + 10;

  PanelPairs.Width := totalWidth;
  rightPos := PanelPairs.Width;

  for i := 0 to FLangPairs.Count - 1 do
  begin
    w := PanelPairs.Canvas.TextWidth(FLangPairs[i]);

    lbl := TLabel.Create(PanelPairs);
    lbl.Parent := PanelPairs;
    lbl.Caption := FLangPairs[i];
    lbl.Cursor := crHandPoint;
    lbl.Tag := i;
    lbl.AutoSize := True;

    lbl.Left := rightPos - w;
    lbl.Top := (PanelPairs.Height - lbl.Height) div 2;

    lbl.Font.Color := ThemeColor(clBlue, clSkyBlue);

    lbl.OnMouseEnter := @LabelMouseEnter;
    lbl.OnMouseLeave := @LabelMouseLeave;
    lbl.OnMouseDown := @LabelLangMouseDown;

    rightPos := lbl.Left - 10;
  end;
end;

{$IFDEF WINDOWS}

procedure TformTrayslator.UnregisterHotKeys;
begin
  UnregisterHotKey(Handle, HOTKEY_APP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_SWAP);
  UnregisterHotKey(Handle, HOTKEY_TRANS_FROM_CLIPBOARD);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CLIPBOARD);
  UnregisterHotKey(Handle, HOTKEY_TRANS_FROM_CONTROL);
  UnregisterHotKey(Handle, HOTKEY_TRANS_CONTROL);
end;

procedure TformTrayslator.RegisterHotKeys;
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

procedure TformTrayslator.Translate;
var
  Th: TTranslateThread;
begin
  if Trim(MemoSource.Text) = string.Empty then Exit;

  Screen.Cursor := crAppStart;
  try
    // Create translation thread (it will handle exceptions itself)
    Trans.TextToTranslate := MemoSource.Text;
    Th := TTranslateThread.Create(Trans);
    try
      Th.FreeOnTerminate := False;

      // Wait for thread to finish
      while not Th.Finished do
        Application.ProcessMessages;

      // Set translated text to memo
      MemoTarget.Text := Th.ResultTextSync;
    finally
      Th.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TformTrayslator.TranslateFromClipboard;
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

procedure TformTrayslator.TranslateClipboard;
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

procedure TformTrayslator.TranslateFromControl(Data: PtrInt);
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

procedure TformTrayslator.TranslateControl(Data: PtrInt);
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

procedure TformTrayslator.ChangeSourceLang(NewLang: string);
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

procedure TformTrayslator.ChangeTargetLang(NewLang: string);
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

procedure TformTrayslator.ProcessMessages;
begin
  Application.ProcessMessages;
  Repaint;
  Application.ProcessMessages;
end;

procedure TformTrayslator.SetAutoStart(Value: boolean);
begin
  FAutoStart := Value;
  RegAutoStart(FAutoStart, rtrayslator);
end;

procedure TformTrayslator.AddLangPair(const Pair: string);
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

end.
