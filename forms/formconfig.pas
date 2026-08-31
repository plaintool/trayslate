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
  Menus,
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
  ColorBox,
  LCLType,
  LCLIntf,
  SynEdit,
  SynEditTypes,
  SynHighlighterPas,
  SynEditHighlighterFoldBase,
  oneshottooltip;

type

  { TformConfigTrayslate }

  TformConfigTrayslate = class(TForm)
    AClearIcon: TAction;
    ASaveIconAs: TAction;
    LabelFillTargetLanguages: TLabel;
    LabelSort: TLabel;
    LabelTargetSort: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Popup: TPopupMenu;
    ReloadConfigs: TAction;
    {%Region -fold Form Common}
    aSave: TAction;
    ActionList: TActionList;
    BtnClose: TButton;
    BtnInitParametersTest: TSpeedButton;
    BtnResponseHelp: TSpeedButton;
    BtnScriptResponseHelp: TSpeedButton;
    BtnScriptTest: TSpeedButton;
    BtnScriptHelp: TSpeedButton;
    BtnScriptResponseTest: TSpeedButton;
    BtnUrlTest: TSpeedButton;
    BtnSave: TButton;
    BtnPostDataTest: TSpeedButton;
    BtnResponseTest: TSpeedButton;
    CheckEncodeText: TCheckBox;
    CheckServiceAutoSwap: TCheckBox;
    CheckEncodeCustomParameters: TCheckBox;
    CheckServiceProxy: TCheckBox;
    CheckServiceVisible: TCheckBox;
    CheckServiceRealTime: TCheckBox;
    CheckServiceOnlyButton: TCheckBox;
    ColorDialog: TColorDialog;
    ColorServiceColorRecent: TColorBox;
    ComboMethod: TComboBox;
    ComboConfig: TComboBox;
    ComboValueType: TComboBox;
    EditAccept: TEdit;
    EditUserAgent: TEdit;
    EditContentType: TEdit;
    EditServiceName: TEdit;
    EditInitUserAgent: TEdit;
    GroupBoxCustomParameters: TGroupBox;
    GroupBoxService: TGroupBox;
    GroupInitParameters: TGroupBox;
    GroupLanguagesTarget: TGroupBox;
    GroupRequest: TGroupBox;
    GroupResponse: TGroupBox;
    GroupLanguages: TGroupBox;
    GroupScript: TGroupBox;
    GroupScriptResponse: TGroupBox;
    ImagePreview: TImage;
    LabelAccept: TLabel;
    LabelInitHeaders: TLabel;
    LabelInitParameters: TLabel;
    LabelInitParameters1: TLabel;
    LabelInitParameters4: TLabel;
    LabelInitParemeters: TLabel;
    LabelLanguages1: TLabel;
    LabelLanguagesTarget: TLabel;
    LabelFillLanguages: TLabel;
    LabelInitLiveTime: TLabel;
    LabelMethod: TLabel;
    LabelLanguages: TLabel;
    LabelServiceDescription: TLabel;
    LabelColorRecent: TLabel;
    LabelMaxLength: TLabel;
    LabelValueType: TLabel;
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
    MemoCustomParameters: TMemo;
    MemoServiceDescription: TMemo;
    MemoInitHeaders: TMemo;
    MemoLanguages: TMemo;
    MemoHeaders: TMemo;
    MemoLanguagesTarget: TMemo;
    MemoInitParameters: TMemo;
    MemoURL: TMemo;
    MemoPostData: TMemo;
    MemoInitURL: TMemo;
    MemoJsonPointer: TMemo;
    DialogOpen: TOpenDialog;
    Pages: TPageControl;
    PanelResponse: TPanel;
    PanelScript: TPanel;
    PanelScript1: TPanel;
    PanelTop: TPanel;
    DialogSave: TSaveDialog;
    SbCopyConfig: TSpeedButton;
    SbNewConfig: TSpeedButton;
    SbUpdateConfigs: TSpeedButton;
    ScrollBoxInitialRequest: TScrollBox;
    ScrollBoxRequest: TScrollBox;
    ScrollBoxService: TScrollBox;
    PageService: TTabSheet;
    PageParameters: TTabSheet;
    PageLanguages: TTabSheet;
    PageLanguagesTarget: TTabSheet;
    BtnInitUrlTest: TSpeedButton;
    ShapePreview: TShape;
    SpinInitLiveTime: TSpinEdit;
    PageResponse: TTabSheet;
    SpinServiceOrder: TSpinEdit;
    PageRequest: TTabSheet;
    SpinMaxLength: TSpinEdit;
    PageInitialRequest: TTabSheet;
    SplitterCustomParameters: TSplitter;
    SplitterResponse: TSplitter;
    SynPasSyn: TSynPasSyn;
    SynScriptParameters: TSynEdit;
    SynScriptResponse: TSynEdit;
    procedure AClearIconExecute(Sender: TObject);
    procedure ASaveIconAsExecute(Sender: TObject);
    procedure GroupLanguagesResize(Sender: TObject);
    procedure GroupLanguagesTargetResize(Sender: TObject);
    procedure LabelSortClick(Sender: TObject);
    procedure ReloadConfigsExecute(Sender: TObject);
    procedure BtnResponseHelpClick(Sender: TObject);
    procedure BtnScriptHelpClick(Sender: TObject);
    procedure BtnScriptResponseHelpClick(Sender: TObject);
    procedure BtnScriptResponseTestClick(Sender: TObject);
    procedure BtnScriptTestClick(Sender: TObject);
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
    procedure BtnResponseTestClick(Sender: TObject);
    procedure BtnInitParametersTestClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure ComboConfigChange(Sender: TObject);
    procedure ComboConfigKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ImagePreviewClick(Sender: TObject);
    procedure ImagePreviewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure LabelFillLanguagesClick(Sender: TObject);
    procedure CustomEditEnter(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure SbNewConfigClick(Sender: TObject);
    procedure SplitterCustomParametersMoved(Sender: TObject);
    procedure SplitterResponseMoved(Sender: TObject);
    procedure ValueChange(Sender: TObject);
    procedure SbCopyConfigClick(Sender: TObject);
    {%EndRegion}
  private
    FLastConfig: integer;
    FInUpdateConfig: boolean;
    FIconBase64: string;
    FHint: TOneShotTooltip;

    procedure UpdateIconPreview;
  public
    function TestChanges(AButtons: TMsgDlgButtons = [mbYes, mbNo, mbCancel]): boolean;
    procedure CreateConfig(ACopy: boolean = False);
    procedure DeleteConfig;
    procedure UpdateConfigList(UpdateItemIndex: boolean = True);
    procedure UpdateConfig;
    procedure ClearConfig;
    procedure SaveConfig;
  end;

var
  formConfigTrayslate: TformConfigTrayslate;

  {%Region -fold Resource strings}

resourcestring
  rnamequestion = 'Enter new config file name:';
  rneedsave = 'The configuration was modified. Save changes?';
  rclearlanguages = 'The list is already filled. Do you want to clear it?';
  rcaption = 'Config Editor';
  rdeleteconfigcaption = 'Delete config';
  rdeleteconfig = 'Are you sure you want to delete config';
  rvaluetype1 = 'None';
  rvaluetype2 = 'Language';
  rvaluetype3 = 'Currency All';
  rvaluetype4 = 'Currency Fiat Only';
  rvaluetype5 = 'Currency Crypto Only';
  rvaluetype6 = 'Measurement Units';

  rscripthint =
    'The script is a standard Pascal program: optional var section, then a main begin ... end. block.' +
    sLineBreak + sLineBreak + 'Example:' + sLineBreak + '  var s: string;' + sLineBreak + '  begin' +
    sLineBreak + '    s := GetParam(''text'');' + sLineBreak + '    s := ReplaceAll(s, ''-'', ''_'', False);' +
    sLineBreak + '    SetOutput(''text'', s);' + sLineBreak + '  end.' + sLineBreak + sLineBreak +
    'You can also use standard Pascal constructs (if, for, while, repeat, etc.). ' +
    'You can define your own functions and procedures before the main begin ... end. block.' + sLineBreak +
    sLineBreak + 'Available functions:' + sLineBreak + '  GetParam(''name'') : string' + sLineBreak +
    '    Retrieve an input parameter value.' + sLineBreak + '  SetOutput(''name'', ''value'')' + sLineBreak +
    '    Store an output value for the host.' + sLineBreak + '  GetTimestamp() : Int64' + sLineBreak +
    '    Current Unix timestamp in milliseconds (UTC).' + sLineBreak + '  GetRandom(Length) : Int64' +
    sLineBreak + '    Random integer with exactly Length decimal digits.' + sLineBreak + '  Random : Extended' +
    sLineBreak + '    Random float in the range [0, 1).' + sLineBreak + '  IntToHex(Value, Digits) : string' +
    sLineBreak + '    Convert integer to hexadecimal string with at least Digits characters.' + sLineBreak +
    '  StrToInt(S) : Integer' + sLineBreak + '    Convert a string to an integer. Raises an exception on invalid input.' +
    sLineBreak + '  IntToStr(Value) : string' + sLineBreak + '    Convert an integer to its string representation.' +
    sLineBreak + '  Trim(S) : string' + sLineBreak + '    Remove leading and trailing whitespace from S.' +
    sLineBreak + '  TrimLeft(S) : string' + sLineBreak + '    Remove leading whitespace from S.' + sLineBreak +
    '  TrimRight(S) : string' + sLineBreak + '    Remove trailing whitespace from S.' + sLineBreak +
    '  HtmlEncode(S) : string' + sLineBreak + '    Encode special HTML characters in S into entities.' +
    sLineBreak + '  HtmlDecode(S) : string' + sLineBreak + '    Decode HTML entities in S back to characters.' +
    sLineBreak + '  UrlEncode(S) : string' + sLineBreak + '    Percent-encode S for safe URL inclusion.' +
    sLineBreak + '  UrlDecode(S) : string' + sLineBreak + '    Decode a percent-encoded string S.' +
    sLineBreak + '  ReplaceAll(S, OldPattern, NewPattern, IgnoreCase=False) : string' + sLineBreak +
    '    Replace all occurrences of OldPattern with NewPattern in S.' + sLineBreak +
    '  RegexReplace(Input, Pattern, Replacement) : string' + sLineBreak +
    '    Replace all regex matches of Pattern with Replacement in Input. Case-insensitive.' + sLineBreak +
    '  RegexMatch(Input, Pattern) : Boolean' + sLineBreak + '    Check if Input matches the regex Pattern. Case-insensitive.' +
    sLineBreak + '  ExtractBetween(S, StartMarker, EndMarker) : string' + sLineBreak +
    '    Extract the substring of S between StartMarker and EndMarker.' + sLineBreak + sLineBreak +
    'JSON functions (use a handle returned by JSONParse):' + sLineBreak + '  JSONParse(S) : Integer' +
    sLineBreak + '    Parse a JSON string and return a handle (>=0). Returns -1 on error.' + sLineBreak +
    '  JSONFree(Handle)' + sLineBreak + '    Release the handle after use.' + sLineBreak +
    '  JSONGetString(Handle, Path) : string' + sLineBreak + '    Get a string value at the specified Path.' +
    sLineBreak + '  JSONGetInt(Handle, Path) : Integer' + sLineBreak + '    Get an integer value at the specified Path.' +
    sLineBreak + '  JSONGetFloat(Handle, Path) : Extended' + sLineBreak + '    Get a floating-point value at the specified Path.' +
    sLineBreak + '  JSONGetBool(Handle, Path) : Boolean' + sLineBreak + '    Get a boolean value at the specified Path.' +
    sLineBreak + '  JSONGetArrayCount(Handle, Path) : Integer' + sLineBreak +
    '    Get the number of elements in an array at the specified Path.' + sLineBreak +
    '  JSONGetArrayString(Handle, Path, Index) : string' + sLineBreak +
    '    Get the string value of an array element at the given Index.' + sLineBreak +
    '  JSONGetArrayInt(Handle, Path, Index) : Integer' + sLineBreak +
    '    Get the integer value of an array element at the given Index.' + sLineBreak + '  JSONGetType(Handle, Path) : string' +
    sLineBreak + '    Return the type of the value at Path: "object", "array", "string", "int", "float", "bool", "null".' +
    sLineBreak + '  JSONPathExists(Handle, Path) : Boolean' + sLineBreak + '    Check if the specified Path exists.' +
    sLineBreak + '  JSONResultInit' + sLineBreak + '    Initialize an empty JSON array for building a standard error result.' +
    sLineBreak + '  JSONResultAddError(Offset, Length, Message, Replacements)' + sLineBreak +
    '    Add an error object to the result array. Replacements is a string of values separated by "|".' +
    sLineBreak + '  JSONResultGet : string' + sLineBreak + '    Return the current result array as a JSON string.' +
    sLineBreak + '  JSONResultClear' + sLineBreak + '    Clear the result array.' + sLineBreak +
    '  Always call JSONFree to release the handle after you are done.' + sLineBreak + sLineBreak +
    'Example of working with JSON:' + sLineBreak + '  var h: Integer;' + sLineBreak + '      s: string;' +
    sLineBreak + '  begin' + sLineBreak + '    h := JSONParse(GetParam(''result''));' + sLineBreak +
    '    if h >= 0 then' + sLineBreak + '    begin' + sLineBreak + '      s := JSONGetString(h, ''some.path'');' +
    sLineBreak + '      SetOutput(''text'', s);' + sLineBreak + '      JSONFree(h);' + sLineBreak + '    end;' +
    sLineBreak + '  end.' + sLineBreak + sLineBreak + 'Available parameters (retrieved with GetParam):' +
    sLineBreak + '  text - the input text to process (possibly truncated to MaxLength)' + sLineBreak +
    '  source - source language code (may be empty)' + sLineBreak + '  target - target language code' +
    sLineBreak + '  timestamp - current Unix timestamp in milliseconds (string)' + sLineBreak +
    '  random  - 9-digit random number (string)' + sLineBreak + '  rand - same as random' + sLineBreak +
    '  rand1..rand9 - first 1..9 digits of the random number' + sLineBreak + sLineBreak +
    'Additional initial and custom parameters are also available.';

  rscriptresponsehint =
    'This script processes the response data. All functions and parameters described in the script hint are available here as well.' +
    sLineBreak + 'Use GetParam(''result'') to obtain the received text.' + sLineBreak + sLineBreak + 'Example:' +
    sLineBreak + '  var s: string;' + sLineBreak + '  begin' + sLineBreak + '    s := GetParam(''result'');' +
    sLineBreak + '    SetOutput(''result'', s);' + sLineBreak + '  end.' + sLineBreak + sLineBreak +
    'You can define custom parameters in the parameters script using SetParam(''name'', ''value''),' +
    sLineBreak + 'and then retrieve them here with GetParam(''name'').';

  rresponsehint =
    'Json Pointer: Use / for levels, keys for objects, and numbers for indexes.' + sLineBreak +
    'Use * for all items, *#10 to join items by newline. Use ~ at the end of the path to return the raw JSON branch.' +
    sLineBreak + 'Separate multiple segments with semicolon ;.' + sLineBreak +
    'Literal: Text block in {…}. Special tag #10 for newlines. Use {{regex}} inside to extract data directly into the text.' +
    sLineBreak + 'Logic: If a Pointer in a segment is empty, the whole segment is skipped. If a segment has no Pointer, only literal text blocks with embedded regular expressions are processed.' + sLineBreak + 'Regex: {prefix {regex[index]} suffix} inside a text block. If no [index] is specified, the first match is used.' + sLineBreak + 'Index can be a number, [*] (join by space), or [*#10] (join by newline). If the regex finds no match, the entire {…} block is removed.' + sLineBreak + 'Using ~ inside a regex returns the entire text.' + sLineBreak + 'Inversion: Start a segment with ! (e.g. !/path{Error}) to show its text only if the Pointer data is missing or the JSON is invalid.' + sLineBreak + 'Commenting: /* text */ comments are stripped from the entire expression before any processing.' + sLineBreak + 'Examples:' + sLineBreak + 'responseData/translatedText; matches/*#10/translation; /texts/text; {literal text#10}; /result/text; /text{ ({(\w+)})}; !/translations{Error: No data!#10}; /translations/0/text';

  {%EndRegion}

implementation

uses Consts, mainform, formsettings, translate, languages, network, stringhelper, base64utils,
  localize, darkutils, controlshelper, osutils;

  {$R *.lfm}

  { TformConfigTrayslate }

procedure TformConfigTrayslate.FormCreate(Sender: TObject);
var
  i: integer;
begin
  TLocalize.ApplicationTranslate(APP_NAME, language, self, TLocalize.LoadCustomPoFile(formTrayslate.CustomPoFile));

  Pages.PageIndex := 0;
  BtnClose.Cancel := True;
  LabelFillLanguages.Font.Color := TDarkUtils.ThemeColor(clBlue, clSkyBlue);
  ColorServiceColorRecent.AddCustomColors;

  ReloadConfigs.ImageIndex := TDarkUtils.ThemeValue(24, 25);

  ComboValueType.Items.Clear;
  ComboValueType.Items.Add(rvaluetype1);
  ComboValueType.Items.Add(rvaluetype2);
  ComboValueType.Items.Add(rvaluetype3);
  ComboValueType.Items.Add(rvaluetype4);
  ComboValueType.Items.Add(rvaluetype5);
  ComboValueType.Items.Add(rvaluetype6);
  ComboValueType.ItemIndex := Ord(formTrayslate.Trans.LangType);

  SynScriptParameters.TabWidth := 2;
  SynScriptParameters.Options := SynScriptParameters.Options + [eoTabsToSpaces];
  SynScriptParameters.Font.Color := clWindowText;
  SynScriptParameters.Gutter.LineNumberPart.MarkupInfo.Foreground := clWindowText;
  for i := 0 to SynPasSyn.FoldConfigCount - 1 do
    SynPasSyn.FoldConfig[i].Modes :=
      SynPasSyn.FoldConfig[i].Modes - [fmHide];

  SynScriptResponse.TabWidth := 2;
  SynScriptResponse.Options := SynScriptResponse.Options + [eoTabsToSpaces];
  SynScriptResponse.Font.Color := clWindowText;
  SynScriptResponse.Gutter.LineNumberPart.MarkupInfo.Foreground := clWindowText;
  for i := 0 to SynPasSyn.FoldConfigCount - 1 do
    SynPasSyn.FoldConfig[i].Modes :=
      SynPasSyn.FoldConfig[i].Modes - [fmHide];

  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TCustomEdit then
    begin
      (Components[i] as TCustomEdit).Font.Assign(SynScriptParameters.Font);
      (Components[i] as TCustomEdit).OnEnter := @CustomEditEnter;
    end;
    if Components[i] is TCustomComboBox and (Components[i] <> ComboConfig) then
      (Components[i] as TCustomComboBox).Font.Assign(SynScriptParameters.Font);
    if Components[i] is TCustomCheckBox then
      (Components[i] as TCustomCheckBox).Font.Assign(SynScriptParameters.Font);
  end;
end;

procedure TformConfigTrayslate.FormShow(Sender: TObject);
begin
  UpdateConfigList;
  UpdateConfig;
  formTrayslate.TopMost := False;
  Self.FitToScreen;
end;

procedure TformConfigTrayslate.FormDestroy(Sender: TObject);
begin
  formConfigTrayslate := nil;
  FreeAndNil(FHint);
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
  GroupBoxCustomParameters.Top := 0;
  SplitterCustomParameters.Top := GroupBoxCustomParameters.Height;
  GroupResponse.Top := 0;
  SplitterResponse.Top := GroupResponse.Height;

  formTrayslate.FormConfigWidth := Width;
  formTrayslate.FormConfigHeight := Height;
  formTrayslate.FormConfigSep1 := GroupBoxCustomParameters.Height;
  formTrayslate.FormConfigSep2 := GroupResponse.Height;
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
      Get(True).OpenStringInTextEditor;
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
      Post(True).OpenStringInTextEditor;
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
      GetInit.OpenStringInTextEditor;
    end;
  finally
    Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TformConfigTrayslate.BtnResponseTestClick(Sender: TObject);
begin
  Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    if (MemoJsonPointer.Text = string.empty) or (formTrayslate.MemoTarget.Text = string.Empty) or not TestChanges then exit;
    with formTrayslate.Trans do
      ParseResponse(formTrayslate.RawTranslate).OpenStringInTextEditor;
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
      if GetParameters(GetInit) then
        ParameterValues.Text.OpenStringInTextEditor;
    end;
  finally
    Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TformConfigTrayslate.BtnScriptTestClick(Sender: TObject);
begin
  Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    if (SynScriptParameters.Text = string.empty) or not TestChanges then exit;
    with formTrayslate.Trans do
    begin
      ParametersAge := Now + 3650;
      if GetParameters(GetInit) then
        ParameterValues.Text.OpenStringInTextEditor;
    end;
  finally
    Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TformConfigTrayslate.BtnScriptResponseTestClick(Sender: TObject);
begin
  Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    if (SynScriptResponse.Text = string.empty) or not TestChanges then exit;
    with formTrayslate.Trans do
    begin
      ParametersAge := Now + 3650;
      Translate.OpenStringInTextEditor;
    end;
  finally
    Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TformConfigTrayslate.BtnScriptHelpClick(Sender: TObject);
begin
  if not Assigned(FHint) then
    FHint := TOneShotTooltip.Create(Self);
  FHint.ShowHintText(rscripthint, BtnScriptHelp.ClientOrigin.X, BtnScriptHelp.ClientOrigin.Y + BtnScriptHelp.Height, 500, 300);
end;

procedure TformConfigTrayslate.BtnScriptResponseHelpClick(Sender: TObject);
begin
  if not Assigned(FHint) then
    FHint := TOneShotTooltip.Create(Self);
  FHint.ShowHintText(rscriptresponsehint, BtnScriptResponseHelp.ClientOrigin.X,
    BtnScriptResponseHelp.ClientOrigin.Y + BtnScriptResponseHelp.Height, 500);
end;

procedure TformConfigTrayslate.BtnResponseHelpClick(Sender: TObject);
begin
  if not Assigned(FHint) then
    FHint := TOneShotTooltip.Create(Self);
  FHint.ShowHintText(rresponsehint, BtnResponseHelp.ClientOrigin.X, BtnResponseHelp.ClientOrigin.Y + BtnResponseHelp.Height, 500);
end;

procedure TformConfigTrayslate.ReloadConfigsExecute(Sender: TObject);
var
  LastIndex: integer;
begin
  Screen.Cursor := crHourGlass;
  try
    LastIndex := ComboConfig.ItemIndex;
    TTranslate.GetIniFiles(formTrayslate.ConfigFiles);
    formTrayslate.BuildConfigMenu;
    Application.QueueAsyncCall(@formTrayslate.RebuildLangPairsPanel, 0);
    UpdateConfigList;
    if (LastIndex >= ComboConfig.Items.Count) then Dec(LastIndex);
    ComboConfig.ItemIndex := LastIndex;
    ComboConfigChange(Self);
    UpdateConfig;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TformConfigTrayslate.AClearIconExecute(Sender: TObject);
begin
  FIconBase64 := string.Empty;
  UpdateIconPreview;
  ValueChange(Self);
end;

procedure TformConfigTrayslate.ASaveIconAsExecute(Sender: TObject);
var
  Bmp: TBitmap;
begin
  if formTrayslate.Trans.ServiceName <> string.Empty then
    DialogSave.FileName := formTrayslate.Trans.ServiceName;
  if DialogSave.Execute then
  begin
    Bmp := TBase64.Base64ToBitmap(FIconBase64);
    if Assigned(Bmp) then
    begin
      try
        Bmp.SaveToFile(DialogSave.FileName);
      finally
        Bmp.Free;
      end;
    end;
  end;
end;

procedure TformConfigTrayslate.GroupLanguagesResize(Sender: TObject);
begin
  LabelSort.Left := LabelFillLanguages.BoundsRect.Right + 10;
end;

procedure TformConfigTrayslate.GroupLanguagesTargetResize(Sender: TObject);
begin
  LabelTargetSort.Left := LabelFillTargetLanguages.BoundsRect.Right + 10;
end;

procedure TformConfigTrayslate.LabelFillLanguagesClick(Sender: TObject);
var
  List: TStringList;
  AMemo: TMemo;
begin
  if Sender = LabelFillLanguages then
    AMemo := MemoLanguages
  else
    AMemo := MemoLanguagesTarget;

  if AMemo.Lines.Count > 0 then
  begin
    if MessageDlg(rclearlanguages, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      Exit;

    AMemo.Clear;
  end;

  List := TLanguages.GetLanguageCodePairList(TLangType(ComboValueType.ItemIndex), True);
  try
    AMemo.Lines.Assign(List);
  finally
    List.Free;
  end;
end;

procedure TformConfigTrayslate.LabelSortClick(Sender: TObject);
var
  sl: TStringList;
  AMemo: TMemo;
begin
  if Sender = LabelSort then
    AMemo := MemoLanguages
  else
    AMemo := MemoLanguagesTarget;

  sl := TStringList.Create;
  try
    sl.Assign(AMemo.Lines);
    sl.Sort;
    AMemo.Lines.BeginUpdate;
    try
      AMemo.Lines.Assign(sl);
    finally
      AMemo.Lines.EndUpdate;
    end;
  finally
    sl.Free;
  end;
end;

procedure TformConfigTrayslate.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TformConfigTrayslate.ComboConfigChange(Sender: TObject);
var
  LastEnabled: boolean;
begin
  if formTrayslate.Visible then
  begin
    LastEnabled := formTrayslate.Enabled;
    formTrayslate.Enabled := False;
  end;

  FInUpdateConfig := True;
  try
    if not TestChanges then
    begin
      if (FLastConfig >= 0) and (FLastConfig < ComboConfig.Items.Count) then
        ComboConfig.ItemIndex := FLastConfig;
      exit;
    end;
    formTrayslate.ConfigFile := ComboConfig.Text;
    formTrayslate.LoadConfig;
    UpdateConfig;
    FLastConfig := ComboConfig.ItemIndex;
  finally
    FInUpdateConfig := False;
    if formTrayslate.Visible then
      formTrayslate.Enabled := LastEnabled;
    if Visible and CanFocus then SetFocus;
  end;
end;

procedure TformConfigTrayslate.ComboConfigKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in shift) and (Key = VK_C) then
  begin
    Clipboard.AsText := ComboConfig.Text;
    Key := 0;
  end;

  if (ComboConfig.Focused) and (Key = VK_DELETE) then
  begin
    DeleteConfig;
    Key := 0;
  end;
end;

procedure TformConfigTrayslate.ImagePreviewClick(Sender: TObject);
begin
  if DialogOpen.Execute then
  begin
    FIconBase64 := TBase64.LoadImageFileToBase64(DialogOpen.FileName);
    UpdateIconPreview;
    ValueChange(Self);
  end;
end;

procedure TformConfigTrayslate.ImagePreviewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if Button = mbMiddle then
    AClearIcon.Execute;
end;

procedure TformConfigTrayslate.CustomEditEnter(Sender: TObject);
begin
  if Sender is TCustomEdit then
    TCustomEdit(Sender).SetCaretWidth;
end;

procedure TformConfigTrayslate.MemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = VK_V) then // Ctrl + V
  begin
    (Sender as TMemo).PasteWithLineEnding;
    Key := 0;
  end;
