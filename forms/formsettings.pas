//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formsettings;

{$mode ObjFPC}{$H+}

interface

uses
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
  Math,
  LCLType,
  langtool;

type

  { TformSettingsTrayslate }

  TformSettingsTrayslate = class(TForm)
    BtnFont: TButton;
    BtnReset: TButton;
    BtnApply: TButton;
    BtnCancel: TButton;
    BtnOk: TButton;
    CheckRecentPairHotkeys: TCheckBox;
    CheckRealTime: TCheckBox;
    CheckAutoSwap: TCheckBox;
    CheckTwoLang: TCheckBox;
    CheckAutostart: TCheckBox;
    CheckAutoAddLangPairs: TCheckBox;
    ColorIconBackground: TColorBox;
    ColorIconFont: TColorBox;
    ColorDialog: TColorDialog;
    ComboIconFontName: TComboBox;
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
    GroupRealTime: TGroupBox;
    GroupApp: TGroupBox;
    GroupFont: TGroupBox;
    GroupTransClipboard: TGroupBox;
    GroupTransControl: TGroupBox;
    GroupTrayIcon: TGroupBox;
    LabelIconBackground1: TLabel;
    LabelIconFont1: TLabel;
    LabelMaxLangPairs: TLabel;
    LabelRealTimeDelay: TLabel;
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
    SpinRealTimeDelay: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnFontClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure EditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure EditMouseLeave(Sender: TObject);
    procedure PagesSettingsChange(Sender: TObject);
    procedure SettingChange(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    FOriginalAutoStart: boolean;
    FOriginalFont: TFont;
    FOriginalIconBackgroundColor: TColor;
    FOriginalIconFontColor: TColor;
    FOriginalIconFontName: string;
    FOriginalIconTwoLang: boolean;
    FOriginalMaxLangPairs: integer;
    FOriginalAutoAddLangPairs: boolean;
    FOriginalRecentPairHotkeys: boolean;
    FOriginalRealTime: boolean;
    FOriginalRealTimeDelay: integer;
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
  public
    procedure Apply;
    procedure Reset;
  end;

var
  formSettingsTrayslate: TformSettingsTrayslate;

resourcestring
  rdefaultfont = 'Default';

implementation

uses mainform, formattool, systemtool;

  {$R *.lfm}

  { TformSettingsTrayslate }

procedure TformSettingsTrayslate.FormCreate(Sender: TObject);
var
  i: integer;
begin
  ApplicationTranslate(language, self);

  PagesSettings.PageIndex := 0;
  BtnCancel.Cancel := True;
  BtnReset.Enabled := True;

  ComboLangDetect.Items.Clear;
  for i := 0 to formTrayslate.ConfigFiles.Count - 1 do
    ComboLangDetect.Items.Add(formTrayslate.ConfigFileTitles.Values[formTrayslate.ConfigFiles[i]]);
  ComboLangDetect.ItemIndex := formTrayslate.ConfigFiles.IndexOf(formTrayslate.ConfigLangDetect);

  AddCustomColors(ColorIconBackground);
  AddCustomColors(ColorIconFont);
  FillFontCombo(ComboIconFontName);
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

procedure TformSettingsTrayslate.EditMouseLeave(Sender: TObject);
begin
  PagesSettings.SetFocus;
  (Sender as TEdit).SelLength := 0;
end;

procedure TformSettingsTrayslate.PagesSettingsChange(Sender: TObject);
begin
  if PagesSettings.ActivePage = PageHotkeys then
    PagesSettings.SetFocus;
end;

procedure TformSettingsTrayslate.SettingChange(Sender: TObject);
begin
  BtnApply.Enabled := True;

  if (Sender is TSpinEdit) then
  begin
    if (Sender as TSpinEdit).Value < 0 then
      (Sender as TSpinEdit).Value := 0;
  end
  else
  if (Sender = ColorIconBackground) or (Sender = ColorIconFont) or (Sender = ComboIconFontName) or (Sender = CheckTwoLang) then
  begin
    // Apply real time properies
    formTrayslate.IconBackgroundColor := ColorIconBackground.Selected;
    formTrayslate.IconFontColor := ColorIconFont.Selected;
    formTrayslate.IconFontName := ComboIconFontName.Text;
    formTrayslate.IconTwoLang := CheckTwoLang.Checked;
    formTrayslate.SetIcon;
  end;
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
  end
  else
  if (Key = VK_TAB) and (Shift = []) then
    Exit;

  // Initialize
  HK.Modifiers := 0;
  HK.Key := 0;

  // Set modifiers
  if ssCtrl in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_CTRL;

  if ssShift in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_SHIFT;

  if ssAlt in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_ALT;

  if ssMeta in Shift then
    HK.Modifiers := HK.Modifiers or HOTKEY_META;

  // Set key if not a pure modifier
  if (Key <> VK_CONTROL) and (Key <> VK_SHIFT) and (Key <> VK_MENU) and (Key <> VK_LWIN) and (Key <> VK_RWIN) then
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
  // Reset real time properies
  formTrayslate.IconBackgroundColor := FOriginalIconBackgroundColor;
  formTrayslate.IconFontColor := FOriginalIconFontColor;
  formTrayslate.IconFontName := FOriginalIconFontName;
  formTrayslate.IconTwoLang := FOriginalIconTwoLang;
  formTrayslate.SetIcon;

  Reset;
  ModalResult := mrCancel;
end;

procedure TformSettingsTrayslate.BtnApplyClick(Sender: TObject);
begin
  Apply;
end;

procedure TformSettingsTrayslate.SetPanelFont(const AFont: TFont);
begin
  PanelFont.Caption := ifthen((Trim(AFont.Name) = string.Empty) or (LowerCase(AFont.Name) = 'default'), rdefaultfont, AFont.Name) +
    ',' + IntToStr(AFont.Size);
end;

procedure TformSettingsTrayslate.Apply;
begin
  formTrayslate.AutoStart := CheckAutostart.Checked;
  formTrayslate.MaxLangPairs := SpinMaxLangPairs.Value;
  formTrayslate.AutoAddLangPairs := CheckAutoAddLangPairs.Checked;
  formTrayslate.RecentPairHotKeys := CheckRecentPairHotkeys.Checked;
  formTrayslate.RealTime := CheckRealTime.Checked;
  formTrayslate.RealTimeDelay := SpinRealTimeDelay.Value;
  formTrayslate.AutoSwap := CheckAutoSwap.Checked;
  formTrayslate.ConfigLangDetect := formTrayslate.ConfigFiles[ComboLangDetect.ItemIndex];
  formTrayslate.Font.Assign(PanelFont.Font);
  formTrayslate.IconBackgroundColor := ColorIconBackground.Selected;
  formTrayslate.IconFontColor := ColorIconFont.Selected;
  formTrayslate.IconFontName := ComboIconFontName.Text;
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
  formTrayslate.TimerTranslate.Interval := Max(formTrayslate.RealTimeDelay, 1);
  formTrayslate.LoadConfig;
  formTrayslate.DoRealign(0);
  Application.QueueAsyncCall(@formTrayslate.RebuildLangPairsPanel, 0);
end;

procedure TformSettingsTrayslate.Reset;
begin
  FOriginalAutoStart := formTrayslate.AutoStart;
  FOriginalMaxLangPairs := formTrayslate.MaxLangPairs;
  FOriginalAutoAddLangPairs := formTrayslate.AutoAddLangPairs;
  FOriginalRecentPairHotkeys := formTrayslate.RecentPairHotKeys;
  FOriginalRealTime := formTrayslate.RealTime;
  FOriginalRealTimeDelay := formTrayslate.RealTimeDelay;
  FOriginalAutoSwap := formTrayslate.AutoSwap;
  FOriginalConfigLangDetect := formTrayslate.ConfigLangDetect;
  FOriginalFont := formTrayslate.Font;
  FOriginalIconBackgroundColor := formTrayslate.IconBackgroundColor;
  FOriginalIconFontColor := formTrayslate.IconFontColor;
  FOriginalIconFontName := formTrayslate.IconFontName;
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
  CheckAutoAddLangPairs.Checked := FOriginalAutoAddLangPairs;
  CheckRecentPairHotkeys.Checked := FOriginalRecentPairHotkeys;
  CheckRealTime.Checked := FOriginalRealTime;
  SpinRealTimeDelay.Value := FOriginalRealTimeDelay;
  CheckAutoSwap.Checked := FOriginalAutoSwap;
  ComboLangDetect.ItemIndex := formTrayslate.ConfigFiles.IndexOf(FOriginalConfigLangDetect);
  PanelFont.Font.Assign(FOriginalFont);
  SetPanelFont(FOriginalFont);
  ColorIconBackground.Selected := FOriginalIconBackgroundColor;
  ColorIconFont.Selected := FOriginalIconFontColor;
  ComboIconFontName.Text := FOriginalIconFontName;
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
