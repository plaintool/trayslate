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
  LCLType, ActnList;

type

  { TformConfigTrayslator }

  TformConfigTrayslator = class(TForm)
    aSave: TAction;
    ActionList: TActionList;
    BtnClose: TButton;
    BtnSave: TButton;
    ComboMethod: TComboBox;
    ComboConfig: TComboBox;
    ComboResponseParser: TComboBox;
    EditJsonKeys: TEdit;
    EditUserAgent: TEdit;
    EditContentType: TEdit;
    EditRegexp: TEdit;
    GroupRequest: TGroupBox;
    GroupResponse: TGroupBox;
    GroupLanguages: TGroupBox;
    LabelMethod: TLabel;
    LabelParemeters1: TLabel;
    LabelParemeters2: TLabel;
    LabelPostData: TLabel;
    LabelJsonKeys: TLabel;
    LabelUserAgent: TLabel;
    LabelContentType: TLabel;
    LabelUrl: TLabel;
    LabelParemeters: TLabel;
    LabelResponseParser: TLabel;
    LabelRegexp: TLabel;
    MemoLanguages: TMemo;
    MemoURL: TMemo;
    MemoPostData: TMemo;
    PanelTop: TPanel;
    PanelConfig: TPanel;
    SbCopyConfig: TSpeedButton;
    ScrollBoxConfig: TScrollBox;
    procedure aSaveExecute(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure ComboConfigChange(Sender: TObject);
    procedure ComboConfigKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ValueChange(Sender: TObject);
    procedure SbCopyConfigClick(Sender: TObject);
  private
    FLastConfig: integer;
  public
    procedure UpdateConfigList;
    procedure UpdateConfig;
    function TestChanges: boolean;
    procedure SaveConfig;
  end;

var
  formConfigTrayslator: TformConfigTrayslator;

resourcestring
  rcopyquestion = 'Enter new config file name:';
  rneedsave = 'The configuration was modified. Save changes?';

implementation

uses mainform, translate, settings;

  {$R *.lfm}

  { TformConfigTrayslator }

procedure TformConfigTrayslator.FormShow(Sender: TObject);
begin
  UpdateConfigList;
  UpdateConfig;
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

procedure TformConfigTrayslator.SbCopyConfigClick(Sender: TObject);
var
  NewName: string;
  SourceFile: string;
  DestFile: string;
begin
  if not TestChanges then exit;

  NewName := ExtractFileName(ComboConfig.Text);

  // Ask user for new config name
  if not InputQuery(SbCopyConfig.Hint, rcopyquestion, NewName) then
    Exit; // user pressed Cancel

  NewName := Trim(NewName);
  if NewName = string.Empty then
    Exit;

  // Add .ini extension if missing
  if ExtractFileExt(NewName) = string.Empty then
    NewName := NewName + '.ini';

  if NewName = ExtractFileName(ComboConfig.Text) then
    Exit;

  SourceFile := ComboConfig.Text;
  DestFile := IncludeTrailingPathDelimiter(GetSettingsDirectory) + NewName;

  // Copy config file
  try
    CopyFile(SourceFile, DestFile, [], True);
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

procedure TformConfigTrayslator.ValueChange(Sender: TObject);
begin
  BtnSave.Enabled := True;
  Caption := '*Config Editor';
end;

procedure TformConfigTrayslator.BtnCloseClick(Sender: TObject);
begin
  if not TestChanges then exit;
  Hide;
end;

procedure TformConfigTrayslator.aSaveExecute(Sender: TObject);
begin
  SaveConfig;
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
    if WebMethod = wmGet then
      ComboMethod.ItemIndex := 0
    else
      ComboMethod.ItemIndex := 1;
    EditUserAgent.Text := UserAgent;
    EditContentType.Text := ContentType;
    MemoUrl.Text := Url;
    MemoPostData.Text := PostData;
    if ResponseParser = rpJson then
      ComboResponseParser.ItemIndex := 0
    else
      ComboResponseParser.ItemIndex := 1;
    EditRegexp.Text := Regexp;
    EditJsonKeys.Text := JsonPath;
    MemoLanguages.Lines.Assign(Languages);
  end;
  BtnSave.Enabled := False;
  Caption := 'Config Editor';
end;

function TformConfigTrayslator.TestChanges: boolean;
var
  res: TModalResult;
begin
  Result := True;
  if (BtnSave.Enabled) then
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

procedure TformConfigTrayslator.SaveConfig;
begin
  try
    with formTrayslator.Trans do
    begin
      if ComboMethod.ItemIndex = 0 then
        WebMethod := wmGet
      else
        WebMethod := wmPost;
      UserAgent := EditUserAgent.Text;
      ContentType := EditContentType.Text;
      Url := MemoUrl.Text;
      PostData := MemoPostData.Text;
      if ComboResponseParser.ItemIndex = 0 then
        ResponseParser := rpJson
      else
        ResponseParser := rpRegEx;
      Regexp := EditRegexp.Text;
      JsonPath := EditJsonKeys.Text;
      Languages.Assign(MemoLanguages.Lines);
    end;
    SaveIniSettings(formTrayslator.Trans, formTrayslator.ConfigFile);
    formTrayslator.LoadConfig;
  finally
    BtnSave.Enabled := False;
    Caption := 'Config Editor';
  end;
end;

end.
