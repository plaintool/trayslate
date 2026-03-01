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
  LCLType,
  translate;

type

  { TformTrayslator }

  TformTrayslator = class(TForm)
    aAbout: TAction;
    aConfigEditor: TAction;
    aCheckForUpdates: TAction;
    aSettings: TAction;
    aClipboard: TAction;
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
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormWindowStateChange(Sender: TObject);
    procedure aConfigEditorExecute(Sender: TObject);
    procedure aSettingsExecute(Sender: TObject);
    procedure aClipboardExecute(Sender: TObject);
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
    procedure MemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ConfigItemClick(Sender: TObject);
    procedure PanelLangResize(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure TimerClickTimer(Sender: TObject);
    procedure TimerActiveTimer(Sender: TObject);
    procedure TrayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
  private
    FTrans: TTranslate;
    FTopMost: boolean;
    FClicked: boolean;
    FDoubleClicked: boolean;
    FLeftButton: boolean;
    FLanguages: TStringList;
    FLanguagesSorted: TStringList;

    // Settings
    FConfigFile: string;
    FConfigFiles: TStringList;
    FLangSource: string;
    FLangTarget: string;
    FFormConfigLeft: integer;
    FFormConfigTop: integer;
    FFormConfigWidth: integer;
    FFormConfigHeight: integer;

    // TrayIcon
    FIconBackgroundColor: TColor;
    FIconFontColor: TColor;
    FIconTwoLang: boolean;
    FAutoStart: boolean;

    function GetClipboartText: boolean;
    procedure Translate;
    procedure ProcessMessages;
    procedure SetAutoStart(Value: boolean);
    procedure ApplicationOnActivate(Sender: TObject);
    procedure ApplicationOnDeactivate(Sender: TObject);
    procedure ApplicationOnException(Sender: TObject; E: Exception);
  public
    procedure SetIcon;
    procedure LoadConfig;
    procedure BuildConfigMenu;
    procedure UpdateCheckConfigMenu;

    // Base properties
    property Trans: TTranslate read FTrans write FTrans;

    // Settings properties
    property ConfigFile: string read FConfigFile write FConfigFile;
    property ConfigFiles: TStringList read FConfigFiles write FConfigFiles;
    property IconBackgroundColor: TColor read FIconBackgroundColor write FIconBackgroundColor;
    property IconFontColor: TColor read FIconFontColor write FIconFontColor;
    property IconTwoLang: boolean read FIconTwoLang write FIconTwoLang;
    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    property AutoStart: boolean read FAutoStart write SetAutoStart;

    property FormConfigLeft: integer read FFormConfigLeft write FFormConfigLeft;
    property FormConfigTop: integer read FFormConfigTop write FFormConfigTop;
    property FormConfigWidth: integer read FFormConfigWidth write FFormConfigWidth;
    property FormConfigHeight: integer read FFormConfigHeight write FFormConfigHeight;
  end;

var
  formTrayslator: TformTrayslator;

resourcestring
  NoConfig = 'Configuration file not found!';

implementation

uses formdonate, formabout, formsettings, formconfig, langtool, settings, languages, systemtool, formattool;

  {$R *.lfm}

  { TformTrayslator }

  {Form Events}

procedure TformTrayslator.FormCreate(Sender: TObject);
begin
  // Default values
  FConfigFile := GetIniDirectory('google.ini');
  FIconBackgroundColor := $00FF9E2B;
  FIconFontColor := clWhite;
  FIconTwoLang := False;
  FAutoStart := True;
  FLangTarget := Language;
  FFormConfigLeft := 0;
  FFormConfigTop := 0;
  FFormConfigWidth := 0;
  FFormConfigHeight := 0;

  // Components config
  Left := Screen.WorkAreaRect.Right - Width - 30;
  Top := Screen.WorkAreaRect.Bottom - Height - 50;

  SbSwap.ImageIndex := ThemeValue(0, 1);
  SbTranslate.ImageIndex := ThemeValue(2, 3);

  Trans := TTranslate.Create;
  FLanguages := TStringList.Create;
  FLanguagesSorted := TStringList.Create;

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
      ShowMessage(NoConfig);
      aExit.Execute;
    end;
  end;

  // Load current config
  LoadConfig;

  // Set tray icon
  SetIcon;

  // Events assign
  Application.OnDeactivate := @ApplicationOnDeactivate;
  Application.OnActivate := @ApplicationOnActivate;
  Application.OnException := @ApplicationOnException;
end;

procedure TformTrayslator.FormDestroy(Sender: TObject);
begin
  SaveFormSettings(Self);
  FLanguages.Free;
  FLanguagesSorted.Free;
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

procedure TformTrayslator.FormDeactivate(Sender: TObject);
begin
  FTopMost := False;
end;

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
  MessageDlg('Trayslator', E.Message, mtWarning, [mbOK], 0);
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

procedure TformTrayslator.aClipboardExecute(Sender: TObject);
begin
  Show;
  ProcessMessages;
  if GetClipboartText then
    Translate;
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
    formSettingsTrayslator.ShowModal;
  finally
    FreeAndNil(formSettingsTrayslator);
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
  ComboSourceChange(Self);
  ComboTargetChange(Self);

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
var
  idx, idnative: integer;
begin
  // try to find typed text in items
  idx := ComboSource.Items.IndexOf(ComboSource.Text);
  idnative := FLanguages.IndexOf(ComboSource.Text);
  if idx < 0 then Exit;

  // assign the found index
  ComboSource.ItemIndex := idx;

  // now safe to use ItemIndex
  FLangSource := Trans.Languages.ValueFromIndex[idnative];
  Trans.LangSource := FLangSource;

  if FIconTwoLang then  SetIcon;
end;

procedure TformTrayslator.ComboTargetChange(Sender: TObject);
var
  idx, idnative: integer;
begin
  // try to find typed text in items
  idx := ComboTarget.Items.IndexOf(ComboTarget.Text);
  idnative := FLanguages.IndexOf(ComboTarget.Text);
  if idx < 0 then Exit;

  // assign the found index
  ComboTarget.ItemIndex := idx;

  // now safe to use ItemIndex
  FLangTarget := Trans.Languages.ValueFromIndex[idnative];
  Trans.LangTarget := FLangTarget;
  SetIcon;
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
  MemoSource.SelStart := 0;
  MemoSource.SelLength := Length(MemoSource.Text);
end;

procedure TformTrayslator.MemoTargetEnter(Sender: TObject);
begin
  MemoTarget.SelStart := 0;
  MemoTarget.SelLength := Length(MemoTarget.Text);
end;

procedure TformTrayslator.MemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_V) then // Ctrl + V
  begin
    PasteWithLineEnding(Sender as TMemo);
    Key := 0;
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
var
  Available: integer;
  Border: integer = 3;
