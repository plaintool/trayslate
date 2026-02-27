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
  Clipbrd, Buttons,
  translate;

type

  { TformTrayslator }

  TformTrayslator = class(TForm)
    aAbout: TAction;
    aSwap: TAction;
    aTranslate: TAction;
    aShowTrayslate: TAction;
    aDonate: TAction;
    aExit: TAction;
    ActionList: TActionList;
    ComboSource: TComboBox;
    ComboTarget: TComboBox;
    MemoSource: TMemo;
    MemoTarget: TMemo;
    MenuExit: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PanelLang: TPanel;
    PopupTray: TPopupMenu;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    SbSwap: TSpeedButton;
    SbTranslate: TSpeedButton;
    SplitterMemo: TSplitter;
    TrayIcon: TTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure aShowTrayslateExecute(Sender: TObject);
    procedure aDonateExecute(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure aTranslateExecute(Sender: TObject);
    procedure ComboSourceChange(Sender: TObject);
    procedure ComboTargetChange(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
  private
    FTrans: TTranslate;
    FDoubleClicked: boolean;

    // Settings
    FConfigFile: string;
    FConfigFiles: TStringList;
    FIconBackgroundColor: TColor;
    FIconFontColor: TColor;
    FIconTwoLang: boolean;
    FLangSource: string;
    FLangTarget: string;
    procedure SetIcon;
    function GetClipboartText: boolean;
    procedure Translate;
  public
    property Trans: TTranslate read FTrans write FTrans;

    // Settings property
    property ConfigFile: string read FConfigFile write FConfigFile;
    property IconBackgroundColor: TColor read FIconBackgroundColor write FIconBackgroundColor;
    property IconFontColor: TColor read FIconFontColor write FIconFontColor;
    property IconTwoLang: boolean read FIconTwoLang write FIconTwoLang;
    property LangSource: string read FLangSource write FLangSource;
    property LangTarget: string read FLangTarget write FLangTarget;
  end;

var
  formTrayslator: TformTrayslator;

resourcestring
  NoConfig = 'Configuration file not found!';

implementation

uses formdonate, formabout, langtool, settings, languages;

  {$R *.lfm}

  { TformTrayslator }

procedure TformTrayslator.FormCreate(Sender: TObject);
begin
  // Default values
  FConfigFile := GetIniDirectory('google.ini');
  FIconBackgroundColor := $00FF9628;
  FIconFontColor := $00DCDCDC;
  FIconTwoLang := False;

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

procedure TformTrayslator.aShowTrayslateExecute(Sender: TObject);
begin
  Show;
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

procedure TformTrayslator.TrayIconClick(Sender: TObject);
begin
  if FDoubleClicked then
  begin
    FDoubleClicked := False;
    exit;
  end;

  if Visible then
    Hide;
end;

procedure TformTrayslator.TrayIconDblClick(Sender: TObject);
begin
  FDoubleClicked := True;
  if not Visible then
  begin
    if GetClipboartText then Translate;
    Show;
  end
  else
    Hide;
end;

procedure TformTrayslator.SetIcon;
begin
  TrayIcon.Icon := CreateTrayIconLang(UpperCase(Trans.LangTarget), ifthen(FIconTwoLang, UpperCase(Trans.LangTarget), string.Empty),
    FIconBackgroundColor, FIconFontColor);
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
  MemoTarget.Text := Trans.Translate;
end;

end.
