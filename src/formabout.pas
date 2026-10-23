//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit FormAbout;

{$mode ObjFPC}{$H+}

interface

uses
  Forms,
  Classes,
  StdCtrls,
  ExtCtrls,
  Graphics,
  LCLIntf;

type

  { TformAboutTrayslate }

  TformAboutTrayslate = class(TForm)
    buttonOk: TButton;
    imageLogo: TImage;
    LabelUrlGithub: TLabel;
    LblAbout: TLabel;
    labelBy: TLabel;
    labelName: TLabel;
    labelLic: TLabel;
    LabelUrlEmail: TLabel;
    MemoAbout: TMemo;
    labelBy1: TLabel;
    labelVersion: TLabel;
    panelHeader: TPanel;
    panelBody: TPanel;
    panelFooter: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LabelUrlEmailClick(Sender: TObject);
  public
    procedure UpdateCaptions;
  end;

var
  formAboutTrayslate: TformAboutTrayslate;

implementation

uses Consts, MainForm, CheckUpdates, Localize, DarkUtils;

  {$R *.lfm}

  { TformAboutTrayslate }

procedure TformAboutTrayslate.FormCreate(Sender: TObject);
begin
  TLocalize.ApplicationTranslate(APP_NAME, language, self, TLocalize.LoadCustomPoFile(Localize.CustomPoFile));

  UpdateCaptions;

  // Links: color within the theme
  LabelUrlEmail.Font.Color := TDarkUtils.ThemeColor(clBlue, clSkyBlue);
  LabelUrlGithub.Font.Color := LabelUrlEmail.Font.Color;

  // Panels: Light/Dark Theme Adaptation
  panelHeader.Color := TDarkUtils.ThemeColor($00E7FDFF, $00194855);
  panelBody.Color := TDarkUtils.ThemeColor(clWhite, $001E1E1E);
  labelVersion.Font.Color := TDarkUtils.ThemeColor(clGray, clSilver);
  panelFooter.Color := panelBody.Color;
  MemoAbout.Color := panelBody.Color;
end;

procedure TformAboutTrayslate.FormResize(Sender: TObject);
begin
  formTrayslate.FormAboutWidth := Width;
  formTrayslate.FormAboutHeight := Height;
end;

procedure TformAboutTrayslate.LabelUrlEmailClick(Sender: TObject);
begin
  OpenUrl((Sender as TLabel).Hint);
end;

procedure TformAboutTrayslate.UpdateCaptions;
var
  Arch: string;
begin
  MemoAbout.Text := LblAbout.Caption;

  {$IFDEF CPU64}
    Arch := 'x64';
  {$ELSE}
  Arch := 'x86';
  {$ENDIF}
  labelName.Caption := rappname + ' © 2026';
  labelVersion.Caption := labelVersion.Caption + ' ' + GetAppVersion + ' · ' + Arch;
end;

end.