begin
  // prevent recursive resize loop
  if PanelLang.Tag = 1 then Exit;
  PanelLang.Tag := 1;
  try
    Available := PanelLang.ClientWidth - sbSwap.ClientWidth - sbTranslate.ClientWidth - 15; // spacing

    ComboSource.SetBounds(
      0,
      ComboSource.Top,
      Available div 2,
      ComboSource.Height);

    sbSwap.SetBounds(
      ComboSource.Width + Border,
      Border,
      sbSwap.Width,
      ComboSource.Height);

    ComboTarget.SetBounds(
      sbSwap.Left + sbSwap.Width + Border,
      ComboTarget.Top,
      Available - ComboSource.Width,
      ComboTarget.Height);

    sbTranslate.SetBounds(
      PanelLang.ClientWidth - sbTranslate.Width - Border * 2,
      Border,
      sbTranslate.Width,
      ComboTarget.Height);
  finally
    PanelLang.Tag := 0;
  end;
end;

procedure TformTrayslator.TrayIconMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  FLeftButton := Button = mbLeft;
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
    aClipboard.Execute;
  end
  else
    Hide;
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
      Hide;
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

{Methods}

function TformTrayslator.GetClipboartText: boolean;
begin
  Result := False;
  if (Clipboard.AsText <> string.empty) then
  begin
    MemoSource.Text := Clipboard.AsText;
    Result := True;
  end;
end;

procedure TformTrayslator.SetIcon;
var
  Ico: TIcon;
begin
  Ico := CreateTrayIconLang(ifthen(FIconTwoLang, UpperCase(Trans.LangSource), UpperCase(Trans.LangTarget)),
    ifthen(FIconTwoLang, UpperCase(Trans.LangTarget), string.Empty), FIconBackgroundColor, FIconFontColor);
  try
    TrayIcon.Icon.Assign(Ico);
  finally
    Ico.Free;
  end;
end;

procedure TformTrayslator.LoadConfig;
var
  List: TStringList;
begin
  Caption := 'Trayslator - ' + ExtractFileName(FConfigFile);
  UpdateCheckConfigMenu;

  LoadIniSettings(Trans, FConfigFile);

  // Init language lists
  List := GetDisplayNamesFromCodeMap(Trans.Languages);
  try
    FLanguages.Assign(List);
  finally
    List.Free;
  end;

  List := GetDisplayNamesFromCodeMap(Trans.Languages, True);
  try
    ComboSource.Items.Assign(List);
    ComboTarget.Items.Assign(List);
  finally
    List.Free;
  end;

  if LangSource <> string.Empty then
    Trans.LangSource := LangSource
  else
  begin
    ComboSource.ItemIndex := 0;
    ComboSourceChange(Self);
  end;
  if LangTarget <> string.Empty then Trans.LangTarget := LangTarget;
  SetComboBoxByCode(ComboSource, Trans.LangSource);
  SetComboBoxByCode(ComboTarget, Trans.LangTarget);
end;

procedure TFormTrayslator.BuildConfigMenu;
var
  i: integer;
  Item: TMenuItem;
  FileName, FullPath: string;
begin
  MenuConfig.Clear;

  for i := 0 to FConfigFiles.Count - 1 do
  begin
    FullPath := FConfigFiles[i];
    FileName := ExtractFileName(FullPath);

    Item := TMenuItem.Create(MenuConfig);
    Item.Caption := FileName;
    Item.Hint := FullPath;
    Item.Tag := i;
    Item.OnClick := @ConfigItemClick;

    // Check the current config
    if SameText(FConfigFiles[i], FConfigFile) then
      Item.Checked := True
    else
      Item.Checked := False;

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

procedure TformTrayslator.Translate;
begin
  if (Trim(MemoSource.Text) = string.Empty) then Exit;

  Trans.TextToTranslate := MemoSource.Text;
  ProcessMessages;
  Screen.Cursor := crAppStart;
  TTranslateThread.Create(Trans, MemoTarget, MemoSource.Text);
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
  RegAutoStart(FAutoStart, 'Trayslator');
end;

end.