end;

procedure TformConfigTrayslate.ValueChange(Sender: TObject);
begin
  if not FInUpdateConfig then
  begin
    aSave.Enabled := True;
    Caption := '*' + rcaption;
  end;
end;

procedure TformConfigTrayslate.SbNewConfigClick(Sender: TObject);
begin
  CreateConfig;
end;

procedure TformConfigTrayslate.SplitterCustomParametersMoved(Sender: TObject);
begin
  formTrayslate.FormConfigSep1 := GroupBoxCustomParameters.Height;
end;

procedure TformConfigTrayslate.SplitterResponseMoved(Sender: TObject);
begin
  formTrayslate.FormConfigSep2 := GroupResponse.Height;
end;

procedure TformConfigTrayslate.SbCopyConfigClick(Sender: TObject);
begin
  CreateConfig(True);
end;

procedure TformConfigTrayslate.UpdateIconPreview;
var
  Bmp: TBitmap;
begin
  Bmp := TBase64.Base64ToBitmap(FIconBase64);
  if Assigned(Bmp) then
  begin
    try
      ImagePreview.Picture.Assign(Bmp);
    finally
      Bmp.Free;
    end;
  end
  else
    ImagePreview.Picture.Clear;
end;

function TformConfigTrayslate.TestChanges(AButtons: TMsgDlgButtons = [mbYes, mbNo, mbCancel]): boolean;
var
  res: TModalResult;
