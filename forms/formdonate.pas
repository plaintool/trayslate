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
  LCLIntf;

type

  { TformDonateTrayslate }

  TformDonateTrayslate = class(TForm)
    buttonOk: TButton;
    editWallet1: TEdit;
    buttonCopy1: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    editWallet2: TEdit;
    buttonCopy2: TSpeedButton;
    Label4: TLabel;
    Label5: TLabel;
    editWallet3: TEdit;
    buttonCopy3: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    editWallet4: TEdit;
    buttonCopy4: TSpeedButton;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    labelUrl: TLabel;
    labelUrl1: TLabel;
    procedure buttonCopy1Click(Sender: TObject);
    procedure buttonCopy2Click(Sender: TObject);
    procedure buttonCopy3Click(Sender: TObject);
    procedure buttonCopy4Click(Sender: TObject);
    procedure labelUrlClick(Sender: TObject);
    procedure editWallet4Click(Sender: TObject);
    procedure editWallet3Click(Sender: TObject);
    procedure editWallet1Click(Sender: TObject);
    procedure editWallet2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  formDonateTrayslate: TformDonateTrayslate;

implementation

uses systemtool;

  {$R *.lfm}

  { TformDonateTrayslate }

procedure TformDonateTrayslate.FormCreate(Sender: TObject);
begin
  ApplicationTranslate(language, self);

  LabelUrl.Font.Color := ThemeColor(clBlue, clSkyBlue);
  LabelUrl1.Font.Color := ThemeColor(clBlue, clSkyBlue);
end;

procedure TformDonateTrayslate.buttonCopy1Click(Sender: TObject);
begin
  if editWallet1.CanFocus then  editWallet1.SetFocus;
  editWallet1.SelectAll;
  Clipboard.AsText := editWallet1.Text;
end;

procedure TformDonateTrayslate.buttonCopy2Click(Sender: TObject);
begin
  if editWallet2.CanFocus then  editWallet2.SetFocus;
  editWallet2.SelectAll;
  Clipboard.AsText := editWallet2.Text;
end;

procedure TformDonateTrayslate.buttonCopy3Click(Sender: TObject);
begin
  if editWallet3.CanFocus then  editWallet3.SetFocus;
  editWallet3.SelectAll;
  Clipboard.AsText := editWallet3.Text;
end;

procedure TformDonateTrayslate.buttonCopy4Click(Sender: TObject);
begin
  if editWallet4.CanFocus then  editWallet4.SetFocus;
  editWallet4.SelectAll;
  Clipboard.AsText := editWallet4.Text;
end;

procedure TformDonateTrayslate.labelUrlClick(Sender: TObject);
begin
  OpenUrl((Sender as TLabel).Hint);
end;

procedure TformDonateTrayslate.editWallet4Click(Sender: TObject);
begin
  editWallet4.SelectAll;
end;

procedure TformDonateTrayslate.editWallet3Click(Sender: TObject);
begin
  editWallet3.SelectAll;
end;

procedure TformDonateTrayslate.editWallet1Click(Sender: TObject);
begin
  editWallet1.SelectAll;
end;

procedure TformDonateTrayslate.editWallet2Click(Sender: TObject);
begin
  editWallet2.SelectAll;
end;

end.
