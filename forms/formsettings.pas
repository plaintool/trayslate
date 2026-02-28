//-----------------------------------------------------------------------------------
//  Trayslator © 2024 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formsettings;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  ColorBox;

type

  { TformSettingsTrayslator }

  TformSettingsTrayslator = class(TForm)
    BtnFont: TButton;
    BtnReset: TButton;
    BtnApply: TButton;
    BtnCancel: TButton;
    BtnOk: TButton;
    CheckTwoLang: TCheckBox;
    CheckAutostart: TCheckBox;
    ColorIconBackground: TColorBox;
    ColorIconFont: TColorBox;
    ColorDialog: TColorDialog;
    FontDialog: TFontDialog;
    GroupAutostart: TGroupBox;
    GroupFont: TGroupBox;
    GroupTrayIcon: TGroupBox;
    LabelIconBackground: TLabel;
    LabelIconFont: TLabel;
    PagesSettings: TPageControl;
    PanelFont: TPanel;
    TabInterface: TTabSheet;
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnFontClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure CheckAutostartChange(Sender: TObject);
    procedure CheckTwoLangChange(Sender: TObject);
    procedure ColorIconBackgroundChange(Sender: TObject);
    procedure ColorIconFontChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FOriginalFont: TFont;
    FOriginalIconBackgroundColor: TColor;
    FOriginalIconFontColor: TColor;
    FOriginalIconTwoLang: boolean;
    FOriginalAutoStart: boolean;
    procedure SetPanelFont(const AFont: TFont);
    procedure AddTrayColors(AColorBox: TColorBox);
  public
    procedure Apply;
    procedure Reset;
  end;

var
  formSettingsTrayslator: TformSettingsTrayslator;

implementation

uses mainform;

  {$R *.lfm}

  { TformSettingsTrayslator }

procedure TformSettingsTrayslator.FormCreate(Sender: TObject);
begin
  AddTrayColors(ColorIconBackground);
  AddTrayColors(ColorIconFont);
  Reset;
end;

procedure TformSettingsTrayslator.BtnFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(PanelFont.Font);
  if FontDialog.Execute then
  begin
    PanelFont.Font.Assign(FontDialog.Font);
    SetPanelFont(FontDialog.Font);

    BtnReset.Enabled := True;
    BtnApply.Enabled := True;
  end;
end;

procedure TformSettingsTrayslator.BtnResetClick(Sender: TObject);
begin
  PanelFont.Font.Assign(FOriginalFont);
  SetPanelFont(FOriginalFont);

  BtnReset.Enabled := False;
end;

procedure TformSettingsTrayslator.CheckAutostartChange(Sender: TObject);
begin
  BtnApply.Enabled := True;
end;

procedure TformSettingsTrayslator.CheckTwoLangChange(Sender: TObject);
begin
  BtnApply.Enabled := True;
end;

procedure TformSettingsTrayslator.ColorIconBackgroundChange(Sender: TObject);
begin
  BtnApply.Enabled := True;
end;

procedure TformSettingsTrayslator.ColorIconFontChange(Sender: TObject);
begin
  BtnApply.Enabled := True;
end;

procedure TformSettingsTrayslator.BtnOkClick(Sender: TObject);
begin
  Apply;
  ModalResult := mrOk;
end;

procedure TformSettingsTrayslator.BtnCancelClick(Sender: TObject);
begin
  Reset;
  ModalResult := mrCancel;
end;

procedure TformSettingsTrayslator.BtnApplyClick(Sender: TObject);
begin
  Apply;
end;

procedure TformSettingsTrayslator.Apply;
begin
  formTrayslator.Font.Assign(PanelFont.Font);
  formTrayslator.IconBackgroundColor := ColorIconBackground.Selected;
  formTrayslator.IconFontColor := ColorIconFont.Selected;
  formTrayslator.IconTwoLang := CheckTwoLang.Checked;
  formTrayslator.AutoStart := CheckAutostart.Checked;

  formTrayslator.SetIcon;
  Reset;
end;

procedure TformSettingsTrayslator.Reset;
begin
  FOriginalFont := formTrayslator.Font;
  FOriginalIconBackgroundColor := formTrayslator.IconBackgroundColor;
  FOriginalIconFontColor := formTrayslator.IconFontColor;
  FOriginalIconTwoLang := formTrayslator.IconTwoLang;
  FOriginalAutoStart := formTrayslator.AutoStart;

  PanelFont.Font.Assign(FOriginalFont);
  SetPanelFont(FOriginalFont);
  ColorIconBackground.Selected := FOriginalIconBackgroundColor;
  ColorIconFont.Selected := FOriginalIconFontColor;
  CheckTwoLang.Checked := FOriginalIconTwoLang;
  CheckAutostart.Checked := FOriginalAutoStart;

  BtnApply.Enabled := False;
  BtnReset.Enabled := False;
end;

procedure TformSettingsTrayslator.SetPanelFont(const AFont: TFont);
begin
  PanelFont.Caption := ifthen((Trim(AFont.Name) = string.Empty) or (LowerCase(AFont.Name) = 'default'), 'Default', AFont.Name) +
    ',' + IntToStr(AFont.Size);
end;

