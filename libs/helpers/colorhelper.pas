//-----------------------------------------------------------------------------------
//  Helpers Package © 2026 by Alexander Tverskoy
//  Licensed under the MIT License
//  You may obtain a copy of the License at https://opensource.org/licenses/MIT
//-----------------------------------------------------------------------------------

unit colorhelper;

{$mode objfpc}{$H+}
{$modeswitch typehelpers}

interface

uses
  Graphics,
  SysUtils,
  LCLIntf;

type
  TColorHelper = type helper for TColor
  public
    // Blend two colors with given intensity (0-100)
    function BlendColor(AColor: TColor; Intensity: integer): TColor;

  // Invert font color against background, with mid-level threshold
    function InvertColor(ABackColor: TColor; MidLevel: integer = 128; AOnlyDarkBackground: boolean = False): TColor;

    // Simple inversion: flip each RGB channel
    function InvertColor: TColor;

    // Convert to web-compatible hex string (#RRGGBB)
    function ToHtml: string;

    // Lighten a dark color for dark themes (blend toward white)
    function ToDarkTheme(Delta: integer = 60): TColor;
  end;

implementation

{%Region -fold Color Utilities}

function TColorHelper.BlendColor(AColor: TColor; Intensity: integer): TColor;
var
  R1, G1, B1: byte;
  R2, G2, B2: byte;
  Alpha: double;
begin
  // Return original color if no blending needed
  if Intensity <= 0 then
    Exit(Self);

  // Return full blend color if maximum intensity
  if Intensity >= 100 then
    Exit(AColor);

  // Calculate blend factor (0.0 to 1.0)
  Alpha := Intensity / 100.0;

  // Extract RGB components from first color
  Self := ColorToRGB(Self);
  R1 := GetRValue(Self);
  G1 := GetGValue(Self);
  B1 := GetBValue(Self);

  // Extract RGB components from second color
  AColor := ColorToRGB(AColor);
  R2 := GetRValue(AColor);
  G2 := GetGValue(AColor);
  B2 := GetBValue(AColor);

  // Linear interpolation: result = Self * (1-alpha) + AColor * alpha
  Result := RGBToColor(Round(R1 * (1 - Alpha) + R2 * Alpha), Round(G1 * (1 - Alpha) + G2 * Alpha),
    Round(B1 * (1 - Alpha) + B2 * Alpha));
end;

function TColorHelper.InvertColor(ABackColor: TColor; MidLevel: integer = 128; AOnlyDarkBackground: boolean = False): TColor;
var
  Rb, Gb, Bb: byte;
  Rf, Gf, Bf: byte;
  BrightnessBack, BrightnessFont: double;
begin
  // Clamp MidLevel to valid byte range
  if MidLevel < 0 then MidLevel := 0;
  if MidLevel > 255 then MidLevel := 255;

  // Resolve system colors to actual RGB
  ABackColor := ColorToRGB(ABackColor);
  Self := ColorToRGB(Self);

  Rb := GetRValue(ABackColor);
  Gb := GetGValue(ABackColor);
  Bb := GetBValue(ABackColor);

  Rf := GetRValue(Self);
  Gf := GetGValue(Self);
  Bf := GetBValue(Self);

  // Perceived luminance using ITU-R BT.709 coefficients
  BrightnessBack := 0.299 * Rb + 0.587 * Gb + 0.114 * Bb;
  BrightnessFont := 0.299 * Rf + 0.587 * Gf + 0.114 * Bf;

  // Check if both colors are on the same side of the brightness threshold
  if (BrightnessBack < MidLevel) = (BrightnessFont < MidLevel) then
  begin
    if AOnlyDarkBackground then
    begin
      // Invert only if the background is dark (and thus the font is dark too)
      if BrightnessBack < MidLevel then
        Result := RGBToColor(255 - Rf, 255 - Gf, 255 - Bf)
      else
        Result := Self; // On a light background, leave the font unchanged
    end
    else
      // Default behavior: always invert when both are on the same side
      Result := RGBToColor(255 - Rf, 255 - Gf, 255 - Bf);
  end
  else
    Result := Self; // Already contrasting, keep the original font color
end;

function TColorHelper.InvertColor: TColor;
var
  C: TColor;
begin
  C := ColorToRGB(Self);
  Result := RGB(255 - GetRValue(C), 255 - GetGValue(C), 255 - GetBValue(C));
end;

function TColorHelper.ToHtml: string;
var
  C: TColor;
begin
  C := ColorToRGB(Self);
  Result := Format('#%.2x%.2x%.2x', [GetRValue(C), GetGValue(C), GetBValue(C)]);
end;

function TColorHelper.ToDarkTheme(Delta: integer = 60): TColor;
var
  R, G, B: byte;
  Bright: double;
  Factor: double;
begin
  Self := ColorToRGB(Self);
  R := GetRValue(Self);
  G := GetGValue(Self);
  B := GetBValue(Self);

  // Perceptual brightness (Luma) calculation
  Bright := (0.299 * R + 0.587 * G + 0.114 * B);

  // If already bright enough, return unchanged
  if Bright > 150 then
  begin
    Result := Self;
    Exit;
  end;

  // Delta is 1..100 mapped to 0.0..1.0 factor
  Factor := Delta / 100.0;
  if Factor < 0 then Factor := 0;
  if Factor > 1 then Factor := 1;

  // Linear interpolation towards white
  R := R + Round((255 - R) * Factor);
  G := G + Round((255 - G) * Factor);
  B := B + Round((255 - B) * Factor);

  Result := RGB(R, G, B);
end;

{%EndRegion}

end.
