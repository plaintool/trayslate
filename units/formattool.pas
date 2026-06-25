//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formattool;

{$mode ObjFPC}{$H+}
{$codepage utf8}

interface

uses
  Forms,
  Classes,
  SysUtils,
  StdCtrls,
  Clipbrd,
  Graphics,
  DateUtils,
  Math,
  ColorBox,
  LCLIntf,
  LazUTF8,
  fpjson;

function ColorToHtml(AColor: TColor): string;

function ColorFromHtml(const AHtml: string): TColor;

function InvertColor(Color: TColor): TColor;

function UnescapeUnicode(const S: string): string;

function EscapeText(const AText: string): string;

function GetTimestampNow: int64;

function GetRandomID(ALength: integer): int64;

function IsJson(const S: string): boolean;

procedure PasteWithLineEnding(AMemo: TMemo);

procedure RemoveSameNameValueFromMemo(Memo: TMemo);

function RemoveEmptyParams(const AInput: string): string;

procedure SaveStringToFile(const FileName, Data: string);

procedure OpenStringInTextEditor(const S: string);

function RemoveTrailingLineBreak(const S: string): string;

procedure FillFontCombo(ACombo: TComboBox);

function ExtractTextSample(const AText: string; MaxLen: integer = 500): string;

procedure AddCustomColors(AColorBox: TColorBox);

function DarkThemeColor(BaseColor: TColor; Delta: integer = 60): TColor;

function PosExReverse(const SubStr, S: unicodestring; Offset: SizeInt = -1): SizeInt;

function Utf8Truncate(const S: string; MaxBytes: integer; Encode: boolean): string;

function Utf8TruncateWithEncoding(const S: string; MaxBytes: integer; Encode: boolean): string;

function EncodeURLElement(S: string): string;

function HTTPDecode(const AStr: string): string;

function LongestString(const Values: array of string): string;

function TryFormatJson(const AText: string; out AFormatted: string): boolean;

implementation

function ColorToHtml(AColor: TColor): string;
var
  C: TColor;
begin
  // Convert to pure RGB value
  C := ColorToRGB(AColor);

  // Format as #RRGGBB
  Result := Format('#%.2x%.2x%.2x', [Red(C), Green(C), Blue(C)]);
end;

function ColorFromHtml(const AHtml: string): TColor;
var
  S: string;
  R, G, B: byte;
begin
  // Remove leading #
  S := Trim(AHtml);
  if (Length(S) = 7) and (S[1] = '#') then
    Delete(S, 1, 1);

  // Parse RRGGBB
  R := StrToInt('$' + Copy(S, 1, 2));
  G := StrToInt('$' + Copy(S, 3, 2));
  B := StrToInt('$' + Copy(S, 5, 2));

  // Build TColor
  Result := RGBToColor(R, G, B);
end;

function InvertColor(Color: TColor): TColor;
begin
  Result := RGB(255 - GetRValue(ColorToRGB(Color)), 255 - GetGValue(ColorToRGB(Color)), 255 - GetBValue(ColorToRGB(Color)));
end;

function UnescapeUnicode(const S: string): string;
var
  i: integer;
  Code: string;
  tmp: integer;
