//-----------------------------------------------------------------------------------
//  Trayslator © 2024 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit langtool;

{$mode ObjFPC}{$H+}
{$codepage utf8}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  Classes,
  Graphics,
  Types,
  SysUtils,
  StdCtrls,
  LCLType,
  LCLIntf,
  fpjson,
  jsonparser;

type
  THotKeyData = record
    Modifiers: cardinal;  // MOD_CONTROL, MOD_SHIFT...
    Key: word;            // virtual key code
  end;

{$IFDEF WINDOWS}

const
  HOTKEY_APP = 1;
  HOTKEY_TRANS_SWAP = 2;
  HOTKEY_TRANS_FROM_CLIPBOARD = 3;
  HOTKEY_TRANS_CLIPBOARD = 4;
  HOTKEY_TRANS_FROM_CONTROL = 5;
  HOTKEY_TRANS_CONTROL = 6;

{$ENDIF}

function CreateTrayIconLang(const ALang1: string; const ALang2: string = ''; ABackgroundColor: TColor = $00FF9628;
  AFontColor: TColor = $00DCDCDC): TIcon;

procedure SetComboBoxByCode(ComboBox: TComboBox; const Code: string);

function HeadersFromMemo(AMemo: TMemo): TStringList;

function ParseJsonByPointer(const JsonStr, JsonPointer: string): string;

function HotKeyToText(const AHotKey: THotKeyData): string;

implementation

uses languages;

function CreateTrayIconLang(const ALang1: string; const ALang2: string = ''; ABackgroundColor: TColor = $00FF9628;
  AFontColor: TColor = $00DCDCDC): TIcon;
var
  bmp: TBitmap;
  rect, rect1, rect2: TRect;
  Value: string;

  function FormatValue(const Value: string; DefSize: integer = 8): string;
  begin
    Result := Value;
    if Pos('-', Result) > 0 then
      Result := LeftStr(Result, Pos('-', Result + '-') - 1);

    if (Length(Result) = 3) then
      bmp.Canvas.Font.Size := 5
    else
    begin
      bmp.Canvas.Font.Size := DefSize;
      Result := Result.Substring(0, 2);
    end;
  end;

