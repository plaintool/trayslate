//-----------------------------------------------------------------------------------
//  Trayslator © 2024 by Alexander Tverskoy
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

function UnescapeUnicode(const S: string): string;

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

function UnescapeUnicode(const S: string): string;
var
  i: Integer;
  Code: string;
  tmp: Integer;
begin
  // Initialize result
  Result := '';
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
        Result := Result + string(WideChar(tmp))
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

end.