begin
  // Initialize result
  Result := string.Empty;
  i := 1;

  // Loop through the input string
  while i <= Length(S) do
  begin
    // Handle Unicode escape sequence \uXXXX
    if (S[i] = '\') and (i + 5 <= Length(S)) and (S[i + 1] = 'u') then
    begin
      Code := Copy(S, i + 2, 4);
      // Convert hexadecimal code to integer
      if TryStrToInt('$' + Code, tmp) and (tmp <= $FFFF) then
        // Explicit conversion to AnsiChar to remove warnings
        Result := Result + string(widechar(tmp))
      else
        Result := Result + '\u' + Code; // Keep original if conversion fails
      Inc(i, 6);
    end
    // Handle standard escape sequences \r, \n, \t, \\, \"
    else if (S[i] = '\') and (i < Length(S)) then
    begin
      case S[i + 1] of
        'r': Result := Result + #13;
        'n': Result := Result + #10;
        't': Result := Result + #9;
        '\': Result := Result + '\';
        '"': Result := Result + '"';
        else
          Result := Result + '\' + S[i + 1]; // Keep unknown escapes as-is
      end;
      Inc(i, 2);
    end
    // Append normal character
    else
    begin
      Result := Result + S[i];
      Inc(i);
    end;
  end;
end;

function EscapeText(const AText: string): string;
begin
  Result := AText;

  // 1. Backslash must be escaped first!
  Result := StringReplace(Result, '\', '\\', [rfReplaceAll]);

  // 2. Double quotes will break the JSON string if not escaped
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);

  // 3. Line breaks (Enter) must be replaced with \n
  Result := StringReplace(Result, #13#10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\r', [rfReplaceAll]);

  // 4. Tabs are also problematic
  Result := StringReplace(Result, #9, '\t', [rfReplaceAll]);
end;

function GetTimestampNow: int64;
begin
  // DateTimeToUnix returns seconds. False means we use UTC time.
  // We multiply by 1000 to convert seconds to milliseconds for DeepL.
  Result := DateTimeToUnix(Now, False) * 1000;
end;

function GetRandomID(ALength: integer): int64;
var
  MinVal, MaxVal: int64;
begin
  // Limit length to stay within Int64 boundaries (max ~18 digits)
  if ALength > 18 then ALength := 18;
  if ALength < 1 then ALength := 1;

  // Calculate range for the requested length (e.g., 3 digits: 100 to 999)
  MinVal := Trunc(Power(10, ALength - 1));
  MaxVal := Trunc(Power(10, ALength)) - 1;

  // Standard random range generation
  // Note: Ensure Randomize is called once in your FormCreate/Initialization
  Result := MinVal + RandomRange(0, MaxVal - MinVal + 1);
end;

function IsJson(const S: string): boolean;
var
  Trimmed: string;
begin
  Trimmed := TrimLeft(S);
  // Check first character
  Result := (Trimmed <> string.Empty) and ((Trimmed[1] = '{') or (Trimmed[1] = '['));
end;

procedure PasteWithLineEnding(AMemo: TMemo);
var
  s: string;
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    s := Clipboard.AsText;

    s := StringReplace(s, #13#10, #10, [rfReplaceAll]); // Windows CRLF -> LF
    s := StringReplace(s, #13, #10, [rfReplaceAll]);   // Macintosh CR -> LF

    s := StringReplace(s, #10, LineEnding, [rfReplaceAll]);   // Macintosh CR -> LF

    AMemo.SelText := s;
  end;
end;

procedure RemoveSameNameValueFromMemo(Memo: TMemo);
var
  i: integer;
  EqualPos: integer;
  KeyPart, ValuePart: string;
begin
  for i := Memo.Lines.Count - 1 downto 0 do
  begin
    EqualPos := Pos('=', Memo.Lines[i]);

    // Skip lines without '='
    if EqualPos <= 0 then
      Continue;

    KeyPart := Copy(Memo.Lines[i], 1, EqualPos - 1);
    ValuePart := Copy(Memo.Lines[i], EqualPos + 1, MaxInt);

    // Case-sensitive compare
    if (KeyPart = ValuePart) and (Length(KeyPart) > 10) then
      Memo.Lines[i] := KeyPart;
  end;
end;

function RemoveEmptyParams(const AInput: string): string;
var
  JsonData: TJSONData;
  JsonObj, ParamsObj, LangObjJson: TJSONObject;
  LangObj: TJSONData;
  I: integer;
  Params: TStringList;
begin
  Result := AInput;

  // Check if input looks like JSON
  if (Length(AInput) > 0) and (AInput[1] = '{') then
  begin
    try
      JsonData := GetJSON(AInput);
      try
        if JsonData.JSONType = jtObject then
        begin
          JsonObj := TJSONObject(JsonData);

          if JsonObj.FindPath('params') <> nil then
          begin
            ParamsObj := TJSONObject(JsonObj.FindPath('params'));

            // Clean "lang" object
            LangObj := ParamsObj.FindPath('lang');
            if (LangObj <> nil) and (LangObj.JSONType = jtObject) then
            begin
              LangObjJson := TJSONObject(LangObj);
              for I := LangObjJson.Count - 1 downto 0 do
                if LangObjJson.Items[I].AsString = string.Empty then
                  LangObjJson.Delete(I);
            end;

            // Remove other empty string fields in params
            for I := ParamsObj.Count - 1 downto 0 do
              if (ParamsObj.Items[I].JSONType = jtString) and (ParamsObj.Items[I].AsString = string.Empty) then
                ParamsObj.Delete(I);
          end;

          Result := JsonObj.AsJSON;
          Exit;
        end;
      finally
        JsonData.Free;
      end;
    except
      on E: Exception do
        // Invalid JSON, fall through to URL processing
    end;
  end;

  // Treat as URL parameters
  Params := TStringList.Create;
  try
    Params.Delimiter := '&';
    Params.StrictDelimiter := True;
    Params.DelimitedText := AInput;

    for I := Params.Count - 1 downto 0 do
      if Pos('=', Params[I]) > 0 then
        if Copy(Params[I], Pos('=', Params[I]) + 1, MaxInt) = string.Empty then
          Params.Delete(I);

    // Rebuild URL string with &
    Result := string.Empty;
    for I := 0 to Params.Count - 1 do
      if I = 0 then
        Result := Params[I]
      else
        Result := Result + '&' + Params[I];
  finally
    Params.Free;
  end;
end;

procedure SaveStringToFile(const FileName, Data: string);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := Data;
    SL.SaveToFile(FileName, TEncoding.UTF8);
  finally
    SL.Free;
  end;
end;

procedure OpenStringInTextEditor(const S: string);
var
  SL: TStringList;
  FileName: string;
begin
  FileName := GetTempFileName(GetTempDir, 'txt_') + '.txt';

  SL := TStringList.Create;
  try
    SL.Text := S;
    SL.SaveToFile(FileName); // save string to temp file
  finally
    SL.Free;
  end;

  // open with associated editor
  OpenDocument(FileName);
end;

function RemoveTrailingLineBreak(const S: string): string;
begin
  Result := S;
  if (Length(Result) >= 2) and (Copy(Result, Length(Result) - 1, 2) = sLineBreak) then
    Result := Copy(Result, 1, Length(Result) - 2)
  else if (Length(Result) >= 1) and ((Result[Length(Result)] = #10) or (Result[Length(Result)] = #13)) then
    Result := Copy(Result, 1, Length(Result) - 1);
end;

procedure FillFontCombo(ACombo: TComboBox);
var
  i: integer;
begin
  ACombo.Items.BeginUpdate;
  try
    ACombo.Items.Clear;
    for i := 0 to Screen.Fonts.Count - 1 do
      ACombo.Items.Add(Screen.Fonts[i]);
  finally
    ACombo.Items.EndUpdate;
  end;
end;

function ExtractTextSample(const AText: string; MaxLen: integer = 500): string;
var
  CutPos, i, L: integer;
begin
  Result := Trim(AText);
  L := Length(Result);

  // 1. If short enough
  if L <= MaxLen then
    Exit;

  // 2. Try cut by sentence end (. ! ?) + space
  CutPos := 0;
  for i := MaxLen downto 1 do
  begin
    if (Result[i] in ['.', '!', '?']) and (i < L) and (Result[i + 1] = ' ') then
    begin
      CutPos := i;
      Break;
    end;
  end;

  // 3. Try cut by space
  if CutPos = 0 then
  begin
    for i := MaxLen downto 1 do
    begin
      if Result[i] = ' ' then
      begin
        CutPos := i;
        Break;
      end;
    end;
  end;

  // 4. Fallback
  if CutPos = 0 then
    CutPos := MaxLen;

  Result := Trim(Copy(Result, 1, CutPos));
end;

procedure AddCustomColors(AColorBox: TColorBox);
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
  AColorBox.Items.AddObject('Blood Red', TObject(PtrUInt($000000CC)));
  AColorBox.Items.AddObject('Scarlet', TObject(PtrUInt($000A10FF)));
  AColorBox.Items.AddObject('Brick', TObject(PtrUInt($001020A0)));
  AColorBox.Items.AddObject('Rosewood', TObject(PtrUInt($00203080)));

  // Oranges
  AColorBox.Items.AddObject('Amber', TObject(PtrUInt($0000C8FF)));
  AColorBox.Items.AddObject('Tangerine', TObject(PtrUInt($0010A5FF)));
  AColorBox.Items.AddObject('Copper', TObject(PtrUInt($002A6BFF)));
  AColorBox.Items.AddObject('Sunset', TObject(PtrUInt($004080FF)));
  AColorBox.Items.AddObject('Burnt Orange', TObject(PtrUInt($001060D0)));
  AColorBox.Items.AddObject('Rust', TObject(PtrUInt($002050B0)));
  AColorBox.Items.AddObject('Deep Tangerine', TObject(PtrUInt($000040A0)));
  AColorBox.Items.AddObject('Orange Peel', TObject(PtrUInt($000070C0)));
  AColorBox.Items.AddObject('Autumn Orange', TObject(PtrUInt($001050C0)));
  AColorBox.Items.AddObject('Spice', TObject(PtrUInt($002060B0)));
  AColorBox.Items.AddObject('Copper Dark', TObject(PtrUInt($00303090)));

  // Yellows
  AColorBox.Items.AddObject('Gold', TObject(PtrUInt($0000D7FF)));
  AColorBox.Items.AddObject('Mustard', TObject(PtrUInt($0020B5D0)));
  AColorBox.Items.AddObject('Honey', TObject(PtrUInt($0030C8E0)));
  AColorBox.Items.AddObject('Sand', TObject(PtrUInt($0050D8E8)));
  AColorBox.Items.AddObject('Lemon', TObject(PtrUInt($0000F0FF)));
  AColorBox.Items.AddObject('Canary', TObject(PtrUInt($0000FFFF)));
  AColorBox.Items.AddObject('Butter', TObject(PtrUInt($0010F0F0)));
  AColorBox.Items.AddObject('Dijon', TObject(PtrUInt($0020D0D0)));
  AColorBox.Items.AddObject('Old Gold', TObject(PtrUInt($002090C0)));
  AColorBox.Items.AddObject('Antique Gold', TObject(PtrUInt($001070A0)));
  AColorBox.Items.AddObject('Bronze Yellow', TObject(PtrUInt($00106090)));
  AColorBox.Items.AddObject('Mustard Dark', TObject(PtrUInt($000080A0)));
  AColorBox.Items.AddObject('Ochre', TObject(PtrUInt($00007090)));
  AColorBox.Items.AddObject('Amber Dark', TObject(PtrUInt($00005080)));
  AColorBox.Items.AddObject('Honey Brown', TObject(PtrUInt($00104070)));
  AColorBox.Items.AddObject('Olive', TObject(PtrUInt($00308080)));

  // Greens
  AColorBox.Items.AddObject('Emerald', TObject(PtrUInt($0032CD32)));
  AColorBox.Items.AddObject('Forest', TObject(PtrUInt($00228B22)));
  AColorBox.Items.AddObject('Lime', TObject(PtrUInt($0000FF80)));
  AColorBox.Items.AddObject('Mint', TObject(PtrUInt($0078D890)));
  AColorBox.Items.AddObject('Moss', TObject(PtrUInt($00408060)));
  AColorBox.Items.AddObject('Leaf Green', TObject(PtrUInt($0050C050)));
  AColorBox.Items.AddObject('Grass', TObject(PtrUInt($0060B050)));
  AColorBox.Items.AddObject('Meadow', TObject(PtrUInt($0070C060)));
  AColorBox.Items.AddObject('Fern', TObject(PtrUInt($00409040)));
  AColorBox.Items.AddObject('Apple Green', TObject(PtrUInt($0080D070)));
  AColorBox.Items.AddObject('Natural Green', TObject(PtrUInt($0060A060)));
  AColorBox.Items.AddObject('Shamrock', TObject(PtrUInt($0050B070)));
  AColorBox.Items.AddObject('Jungle Green', TObject(PtrUInt($00408050)));
  AColorBox.Items.AddObject('Jade', TObject(PtrUInt($0050C060)));
  AColorBox.Items.AddObject('Pine', TObject(PtrUInt($00306030)));
  AColorBox.Items.AddObject('Herb', TObject(PtrUInt($0040A040)));
  AColorBox.Items.AddObject('Seaweed', TObject(PtrUInt($00609060)));
  AColorBox.Items.AddObject('Neon Green', TObject(PtrUInt($0000FF40)));
  AColorBox.Items.AddObject('Spring', TObject(PtrUInt($0020FF80)));

  // Cyans
  AColorBox.Items.AddObject('Turquoise', TObject(PtrUInt($00D0E040)));
  AColorBox.Items.AddObject('Aqua', TObject(PtrUInt($00FFFF00)));
  AColorBox.Items.AddObject('Teal', TObject(PtrUInt($00808000)));
  AColorBox.Items.AddObject('Lagoon', TObject(PtrUInt($00D0C000)));
  AColorBox.Items.AddObject('Pool', TObject(PtrUInt($00B0A000)));
  AColorBox.Items.AddObject('Deep Sky Cyan', TObject(PtrUInt($00C0B050)));
  AColorBox.Items.AddObject('Muted Teal', TObject(PtrUInt($00B0A040)));
  AColorBox.Items.AddObject('Storm Aqua', TObject(PtrUInt($00A09040)));
  AColorBox.Items.AddObject('Dark Seafoam', TObject(PtrUInt($00908030)));
  AColorBox.Items.AddObject('Cold Cyan', TObject(PtrUInt($00B0A060)));
  AColorBox.Items.AddObject('Faded Glacier', TObject(PtrUInt($00907030)));
  AColorBox.Items.AddObject('Deep Lagoon', TObject(PtrUInt($00806020)));
  AColorBox.Items.AddObject('Arctic Depth', TObject(PtrUInt($00705020)));

  // Blues
  AColorBox.Items.AddObject('Azure', TObject(PtrUInt($00FF9E2B)));
  AColorBox.Items.AddObject('Royal Blue', TObject(PtrUInt($00E16941)));
  AColorBox.Items.AddObject('Sky', TObject(PtrUInt($00FFBF00)));
  AColorBox.Items.AddObject('Sea Blue', TObject(PtrUInt($00C07000)));
  AColorBox.Items.AddObject('Ocean', TObject(PtrUInt($00B06000)));
  AColorBox.Items.AddObject('Ocean Deep', TObject(PtrUInt($00905000)));
  AColorBox.Items.AddObject('Midnight', TObject(PtrUInt($00800000)));
  AColorBox.Items.AddObject('Blue Steel', TObject(PtrUInt($00C06040)));
  AColorBox.Items.AddObject('Cornflower', TObject(PtrUInt($00E09050)));
  AColorBox.Items.AddObject('Denim Blue', TObject(PtrUInt($00D07040)));
  AColorBox.Items.AddObject('Classic Blue', TObject(PtrUInt($00FF7030)));
  AColorBox.Items.AddObject('Medium Azure', TObject(PtrUInt($00E08040)));
  AColorBox.Items.AddObject('Sky Blue Soft', TObject(PtrUInt($00F0A060)));
  AColorBox.Items.AddObject('Ocean Medium', TObject(PtrUInt($00D06030)));
  AColorBox.Items.AddObject('Steel Blue', TObject(PtrUInt($00A06040)));
  AColorBox.Items.AddObject('Navy', TObject(PtrUInt($00600000)));
  AColorBox.Items.AddObject('Cobalt', TObject(PtrUInt($00B04020)));
  AColorBox.Items.AddObject('Sapphire', TObject(PtrUInt($00C05030)));
  AColorBox.Items.AddObject('Denim', TObject(PtrUInt($00A05030)));
  AColorBox.Items.AddObject('Sky Deep', TObject(PtrUInt($00908010)));
  AColorBox.Items.AddObject('Twilight', TObject(PtrUInt($00704020)));

  // Purples
  AColorBox.Items.AddObject('Violet', TObject(PtrUInt($00D670DA)));
  AColorBox.Items.AddObject('Plum', TObject(PtrUInt($00B070C0)));
  AColorBox.Items.AddObject('Orchid', TObject(PtrUInt($00CC66CC)));
  AColorBox.Items.AddObject('Lavender', TObject(PtrUInt($00E6A8D7)));
  AColorBox.Items.AddObject('Amethyst', TObject(PtrUInt($00A060C0)));
  AColorBox.Items.AddObject('Grape', TObject(PtrUInt($008050A0)));
  AColorBox.Items.AddObject('Eggplant', TObject(PtrUInt($00604080)));
  AColorBox.Items.AddObject('Lilac', TObject(PtrUInt($00D0A0E0)));
  AColorBox.Items.AddObject('Indigo', TObject(PtrUInt($0082004B)));

  // Pinks
  AColorBox.Items.AddObject('Rose', TObject(PtrUInt($006060FF)));
  AColorBox.Items.AddObject('Coral', TObject(PtrUInt($00507FFF)));
  AColorBox.Items.AddObject('Blush', TObject(PtrUInt($007080FF)));
  AColorBox.Items.AddObject('Magenta', TObject(PtrUInt($00FF00FF)));
  AColorBox.Items.AddObject('Bubblegum', TObject(PtrUInt($00FF80FF)));
  AColorBox.Items.AddObject('Flamingo', TObject(PtrUInt($0080A0FF)));
  AColorBox.Items.AddObject('Peony', TObject(PtrUInt($009090FF)));
  AColorBox.Items.AddObject('Candy', TObject(PtrUInt($00FF60FF)));
  AColorBox.Items.AddObject('Dusty Rose', TObject(PtrUInt($004060A0)));
  AColorBox.Items.AddObject('Wine Rose', TObject(PtrUInt($00304090)));
  AColorBox.Items.AddObject('Deep Pink', TObject(PtrUInt($005000C0)));
  AColorBox.Items.AddObject('Mulberry', TObject(PtrUInt($00302070)));
  AColorBox.Items.AddObject('Burgundy Pink', TObject(PtrUInt($00201060)));
  AColorBox.Items.AddObject('Dark Fuchsia', TObject(PtrUInt($004000A0)));
end;

function DarkThemeColor(BaseColor: TColor; Delta: integer = 60): TColor;
var
  R, G, B: byte;
  Bright: double;
  Factor: double;
begin
  R := GetRValue(BaseColor);
  G := GetGValue(BaseColor);
  B := GetBValue(BaseColor);

  // Perceptual brightness (Luma) calculation
  Bright := (0.299 * R + 0.587 * G + 0.114 * B);

  // If the color is already bright enough (threshold 150), return original
  if Bright > 150 then
  begin
    Result := BaseColor;
    Exit;
  end;

  // Convert Delta (1..100) to a scale factor (0.0..1.0)
  // 1 = almost no change, 100 = full white
  Factor := Delta / 100.0;

  // Clamp factor for safety
  if Factor < 0 then Factor := 0;
  if Factor > 1 then Factor := 1;

  // Linear interpolation towards white (Tinting)
  // This formula ensures that even 0 values (like in clBlue) become brighter
  R := R + Round((255 - R) * Factor);
  G := G + Round((255 - G) * Factor);
  B := B + Round((255 - B) * Factor);

  Result := RGB(R, G, B);
end;

function PosExReverse(const SubStr, S: unicodestring; Offset: SizeInt = -1): SizeInt;
var
  i, MaxLen, SubLen: SizeInt;
  // SubFirst: widechar;
  pc: pwidechar;
begin
  Result := 0; // Initialize result to 0 (not found)
  SubLen := Length(SubStr); // Get length of the substring
  if Offset < 0 then Offset := Length(S);

  // Check if the substring is not empty and Offset is valid
  if (SubLen > 0) and (Offset > 0) and (Offset <= Length(S)) then
  begin
    MaxLen := Length(S) - SubLen + 1; // Adjust max starting index to include end of the string
    // SubFirst := SubStr[1]; // Get the first character of the substring

    // Search backwards, starting from Offset
    for i := Offset downto 1 do
    begin
      // Ensure there is enough space left for the substring
      if (i <= MaxLen) then
      begin
        pc := @S[i]; // Pointer to the current position

        // Check for a match with the substring
        if (CompareWord(SubStr[1], pc^, SubLen) = 0) then
        begin
          Result := i; // Return the found position
          Exit; // Exit the function
        end;
      end;
    end;
  end;
end;

function Utf8Truncate(const S: string; MaxBytes: integer; Encode: boolean): string;
var
  p, startPtr: pchar;
  CharLen: integer;
  PredictedSize: integer;
  CurrentTotal: integer;
begin
  Result := '';
  if (S = '') or (MaxBytes <= 0) then Exit;

  p := PChar(S);
  startPtr := p;
  CurrentTotal := 0;

  while (p^ <> #0) do
  begin
    // 1. Determine UTF-8 character length (1-4 bytes)
    {$NOTES OFF}
    CharLen := UTF8CodepointSize(p);
    {$NOTES ON}

    // 2. Predict the size of the character after encoding/escaping
    if Encode then
    begin
      // URL Encoding logic:
      // Safe chars [A-Z, a-z, 0-9, -, _, ., ~] remain 1 byte.
      // All other bytes are converted to %XX format (3 bytes per 1 input byte).
      if (p^ in ['A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.', '~']) then
        PredictedSize := 1
      else
        PredictedSize := CharLen * 3;
    end
    else
    begin
      // Escaping logic:
      // Control chars \, ", LF, CR, Tab are replaced with 2-byte sequences (e.g. \n).
      // Other UTF-8 characters remain as-is (their original byte length).
      if (p^ in ['\', '"', #10, #13, #9]) then
        PredictedSize := 2
      else
        PredictedSize := CharLen;
    end;

    // 3. Check if the encoded character fits within the remaining byte budget
    if CurrentTotal + PredictedSize <= MaxBytes then
    begin
      Inc(CurrentTotal, PredictedSize);
      Inc(p, CharLen); // Move pointer to the start of the next UTF-8 character
    end
    else
      Break; // Limit exceeded, stop processing
  end;

  // 4. Perform a single memory allocation and copy the resulting substring
  if p > startPtr then
    SetString(Result, startPtr, p - startPtr)
  else
    Result := '';
end;

function Utf8TruncateWithEncoding(const S: string; MaxBytes: integer; Encode: boolean): string;
var
  p, startPtr: pchar;
  CharLen: integer;
  CurrentChar, EncodedChar: string;
  CurrentTotalBytes: integer;
begin
  Result := '';
  if (S = '') or (MaxBytes <= 0) then Exit;

  p := PChar(S);
  startPtr := p;
  CurrentTotalBytes := 0;

  while (p^ <> #0) do
  begin
    {$NOTES OFF}
    CharLen := UTF8CodepointSize(p);
    {$NOTES ON}
    SetString(CurrentChar, p, CharLen);

    if Encode then
      EncodedChar := EncodeURLElement(CurrentChar)
    else
      EncodedChar := EscapeText(CurrentChar);

    if CurrentTotalBytes + Length(EncodedChar) <= MaxBytes then
    begin
      Inc(CurrentTotalBytes, Length(EncodedChar));
      Inc(p, CharLen);
    end
    else
      Break;
  end;

  // Only allocate Result ONCE at the end
  if p > startPtr then
    SetString(Result, startPtr, p - startPtr);
end;

function EncodeURLElement(S: string): string;
const
  NotAllowed = [';', '/', '?', ':', '@', '=', '&', '#', '+', '_', '<', '>', '"', '%', '{', '}', '|', '\', '^', '~', '[', ']', '`'];
var
  i, o, l: integer;
  h: string[2];
  P: pchar;
  c: ansichar;
begin
  Result := '';
  l := Length(S);
  if (l = 0) then Exit;
  SetLength(Result, l * 3);
  P := PChar(Result);
  for I := 1 to L do
  begin
    C := S[i];
    O := Ord(c);
    if (O <= $20) or (O >= $7F) or (c in NotAllowed) then
    begin
      P^ := '%';
      Inc(P);
      h := IntToHex(Ord(c), 2);
      p^ := h[1];
      Inc(P);
      p^ := h[2];
      Inc(P);
    end
    else
    begin
      P^ := c;
      Inc(p);
    end;
  end;
  SetLength(Result, P - PChar(Result));
end;

function HTTPDecode(const AStr: string): string;
var
  S, SS, R: pchar;
  H: string[3];
  L, C: integer;
begin
  L := Length(Astr);
  Result := '';
  SetLength(Result, L);
  if (L = 0) then
    exit;
  S := PChar(AStr);
  SS := S;
  R := PChar(Result);
  while (S - SS) < L do
  begin
    case S^ of
      '+': R^ := ' ';
      '%': begin
        Inc(S);
        if ((S - SS) < L) then
        begin
          if (S^ = '%') then
            R^ := '%'
          else
          begin
            H := '$00';
            H[2] := S^;
            Inc(S);
            if (S - SS) < L then
            begin
              H[3] := S^;
              Val(H, pbyte(R)^, C);
              if (C <> 0) then
                R^ := ' ';
            end;
          end;
        end;
      end;
      else
        R^ := S^;
    end;
    Inc(R);
    Inc(S);
  end;
  SetLength(Result, R - PChar(Result));
end;

function LongestString(const Values: array of string): string;
var
  I: integer;
begin
  Result := string.Empty;
  for I := Low(Values) to High(Values) do
    if Length(Values[I]) > Length(Result) then
      Result := Values[I];
end;

function TryFormatJson(const AText: string; out AFormatted: string): boolean;
var
  JsonData: TJSONData;
begin
  Result := False;
  AFormatted := string.Empty;

  try
    // Try parse JSON
    JsonData := GetJSON(AText);
    try
      // Format with 2 spaces indent
      if Assigned(JsonData) then
        AFormatted := JsonData.FormatJSON([], 2);
      Result := True;
    finally
      JsonData.Free;
    end;
  except
    on E: Exception do
    begin
      // Not valid JSON
      Result := False;
    end;
  end;
end;

end.
