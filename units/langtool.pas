//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit langtool;

{$mode ObjFPC}{$H+}
{$codepage utf8}

interface

uses
  Forms,
  Classes,
  Graphics,
  Types,
  Math,
  SysUtils,
  StdCtrls,
  StrUtils,
  LCLType,
  LCLIntf,
  IntfGraphics,
  fpjson,
  jsonparser;

type
  THotKeyData = record
    Modifiers: cardinal;  // MOD_CONTROL, MOD_SHIFT...
    Key: word;            // virtual key code
  end;

const
  {$IFDEF WINDOWS}
  HOTKEY_APP = 1;
  HOTKEY_TRANS_SWAP = 2;
  HOTKEY_TRANS_FROM_CLIPBOARD = 3;
  HOTKEY_TRANS_CLIPBOARD = 4;
  HOTKEY_TRANS_FROM_CONTROL = 5;
  HOTKEY_TRANS_CONTROL = 6;
  HOTKEY_LANG_BASE = 10;
  {$ENDIF}

  HOTKEY_CTRL = 1 shl 1; // 2
  HOTKEY_SHIFT = 1 shl 2; // 4
  HOTKEY_ALT = 1 shl 0; // 1
  HOTKEY_META = 1 shl 3; // 8 (Win / Cmd)

  ICON_SIZE = 16;

  DEF_FONT = 'Tahoma';
  DEF_NA = 'N/A';
  DEF_AUTO = '*';

function CreateTrayIconLang(Form: TForm; const ALang1: string; const ALang2: string = string.Empty;
  ABackgroundColor: TColor = clNone; AFontColor: TColor = clWhite; AFontName: string = string.Empty): TBitmap;

function CreateTrayIconProgress(AAngle: integer; ABackgroundColor: TColor = clNone; APenColor: TColor = clWhite): TBitmap;

procedure SetComboBoxByCode(ComboBox: TComboBox; const Code: string);

function HeadersFromMemo(AMemo: TMemo): TStringList;

function ParseJsonByPointer(const JsonStr, JsonPointer: string): string;

function HotKeyToText(const AHotKey: THotKeyData): string;

implementation

uses languages, formattool;

function CreateTrayIconLang(Form: TForm; const ALang1: string; const ALang2: string = string.Empty;
  ABackgroundColor: TColor = clNone; AFontColor: TColor = clWhite; AFontName: string = string.Empty): TBitmap;
var
  Bmp: TBitmap;
  IntfImg: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  rect, rect1, rect2: TRect;
  delta: integer;
  Value: string;

  function FormatValue(const Value: string; DefSize: integer = 8): string;
  begin
    Result := Value;

    if Result = string.Empty then Result := DEF_NA;

    if Pos('-', Result) > 0 then
      Result := LeftStr(Result, Pos('-', Result + '-') - 1);

    if (Length(Result) = 3) then
      Bmp.Canvas.Font.Size := Form.ScaleScreenTo96(5)
    else
    begin
      if (LowerCase(Result) = 'auto') then
      begin
        Bmp.Canvas.Font.Size := Form.ScaleScreenTo96(8);
        Result := DEF_AUTO;
      end
      else
      begin
        Bmp.Canvas.Font.Size := Form.ScaleScreenTo96(DefSize);
        Result := Result.Substring(0, 2);
      end;
    end;
  end;

