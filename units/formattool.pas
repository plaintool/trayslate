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

function GetTimestampNow: int64;

function GetRandomID(ALength: integer): int64;

procedure PasteWithLineEnding(AMemo: TMemo);

procedure RemoveSameNameValueFromMemo(Memo: TMemo);

function HeadersFromMemo(AMemo: TMemo): TStringList;

procedure FillFontCombo(ACombo: TComboBox);

procedure AddCustomColors(AColorBox: TColorBox);

implementation

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

end.