procedure TformSettingsTrayslator.AddTrayColors(AColorBox: TColorBox);
begin
  AColorBox.Style := AColorBox.Style + [cbCustomColor];

  // Basic colors
  AColorBox.Items.AddObject('Black', TObject(PtrUInt($00000000)));
  AColorBox.Items.AddObject('White', TObject(PtrUInt($00FFFFFF)));
  AColorBox.Items.AddObject('Blue', TObject(PtrUInt($00FF0000)));
  AColorBox.Items.AddObject('Red', TObject(PtrUInt($000000FF)));
  AColorBox.Items.AddObject('Green', TObject(PtrUInt($0000FF00)));
  AColorBox.Items.AddObject('Yellow', TObject(PtrUInt($0000FFFF)));
  AColorBox.Items.AddObject('Cyan', TObject(PtrUInt($00FFFF00)));
  AColorBox.Items.AddObject('Magenta', TObject(PtrUInt($00FF00FF)));
  AColorBox.Items.AddObject('Gray', TObject(PtrUInt($00808080)));
  AColorBox.Items.AddObject('Silver', TObject(PtrUInt($00C0C0C0)));

  // Dark neutrals
  AColorBox.Items.AddObject('Graphite', TObject(PtrUInt($00454545)));
  AColorBox.Items.AddObject('Charcoal', TObject(PtrUInt($00353535)));
  AColorBox.Items.AddObject('Slate', TObject(PtrUInt($00505060)));
  AColorBox.Items.AddObject('Steel Gray', TObject(PtrUInt($00606070)));

  // Reds
  AColorBox.Items.AddObject('Crimson', TObject(PtrUInt($003C3CFF)));
  AColorBox.Items.AddObject('Cherry', TObject(PtrUInt($002020D0)));
  AColorBox.Items.AddObject('Ruby', TObject(PtrUInt($004040E0)));
  AColorBox.Items.AddObject('Wine', TObject(PtrUInt($004060A0)));

  // Oranges
  AColorBox.Items.AddObject('Amber', TObject(PtrUInt($0000C8FF)));
  AColorBox.Items.AddObject('Tangerine', TObject(PtrUInt($0010A5FF)));
  AColorBox.Items.AddObject('Copper', TObject(PtrUInt($002A6BFF)));
  AColorBox.Items.AddObject('Sunset', TObject(PtrUInt($004080FF)));

  // Yellows
  AColorBox.Items.AddObject('Gold', TObject(PtrUInt($0000D7FF)));
  AColorBox.Items.AddObject('Mustard', TObject(PtrUInt($0020B5D0)));
  AColorBox.Items.AddObject('Honey', TObject(PtrUInt($0030C8E0)));
  AColorBox.Items.AddObject('Sand', TObject(PtrUInt($0050D8E8)));

  // Greens
  AColorBox.Items.AddObject('Emerald', TObject(PtrUInt($0032CD32)));
  AColorBox.Items.AddObject('Forest', TObject(PtrUInt($00228B22)));
  AColorBox.Items.AddObject('Lime', TObject(PtrUInt($0000FF80)));
  AColorBox.Items.AddObject('Mint', TObject(PtrUInt($0078D890)));
  AColorBox.Items.AddObject('Olive', TObject(PtrUInt($00308080)));
  AColorBox.Items.AddObject('Moss', TObject(PtrUInt($00408060)));

  // Cyans
  AColorBox.Items.AddObject('Turquoise', TObject(PtrUInt($00D0E040)));
  AColorBox.Items.AddObject('Aqua', TObject(PtrUInt($00FFFF00)));
  AColorBox.Items.AddObject('Teal', TObject(PtrUInt($00808000)));
  AColorBox.Items.AddObject('Sea Blue', TObject(PtrUInt($00C07000)));

  // Blues
  AColorBox.Items.AddObject('Azure', TObject(PtrUInt($00FF9E2B)));
  AColorBox.Items.AddObject('Royal Blue', TObject(PtrUInt($00E16941)));
  AColorBox.Items.AddObject('Sky', TObject(PtrUInt($00FFBF00)));
  AColorBox.Items.AddObject('Ocean', TObject(PtrUInt($00B06000)));
  AColorBox.Items.AddObject('Midnight', TObject(PtrUInt($00800000)));
  AColorBox.Items.AddObject('Indigo', TObject(PtrUInt($0082004B)));

  // Purples
  AColorBox.Items.AddObject('Violet', TObject(PtrUInt($00D670DA)));
  AColorBox.Items.AddObject('Plum', TObject(PtrUInt($00B070C0)));
  AColorBox.Items.AddObject('Orchid', TObject(PtrUInt($00CC66CC)));
  AColorBox.Items.AddObject('Lavender', TObject(PtrUInt($00E6A8D7)));

  // Pinks
  AColorBox.Items.AddObject('Rose', TObject(PtrUInt($006060FF)));
  AColorBox.Items.AddObject('Coral', TObject(PtrUInt($00507FFF)));
  AColorBox.Items.AddObject('Blush', TObject(PtrUInt($007080FF)));
  AColorBox.Items.AddObject('Magenta', TObject(PtrUInt($00FF00FF)));
end;

end.
