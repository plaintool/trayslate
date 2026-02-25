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
  translate;

type

  { TformTrayslator }

  TformTrayslator = class(TForm)
    aAbout: TAction;
    aShowTrayslate: TAction;
    aDonate: TAction;
    aExit: TAction;
    ActionList: TActionList;
    BtnTranslate: TButton;
    MemoSource: TMemo;
    MemoTarget: TMemo;
    MenuExit: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupTray: TPopupMenu;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    TrayIcon: TTrayIcon;
    procedure aShowTrayslateExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure aDonateExecute(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure BtnTranslateClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
  private
    FTrans: TTranslate;
    FDoubleClicked: boolean;
    FIconBackgroundColor: TColor;
    FIconFontColor: TColor;
    FIconTwoLang: boolean;
    procedure SetIcon;
    function GetClipboartText: boolean;
    procedure Translate;
  public
    property Trans: TTranslate read FTrans write FTrans;
    property IconBackgroundColor: TColor read FIconBackgroundColor write FIconBackgroundColor;
    property IconFontColor: TColor read FIconFontColor write FIconFontColor;
    property IconTwoLang: boolean read FIconTwoLang write FIconTwoLang;
  end;

var
  formTrayslator: TformTrayslator;

implementation

uses formdonate, formabout, langtool, settings;

  {$R *.lfm}

  { TformTrayslator }

procedure TformTrayslator.FormCreate(Sender: TObject);
begin
  FIconBackgroundColor := $00FF9628;
  FIconFontColor := $00DCDCDC;
  FIconTwoLang := False;

  Trans := TTranslate.Create;
  LoadFormSettings(Self);
  LoadIniSettings(Self, Trans);
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

procedure TformTrayslator.BtnTranslateClick(Sender: TObject);
begin
  Translate;
end;

procedure TformTrayslator.SetIcon;
begin
  TrayIcon.Icon := CreateTrayIconLang(UpperCase(Trans.SourceLang), ifthen(FIconTwoLang, UpperCase(Trans.TargetLang), string.Empty),
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
