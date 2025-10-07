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
  SysUtils;

function CreateTrayIconLang(const ALang1: string; const ALang2: string = ''): TIcon;

implementation

function CreateTrayIconLang(const ALang1: string; const ALang2: string = ''): TIcon;
var
  bmp: TBitmap;
  icon: TIcon;
  rect, r1, r2: TRect;
begin
  bmp := TBitmap.Create;
  icon := TIcon.Create;
  try
    bmp.Width := 16;  // standard tray icon size
    bmp.Height := 16;
    bmp.PixelFormat := pf32bit;

    // set background
    bmp.Canvas.Brush.Style := bsSolid;
    bmp.Canvas.Brush.Color := RGB(40, 150, 255); // background color
    rect := Types.Rect(0, 0, bmp.Width, bmp.Height);
    bmp.Canvas.FillRect(rect);

    // set text style
    bmp.Canvas.Font.Name := 'Tahoma';
    bmp.Canvas.Font.Color := RGB(220, 220, 220);
    bmp.Canvas.Font.Style := [fsBold];

    if (ALang2 = string.Empty) then
    begin
      bmp.Canvas.Font.Size := 8;
      // draw text centered
      DrawText(bmp.Canvas.Handle, PChar(ALang1), Length(ALang1), rect,
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

end.
