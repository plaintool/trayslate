//-----------------------------------------------------------------------------------
//  Notetask © 2024 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit formattool;

{$mode ObjFPC}{$H+}
{$codepage utf8}

interface

uses
  Classes,
  SysUtils,
  Graphics;

  {TColor}

function ColorToHtml(AColor: TColor): string;

function ColorFromHtml(const AHtml: string): TColor;

implementation

{TColor}

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

end.
