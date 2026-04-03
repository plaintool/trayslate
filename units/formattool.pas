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
  LCLIntf,
  fpjson,
  jsonparser;

function ColorToHtml(AColor: TColor): string;

function ColorFromHtml(const AHtml: string): TColor;

function UnescapeUnicode(const S: string): string;

function EscapeText(const AText: string): string;

function GetTimestampNow: int64;

function GetRandomID(ALength: integer): int64;

function IsJson(const S: string): boolean;

procedure PasteWithLineEnding(AMemo: TMemo);

function FindInStringList(List: TStringList; const SubText: string): integer;

procedure RemoveEmptyValues(Strings: TStringList);

function RemoveEmptyParams(const AInput: string): string;

procedure SaveStringToFile(const FileName, Data: string);

procedure OpenStringInTextEditor(const S: string);

function RemoveTrailingLineBreak(const S: string): string;

procedure FillFontCombo(ACombo: TComboBox);

function GetIndexByValue(SL: TStringList; const AValue: string): integer;

function ExtractTextSample(const AText: string; MaxLen: integer = 500): string;

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
  // Check first character: { или [ — обычно JSON
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

function FindInStringList(List: TStringList; const SubText: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to List.Count - 1 do
    if Pos(SubText, List[i]) > 0 then
    begin
      Result := i;
      Exit;
    end;
end;

procedure RemoveEmptyValues(Strings: TStringList);
var
  i: integer;
  EqualPos: integer;
begin
  // Traverse the list backwards so that deletions don't affect subsequent indices
  for i := Strings.Count - 1 downto 0 do
  begin
    // Locate the position of the '=' character in the current line
    EqualPos := Pos('=', Strings[i]);

    // If '=' exists and there is no text after it, remove the line
    if (EqualPos > 0) and (Copy(Strings[i], EqualPos + 1, MaxInt) = string.Empty) then
      Strings.Delete(i);
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

function GetIndexByValue(SL: TStringList; const AValue: string): integer;
var
  i: integer;
begin
  Result := -1; // not found
  for i := 0 to SL.Count - 1 do
    if SL.ValueFromIndex[i] = AValue then
    begin
      Result := i;
      Exit; // first match
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

end.