begin
  bmp := TBitmap.Create;
  Result := TIcon.Create;
  try
    bmp.Width := 16;  // standard tray icon size
    bmp.Height := 16;
    bmp.PixelFormat := pf32bit;

    // set background
    bmp.Canvas.Brush.Style := bsSolid;
    bmp.Canvas.Brush.Color := ABackgroundColor;
    rect := Types.Rect(0, 0, bmp.Width, bmp.Height);
    bmp.Canvas.FillRect(rect);

    // set text style
    bmp.Canvas.Font.Name := 'Tahoma';
    bmp.Canvas.Font.Color := AFontColor;
    bmp.Canvas.Font.Style := [fsBold];

    if (ALang2 = string.Empty) then
    begin
      // draw text centered
      Value := FormatValue(ALang1);
      DrawText(bmp.Canvas.Handle, PChar(Value), Length(Value), rect,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
    else
    begin
      // upper half
      Value := FormatValue(ALang1, 7);
      rect1 := Types.Rect(rect.Left, rect.Top, rect.Right, (rect.Top + rect.Bottom) div 2);
      DrawText(bmp.Canvas.Handle, PChar(Value), Length(Value), rect1,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);

      // lower half
      Value := FormatValue(ALang2, 7);
      rect2 := Types.Rect(rect.Left, (rect.Top + rect.Bottom) div 2, rect.Right, rect.Bottom);
      DrawText(bmp.Canvas.Handle, PChar(Value), Length(Value), rect2,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
    // create icon from bitmap
    Result.Assign(bmp);
  finally
    bmp.Free;
  end;
end;

procedure SetComboBoxByCode(ComboBox: TComboBox; const Code: string);
var
  i: integer;
begin
  for i := 0 to ComboBox.Items.Count - 1 do
  begin
    if ExtractCodeFromItem(ComboBox.Items[i]) = Code then
    begin
      ComboBox.ItemIndex := i;
      Exit;
    end;
  end;
  // If code not found, clear selection
  ComboBox.ItemIndex := -1;
end;

function HeadersFromMemo(AMemo: TMemo): TStringList;
var
  i, p: integer;
  line, Key, Value: string;
begin
  Result := TStringList.Create;

  if not Assigned(AMemo) then
    Exit;

  for i := 0 to AMemo.Lines.Count - 1 do
  begin
    line := Trim(AMemo.Lines[i]);
    if line = string.Empty then
      Continue;

    // Try ':' first
    p := Pos(':', line);

    // If not found, try '='
    if p = 0 then
      p := Pos('=', line);

    if p > 0 then
    begin
      Key := Trim(Copy(line, 1, p - 1));
      Value := Trim(Copy(line, p + 1, MaxInt));

      if Key <> string.Empty then
        Result.Values[Key] := Value; // store as Key=Value
    end;
  end;
end;

function ParseJsonByPointer(const JsonStr, JsonPointer: string): string;
var
  Data: TJSONData;

// Recursive traversal of JSON according to path parts
  function Traverse(Data: TJSONData; PathParts: TStringList; Level: integer): string;
  var
    Key: string;
    i: integer;
    Arr: TJSONArray;
    Obj: TJSONObject;
    SubResult: string;
    Child: TJSONData;
  begin
    Result := string.Empty;
    if Data = nil then Exit;

    // If we've reached the end of the path, return string or number
    if Level >= PathParts.Count then
    begin
      case Data.JSONType of
        jtString, jtNumber: Result := Data.AsString;
        jtArray:
        begin
          Arr := TJSONArray(Data);
          for i := 0 to Arr.Count - 1 do
          begin
            SubResult := Traverse(Arr.Items[i], PathParts, Level);
            if SubResult <> string.Empty then
            begin
              if Result <> string.Empty then
                Result := Result + #10;
              Result := Result + SubResult;
            end;
          end;
        end;
      end;
      Exit;
    end;

    Key := PathParts[Level];

    // Decode JSON Pointer escape sequences
    Key := StringReplace(Key, '~1', '/', [rfReplaceAll]);
    Key := StringReplace(Key, '~0', '~', [rfReplaceAll]);

    case Data.JSONType of
      jtObject:
      begin
        Obj := TJSONObject(Data);
        Child := Obj.Find(Key);
        if Child <> nil then
          Result := Traverse(Child, PathParts, Level + 1);
      end;

      jtArray:
      begin
        Arr := TJSONArray(Data);
        if (Key = '*') or (Key = '*#10') then
        begin
          // Iterate all elements of the array
          for i := 0 to Arr.Count - 1 do
          begin
            SubResult := Traverse(Arr.Items[i], PathParts, Level + 1);
            if SubResult <> string.Empty then
            begin
              if (Result <> string.Empty) and (Key = '*#10') then
                Result := Result + #10;
              Result := Result + SubResult;
            end;
          end;
        end
        else
        begin
          // Numeric index
          i := StrToIntDef(Key, -1);
          if (i >= 0) and (i < Arr.Count) then
            Result := Traverse(Arr.Items[i], PathParts, Level + 1);
        end;
      end;
    end;
  end;

var
  PathParts: TStringList;
begin
  Result := string.Empty;
  if Trim(JsonStr) = string.Empty then Exit;

  PathParts := TStringList.Create;
  try
    PathParts.Delimiter := '/';
    PathParts.StrictDelimiter := True;
    PathParts.DelimitedText := JsonPointer;

    // Keep empty parts (they are valid keys in Json Pointer)
    // Only remove a single leading empty segment if JsonPointer starts with '/'
    if (PathParts.Count > 0) and (PathParts[0] = '') then
      PathParts.Delete(0);

    Data := fpjson.GetJSON(JsonStr);
    try
      Result := Traverse(Data, PathParts, 0);
    finally
      Data.Free;
    end;
  finally
    PathParts.Free;
  end;
end;

function HotKeyToText(const AHotKey: THotKeyData): string;
begin
  Result := string.Empty;

  if (AHotKey.Modifiers and MOD_CONTROL) <> 0 then
    Result := Result + 'Ctrl+';
  if (AHotKey.Modifiers and MOD_SHIFT) <> 0 then
    Result := Result + 'Shift+';
  if (AHotKey.Modifiers and MOD_ALT) <> 0 then
    Result := Result + 'Alt+';
  if (AHotKey.Modifiers and MOD_WIN) <> 0 then
    Result := Result + 'Win+';

  case AHotKey.Key of
    0: ; // no key
    VK_RETURN: Result := Result + 'Enter';
    VK_SPACE: Result := Result + 'Space';
    VK_TAB: Result := Result + 'Tab';
    VK_ESCAPE: Result := Result + 'Esc';
    VK_BACK: Result := Result + 'Backspace';
    VK_DELETE: Result := Result + 'Delete';
    VK_INSERT: Result := Result + 'Insert';
    VK_HOME: Result := Result + 'Home';
    VK_END: Result := Result + 'End';
    VK_PRIOR: Result := Result + 'PageUp';
    VK_NEXT: Result := Result + 'PageDown';
    VK_LEFT: Result := Result + 'Left';
    VK_RIGHT: Result := Result + 'Right';
    VK_UP: Result := Result + 'Up';
    VK_DOWN: Result := Result + 'Down';
  else
    // For printable ASCII symbols
    if (AHotKey.Key >= 32) and (AHotKey.Key <= 126) then
      Result := Result + Chr(AHotKey.Key)
    else
      Result := Result + Format('VK_%d', [AHotKey.Key]);
  end;
end;

end.