begin
  Result := True;
  if not Assigned(aSave) or not aSave.Enabled then
    Exit;

  res := MessageDlg(rneedsave, mtConfirmation, AButtons, 0);

  case res of
    mrYes:
      SaveConfig; // save and continue

    mrNo:
      UpdateConfig; // revert changes

    mrCancel:
      Result := False; // cancel action
    else
      Result := False; // safety fallback
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
  if not InputQueryLite(ifthen(ACopy, SbCopyConfig.Hint, SbNewConfig.Hint), rnamequestion, NewName) then
    Exit; // user pressed Cancel

  NewName := Trim(NewName);
  if NewName = string.Empty then Exit;

  // Add .ini extension if missing
  if not SameText(ExtractFileExt(NewName), '.ini') then
    NewName := NewName + '.ini';

  if NewName = ExtractFileName(ComboConfig.Text) then Exit;

  SourceFile := ComboConfig.Text;
  DestFile := IncludeTrailingPathDelimiter(TOS.GetSettingsDirectory(APP_NAME)) + NewName;

  if FileExists(DestFile) then Exit;

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
  formTrayslate.BuildConfigMenu;
  formTrayslate.ConfigFile := DestFile;
  formTrayslate.LoadConfig;
  UpdateConfigList;
  UpdateConfig;
