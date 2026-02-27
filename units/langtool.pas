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
  icon: TIcon;
  rect, r1, r2: TRect;
  Value: string;
begin
  bmp := TBitmap.Create;
  icon := TIcon.Create;
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
      Value := ALang1;
      if Pos('-', Value) > 0 then
        Value := LeftStr(Value, Pos('-', Value + '-') - 1);

      if (Length(Value) = 3) then
        bmp.Canvas.Font.Size := 5
      else
      begin
        bmp.Canvas.Font.Size := 8;
        Value := Value.Substring(0, 2);
      end;

      // draw text centered
      DrawText(bmp.Canvas.Handle, PChar(Value), Length(Value), rect,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
    else
    begin
      bmp.Canvas.Font.Size := 6;
      // upper half
      r1 := Types.Rect(rect.Left, rect.Top, rect.Right, (rect.Top + rect.Bottom) div 2);

      // lower half
      r2 := Types.Rect(rect.Left, (rect.Top + rect.Bottom) div 2, rect.Right, rect.Bottom);

      DrawText(bmp.Canvas.Handle, PChar(ALang1), Length(ALang1), r1,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
      DrawText(bmp.Canvas.Handle, PChar(ALang2), Length(ALang2), r2,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
    // create icon from bitmap
    icon.Assign(bmp);
    Result := icon;
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
