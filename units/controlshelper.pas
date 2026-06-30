//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit controlshelper;

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
  ColorBox,
  LCLIntf,
  LazUTF8;

type
  { Helper methods for TMemo }
  TMemoHelper = class helper for TMemo
  public
    procedure PasteWithLineEnding;
    procedure RemoveSameNameValueFromMemo;
    function HeadersFromMemo: TStringList;
  end;

  { Helper methods for TComboBox }
  TComboBoxHelper = class helper for TComboBox
  public
    procedure FillFontCombo;
  end;

  { Helper methods for TColorBox }
  TColorBoxHelper = class helper for TColorBox
  public
    procedure AddCustomColors;
  end;

implementation

{ TMemoHelper }

procedure TMemoHelper.PasteWithLineEnding;
var
  s: string;
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    s := Clipboard.AsText;

    s := StringReplace(s, #13#10, #10, [rfReplaceAll]); // Windows CRLF -> LF
    s := StringReplace(s, #13, #10, [rfReplaceAll]);   // Macintosh CR -> LF
    s := StringReplace(s, #10, LineEnding, [rfReplaceAll]); // LF -> platform line ending

    Self.SelText := s;
  end;
end;

procedure TMemoHelper.RemoveSameNameValueFromMemo;
var
  i: integer;
  EqualPos: integer;
  KeyPart, ValuePart: string;
begin
  for i := Self.Lines.Count - 1 downto 0 do
  begin
    EqualPos := Pos('=', Self.Lines[i]);

    // Skip lines without '='
    if EqualPos <= 0 then
      Continue;

    KeyPart := Copy(Self.Lines[i], 1, EqualPos - 1);
    ValuePart := Copy(Self.Lines[i], EqualPos + 1, MaxInt);

    // Case-sensitive compare
    if (KeyPart = ValuePart) and (Length(KeyPart) > 10) then
      Self.Lines[i] := KeyPart;
  end;
end;

function TMemoHelper.HeadersFromMemo: TStringList;
var
  i, p, pColon, pEqual: integer;
  line, Key, Value: string;
begin
  Result := TStringList.Create;

  for i := 0 to Self.Lines.Count - 1 do
  begin
    line := Trim(Self.Lines[i]);
    if line = '' then
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

    if Key <> '' then
      Result.Values[Key] := Value;  // stored as Key=Value internally
  end;
end;

{ TComboBoxHelper }

procedure TComboBoxHelper.FillFontCombo;
var
  i: integer;
begin
  Self.Items.BeginUpdate;
  try
    Self.Items.Clear;
    for i := 0 to Screen.Fonts.Count - 1 do
      Self.Items.Add(Screen.Fonts[i]);
  finally
    Self.Items.EndUpdate;
  end;
end;

{ TColorBoxHelper }

procedure TColorBoxHelper.AddCustomColors;
begin
  Self.Style := Self.Style + [cbCustomColor];

  // Basic colors
  Self.Items.AddObject('Black', TObject(PtrUInt($00000000)));
  Self.Items.AddObject('White', TObject(PtrUInt($00FFFFFF)));
  Self.Items.AddObject('Blue', TObject(PtrUInt($00FF0000)));
  Self.Items.AddObject('Red', TObject(PtrUInt($000000FF)));
  Self.Items.AddObject('Green', TObject(PtrUInt($0000FF00)));
  Self.Items.AddObject('Yellow', TObject(PtrUInt($0000FFFF)));
  Self.Items.AddObject('Cyan', TObject(PtrUInt($00FFFF00)));
  Self.Items.AddObject('Magenta', TObject(PtrUInt($00FF00FF)));
  Self.Items.AddObject('Gray', TObject(PtrUInt($00808080)));
  Self.Items.AddObject('Silver', TObject(PtrUInt($00C0C0C0)));

  // Dark neutrals
  Self.Items.AddObject('Graphite', TObject(PtrUInt($00454545)));
  Self.Items.AddObject('Charcoal', TObject(PtrUInt($00353535)));
  Self.Items.AddObject('Slate', TObject(PtrUInt($00505060)));
  Self.Items.AddObject('Steel Gray', TObject(PtrUInt($00606070)));

  // Reds
  Self.Items.AddObject('Crimson', TObject(PtrUInt($003C3CFF)));
  Self.Items.AddObject('Cherry', TObject(PtrUInt($002020D0)));
  Self.Items.AddObject('Ruby', TObject(PtrUInt($004040E0)));
  Self.Items.AddObject('Wine', TObject(PtrUInt($004060A0)));
  Self.Items.AddObject('Blood Red', TObject(PtrUInt($000000CC)));
  Self.Items.AddObject('Scarlet', TObject(PtrUInt($000A10FF)));
  Self.Items.AddObject('Brick', TObject(PtrUInt($001020A0)));
  Self.Items.AddObject('Rosewood', TObject(PtrUInt($00203080)));

  // Oranges
  Self.Items.AddObject('Amber', TObject(PtrUInt($0000C8FF)));
  Self.Items.AddObject('Tangerine', TObject(PtrUInt($0010A5FF)));
  Self.Items.AddObject('Copper', TObject(PtrUInt($002A6BFF)));
  Self.Items.AddObject('Sunset', TObject(PtrUInt($004080FF)));
  Self.Items.AddObject('Burnt Orange', TObject(PtrUInt($001060D0)));
  Self.Items.AddObject('Rust', TObject(PtrUInt($002050B0)));
  Self.Items.AddObject('Deep Tangerine', TObject(PtrUInt($000040A0)));
  Self.Items.AddObject('Orange Peel', TObject(PtrUInt($000070C0)));
  Self.Items.AddObject('Autumn Orange', TObject(PtrUInt($001050C0)));
  Self.Items.AddObject('Spice', TObject(PtrUInt($002060B0)));
  Self.Items.AddObject('Copper Dark', TObject(PtrUInt($00303090)));

  // Yellows
  Self.Items.AddObject('Gold', TObject(PtrUInt($0000D7FF)));
  Self.Items.AddObject('Mustard', TObject(PtrUInt($0020B5D0)));
  Self.Items.AddObject('Honey', TObject(PtrUInt($0030C8E0)));
  Self.Items.AddObject('Sand', TObject(PtrUInt($0050D8E8)));
  Self.Items.AddObject('Lemon', TObject(PtrUInt($0000F0FF)));
  Self.Items.AddObject('Canary', TObject(PtrUInt($0000FFFF)));
  Self.Items.AddObject('Butter', TObject(PtrUInt($0010F0F0)));
  Self.Items.AddObject('Dijon', TObject(PtrUInt($0020D0D0)));
  Self.Items.AddObject('Old Gold', TObject(PtrUInt($002090C0)));
  Self.Items.AddObject('Antique Gold', TObject(PtrUInt($001070A0)));
  Self.Items.AddObject('Bronze Yellow', TObject(PtrUInt($00106090)));
  Self.Items.AddObject('Mustard Dark', TObject(PtrUInt($000080A0)));
  Self.Items.AddObject('Ochre', TObject(PtrUInt($00007090)));
  Self.Items.AddObject('Amber Dark', TObject(PtrUInt($00005080)));
  Self.Items.AddObject('Honey Brown', TObject(PtrUInt($00104070)));
  Self.Items.AddObject('Olive', TObject(PtrUInt($00308080)));

  // Greens
  Self.Items.AddObject('Emerald', TObject(PtrUInt($0032CD32)));
  Self.Items.AddObject('Forest', TObject(PtrUInt($00228B22)));
  Self.Items.AddObject('Lime', TObject(PtrUInt($0000FF80)));
  Self.Items.AddObject('Mint', TObject(PtrUInt($0078D890)));
  Self.Items.AddObject('Moss', TObject(PtrUInt($00408060)));
  Self.Items.AddObject('Leaf Green', TObject(PtrUInt($0050C050)));
  Self.Items.AddObject('Grass', TObject(PtrUInt($0060B050)));
  Self.Items.AddObject('Meadow', TObject(PtrUInt($0070C060)));
  Self.Items.AddObject('Fern', TObject(PtrUInt($00409040)));
  Self.Items.AddObject('Apple Green', TObject(PtrUInt($0080D070)));
  Self.Items.AddObject('Natural Green', TObject(PtrUInt($0060A060)));
  Self.Items.AddObject('Shamrock', TObject(PtrUInt($0050B070)));
  Self.Items.AddObject('Jungle Green', TObject(PtrUInt($00408050)));
  Self.Items.AddObject('Jade', TObject(PtrUInt($0050C060)));
  Self.Items.AddObject('Pine', TObject(PtrUInt($00306030)));
  Self.Items.AddObject('Herb', TObject(PtrUInt($0040A040)));
  Self.Items.AddObject('Seaweed', TObject(PtrUInt($00609060)));
  Self.Items.AddObject('Neon Green', TObject(PtrUInt($0000FF40)));
  Self.Items.AddObject('Spring', TObject(PtrUInt($0020FF80)));

  // Cyans
  Self.Items.AddObject('Turquoise', TObject(PtrUInt($00D0E040)));
  Self.Items.AddObject('Aqua', TObject(PtrUInt($00FFFF00)));
  Self.Items.AddObject('Teal', TObject(PtrUInt($00808000)));
  Self.Items.AddObject('Lagoon', TObject(PtrUInt($00D0C000)));
  Self.Items.AddObject('Pool', TObject(PtrUInt($00B0A000)));
  Self.Items.AddObject('Deep Sky Cyan', TObject(PtrUInt($00C0B050)));
  Self.Items.AddObject('Muted Teal', TObject(PtrUInt($00B0A040)));
  Self.Items.AddObject('Storm Aqua', TObject(PtrUInt($00A09040)));
  Self.Items.AddObject('Dark Seafoam', TObject(PtrUInt($00908030)));
  Self.Items.AddObject('Cold Cyan', TObject(PtrUInt($00B0A060)));
  Self.Items.AddObject('Faded Glacier', TObject(PtrUInt($00907030)));
  Self.Items.AddObject('Deep Lagoon', TObject(PtrUInt($00806020)));
  Self.Items.AddObject('Arctic Depth', TObject(PtrUInt($00705020)));

  // Blues
  Self.Items.AddObject('Azure', TObject(PtrUInt($00FF9E2B)));
  Self.Items.AddObject('Royal Blue', TObject(PtrUInt($00E16941)));
  Self.Items.AddObject('Sky', TObject(PtrUInt($00FFBF00)));
  Self.Items.AddObject('Sea Blue', TObject(PtrUInt($00C07000)));
  Self.Items.AddObject('Ocean', TObject(PtrUInt($00B06000)));
  Self.Items.AddObject('Ocean Deep', TObject(PtrUInt($00905000)));
  Self.Items.AddObject('Midnight', TObject(PtrUInt($00800000)));
  Self.Items.AddObject('Blue Steel', TObject(PtrUInt($00C06040)));
  Self.Items.AddObject('Cornflower', TObject(PtrUInt($00E09050)));
  Self.Items.AddObject('Denim Blue', TObject(PtrUInt($00D07040)));
  Self.Items.AddObject('Classic Blue', TObject(PtrUInt($00FF7030)));
  Self.Items.AddObject('Medium Azure', TObject(PtrUInt($00E08040)));
  Self.Items.AddObject('Sky Blue Soft', TObject(PtrUInt($00F0A060)));
  Self.Items.AddObject('Ocean Medium', TObject(PtrUInt($00D06030)));
  Self.Items.AddObject('Steel Blue', TObject(PtrUInt($00A06040)));
  Self.Items.AddObject('Navy', TObject(PtrUInt($00600000)));
  Self.Items.AddObject('Cobalt', TObject(PtrUInt($00B04020)));
  Self.Items.AddObject('Sapphire', TObject(PtrUInt($00C05030)));
  Self.Items.AddObject('Denim', TObject(PtrUInt($00A05030)));
  Self.Items.AddObject('Sky Deep', TObject(PtrUInt($00908010)));
  Self.Items.AddObject('Twilight', TObject(PtrUInt($00704020)));

  // Purples
  Self.Items.AddObject('Violet', TObject(PtrUInt($00D670DA)));
  Self.Items.AddObject('Plum', TObject(PtrUInt($00B070C0)));
  Self.Items.AddObject('Orchid', TObject(PtrUInt($00CC66CC)));
  Self.Items.AddObject('Lavender', TObject(PtrUInt($00E6A8D7)));
  Self.Items.AddObject('Amethyst', TObject(PtrUInt($00A060C0)));
  Self.Items.AddObject('Grape', TObject(PtrUInt($008050A0)));
  Self.Items.AddObject('Eggplant', TObject(PtrUInt($00604080)));
  Self.Items.AddObject('Lilac', TObject(PtrUInt($00D0A0E0)));
  Self.Items.AddObject('Indigo', TObject(PtrUInt($0082004B)));

  // Pinks
  Self.Items.AddObject('Rose', TObject(PtrUInt($006060FF)));
  Self.Items.AddObject('Coral', TObject(PtrUInt($00507FFF)));
  Self.Items.AddObject('Blush', TObject(PtrUInt($007080FF)));
  Self.Items.AddObject('Magenta', TObject(PtrUInt($00FF00FF)));
  Self.Items.AddObject('Bubblegum', TObject(PtrUInt($00FF80FF)));
  Self.Items.AddObject('Flamingo', TObject(PtrUInt($0080A0FF)));
  Self.Items.AddObject('Peony', TObject(PtrUInt($009090FF)));
  Self.Items.AddObject('Candy', TObject(PtrUInt($00FF60FF)));
  Self.Items.AddObject('Dusty Rose', TObject(PtrUInt($004060A0)));
  Self.Items.AddObject('Wine Rose', TObject(PtrUInt($00304090)));
  Self.Items.AddObject('Deep Pink', TObject(PtrUInt($005000C0)));
  Self.Items.AddObject('Mulberry', TObject(PtrUInt($00302070)));
  Self.Items.AddObject('Burgundy Pink', TObject(PtrUInt($00201060)));
  Self.Items.AddObject('Dark Fuchsia', TObject(PtrUInt($004000A0)));
end;

end.
