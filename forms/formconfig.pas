//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formconfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  Forms,
  Controls,
  Graphics,
  Clipbrd,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  FileUtil,
  Buttons,
  ActnList,
  ComCtrls,
  Spin,
  LCLType;

type

  { TformConfigTrayslate }

  TformConfigTrayslate = class(TForm)
    aSave: TAction;
    ActionList: TActionList;
    BtnClose: TButton;
    BtnInitParametersTest: TSpeedButton;
    BtnUrlTest: TSpeedButton;
    BtnSave: TButton;
    BtnPostDataTest: TSpeedButton;
    CheckEncryptText: TCheckBox;
    CheckAutoSwap: TCheckBox;
    ComboMethod: TComboBox;
    ComboConfig: TComboBox;
    ComboValueType: TComboBox;
    EditAccept: TEdit;
    EditUserAgent: TEdit;
    EditContentType: TEdit;
    EditServiceName: TEdit;
    EditInitUserAgent: TEdit;
    GroupBoxService: TGroupBox;
    GroupInitParameters: TGroupBox;
    GroupLanguagesTarget: TGroupBox;
    GroupRequest: TGroupBox;
    GroupResponse: TGroupBox;
    GroupLanguages: TGroupBox;
    LabelAccept: TLabel;
    LabelInitHeaders: TLabel;
    LabelInitParameters: TLabel;
    LabelInitParameters1: TLabel;
    LabelLanguages1: TLabel;
    LabelLanguagesTarget: TLabel;
    LabelFillLanguages: TLabel;
    LabelInitLiveTime: TLabel;
    LabelMethod: TLabel;
    LabelLanguages: TLabel;
    LabelInitParemeters: TLabel;
    LabelValueType: TLabel;
    LabelJsonPointer2: TLabel;
    LabelHeaders: TLabel;
    LabelPostData: TLabel;
    LabelPostData1: TLabel;
    LabelInitParameters2: TLabel;
    LabelInitHeaders2: TLabel;
    LabelInitUrl: TLabel;
    LabelServiceOrder: TLabel;
    LabelUserAgent: TLabel;
    LabelContentType: TLabel;
    LabelUrl: TLabel;
    LabelParemeters: TLabel;
    LabelServiceName: TLabel;
    LabelInitUserAgent: TLabel;
    MemoInitHeaders: TMemo;
    MemoLanguages: TMemo;
    MemoHeaders: TMemo;
    MemoLanguagesTarget: TMemo;
    MemoInitParameters: TMemo;
    MemoURL: TMemo;
    MemoPostData: TMemo;
    MemoInitURL: TMemo;
    MemoJsonPointer: TMemo;
    Pages: TPageControl;
    PanelTop: TPanel;
    SbCopyConfig: TSpeedButton;
    SbNewConfig: TSpeedButton;
    ScrollBoxResponse: TScrollBox;
    ScrollBoxParameters: TScrollBox;
    ScrollBoxService: TScrollBox;
    PageService: TTabSheet;
    PageParameters: TTabSheet;
    PageLanguages: TTabSheet;
    PageLanguagesTarget: TTabSheet;
    BtnInitUrlTest: TSpeedButton;
    SpinInitLiveTime: TSpinEdit;
    PageResponse: TTabSheet;
    SpinServiceOrder: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormResize(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure BtnUrlTestClick(Sender: TObject);
    procedure BtnPostDataTestClick(Sender: TObject);
    procedure BtnInitUrlTestClick(Sender: TObject);
    procedure BtnInitParametersTestClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure ComboConfigChange(Sender: TObject);
    procedure ComboConfigKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure LabelFillLanguagesClick(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure SbNewConfigClick(Sender: TObject);
    procedure ValueChange(Sender: TObject);
    procedure SbCopyConfigClick(Sender: TObject);
  private
    FLastConfig: integer;
  public
    function TestChanges: boolean;
    procedure CreateConfig(ACopy: boolean = False);
    procedure DeleteConfig;
    procedure UpdateConfigList(UpdateItemIndex: boolean = True);
    procedure UpdateConfig;
    procedure ClearConfig;
    procedure SaveConfig;
  end;

var
  formConfigTrayslate: TformConfigTrayslate;

resourcestring
  rnamequestion = 'Enter new config file name:';
  rneedsave = 'The configuration was modified. Save changes?';
  rclearlanguages = 'The list is already filled. Do you want to clear it?';
  rcaption = 'Config Editor';

implementation

uses mainform, translate, settings, formattool, langtool, languages, systemtool;

  {$R *.lfm}

  { TformConfigTrayslate }

procedure TformConfigTrayslate.FormCreate(Sender: TObject);
begin
  Pages.PageIndex := 0;
  BtnClose.Cancel := True;
  LabelFillLanguages.Font.Color := ThemeColor(clBlue, clSkyBlue);
end;

procedure TformConfigTrayslate.FormShow(Sender: TObject);
begin
  UpdateConfigList;
  UpdateConfig;
  formTrayslate.TopMost := False;
end;

procedure TformConfigTrayslate.FormDestroy(Sender: TObject);
begin
  formConfigTrayslate := nil;
end;

procedure TformConfigTrayslate.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TformConfigTrayslate.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := TestChanges;
end;

procedure TformConfigTrayslate.FormResize(Sender: TObject);
begin
  formTrayslate.FormConfigWidth := Width;
  formTrayslate.FormConfigHeight := Height;
end;

procedure TformConfigTrayslate.FormChangeBounds(Sender: TObject);
begin
  formTrayslate.FormConfigLeft := Left;
  formTrayslate.FormConfigTop := Top;
end;

procedure TformConfigTrayslate.aSaveExecute(Sender: TObject);
begin
  SaveConfig;
end;

procedure TformConfigTrayslate.BtnUrlTestClick(Sender: TObject);
begin
  Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    if (MemoUrl.Text = string.empty) or not TestChanges then exit;
    with formTrayslate.Trans do
    begin
      ParametersAge := Now + 3650;
      OpenStringInTextEditor(Get(True));
    end;
  finally
    Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TformConfigTrayslate.BtnPostDataTestClick(Sender: TObject);
begin
  Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    if (MemoPostData.Text = string.empty) or not TestChanges then exit;
    with formTrayslate.Trans do
    begin
      ParametersAge := Now + 3650;
      OpenStringInTextEditor(Post(True));
    end;
  finally
    Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TformConfigTrayslate.BtnInitUrlTestClick(Sender: TObject);
begin
  Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    if (MemoInitUrl.Text = string.empty) or not TestChanges then exit;
    with formTrayslate.Trans do
    begin
      ParametersAge := Now + 3650;
      OpenStringInTextEditor(GetInit);
    end;
  finally
    Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TformConfigTrayslate.BtnInitParametersTestClick(Sender: TObject);
begin
  Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    if (MemoInitUrl.Text = string.empty) or (MemoInitParameters.Text = string.empty) or not TestChanges then exit;
    with formTrayslate.Trans do
    begin
      ParametersAge := Now + 3650;
      GetParameters(GetInit);
      OpenStringInTextEditor(ParameterValues.Text);
    end;
  finally
    Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TformConfigTrayslate.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TformConfigTrayslate.ComboConfigChange(Sender: TObject);
begin
  if not TestChanges then
  begin
    ComboConfig.ItemIndex := FLastConfig;
    exit;
  end;
  formTrayslate.ConfigFile := ComboConfig.Text;
  formTrayslate.LoadConfig;
  UpdateConfig;
  FLastConfig := ComboConfig.ItemIndex;
end;

procedure TformConfigTrayslate.ComboConfigKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in shift) and (Key = VK_C) then
    Clipboard.AsText := ComboConfig.Text;

  if (ComboConfig.Focused) and (Key = VK_DELETE) then
    DeleteConfig;
end;

procedure TformConfigTrayslate.LabelFillLanguagesClick(Sender: TObject);
var
  List: TStringList;
begin
  if MemoLanguages.Lines.Count > 0 then
  begin
    if MessageDlg(rclearlanguages, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;

    MemoLanguages.Clear;
  end;

  List := GetLanguageCodePairList(TValueType(ComboValueType.ItemIndex));
  try
    MemoLanguages.Lines.Assign(List);
  finally
    List.Free;
  end;
end;

procedure TformConfigTrayslate.MemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_V) then // Ctrl + V
  begin
    PasteWithLineEnding(Sender as TMemo);
    Key := 0;
  end;
end;

procedure TformConfigTrayslate.ValueChange(Sender: TObject);
begin
  aSave.Enabled := True;
  Caption := '*' + rcaption;
end;

procedure TformConfigTrayslate.SbNewConfigClick(Sender: TObject);
begin
  CreateConfig;
end;

procedure TformConfigTrayslate.SbCopyConfigClick(Sender: TObject);
begin
  CreateConfig(True);
end;

function TformConfigTrayslate.TestChanges: boolean;
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

procedure TformConfigTrayslate.CreateConfig(ACopy: boolean = False);
var
  NewName: string;
  SourceFile: string;
  DestFile: string;
begin
  if (ComboConfig.Text <> string.Empty) and (not TestChanges) then Exit;

  NewName := ExtractFileName(ComboConfig.Text);

  // Ask user for new config name
  if not InputQuery(ifthen(ACopy, SbCopyConfig.Hint, SbNewConfig.Hint), rnamequestion, NewName) then
    Exit; // user pressed Cancel

  NewName := Trim(NewName);
  if NewName = string.Empty then Exit;

  // Add .ini extension if missing
  if not SameText(ExtractFileExt(NewName), '.ini') then
    NewName := NewName + '.ini';

  if NewName = ExtractFileName(ComboConfig.Text) then Exit;

  SourceFile := ComboConfig.Text;
  DestFile := IncludeTrailingPathDelimiter(GetSettingsDirectory) + NewName;

  try
    if (SourceFile = string.Empty) then
    begin
      // Create new empty config
      with TFileStream.Create(DestFile, fmCreate) do
        Free;

      // Save current data to the new file
      formTrayslate.ConfigFile := DestFile;
      SaveConfig;
    end
    else
    if (not ACopy) then
    begin
      // Create new empty config
      with TFileStream.Create(DestFile, fmCreate) do
        Free;

      // Save current data to the new file
      formTrayslate.ConfigFile := DestFile;
      ClearConfig;
      SaveConfig;
    end
    else
    begin
      // Copy existing config file
      CopyFile(SourceFile, DestFile, [], True);
    end;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  formTrayslate.ConfigFiles.Add(DestFile);
  formTrayslate.ConfigFile := DestFile;
  formTrayslate.LoadConfig;
  UpdateConfigList;
  UpdateConfig;
end;

procedure TformConfigTrayslate.DeleteConfig;
var
  FileName: string;
  LastIndex: integer;
begin
  FileName := ComboConfig.Text;
  LastIndex := ComboConfig.ItemIndex;

  if FileName = string.Empty then Exit;

  // Ask user for confirmation
  if MessageDlg('Delete config', 'Are you sure you want to delete config ' + ExtractFileName(FileName) +
    '?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    if FileExists(FileName) then
      DeleteFile(FileName);

    // Remove from list
    formTrayslate.ConfigFiles.Delete(
      formTrayslate.ConfigFiles.IndexOf(FileName));

    // Reset current config
    formTrayslate.ConfigFile := string.Empty;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  // Reload UI
  UpdateConfigList;
  if (LastIndex >= ComboConfig.Items.Count) then Dec(LastIndex);
  ComboConfig.ItemIndex := LastIndex;
  ComboConfigChange(Self);
  UpdateConfig;
end;

procedure TformConfigTrayslate.UpdateConfigList(UpdateItemIndex: boolean = True);
begin
  ComboConfig.Items.Assign(formTrayslate.ConfigFiles);
  if (UpdateItemIndex) then
    ComboConfig.ItemIndex := ComboConfig.Items.IndexOf(formTrayslate.ConfigFile);
  FLastConfig := ComboConfig.ItemIndex;
end;

procedure TformConfigTrayslate.UpdateConfig;
begin
  with formTrayslate.Trans do
  begin
    EditServiceName.Text := ServiceName;
    SpinServiceOrder.Value := ServiceOrder;
    CheckAutoSwap.Checked := AutoSwap;
    ComboMethod.ItemIndex := Ord(WebMethod);
    EditUserAgent.Text := UserAgent;
    MemoHeaders.Lines.Assign(Headers);
    CheckEncryptText.Checked := EncryptText;
    MemoUrl.Text := Url;
    EditContentType.Text := ContentType;
    MemoPostData.Text := PostData;
    EditAccept.Text := Accept;
    MemoJsonPointer.Text := JsonPointer;
    MemoLanguages.Lines.Assign(Languages);
    MemoLanguagesTarget.Lines.Assign(LanguagesTarget);
    ComboValueType.ItemIndex := Ord(ValueType);

    EditInitUserAgent.Text := InitUserAgent;
    MemoInitHeaders.Lines.Assign(InitHeaders);
    MemoInitUrl.Text := InitUrl;
    MemoInitParameters.Lines.Assign(InitParameters);
    SpinInitLiveTime.Value := InitLiveTime;
  end;
  aSave.Enabled := False;
  Caption := rcaption;
end;

procedure TformConfigTrayslate.ClearConfig;
begin
  with formTrayslate.Trans do
  begin
    ServiceName := string.Empty;
    ServiceOrder := 0;
    AutoSwap := False;
    WebMethod := wmGet;
    UserAgent := string.Empty;
    Headers.Clear;
    EncryptText := False;
    Url := string.Empty;
    ContentType := string.Empty;
    PostData := string.Empty;
    Accept := string.Empty;
    JsonPointer := string.Empty;
    Languages.Clear;
    LanguagesTarget.Clear;

    InitUserAgent := string.Empty;
    InitHeaders.Clear;
    InitUrl := string.Empty;
    InitParameters.Clear;
    SpinInitLiveTime.Value := 0;

    // Clear controls
    EditServiceName.Text := string.Empty;
    SpinServiceOrder.Value := 0;
    CheckAutoSwap.Checked := False;
    ComboMethod.ItemIndex := 0;
    ComboValueType.ItemIndex := 0;
    EditUserAgent.Text := string.Empty;
    EditContentType.Text := string.Empty;
    MemoUrl.Clear;
    MemoPostData.Clear;
    EditAccept.Text := string.Empty;
    MemoJsonPointer.Text := string.Empty;
    CheckEncryptText.Checked := False;
    MemoLanguages.Clear;
    MemoLanguagesTarget.Clear;
    MemoHeaders.Clear;
  end;

  aSave.Enabled := False;
  Caption := rcaption;
end;

procedure TformConfigTrayslate.SaveConfig;
var
  TempHeaders: TStringList;
begin
  if (formTrayslate.ConfigFile = string.Empty) then
    CreateConfig;

  if (formTrayslate.ConfigFile = string.Empty) then
    exit;

  Screen.Cursor := crHourGlass;
  try
    with formTrayslate.Trans do
    begin
      ServiceName := EditServiceName.Text;
      ServiceOrder := SpinServiceOrder.Value;
      AutoSwap := CheckAutoSwap.Checked;
      WebMethod := TWebMethod(ComboMethod.ItemIndex);
      UserAgent := EditUserAgent.Text;
      EncryptText := CheckEncryptText.Checked;
      TempHeaders := HeadersFromMemo(MemoHeaders);
      try
        Headers.Assign(TempHeaders);
      finally
        TempHeaders.Free;
      end;
      Url := MemoUrl.Text;
      ContentType := EditContentType.Text;
      PostData := MemoPostData.Text;
      Accept := EditAccept.Text;
      JsonPointer := MemoJsonPointer.Text;
      Languages.Assign(MemoLanguages.Lines);
      LanguagesTarget.Assign(MemoLanguagesTarget.Lines);
      ValueType := TValueType(ComboValueType.ItemIndex);

      InitUserAgent := EditInitUserAgent.Text;
      TempHeaders := HeadersFromMemo(MemoInitHeaders);
      try
        InitHeaders.Assign(TempHeaders);
      finally
        TempHeaders.Free;
      end;
      InitUrl := MemoInitUrl.Text;
      InitParameters.Assign(MemoInitParameters.Lines);
      InitLiveTime := SpinInitLiveTime.Value;
    end;
    SaveIniSettings(formTrayslate.Trans, formTrayslate.ConfigFile);
    aSave.Enabled := False;
    formTrayslate.LoadConfig;
    formTrayslate.BuildConfigMenu;
    UpdateConfigList(False);
  finally
    Screen.Cursor := crDefault;
    Caption := rcaption;
  end;
end;

end.
