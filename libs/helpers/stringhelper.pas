//-----------------------------------------------------------------------------------
//  Helpers Package © 2026 by Alexander Tverskoy
//  Licensed under the MIT License
//  You may obtain a copy of the License at https://opensource.org/licenses/MIT
//-----------------------------------------------------------------------------------

unit stringhelper;

{$mode objfpc}{$H+}
{$modeswitch typehelpers}

interface

uses
  Forms,
  Controls,
  StdCtrls,
  SysUtils,
  Classes,
  Graphics,
  LCLIntf,
  LazUTF8,
  fpjson;

type
  { TStringExHelper }

  TStringHelperEx = type helper(TStringHelper) for string
    function ToColor: TColor;
    function UnescapeUnicode: string;
    function EscapeText: string;
    function EncodeURLElement: string;
    function HTTPDecode: string;
    function Utf8Truncate(MaxBytes: integer; Encode: boolean): string;
    function Utf8TruncateWithEncoding(MaxBytes: integer; Encode: boolean): string;
    function IsJson: boolean;
    function RemoveEmptyParams: string;
    procedure SaveStringToFile(const FileName: string);
    procedure OpenStringInTextEditor;
    function RemoveTrailingLineBreak: string;
    function ExtractTextSample(MaxLen: integer = 500): string;
    function TryFormatJson(out AFormatted: string): boolean;
    function TryParseIPPort(out IP: string; out Port: Word): Boolean;
  end;

  { TCaptionHelper }

  TCaptionHelper = type helper for TCaption
    function Replace(const Old, New: string): TCaption;
  end;

  { String Ex Methods }

function PosExReverse(const SubStr, S: unicodestring; Offset: SizeInt = -1): SizeInt;

function LongestString(const Values: array of string): string;

function InputQueryLite(const ACaption, APrompt: string; var AValue: string): boolean;

implementation

{%Region -fold String Ex Methods}

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

function LongestString(const Values: array of string): string;
var
  I: integer;
begin
  Result := string.Empty;
  for I := Low(Values) to High(Values) do
    if Length(Values[I]) > Length(Result) then
      Result := Values[I];
end;

function InputQueryLite(const ACaption, APrompt: string; var AValue: string): boolean;
var
  InputForm: TForm;
  PromptLabel: TLabel;
  InputEdit: TEdit;
  BtnOK, BtnCancel: TButton;
begin
  Result := False;

  // Create the form dynamically
  InputForm := TForm.Create(nil);
  try
    InputForm.Caption := ACaption;
    InputForm.Position := poScreenCenter;
    InputForm.BorderStyle := bsDialog;
    InputForm.Width := 350;
    InputForm.Font.Size := 10; // Make font a bit more modern

    // Create the prompt label
    PromptLabel := TLabel.Create(InputForm);
    PromptLabel.Parent := InputForm;
    PromptLabel.Caption := APrompt;
    PromptLabel.Left := 12;
    PromptLabel.Top := 12;
    PromptLabel.AutoSize := True;

    // Create the input field tightly below the label
    InputEdit := TEdit.Create(InputForm);
    InputEdit.Parent := InputForm;
    InputEdit.Left := 12;
    InputEdit.Top := PromptLabel.Top + PromptLabel.Height + 6;
    InputEdit.Width := InputForm.ClientWidth - 24;
    InputEdit.Text := AValue;

    // Create the OK button tight below the input field
    BtnOK := TButton.Create(InputForm);
    BtnOK.Parent := InputForm;
    BtnOK.Caption := 'OK';
    BtnOK.ModalResult := mrOk;
    BtnOK.Default := True; // Triggers on Enter key
    BtnOK.Width := 75;
    BtnOK.Height := 25;
    BtnOK.Top := InputEdit.Top + InputEdit.Height + 12;
    BtnOK.Left := InputForm.ClientWidth - (BtnOK.Width * 2) - 18;

    // Create the Cancel button next to OK
    BtnCancel := TButton.Create(InputForm);
    BtnCancel.Parent := InputForm;
    BtnCancel.Caption := 'Cancel';
    BtnCancel.ModalResult := mrCancel;
    BtnCancel.Cancel := True; // Triggers on Esc key
    BtnCancel.Width := 75;
    BtnCancel.Height := 25;
    BtnCancel.Top := BtnOK.Top;
    BtnCancel.Left := InputForm.ClientWidth - BtnCancel.Width - 12;

    // Dynamically adjust form height to fit controls snugly
    InputForm.ClientHeight := BtnOK.Top + BtnOK.Height + 12;

    // Show the dialog and check the result
    if InputForm.ShowModal = mrOk then
    begin
      AValue := InputEdit.Text;
      Result := True;
    end;
  finally
    InputForm.Free;
  end;
