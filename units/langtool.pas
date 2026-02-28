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
  Windows,
  Graphics,
  Types,
  SysUtils,
  StdCtrls;

function CreateTrayIconLang(const ALang1: string; const ALang2: string = ''; ABackgroundColor: TColor = $00FF9628;
  AFontColor: TColor = $00DCDCDC): TIcon;

procedure SetComboBoxByCode(ComboBox: TComboBox; const Code: string);

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
      Value := FormatValue(ALang1, 6);
      rect1 := Types.Rect(rect.Left, rect.Top, rect.Right, (rect.Top + rect.Bottom) div 2);
      DrawText(bmp.Canvas.Handle, PChar(Value), Length(Value), rect1,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);

      // lower half
      Value := FormatValue(ALang2, 6);
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


end.
