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
    ComboResponseParser: TComboBox;
    EditAccept: TEdit;
    EditJsonPointer: TEdit;
    EditUserAgent: TEdit;
    EditContentType: TEdit;
    EditRegexp: TEdit;
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
    LabelLanguagesTarget: TLabel;
    LabelFillLanguages: TLabel;
    LabelInitLiveTime: TLabel;
    LabelMethod: TLabel;
    LabelLanguages: TLabel;
    LabelInitParemeters: TLabel;
    LabelParemeters2: TLabel;
    LabelHeaders: TLabel;
    LabelPostData: TLabel;
    LabelJsonPointer: TLabel;
    LabelPostData1: TLabel;
    LabelInitParameters2: TLabel;
    LabelInitHeaders2: TLabel;
    LabelInitUrl: TLabel;
    LabelUserAgent: TLabel;
    LabelContentType: TLabel;
    LabelUrl: TLabel;
    LabelParemeters: TLabel;
    LabelResponseParser: TLabel;
    LabelRegexp: TLabel;
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
    procedure UpdateConfigList;
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
  if (MemoUrl.Text = string.empty) or not TestChanges then exit;
  with formTrayslate.Trans do
  begin
    ParametersAge := Now + 3650;
    OpenStringInTextEditor(Get(True));
  end;
end;

procedure TformConfigTrayslate.BtnPostDataTestClick(Sender: TObject);
begin
  if (MemoPostData.Text = string.empty) or not TestChanges then exit;
  with formTrayslate.Trans do
  begin
    ParametersAge := Now + 3650;
    OpenStringInTextEditor(Post);
  end;
end;

procedure TformConfigTrayslate.BtnInitUrlTestClick(Sender: TObject);
begin
  if (MemoInitUrl.Text = string.empty) or not TestChanges then exit;
  with formTrayslate.Trans do
  begin
    ParametersAge := Now + 3650;
    OpenStringInTextEditor(GetInit);
  end;
end;

procedure TformConfigTrayslate.BtnInitParametersTestClick(Sender: TObject);
begin
  if (MemoInitUrl.Text = string.empty) or (MemoInitParameters.Text = string.empty) or not TestChanges then exit;
  with formTrayslate.Trans do
  begin
    ParametersAge := Now + 3650;
    GetParameters(GetInit);
    OpenStringInTextEditor(ParameterValues.Text);
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

  List := GetLanguageCodePairList;
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

procedure TformConfigTrayslate.UpdateConfigList;
begin
  ComboConfig.Items.Assign(formTrayslate.ConfigFiles);
  ComboConfig.ItemIndex := ComboConfig.Items.IndexOf(formTrayslate.ConfigFile);
  FLastConfig := ComboConfig.ItemIndex;
end;

procedure TformConfigTrayslate.UpdateConfig;
begin
  with formTrayslate.Trans do
  begin
    EditServiceName.Text := ServiceName;
    CheckAutoSwap.Checked := AutoSwap;
    if WebMethod = wmGet then
      ComboMethod.ItemIndex := 0
    else
      ComboMethod.ItemIndex := 1;
    EditUserAgent.Text := UserAgent;
    MemoHeaders.Lines.Assign(Headers);
    CheckEncryptText.Checked := EncryptText;
    MemoUrl.Text := Url;
    EditContentType.Text := ContentType;
    MemoPostData.Text := PostData;
    EditAccept.Text := Accept;
    if ResponseParser = rpJson then
      ComboResponseParser.ItemIndex := 0
    else
      ComboResponseParser.ItemIndex := 1;
    EditJsonPointer.Text := JsonPointer;
    EditRegexp.Text := Regexp;
    MemoLanguages.Lines.Assign(Languages);
    MemoLanguagesTarget.Lines.Assign(LanguagesTarget);

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
    AutoSwap := False;
    WebMethod := wmGet;
    UserAgent := string.Empty;
    Headers.Clear;
    EncryptText := False;
    Url := string.Empty;
    ContentType := string.Empty;
    PostData := string.Empty;
    Accept := string.Empty;
    ResponseParser := rpJson;
    JsonPointer := string.Empty;
    Regexp := string.Empty;
    Languages.Clear;
    LanguagesTarget.Clear;

    InitUserAgent := string.Empty;
    InitHeaders.Clear;
    InitUrl := string.Empty;
    InitParameters.Clear;
    SpinInitLiveTime.Value := 0;

    // Clear controls
    EditServiceName.Text := string.Empty;
    CheckAutoSwap.Checked := False;
    ComboMethod.ItemIndex := 0;
    EditUserAgent.Text := string.Empty;
    EditContentType.Text := string.Empty;
    MemoUrl.Clear;
    MemoPostData.Clear;
    EditAccept.Text := string.Empty;
    ComboResponseParser.ItemIndex := 0;
    EditRegexp.Text := string.Empty;
    EditJsonPointer.Text := string.Empty;
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
      AutoSwap := CheckAutoSwap.Checked;
      if ComboMethod.ItemIndex = 0 then
        WebMethod := wmGet
      else
        WebMethod := wmPost;
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
      if ComboResponseParser.ItemIndex = 0 then
        ResponseParser := rpJson
      else
        ResponseParser := rpRegEx;
      JsonPointer := EditJsonPointer.Text;
      Regexp := EditRegexp.Text;
      Languages.Assign(MemoLanguages.Lines);
      LanguagesTarget.Assign(MemoLanguagesTarget.Lines);

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
  finally
    Screen.Cursor := crDefault;
    Caption := rcaption;
  end;
end;

end.