end;

{%EndRegion}

{%Region -fold StringExHelper}

function TStringHelperEx.ToColor: TColor;
var
  S: string;
  R, G, B: byte;
begin
  // Remove leading #
  S := Self.Trim;

  if (S.Length = 7) and (S[1] = '#') then
    System.Delete(S, 1, 1);

  // Parse RRGGBB
  R := StrToInt('$' + System.Copy(S, 1, 2));
  G := StrToInt('$' + System.Copy(S, 3, 2));
  B := StrToInt('$' + System.Copy(S, 5, 2));

  // Build TColor
  Result := RGBToColor(R, G, B);
end;

function TStringHelperEx.UnescapeUnicode: string;
var
  i: integer;
  Code: string;
  tmp: integer;
begin
  // Initialize result
  Result := string.Empty;
  i := 1;

  // Loop through the input string
  while i <= Self.Length do
  begin
    // Handle Unicode escape sequence \uXXXX
    if (Self[i] = '\') and (i + 5 <= Self.Length) and (Self[i + 1] = 'u') then
    begin
      Code := System.Copy(Self, i + 2, 4);
      // Convert hexadecimal code to integer
      if TryStrToInt('$' + Code, tmp) and (tmp <= $FFFF) then
        // Explicit conversion to AnsiChar to remove warnings
        Result := Result + string(widechar(tmp))
      else
        Result := Result + '\u' + Code; // Keep original if conversion fails
      Inc(i, 6);
    end
    // Handle standard escape sequences \r, \n, \t, \\, \"
    else if (Self[i] = '\') and (i < Self.Length) then
    begin
      case Self[i + 1] of
        'r': Result := Result + #13;
        'n': Result := Result + #10;
        't': Result := Result + #9;
        '\': Result := Result + '\';
        '"': Result := Result + '"';
        else
          Result := Result + '\' + Self[i + 1]; // Keep unknown escapes as-is
      end;
      Inc(i, 2);
    end
    // Append normal character
    else
    begin
      Result := Result + Self[i];
      Inc(i);
    end;
  end;
end;

function TStringHelperEx.EscapeText: string;
begin
  Result := Self;

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

function TStringHelperEx.EncodeURLElement: string;
const
  NotAllowed = [';', '/', '?', ':', '@', '=', '&', '#', '+', '_', '<', '>', '"', '%', '{', '}', '|', '\', '^', '~', '[', ']', '`'];
var
  i, o, l: integer;
  h: string[2];
  P: pchar;
  c: ansichar;
begin
  Result := '';
  l := Self.Length;
  if (l = 0) then Exit;
  SetLength(Result, l * 3);
  P := PChar(Result);
  for I := 1 to L do
  begin
    C := Self[i];
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

function TStringHelperEx.HTTPDecode: string;
var
  S, SS, R: pchar;
  H: string[3];
  L, C: integer;
begin
  L := Self.Length;
  Result := '';
  SetLength(Result, L);
  if (L = 0) then
    exit;
  S := PChar(Self);
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

function TStringHelperEx.Utf8Truncate(MaxBytes: integer; Encode: boolean): string;
var
  p, startPtr: pchar;
  CharLen: integer;
  PredictedSize: integer;
  CurrentTotal: integer;
begin
  Result := '';
  if (Self = '') or (MaxBytes <= 0) then Exit;

  p := PChar(Self);
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

function TStringHelperEx.Utf8TruncateWithEncoding(MaxBytes: integer; Encode: boolean): string;
var
  p, startPtr: pchar;
  CharLen: integer;
  CurrentChar, EncodedChar: string;
  CurrentTotalBytes: integer;
begin
  Result := '';
  if (Self = '') or (MaxBytes <= 0) then Exit;

  p := PChar(Self);
  startPtr := p;
  CurrentTotalBytes := 0;

  while (p^ <> #0) do
  begin
    {$NOTES OFF}
    CharLen := UTF8CodepointSize(p);
    {$NOTES ON}
    SetString(CurrentChar, p, CharLen);

    if Encode then
      EncodedChar := CurrentChar.EncodeURLElement
    else
      EncodedChar := CurrentChar.EscapeText;

    if CurrentTotalBytes + EncodedChar.Length <= MaxBytes then
    begin
      Inc(CurrentTotalBytes, EncodedChar.Length);
      Inc(p, CharLen);
    end
    else
      Break;
  end;

  // Only allocate Result ONCE at the end
  if p > startPtr then
    SetString(Result, startPtr, p - startPtr);
end;

function TStringHelperEx.IsJson: boolean;
var
  Trimmed: string;
begin
  Trimmed := Self.TrimLeft;
  // Check first character
  Result := (Trimmed <> string.Empty) and ((Trimmed[1] = '{') or (Trimmed[1] = '['));
end;

function TStringHelperEx.RemoveEmptyParams: string;
var
  JsonData: TJSONData;
  JsonObj, ParamsObj, LangObjJson: TJSONObject;
  LangObj: TJSONData;
  I: integer;
  Params: TStringList;
begin
  Result := Self;

  // Check if input looks like JSON
  if (Self.Length > 0) and (Self[1] = '{') then
  begin
    try
      JsonData := GetJSON(Self);
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
    Params.DelimitedText := Self;

    for I := Params.Count - 1 downto 0 do
      if Pos('=', Params[I]) > 0 then
        if System.Copy(Params[I], Pos('=', Params[I]) + 1, MaxInt) = string.Empty then
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

procedure TStringHelperEx.SaveStringToFile(const FileName: string);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := Self;
    SL.SaveToFile(FileName, TEncoding.UTF8);
  finally
    SL.Free;
  end;
end;

procedure TStringHelperEx.OpenStringInTextEditor;
var
  SL: TStringList;
  FileName: string;
begin
  FileName := GetTempFileName(GetTempDir, 'txt_') + '.txt';

  SL := TStringList.Create;
  try
    SL.Text := Self;
    SL.SaveToFile(FileName); // save string to temp file
  finally
    SL.Free;
  end;

  // open with associated editor
  OpenDocument(FileName);
end;

function TStringHelperEx.RemoveTrailingLineBreak: string;
begin
  Result := Self;
  if (Result.Length >= 2) and (System.Copy(Result, Result.Length - 1, 2) = sLineBreak) then
    Result := System.Copy(Result, 1, Result.Length - 2)
  else if (Result.Length >= 1) and ((Result[Result.Length] = #10) or (Result[Result.Length] = #13)) then
    Result := System.Copy(Result, 1, Result.Length - 1);
end;

function TStringHelperEx.ExtractTextSample(MaxLen: integer = 500): string;
var
  CutPos, i, L: integer;
begin
  Result := Self.Trim;
  L := Result.Length;

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

  Result := System.Copy(Result, 1, CutPos).Trim;
end;

function TStringHelperEx.TryFormatJson(out AFormatted: string): boolean;
var
  JsonData: TJSONData;
begin
  Result := False;
  AFormatted := string.Empty;

  try
    // Try parse JSON
    JsonData := GetJSON(Self);
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

function TStringHelperEx.TryParseIPPort(out IP: string; out Port: Word): Boolean;
var
  Parts, IPParts: TStringList;
  i, Val: Integer;
  ok: Boolean;
  S: string;
begin
  S := Self.Trim;
  Result := False;
  Parts := TStringList.Create;
  try
    Parts.Delimiter := ':';
    Parts.StrictDelimiter := True;
    Parts.DelimitedText := S;
    if Parts.Count <> 2 then
      Exit;

    IP := Parts[0];

    // Validate the IP part (four numbers 0..255 separated by dots)
    IPParts := TStringList.Create;
    try
      IPParts.Delimiter := '.';
      IPParts.StrictDelimiter := True;
      IPParts.DelimitedText := IP;
      if IPParts.Count <> 4 then
        Exit;

      ok := True;
      for i := 0 to 3 do
      begin
        if not TryStrToInt(IPParts[i], Val) or (Val < 0) or (Val > 255) then
        begin
          ok := False;
          Break;
        end;
      end;
      if not ok then
        Exit;
    finally
      IPParts.Free;
    end;

    // Validate the port number (1..65535)
    if not TryStrToInt(Parts[1], Val) or (Val < 1) or (Val > 65535) then
      Exit;

    Port := Val;
    Result := True;
  finally
    Parts.Free;
  end;
end;

{%EndRegion}

{%Region -fold CaptionHelper}

function TCaptionHelper.Replace(const Old, New: string): TCaption;
begin
  Result := TCaption(string(Self).Replace(Old, New));
end;

{%EndRegion}

end.