begin
  IntfImg := TLazIntfImage.Create(ICON_SIZE, ICON_SIZE);
  Bmp := TBitmap.Create;
  try
    Bmp.SetSize(ICON_SIZE, ICON_SIZE);  // standard tray icon size

    // set background
    if ABackgroundColor = clNone then
    begin
      Bmp.Canvas.Brush.Color := clFuchsia;
      Bmp.Canvas.Font.Quality := fqNonAntialiased;
      Bmp.TransparentColor := clFuchsia;
      Bmp.Transparent := True;
    end
    else
      Bmp.Canvas.Brush.Color := ABackgroundColor;
    Bmp.Canvas.Brush.Style := bsSolid;
    rect := Types.Rect(0, 0, Bmp.Width, Bmp.Height);
    Bmp.Canvas.FillRect(rect);

    // set text style
    Bmp.Canvas.Font.Name := ifthen(AFontName = string.Empty, DEF_FONT, AFontName);
    Bmp.Canvas.Font.Color := AFontColor;
    Bmp.Canvas.Font.Style := [fsBold];

    if (ALang2 = string.Empty) then
    begin
      // draw text centered
      Value := FormatValue(ALang1);
      DrawText(Bmp.Canvas.Handle, PChar(Value), Length(Value), rect,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
    else
    begin
      // upper half
      Value := FormatValue(ALang1, 7);
      rect1 := Types.Rect(rect.Left, rect.Top, rect.Right, (rect.Top + rect.Bottom) div 2);
      DrawText(Bmp.Canvas.Handle, PChar(Value), Length(Value), rect1,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);

      // lower half
      Value := FormatValue(ALang2, 7);
      delta := ifthen(Value = DEF_AUTO, 3, 0);
      rect2 := Types.Rect(rect.Left, (rect.Top + rect.Bottom) div 2 + delta, rect.Right, rect.Bottom + delta);
      DrawText(Bmp.Canvas.Handle, PChar(Value), Length(Value), rect2,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;

    IntfImg.LoadFromBitmap(Bmp.Handle, Bmp.MaskHandle);

    // Copy it to a TBitmap
    IntfImg.CreateBitmaps(ImgHandle, ImgMaskHandle, False);
    Bmp.Handle := ImgHandle;
    Bmp.MaskHandle := ImgMaskHandle;

    // create icon from bitmap
    Result := Bmp;
  finally
    IntfImg.Free;
  end;
end;

function CreateTrayIconProgress(AAngle: integer; ABackgroundColor: TColor = clNone; APenColor: TColor = clWhite): TBitmap;
var
  TempIntfImg: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  TempBitmap: Graphics.TBitmap;
  cx, cy, r: integer;
  p1x, p1y, p2x, p2y: integer;
  a1, a2: double;
begin
  TempIntfImg := TLazIntfImage.Create(ICON_SIZE, ICON_SIZE);
  TempBitmap := Graphics.TBitmap.Create;

  try
    TempBitmap.SetSize(ICON_SIZE, ICON_SIZE);

    // transparent background
    TempBitmap.Canvas.AntialiasingMode := amOn;

    if ABackgroundColor = clNone then
    begin
      TempBitmap.Canvas.Brush.Color := clFuchsia;
      TempBitmap.Transparent := True;
      TempBitmap.TransparentColor := clFuchsia;
    end
    else
      TempBitmap.Canvas.Brush.Color := ABackgroundColor;

    TempBitmap.Canvas.FillRect(Rect(0, 0, ICON_SIZE, ICON_SIZE));
    TempBitmap.Canvas.Pen.Color := APenColor;
    TempBitmap.Canvas.Pen.Width := 3;

    cx := ICON_SIZE div 2;
    cy := ICON_SIZE div 2;
    r := (ICON_SIZE div 2) - 2;

    a1 := DegToRad(AAngle);
    a2 := DegToRad(AAngle + 180);

    // arc points
    p1x := cx + Round(r * Cos(a1));
    p1y := cy + Round(r * Sin(a1));

    p2x := cx + Round(r * Cos(a2));
    p2y := cy + Round(r * Sin(a2));
    TempBitmap.Canvas.Arc(
      cx - r, cy - r,
      cx + r, cy + r,
      p1x, p1y,
      p2x, p2y
      );

    // create mask through TLazIntfImage
    TempIntfImg.LoadFromBitmap(TempBitmap.Handle, TempBitmap.MaskHandle);
    TempIntfImg.CreateBitmaps(ImgHandle, ImgMaskHandle, False);

    TempBitmap.Handle := ImgHandle;
    TempBitmap.MaskHandle := ImgMaskHandle;

    Result := TempBitmap;
  finally
    TempIntfImg.Free;
  end;
end;

procedure SetComboBoxByCode(ComboBox: TComboBox; const Code: string);
var
  i: integer;
begin
  for i := 0 to ComboBox.Items.Count - 1 do
  begin
    if SameText(ExtractCodeFromItem(ComboBox.Items[i]), Code) then
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
  i, p, pColon, pEqual: integer;
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

    pColon := Pos(':', line);
    pEqual := Pos('=', line);

    // If no separator at all, skip this line
    if (pColon = 0) and (pEqual = 0) then
      Continue;

    // Determine the earliest separator
    if (pColon > 0) and ((pEqual = 0) or (pColon < pEqual)) then
      p := pColon
    else
      p := pEqual;

    Key := Trim(Copy(line, 1, p - 1));
    Value := Trim(Copy(line, p + 1, MaxInt));

    if Key <> string.Empty then
      Result.Values[Key] := Value;  // stored as Key=Value internally
  end;
end;

function ParseJsonByPointer(const JsonStr, JsonPointer: string): string;
var
  Data: TJSONData;

  function Traverse(Data: TJSONData; PathParts: TStringList; Level: integer): string;
  var
    Key: string;
    i: integer;
    Arr: TJSONArray;
    Obj: TJSONObject;
    SubResult: string;
    Child: TJSONData;
    ExtValue: extended;
  begin
    Result := string.Empty;
    if Data = nil then Exit;

    // --- NEW: Handle ~ (Return current branch as JSON string) ---
    if (Level < PathParts.Count) and (PathParts[Level] = '~') then
    begin
      Result := Data.AsJSON;
      Exit;
    end;

    // If we have reached the end of the path, return the value
    if Level >= PathParts.Count then
    begin
      case Data.JSONType of
        jtString, jtBoolean:
          Result := Data.AsString;
        jtNumber:
        begin
          ExtValue := TJSONNumber(Data).AsFloat; // get number as Extended
          Result := Format('%0.*g', [17, ExtValue]); // 17 digits precision
        end;
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
        // Return object as JSON if path ends on an object
        jtObject: Result := Data.AsJSON;
      end;
      Exit;
    end;

    Key := PathParts[Level];

    // Decoding special characters JSON Pointer (RFC 6901)
    Key := StringReplace(Key, '~1', '/', [rfReplaceAll]);
    Key := StringReplace(Key, '~0', '~', [rfReplaceAll]);

    case Data.JSONType of
      jtObject:
      begin
        Obj := TJSONObject(Data);

        // 1. Processing Wildcard for an object (take all properties)
        if (Key = '*') or (Key = '*#10') then
        begin
          for i := 0 to Obj.Count - 1 do
          begin
            SubResult := Traverse(Obj.Items[i], PathParts, Level + 1);
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
          // 2. Search by key name
          Child := Obj.Find(Key);
          if Child <> nil then
            Result := Traverse(Child, PathParts, Level + 1)
          else
          begin
            // 3. If you can’t find it by name, try to interpret the key as an index
            i := StrToIntDef(Key, -1);
            if (i >= 0) and (i < Obj.Count) then
              Result := Traverse(Obj.Items[i], PathParts, Level + 1);
          end;
        end;
      end;

      jtArray:
      begin
        Arr := TJSONArray(Data);
        if (Key = '*') or (Key = '*#10') then
        begin
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
  if (JsonPointer = '~') or (JsonPointer = '/~') then Exit(JsonStr);
  if not IsJson(JsonStr) then Exit;

  PathParts := TStringList.Create;
  try
    PathParts.Delimiter := '/';
    PathParts.StrictDelimiter := True;
    PathParts.DelimitedText := JsonPointer;

    if (PathParts.Count > 0) and (PathParts[0] = string.Empty) then
      PathParts.Delete(0);

    // Root-level dump if pointer is just "~"
    if (PathParts.Count = 1) and (PathParts[0] = '~') then
    begin
      Result := JsonStr;
      Exit;
    end;

    try
      Data := fpjson.GetJSON(JsonStr);
      try
        Result := Traverse(Data, PathParts, 0);
      finally
        Data.Free;
      end;
    except
      Result := string.Empty;
    end;
  finally
    PathParts.Free;
  end;
end;

function HotKeyToText(const AHotKey: THotKeyData): string;
begin
  Result := string.Empty;

  if (AHotKey.Modifiers and HOTKEY_CTRL) <> 0 then
    Result := Result + 'Ctrl+';
  if (AHotKey.Modifiers and HOTKEY_SHIFT) <> 0 then
    Result := Result + 'Shift+';
  if (AHotKey.Modifiers and HOTKEY_ALT) <> 0 then
    Result := Result + 'Alt+';
  if (AHotKey.Modifiers and HOTKEY_META) <> 0 then
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
