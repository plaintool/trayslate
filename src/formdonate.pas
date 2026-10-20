//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit FormDonate;

{$mode ObjFPC}{$H+}

interface

uses
  Forms,
  Classes,
  StdCtrls,
  Buttons,
  Clipbrd,
  Graphics,
  ExtCtrls,
  LCLIntf;

type

  { TformDonateTrayslate }

  TformDonateTrayslate = class(TForm)
    BtnOk: TButton;
    ImageBank: TImage;
    ImageCrypto: TImage;
    LabelDonate: TLabel;
    LabelSupport: TLabel;
    LabelContribution: TLabel;
    labelBank: TLabel;
    labelCrypto: TLabel;
    procedure labelBankClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  formDonateTrayslate: TformDonateTrayslate;

implementation

uses Consts, MainForm, Localize, DarkUtils;

  {$R *.lfm}

  { TformDonateTrayslate }

procedure TformDonateTrayslate.FormCreate(Sender: TObject);
begin
  TLocalize.ApplicationTranslate(APP_NAME, language, self, TLocalize.LoadCustomPoFile(formTrayslate.CustomPoFile));

  labelBank.Font.Color := TDarkUtils.ThemeColor(clBlue, clSkyBlue);
  labelCrypto.Font.Color := TDarkUtils.ThemeColor(clBlue, clSkyBlue);
end;

procedure TformDonateTrayslate.labelBankClick(Sender: TObject);
begin
  OpenUrl((Sender as TLabel).Hint);
end;

end.
