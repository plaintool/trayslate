//-----------------------------------------------------------------------------------
//  Trayslator © 2024 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formconfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Clipbrd,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  FileUtil,
  Buttons,
  LCLType, ActnList, ComCtrls;

type

  { TformConfigTrayslator }

  TformConfigTrayslator = class(TForm)
    aSave: TAction;
    ActionList: TActionList;
    BtnClose: TButton;
    BtnSave: TButton;
    CheckEncryptText: TCheckBox;
    ComboMethod: TComboBox;
    ComboConfig: TComboBox;
    ComboResponseParser: TComboBox;
    EditAccept: TEdit;
    EditJsonPointer: TEdit;
    EditUserAgent: TEdit;
    EditContentType: TEdit;
    EditRegexp: TEdit;
    EditServiceName: TEdit;
    GroupBoxService: TGroupBox;
    GroupHeaders: TGroupBox;
    GroupLanguagesTarget: TGroupBox;
    GroupRequest: TGroupBox;
    GroupResponse: TGroupBox;
    GroupLanguages: TGroupBox;
    LabelAccept: TLabel;
    LabelLanguagesTarget: TLabel;
    LabelFillLanguages: TLabel;
    LabelMethod: TLabel;
    LabelLanguages: TLabel;
    LabelParemeters2: TLabel;
    LabelHeaders: TLabel;
    LabelPostData: TLabel;
    LabelJsonPointer: TLabel;
    LabelUserAgent: TLabel;
    LabelContentType: TLabel;
    LabelUrl: TLabel;
    LabelParemeters: TLabel;
    LabelResponseParser: TLabel;
    LabelRegexp: TLabel;
    LabelServiceName: TLabel;
    MemoLanguages: TMemo;
    MemoHeaders: TMemo;
    MemoLanguagesTarget: TMemo;
    MemoURL: TMemo;
    MemoPostData: TMemo;
    Pages: TPageControl;
    PanelTop: TPanel;
    SbCopyConfig: TSpeedButton;
    ScrollBoxConfig: TScrollBox;
    PageService: TTabSheet;
    PageHeaders: TTabSheet;
    PageLanguages: TTabSheet;
    PageLanguagesTarget: TTabSheet;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure aSaveExecute(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure ComboConfigChange(Sender: TObject);
    procedure ComboConfigKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure LabelFillLanguagesClick(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ValueChange(Sender: TObject);
    procedure SbCopyConfigClick(Sender: TObject);
  private
    FLastConfig: integer;
  public
    function TestChanges: boolean;
    procedure CopyConfig;
    procedure UpdateConfigList;
    procedure UpdateConfig;
    procedure SaveConfig;
  end;

var
  formConfigTrayslator: TformConfigTrayslator;

resourcestring
  rcopyquestion = 'Enter new config file name:';
  rneedsave = 'The configuration was modified. Save changes?';
  rclearlanguages = 'The list is already filled. Do you want to clear it?';
  rcaption = 'Config Editor';

implementation

uses mainform, translate, settings, formattool, langtool, languages;

  {$R *.lfm}

  { TformConfigTrayslator }

procedure TformConfigTrayslator.FormCreate(Sender: TObject);
begin
  Pages.PageIndex := 0;
end;

procedure TformConfigTrayslator.FormShow(Sender: TObject);
begin
  UpdateConfigList;
  UpdateConfig;
end;

procedure TformConfigTrayslator.FormDestroy(Sender: TObject);
begin
  formConfigTrayslator := nil;
end;

procedure TformConfigTrayslator.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TformConfigTrayslator.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := TestChanges;
end;

procedure TformConfigTrayslator.FormResize(Sender: TObject);
begin
  formTrayslator.FormConfigWidth := Width;
  formTrayslator.FormConfigHeight := Height;
end;

procedure TformConfigTrayslator.FormChangeBounds(Sender: TObject);
begin
  formTrayslator.FormConfigLeft := Left;
  formTrayslator.FormConfigTop := Top;
end;

procedure TformConfigTrayslator.aSaveExecute(Sender: TObject);
begin
  SaveConfig;
end;

procedure TformConfigTrayslator.ComboConfigChange(Sender: TObject);
begin
  if not TestChanges then
  begin
    ComboConfig.ItemIndex := FLastConfig;
    exit;
  end;
  formTrayslator.ConfigFile := ComboConfig.Text;
  formTrayslator.LoadConfig;
  UpdateConfig;
  FLastConfig := ComboConfig.ItemIndex;
end;

procedure TformConfigTrayslator.ComboConfigKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in shift) and (Key = VK_C) then
    Clipboard.AsText := ComboConfig.Text;
end;

procedure TformConfigTrayslator.LabelFillLanguagesClick(Sender: TObject);
var
  List: TStringList;
begin
  if MemoLanguages.Lines.Count > 0 then
  begin
    if MessageDlg(rclearlanguages, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;

    MemoLanguages.Clear;
  end;

  List := GetLanguageCodePairList;
  try
    MemoLanguages.Lines.Assign(List);
  finally
    List.Free;
  end;
end;

procedure TformConfigTrayslator.MemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_V) then // Ctrl + V
  begin
    PasteWithLineEnding(Sender as TMemo);
    Key := 0;
  end;
end;

procedure TformConfigTrayslator.ValueChange(Sender: TObject);
begin
  aSave.Enabled := True;
  Caption := '*' + rcaption;
end;

procedure TformConfigTrayslator.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TformConfigTrayslator.SbCopyConfigClick(Sender: TObject);
begin
  CopyConfig;
end;

function TformConfigTrayslator.TestChanges: boolean;
var
  res: TModalResult;
begin
  Result := True;
  if (aSave.Enabled) then
  begin
    res := MessageDlg(rneedsave, mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    if res = mrYes then
    begin
      SaveConfig;
      Exit;
    end
    else
    if res = mrCancel then
      Result := False
    else if res = mrNo then
      UpdateConfig;
  end;
end;

procedure TformConfigTrayslator.CopyConfig;
var
  NewName: string;
  SourceFile: string;
  DestFile: string;
begin
  if (ComboConfig.Text <> string.Empty) and (not TestChanges) then exit;

  NewName := ExtractFileName(ComboConfig.Text);

  // Ask user for new config name
  if not InputQuery(SbCopyConfig.Hint, rcopyquestion, NewName) then
    Exit; // user pressed Cancel

  NewName := Trim(NewName);
  if NewName = string.Empty then
    Exit;

  // Add .ini extension if missing
  if not SameText(ExtractFileExt(NewName), '.ini') then
    NewName := NewName + '.ini';

  if NewName = ExtractFileName(ComboConfig.Text) then
    Exit;

  SourceFile := ComboConfig.Text;
  DestFile := IncludeTrailingPathDelimiter(GetSettingsDirectory) + NewName;

  try
    if SourceFile = string.Empty then
    begin
      // Create empty file
      with TFileStream.Create(DestFile, fmCreate) do
        Free;

      // Save Current Data
      formTrayslator.ConfigFile := DestFile;
      SaveConfig;
    end
    else
    begin
      // Copy config file
      CopyFile(SourceFile, DestFile, [], True);
    end;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  formTrayslator.ConfigFiles.Add(DestFile);
  formTrayslator.ConfigFile := DestFile;
  formTrayslator.LoadConfig;
  UpdateConfigList;
  UpdateConfig;
end;

procedure TformConfigTrayslator.UpdateConfigList;
begin
  ComboConfig.Items.Assign(formTrayslator.ConfigFiles);
  ComboConfig.ItemIndex := ComboConfig.Items.IndexOf(formTrayslator.ConfigFile);
  FLastConfig := ComboConfig.ItemIndex;
end;

procedure TformConfigTrayslator.UpdateConfig;
begin
  with formTrayslator.Trans do
  begin
    EditServiceName.Text := ServiceName;
    if WebMethod = wmGet then
      ComboMethod.ItemIndex := 0
    else
      ComboMethod.ItemIndex := 1;
    EditUserAgent.Text := UserAgent;
    EditContentType.Text := ContentType;
    MemoUrl.Text := Url;
    MemoPostData.Text := PostData;
    EditAccept.Text := Accept;
    if ResponseParser = rpJson then
      ComboResponseParser.ItemIndex := 0
    else
      ComboResponseParser.ItemIndex := 1;
    EditRegexp.Text := Regexp;
    EditJsonPointer.Text := JsonPointer;
    CheckEncryptText.Checked := EncryptText;
    MemoLanguages.Lines.Assign(Languages);
    MemoLanguagesTarget.Lines.Assign(LanguagesTarget);
    MemoHeaders.Lines.Assign(Headers);
  end;
  aSave.Enabled := False;
  Caption := rcaption;
end;

procedure TformConfigTrayslator.SaveConfig;
var
  TempHeaders: TStringList;
begin
  if (formTrayslator.ConfigFile = string.Empty) then
    CopyConfig;

  if (formTrayslator.ConfigFile = string.Empty) then
    exit;

  Screen.Cursor := crHourGlass;
  try
    with formTrayslator.Trans do
    begin
      ServiceName := EditServiceName.Text;
      if ComboMethod.ItemIndex = 0 then
        WebMethod := wmGet
      else
        WebMethod := wmPost;
      UserAgent := EditUserAgent.Text;
      ContentType := EditContentType.Text;
      Accept := EditAccept.Text;
      Url := MemoUrl.Text;
      PostData := MemoPostData.Text;
      if ComboResponseParser.ItemIndex = 0 then
        ResponseParser := rpJson
      else
        ResponseParser := rpRegEx;
      Regexp := EditRegexp.Text;
      JsonPointer := EditJsonPointer.Text;
      EncryptText := CheckEncryptText.Checked;
      Languages.Assign(MemoLanguages.Lines);
      LanguagesTarget.Assign(MemoLanguagesTarget.Lines);
      TempHeaders := HeadersFromMemo(MemoHeaders);
      try
        Headers.Assign(TempHeaders);
      finally
        TempHeaders.Free;
      end;
    end;
    SaveIniSettings(formTrayslator.Trans, formTrayslator.ConfigFile);
    aSave.Enabled := False;
    formTrayslator.LoadConfig;
  finally
    Screen.Cursor := crDefault;
    Caption := rcaption;
  end;
end;

end.
