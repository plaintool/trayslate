//-----------------------------------------------------------------------------------
//  Trayslate © 2024 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formsettings;

{$mode ObjFPC}{$H+}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Forms,
  Classes,
  SysUtils,
  StrUtils,
  Controls,
  Graphics,
  Dialogs,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  ColorBox,
  Spin,
  langtool;

type

  { TformSettingsTrayslate }

  TformSettingsTrayslate = class(TForm)
    BtnFont: TButton;
    BtnReset: TButton;
    BtnApply: TButton;
    BtnCancel: TButton;
    BtnOk: TButton;
    CheckTranslateAsYouType: TCheckBox;
    CheckAutoSwap: TCheckBox;
    CheckTwoLang: TCheckBox;
    CheckAutostart: TCheckBox;
    CheckSwapTranslate: TCheckBox;
    ColorIconBackground: TColorBox;
    ColorIconFont: TColorBox;
    ColorDialog: TColorDialog;
    ComboLangDetect: TComboBox;
    EditApp: TEdit;
    EditTransClipboard: TEdit;
    EditTransFromControl: TEdit;
    EditTransControl: TEdit;
    EditTransSwap: TEdit;
    EditTransFromClipboard: TEdit;
    FontDialog: TFontDialog;
    GroupAutoSwap: TGroupBox;
    GroupAutostart: TGroupBox;
    GroupLangPairs: TGroupBox;
    GroupTransSwap: TGroupBox;
    GroupTransFromControl: TGroupBox;
    GroupTransFromClipboard: TGroupBox;
    GroupSettings: TGroupBox;
    GroupApp: TGroupBox;
    GroupFont: TGroupBox;
    GroupTransClipboard: TGroupBox;
    GroupTransControl: TGroupBox;
    GroupTrayIcon: TGroupBox;
    LabelIconBackground1: TLabel;
    LabelMaxLangPairs: TLabel;
    LabelTransClipboard: TLabel;
    LabelTransFromControl: TLabel;
    LabelTransControl: TLabel;
    LabelTransSwap: TLabel;
    LabelIconBackground: TLabel;
    LabelIconFont: TLabel;
    LabelApp: TLabel;
    LabelTransFromClipboard: TLabel;
    PagesSettings: TPageControl;
    PanelFont: TPanel;
    PageInterface: TTabSheet;
    PageHotkeys: TTabSheet;
    SpinMaxLangPairs: TSpinEdit;
    PageGeneral: TTabSheet;
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnFontClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure EditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormShow(Sender: TObject);
    procedure SettingChange(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    FOriginalAutoStart: boolean;
    FOriginalFont: TFont;
    FOriginalIconBackgroundColor: TColor;
    FOriginalIconFontColor: TColor;
    FOriginalIconTwoLang: boolean;
    FOriginalMaxLangPairs: integer;
    FOriginalSwapTranslate: boolean;
    FOriginalTranslateAsYouType: boolean;
    FOriginalAutoSwap: boolean;
    FOriginalConfigLangDetect: string;
    FOriginalHotKeyApp: THotKeyData;
    FOriginalHotKeyTransSwap: THotKeyData;
    FOriginalHotKeyTransFromClipboard: THotKeyData;
    FOriginalHotKeyTransClipboard: THotKeyData;
    FOriginalHotKeyTransFromControl: THotKeyData;
    FOriginalHotKeyTransControl: THotKeyData;

    FHotKeyApp: THotKeyData;
    FHotKeyTransSwap: THotKeyData;
    FHotKeyTransFromClipboard: THotKeyData;
    FHotKeyTransClipboard: THotKeyData;
    FHotKeyTransFromControl: THotKeyData;
    FHotKeyTransControl: THotKeyData;

    procedure SetPanelFont(const AFont: TFont);
    procedure AddTrayColors(AColorBox: TColorBox);
  public
    procedure Apply;
    procedure Reset;
  end;

var
  formSettingsTrayslate: TformSettingsTrayslate;

implementation

uses mainform;

  {$R *.lfm}

  { TformSettingsTrayslate }

procedure TformSettingsTrayslate.FormCreate(Sender: TObject);
begin
  PagesSettings.PageIndex := 0;
  BtnCancel.Cancel := True;
  BtnOk.Default := True;
  BtnReset.Enabled := True;

  ComboLangDetect.Items.Assign(formTrayslate.ConfigFileTitles);
  ComboLangDetect.ItemIndex := formTrayslate.ConfigFiles.IndexOf(formTrayslate.ConfigLangDetect);

  AddTrayColors(ColorIconBackground);
  AddTrayColors(ColorIconFont);
  Reset;
end;

procedure TformSettingsTrayslate.FormShow(Sender: TObject);
begin
  formTrayslate.TopMost := False;
end;

procedure TformSettingsTrayslate.BtnFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(PanelFont.Font);
  if FontDialog.Execute then
  begin
    PanelFont.Font.Assign(FontDialog.Font);
    SetPanelFont(FontDialog.Font);

    BtnApply.Enabled := True;
  end;
end;

procedure TformSettingsTrayslate.BtnResetClick(Sender: TObject);
begin
  PanelFont.Font.SetDefault;
  SetPanelFont(PanelFont.Font);
  SettingChange(Self);
end;

procedure TformSettingsTrayslate.EditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  if (Sender as TEdit).Visible and (Sender as TEdit).CanFocus and not (Sender as TEdit).Focused then
    (Sender as TEdit).SetFocus;
end;

procedure TformSettingsTrayslate.SettingChange(Sender: TObject);
begin
  BtnApply.Enabled := True;
end;

procedure TformSettingsTrayslate.EditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  HK: THotKeyData;
  Edit: TEdit;
begin
  Edit := TEdit(Sender);
  HK := Default(THotKeyData);

  // If only DEL pressed → clear hotkey
  if (Key = VK_DELETE) and (Shift = []) then
  begin
    HK.Modifiers := 0;
    HK.Key := 0;

    case Edit.Tag of
      HOTKEY_APP: FHotKeyApp := HK;
      HOTKEY_TRANS_SWAP: FHotKeyTransSwap := HK;
      HOTKEY_TRANS_FROM_CLIPBOARD: FHotKeyTransFromClipboard := HK;
      HOTKEY_TRANS_CLIPBOARD: FHotKeyTransClipboard := HK;
      HOTKEY_TRANS_FROM_CONTROL: FHotKeyTransFromControl := HK;
      HOTKEY_TRANS_CONTROL: FHotKeyTransControl := HK;
    end;

    Edit.Text := string.Empty;
    Key := 0; // block default delete behavior
    Exit;
  end
  else
  if (Key = VK_ESCAPE) and (Shift = []) then
  begin
    case Edit.Tag of
      HOTKEY_APP:
      begin
        FHotKeyApp := FOriginalHotKeyApp;
        HK := FHotKeyApp;
      end;

      HOTKEY_TRANS_SWAP:
      begin
        FHotKeyTransSwap := FOriginalHotKeyTransSwap;
        HK := FHotKeyTransSwap;
      end;

      HOTKEY_TRANS_FROM_CLIPBOARD:
      begin
        FHotKeyTransFromClipboard := FOriginalHotKeyTransFromClipboard;
        HK := FHotKeyTransFromClipboard;
      end;

      HOTKEY_TRANS_CLIPBOARD:
      begin
        FHotKeyTransClipboard := FOriginalHotKeyTransClipboard;
        HK := FHotKeyTransClipboard;
      end;

      HOTKEY_TRANS_FROM_CONTROL:
      begin
        FHotKeyTransFromControl := FOriginalHotKeyTransFromControl;
        HK := FHotKeyTransFromControl;
      end;

      HOTKEY_TRANS_CONTROL:
      begin
        FHotKeyTransControl := FOriginalHotKeyTransControl;
        HK := FHotKeyTransControl;
      end;
    end;

    Edit.Text := HotKeyToText(HK);
    Key := 0;
    Exit;
  end;

  // Initialize
  HK.Modifiers := 0;
  HK.Key := 0;

  // Set modifiers
  if ssCtrl in Shift then
    HK.Modifiers := HK.Modifiers or MOD_CONTROL;

  if ssShift in Shift then
    HK.Modifiers := HK.Modifiers or MOD_SHIFT;

  if ssAlt in Shift then
    HK.Modifiers := HK.Modifiers or MOD_ALT;

  // Set key if not a pure modifier
  if (Key <> VK_CONTROL) and (Key <> VK_SHIFT) and (Key <> VK_MENU) then
  begin
    HK.Key := Key;
    Key := 0; // block default processing
  end;

  // Update hotkey
  case Edit.Tag of
    HOTKEY_APP: FHotKeyApp := HK;
    HOTKEY_TRANS_SWAP: FHotKeyTransSwap := HK;
    HOTKEY_TRANS_FROM_CLIPBOARD: FHotKeyTransFromClipboard := HK;
    HOTKEY_TRANS_CLIPBOARD: FHotKeyTransClipboard := HK;
    HOTKEY_TRANS_FROM_CONTROL: FHotKeyTransFromControl := HK;
    HOTKEY_TRANS_CONTROL: FHotKeyTransControl := HK;
  end;

  // Update Edit text
  Edit.Text := HotKeyToText(HK);
end;

procedure TformSettingsTrayslate.BtnOkClick(Sender: TObject);
begin
  Apply;
  ModalResult := mrOk;
end;

procedure TformSettingsTrayslate.BtnCancelClick(Sender: TObject);
begin
  Reset;
  ModalResult := mrCancel;
end;

procedure TformSettingsTrayslate.BtnApplyClick(Sender: TObject);
begin
  Apply;
end;

procedure TformSettingsTrayslate.SetPanelFont(const AFont: TFont);
begin
  PanelFont.Caption := ifthen((Trim(AFont.Name) = string.Empty) or (LowerCase(AFont.Name) = 'default'), 'Default', AFont.Name) +
    ',' + IntToStr(AFont.Size);
end;

procedure TformSettingsTrayslate.AddTrayColors(AColorBox: TColorBox);
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
  AColorBox.Items.AddObject('Ocean Deep', TObject(PtrUInt($00905000)));
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

procedure TformSettingsTrayslate.Apply;
begin
  formTrayslate.AutoStart := CheckAutostart.Checked;
  formTrayslate.MaxLangPairs := SpinMaxLangPairs.Value;
  formTrayslate.SwapTranslate := CheckSwapTranslate.Checked;
  formTrayslate.TranslateAsYouType := CheckTranslateAsYouType.Checked;
  formTrayslate.AutoSwap := CheckAutoSwap.Checked;
  formTrayslate.ConfigLangDetect := formTrayslate.ConfigFiles[ComboLangDetect.ItemIndex];
  formTrayslate.Font.Assign(PanelFont.Font);
  formTrayslate.IconBackgroundColor := ColorIconBackground.Selected;
  formTrayslate.IconFontColor := ColorIconFont.Selected;
  formTrayslate.IconTwoLang := CheckTwoLang.Checked;
  formTrayslate.SetIcon;

  formTrayslate.HotKeyApp := FHotKeyApp;
  formTrayslate.HotKeyTransSwap := FHotKeyTransSwap;
  formTrayslate.HotKeyTransFromClipboard := FHotKeyTransFromClipboard;
  formTrayslate.HotKeyTransClipboard := FHotKeyTransClipboard;
  formTrayslate.HotKeyTransFromControl := FHotKeyTransFromControl;
  formTrayslate.HotKeyTransControl := FHotKeyTransControl;

  formTrayslate.ComboSource.SelLength := 0;
  formTrayslate.ComboTarget.SelLength := 0;

  Reset;
  formTrayslate.LoadConfig;
  formTrayslate.DoRealign(0);
  Application.QueueAsyncCall(@formTrayslate.RebuildLangPairsPanel, 0);
end;

procedure TformSettingsTrayslate.Reset;
begin
  FOriginalAutoStart := formTrayslate.AutoStart;
  FOriginalMaxLangPairs := formTrayslate.MaxLangPairs;
  FOriginalSwapTranslate := formTrayslate.SwapTranslate;
  FOriginalTranslateAsYouType := formTrayslate.TranslateAsYouType;
  FOriginalAutoSwap := formTrayslate.AutoSwap;
  FOriginalConfigLangDetect := formTrayslate.ConfigLangDetect;
  FOriginalFont := formTrayslate.Font;
  FOriginalIconBackgroundColor := formTrayslate.IconBackgroundColor;
  FOriginalIconFontColor := formTrayslate.IconFontColor;
  FOriginalIconTwoLang := formTrayslate.IconTwoLang;
  FOriginalHotKeyApp := formTrayslate.HotKeyApp;
  FOriginalHotKeyTransSwap := formTrayslate.HotKeyTransSwap;
  FOriginalHotKeyTransFromClipboard := formTrayslate.HotKeyTransFromClipboard;
  FOriginalHotKeyTransClipboard := formTrayslate.HotKeyTransClipboard;
  FOriginalHotKeyTransFromControl := formTrayslate.HotKeyTransFromControl;
  FOriginalHotKeyTransControl := formTrayslate.HotKeyTransControl;
  FHotKeyApp := formTrayslate.HotKeyApp;
  FHotKeyTransSwap := formTrayslate.HotKeyTransSwap;
  FHotKeyTransFromClipboard := formTrayslate.HotKeyTransFromClipboard;
  FHotKeyTransClipboard := formTrayslate.HotKeyTransClipboard;
  FHotKeyTransFromControl := formTrayslate.HotKeyTransFromControl;
  FHotKeyTransControl := formTrayslate.HotKeyTransControl;

  CheckAutostart.Checked := FOriginalAutoStart;
  SpinMaxLangPairs.Value := FOriginalMaxLangPairs;
  CheckSwapTranslate.Checked := FOriginalSwapTranslate;
  CheckTranslateAsYouType.Checked := FOriginalTranslateAsYouType;
  CheckAutoSwap.Checked := FOriginalAutoSwap;
  ComboLangDetect.ItemIndex := formTrayslate.ConfigFiles.IndexOf(FOriginalConfigLangDetect);
  PanelFont.Font.Assign(FOriginalFont);
  SetPanelFont(FOriginalFont);
  ColorIconBackground.Selected := FOriginalIconBackgroundColor;
  ColorIconFont.Selected := FOriginalIconFontColor;
  CheckTwoLang.Checked := FOriginalIconTwoLang;
  EditApp.Text := HotKeyToText(FOriginalHotKeyApp);
  EditTransSwap.Text := HotKeyToText(FOriginalHotKeyTransSwap);
  EditTransFromClipboard.Text := HotKeyToText(FOriginalHotKeyTransFromClipboard);
  EditTransClipboard.Text := HotKeyToText(FOriginalHotKeyTransClipboard);
  EditTransFromControl.Text := HotKeyToText(FOriginalHotKeyTransFromControl);
  EditTransControl.Text := HotKeyToText(FOriginalHotKeyTransControl);

  BtnApply.Enabled := False;
end;

end.