end;

procedure TformConfigTrayslate.DeleteConfig;
var
  FileName: string;
  idx, LastIndex: integer;
begin
  FileName := ComboConfig.Text;
  LastIndex := ComboConfig.ItemIndex;

  if FileName = string.Empty then Exit;

  // Ask user for confirmation
  if MessageDlg(rdeleteconfigcaption, rdeleteconfig + ' ' + ExtractFileName(FileName) + '?', mtConfirmation,
    [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    if FileExists(FileName) then
      DeleteFile(FileName);

    // Remove from list
    idx := formTrayslate.ConfigFiles.IndexOf(FileName);
    if idx >= 0 then
      formTrayslate.ConfigFiles.Delete(idx);

    // Reset current config
    formTrayslate.ConfigFile := string.Empty;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;

  formTrayslate.BuildConfigMenu;
  // Reload UI
  UpdateConfigList;
  if (LastIndex >= ComboConfig.Items.Count) then Dec(LastIndex);
  ComboConfig.ItemIndex := LastIndex;
  ComboConfigChange(Self);
  UpdateConfig;
end;

procedure TformConfigTrayslate.UpdateConfigList(UpdateItemIndex: boolean = True);
var
  idx: integer;
begin
  ComboConfig.Items.Assign(formTrayslate.ConfigFiles);
  if UpdateItemIndex then
  begin
    idx := ComboConfig.Items.IndexOf(formTrayslate.ConfigFile);
    if idx >= 0 then
      ComboConfig.ItemIndex := idx
    else
      ComboConfig.ItemIndex := -1;
  end;
  FLastConfig := ComboConfig.ItemIndex;

  if Assigned(formSettingsTrayslate) and formSettingsTrayslate.Visible then
    formSettingsTrayslate.FillConfigs;
end;

procedure TformConfigTrayslate.UpdateConfig;
begin
  with formTrayslate.Trans do
  begin
    EditServiceName.Text := ServiceName;
    FIconBase64 := ServiceIcon;
    UpdateIconPreview;
    SpinServiceOrder.Value := ServiceOrder;
    CheckServiceVisible.Checked := ServiceVisible;
    CheckServiceAutoSwap.Checked := ServiceAutoSwap;
    CheckServiceRealTime.Checked := ServiceRealTime;
    CheckServiceOnlyButton.Checked := ServiceOnlyButton;
    CheckServiceProxy.Checked := ServiceProxy;
    ColorServiceColorRecent.Selected := ServiceColorRecent;
    MemoServiceDescription.Lines.Assign(ServiceDescription);

    ComboMethod.ItemIndex := Ord(WebMethod);
    EditUserAgent.Text := UserAgent;
    MemoHeaders.Lines.Assign(Headers);
    MemoCustomParameters.Lines.Assign(CustomParameters);
    SynScriptParameters.Lines.Assign(ScriptParameters);
    SynScriptResponse.Lines.Assign(ScriptResponse);
    CheckEncodeText.Checked := EncodeText;
    SpinMaxLength.Value := MaxLength;
    CheckEncodeCustomParameters.Checked := EncodeCustomParameters;
    MemoUrl.Text := Url;
    EditContentType.Text := ContentType;
    MemoPostData.Text := PostData;
    EditAccept.Text := Accept;
    MemoJsonPointer.Text := JsonPointer;

    MemoLanguages.Lines.Assign(LanguagesOriginal);
    MemoLanguages.RemoveSameNameValueFromMemo;

    MemoLanguagesTarget.Lines.Assign(LanguagesTargetOriginal);
    MemoLanguagesTarget.RemoveSameNameValueFromMemo;

    ComboValueType.ItemIndex := Ord(LangType);
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
    Clear;
    UpdateConfig;
  end;

  aSave.Enabled := False;
  Caption := rcaption;
end;

procedure TformConfigTrayslate.SaveConfig;
var
  TempHeaders: TStringList;
  LastEnabled: boolean;
begin
  if formTrayslate.Visible then
  begin
    LastEnabled := formTrayslate.Enabled;
    formTrayslate.Enabled := False;
  end;

  if (formTrayslate.ConfigFile = string.Empty) then
    CreateConfig;

  if (formTrayslate.ConfigFile = string.Empty) then
    exit;

  Screen.Cursor := crHourGlass;
  try
    with formTrayslate.Trans do
    begin
      ServiceName := EditServiceName.Text;
      ServiceIcon := FIconBase64;
      ServiceOrder := SpinServiceOrder.Value;
      ServiceVisible := CheckServiceVisible.Checked;
      ServiceAutoSwap := CheckServiceAutoSwap.Checked;
      ServiceRealTime := CheckServiceRealTime.Checked;
      ServiceOnlyButton := CheckServiceOnlyButton.Checked;
      ServiceProxy := CheckServiceProxy.Checked;
      ServiceColorRecent := ColorServiceColorRecent.Selected;
      ServiceDescription.Text := MemoServiceDescription.Text;

      WebMethod := TWebMethod(ComboMethod.ItemIndex);
      UserAgent := EditUserAgent.Text;
      EncodeText := CheckEncodeText.Checked;
      MaxLength := SpinMaxLength.Value;

      TempHeaders := MemoHeaders.HeadersFromMemo;
      try
        Headers.Text := TempHeaders.Text;
      finally
        TempHeaders.Free;
      end;

      Url := MemoUrl.Text;
      ContentType := EditContentType.Text;
      PostData := MemoPostData.Text;
      Accept := EditAccept.Text;
      JsonPointer := MemoJsonPointer.Text;
      LanguagesOriginal.Text := MemoLanguages.Text;
      LanguagesTargetOriginal.Text := MemoLanguagesTarget.Text;
      Languages.Assign(LanguagesOriginal);
      LanguagesTarget.Assign(LanguagesTargetOriginal);
      LangType := TLangType(ComboValueType.ItemIndex);
      EncodeCustomParameters := CheckEncodeCustomParameters.Checked;
      CustomParameters.Text := MemoCustomParameters.Text;
      ScriptParameters.Text := SynScriptParameters.Text;
      ScriptResponse.Text := SynScriptResponse.Text;
      InitUserAgent := EditInitUserAgent.Text;

      TempHeaders := MemoInitHeaders.HeadersFromMemo;
      try
        InitHeaders.Text := TempHeaders.Text;
      finally
        TempHeaders.Free;
      end;

      InitUrl := MemoInitUrl.Text;
      InitParameters.Text := MemoInitParameters.Text;
      InitLiveTime := SpinInitLiveTime.Value;
    end;
    formTrayslate.Trans.SaveIniSettings(formTrayslate.ConfigFile);
    aSave.Enabled := False;
    formTrayslate.LoadConfig;
    formTrayslate.BuildConfigMenu;
    Application.QueueAsyncCall(@formTrayslate.RebuildLangPairsPanel, 0);
    UpdateConfigList(False);
  finally
    Screen.Cursor := crDefault;
    Caption := rcaption;
    if formTrayslate.Visible then
      formTrayslate.Enabled := LastEnabled;
    if Visible and CanFocus then SetFocus;
  end;
end;

end.
