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
    MemoSource: TMemo;
    MemoTarget: TMemo;
    MenuExit: TMenuItem;
    MenuAbout: TMenuItem;
    MenuDonate: TMenuItem;
    MenuItem1: TMenuItem;
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
    TrayIcon: TTrayIcon;
    procedure aSettingsExecute(Sender: TObject);
    procedure aClipboardExecute(Sender: TObject);
    procedure aSwapExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure aShowExecute(Sender: TObject);
    procedure aDonateExecute(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure aTranslateExecute(Sender: TObject);
    procedure ComboSourceChange(Sender: TObject);
    procedure ComboTargetChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MemoSourceEnter(Sender: TObject);
    procedure MemoTargetEnter(Sender: TObject);
    procedure PanelLangResize(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure TimerClickTimer(Sender: TObject);
  private
    FTrans: TTranslate;
    FClicked, FDoubleClicked: boolean;

    // Settings
    FConfigFile: string;
    FConfigFiles: TStringList;
    FLangSource: string;
    FLangTarget: string;

    // TrayIcon
    FIconBackgroundColor: TColor;
    FIconFontColor: TColor;
    FIconTwoLang: boolean;

    function GetClipboartText: boolean;
    procedure Translate;
    procedure ProcessMessages;
  public
    property Trans: TTranslate read FTrans write FTrans;

    // Settings property
    property ConfigFile: string read FConfigFile write FConfigFile;
    property IconBackgroundColor: TColor read FIconBackgroundColor write FIconBackgroundColor;
    property IconFontColor: TColor read FIconFontColor write FIconFontColor;
    property IconTwoLang: boolean read FIconTwoLang write FIconTwoLang;
    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
    procedure SetIcon;
  end;

var
  formTrayslator: TformTrayslator;

resourcestring
  NoConfig = 'Configuration file not found!';

implementation

uses formdonate, formabout, formsettings, langtool, settings, languages;

  {$R *.lfm}

  { TformTrayslator }

procedure TformTrayslator.FormCreate(Sender: TObject);
begin
  // Default values
  FConfigFile := GetIniDirectory('google.ini');
  FIconBackgroundColor := $00FF9628;
  FIconFontColor := $00DCDCDC;
  FIconTwoLang := False;

  Left := Screen.WorkAreaRect.Right - Width - 30;
  Top := Screen.WorkAreaRect.Bottom - Height - 50;

  Trans := TTranslate.Create;
  LoadFormSettings(Self);

  FConfigFiles := TStringList.Create;
  GetIniFiles(FConfigFiles);

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

  LoadIniSettings(Trans, FConfigFile);

  // Init Controls
  ComboSource.Items.Assign(GetDisplayNamesFromCodeMap(Trans.Languages));
  ComboTarget.Items.Assign(ComboSource.Items);
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

  SetIcon;
end;

procedure TformTrayslator.FormDestroy(Sender: TObject);
begin
  SaveFormSettings(Self);
  Trans.Free;
end;

procedure TformTrayslator.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := False;
  Hide;
end;

procedure TformTrayslator.aShowExecute(Sender: TObject);
begin
  Show;
end;

procedure TformTrayslator.aClipboardExecute(Sender: TObject);
begin
  Show;
  ProcessMessages;
  if GetClipboartText then
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

procedure TformTrayslator.aAboutExecute(Sender: TObject);
begin
  formAboutTrayslator := TformAboutTrayslator.Create(nil);
  try
    formAboutTrayslator.ShowModal;
  finally
    formAboutTrayslator.Free;
  end;
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

procedure TformTrayslator.aExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TformTrayslator.aTranslateExecute(Sender: TObject);
begin
  Translate;
end;

procedure TformTrayslator.ComboSourceChange(Sender: TObject);
begin
  if ComboSource.ItemIndex < 0 then exit;
  FLangSource := Trans.Languages.ValueFromIndex[ComboSource.ItemIndex];
  Trans.LangSource := FLangSource;
end;

procedure TformTrayslator.ComboTargetChange(Sender: TObject);
begin
  if ComboTarget.ItemIndex < 0 then exit;
  FLangTarget := Trans.Languages.ValueFromIndex[ComboTarget.ItemIndex];
  Trans.LangTarget := FLangTarget;
  SetIcon;
end;

procedure TformTrayslator.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Hide;
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

procedure TformTrayslator.PanelLangResize(Sender: TObject);
var
  Available: integer;
begin
  // prevent recursive resize loop
  if PanelLang.Tag = 1 then Exit;
  PanelLang.Tag := 1;
  try
    Available := PanelLang.ClientWidth - sbSwap.Width - sbTranslate.Width - 15; // spacing

    ComboSource.SetBounds(
      0,
      ComboSource.Top,
      Available div 2,
      ComboSource.Height);

    sbSwap.Left := ComboSource.Width;

    ComboTarget.SetBounds(
      sbSwap.Left + sbSwap.Width,
      ComboTarget.Top,
      Available - ComboSource.Width,
      ComboTarget.Height);

    sbTranslate.Left := PanelLang.ClientWidth - sbTranslate.Width;
  finally
    PanelLang.Tag := 0;
  end;
end;

procedure TformTrayslator.TrayIconClick(Sender: TObject);
begin
  TimerClick.Enabled := False;
  FClicked := False;
  if FDoubleClicked then
  begin
    FDoubleClicked := False;
    Exit;
  end;

  if Showing then
  begin
    Hide;
    FClicked := True;
  end
  else
    TimerClick.Enabled := True; // start delay
end;

procedure TformTrayslator.TrayIconDblClick(Sender: TObject);
begin
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
    Hide
  else
    Show;
end;

procedure TformTrayslator.SetIcon;
begin
  TrayIcon.Icon := CreateTrayIconLang(ifthen(FIconTwoLang, UpperCase(Trans.LangSource), UpperCase(Trans.LangTarget)),
    ifthen(FIconTwoLang, UpperCase(Trans.LangTarget), string.Empty), FIconBackgroundColor, FIconFontColor);
end;

function TformTrayslator.GetClipboartText: boolean;
begin
  Result := False;
  if (Clipboard.AsText <> string.empty) then
  begin
    MemoSource.Text := Clipboard.AsText;
    Result := True;
  end;
end;

procedure TformTrayslator.Translate;
begin
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

end.
