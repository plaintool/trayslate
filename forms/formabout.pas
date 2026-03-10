//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formabout;

{$mode ObjFPC}{$H+}

interface

uses
  Forms,
  StdCtrls,
  ExtCtrls,
  Graphics,
  LCLIntf;

type

  { TformAboutTrayslate }

  TformAboutTrayslate = class(TForm)
    buttonOk: TButton;
    imageLogo: TImage;
    labelBy: TLabel;
    labelName: TLabel;
    labelLic: TLabel;
    LabelLicUrl: TLabel;
    Memo1: TMemo;
    labelBy1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure LabelLicUrlClick(Sender: TObject);
  private

  public

  end;

var
  formAboutTrayslate: TformAboutTrayslate;

implementation

uses systemtool;

  {$R *.lfm}

  { TformAboutTrayslate }

procedure TformAboutTrayslate.FormCreate(Sender: TObject);
begin
  labelName.Caption := 'Trayslate © ' + GetAppVersion;
  LabelLicUrl.Font.Color := ThemeColor(clBlue, clSkyBlue);
end;

procedure TformAboutTrayslate.LabelLicUrlClick(Sender: TObject);
begin
  OpenUrl(labelLicUrl.Caption);
end;

end.
