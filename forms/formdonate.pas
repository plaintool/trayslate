//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formdonate;

{$mode ObjFPC}{$H+}

interface

uses
  Forms,
  Classes,
  StdCtrls,
  Buttons,
  Clipbrd,
  Graphics,
  LCLIntf, ExtCtrls;

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

uses mainform, localize, colorhelper;

  {$R *.lfm}

  { TformDonateTrayslate }

procedure TformDonateTrayslate.FormCreate(Sender: TObject);
begin
  TLocalize.ApplicationTranslate(language, self, TLocalize.LoadCustomPoFile(formTrayslate.CustomPoFile));

  labelBank.Font.Color := TColor.ThemeColor(clBlue, clSkyBlue);
  labelCrypto.Font.Color := TColor.ThemeColor(clBlue, clSkyBlue);
end;

procedure TformDonateTrayslate.labelBankClick(Sender: TObject);
begin
  OpenUrl((Sender as TLabel).Hint);
end;

end.
