unit formconfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  FileUtil,
  Buttons;

type

  { TformConfigTrayslator }

  TformConfigTrayslator = class(TForm)
    ButtonClose: TButton;
    ComboConfig: TComboBox;
    PanelTop: TPanel;
    PanelConfig: TPanel;
    SbCopyConfig: TSpeedButton;
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SbCopyConfigClick(Sender: TObject);
  private
    procedure UpdateConfigList;
  public

  end;

var
  formConfigTrayslator: TformConfigTrayslator;

resourcestring
  copyquestion = 'Enter new config file name:';

implementation

uses mainform;

  {$R *.lfm}

  { TformConfigTrayslator }

procedure TformConfigTrayslator.FormCreate(Sender: TObject);
begin
  UpdateConfigList;
end;

procedure TformConfigTrayslator.SbCopyConfigClick(Sender: TObject);
var
  NewName: string;
  SourceFile: string;
  DestFile: string;
begin
  NewName := ExtractFileName(ComboConfig.Text);

  // Ask user for new config name
  if not InputQuery(SbCopyConfig.Hint, copyquestion, NewName) then
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
  DestFile := IncludeTrailingPathDelimiter(ExtractFilePath(ComboConfig.Text)) + NewName;

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
end;

procedure TformConfigTrayslator.ButtonCloseClick(Sender: TObject);
begin
  Hide;
end;

procedure TformConfigTrayslator.UpdateConfigList;
begin
  ComboConfig.Items.Assign(formTrayslator.ConfigFiles);
  ComboConfig.ItemIndex := ComboConfig.Items.IndexOf(formTrayslator.ConfigFile);
end;

end.
