//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit base64utils;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  base64,
  Graphics,
  IntfGraphics,
  Controls,
  FPImage,
  FPReadPNG,
  FPReadBMP,
  FPReadJPEG,
  FPWriteBMP,
  FPWritePNG,
  FPCanvas,
  FPImgCanv,
  LCLType;

type
  { TBase64 }

  { Static class providing utility methods for Base64 encoding/decoding
    and image conversion. All methods are class methods and can be called
    without creating an instance. }
  TBase64 = class
  private
    class function StreamToBase64(const MS: TMemoryStream): string; static;
    class procedure Base64ToStream(const S: string; MS: TMemoryStream); static;
    class function FPImageToBitmap(Img: TFPMemoryImage): Graphics.TBitmap; static;
  public
    // Loads an image file, resizes it to 16x16 with white background,
    // and returns its Base64 representation (BMP encoded).
    class function LoadImageFileToBase64(const FileName: string): string; static;

    // Converts a Base64 string (BMP encoded) to a TBitmap.
    class function Base64ToBitmap(const Base64Str: string): Graphics.TBitmap; static;

    // Adds an image from a Base64 string to a TImageList.
    // The image is drawn onto a 16x16 white background and added as a masked bitmap.
    // Returns the index of the newly added image, or -1 on failure.
    class function AddBase64ToImageList(const Base64Str: string; AList: TImageList): integer; static;
  end;

implementation

{ TBase64 }

class function TBase64.StreamToBase64(const MS: TMemoryStream): string;
var
  Encoder: TBase64EncodingStream;
  SS: TStringStream;
begin
  Result := string.Empty;

  MS.Position := 0;
  SS := TStringStream.Create('');
  try
    Encoder := TBase64EncodingStream.Create(SS);
    try
      Encoder.CopyFrom(MS, MS.Size);
    finally
      Encoder.Free;
    end;

    Result := SS.DataString;
  finally
    SS.Free;
  end;
end;

class procedure TBase64.Base64ToStream(const S: string; MS: TMemoryStream);
var
  Decoder: TBase64DecodingStream;
  SS: TStringStream;
  Buffer: array of byte = ();
  Readed: integer;
begin
  MS.Clear;

  // Important: ASCII encoding to correctly interpret the Base64 string
  SS := TStringStream.Create(S, TEncoding.ASCII);
  try
    Decoder := TBase64DecodingStream.Create(SS);
    try
      SetLength(Buffer, 4096); // allocate buffer

      repeat
        // Read returns the number of bytes actually read
        Readed := Decoder.Read(Buffer[0], Length(Buffer));
        if Readed > 0 then
          MS.WriteBuffer(Buffer[0], Readed);
      until Readed = 0;

      MS.Position := 0;
    finally
      Decoder.Free;
    end;
  finally
    SS.Free;
  end;
end;

class function TBase64.FPImageToBitmap(Img: TFPMemoryImage): Graphics.TBitmap;
var
  IntfImg: TLazIntfImage;
begin
  Result := Graphics.TBitmap.Create;
  // Create an intermediate TLazIntfImage with a suitable raw image format.
  IntfImg := TLazIntfImage.Create(0, 0);
  try
    // Define the raw image format (32‑bit RGBA) before copying any data.
    IntfImg.DataDescription := GetDescriptionFromDevice(0);
    IntfImg.SetSize(Img.Width, Img.Height);

    // Manual pixel copy to ensure reliable operation across platforms.
    IntfImg.CopyPixels(Img);

    // Convert the internal representation to an LCL bitmap handle.
    Result.LoadFromIntfImage(IntfImg);
  finally
    IntfImg.Free;
  end;
end;

class function TBase64.LoadImageFileToBase64(const FileName: string): string;
var
  Img, Resized: TFPMemoryImage;
  Reader: TFPCustomImageReader;
  Writer: TFPWriterBMP;
  MS: TMemoryStream;
  Canvas: TFPImageCanvas;
begin
  Result := string.Empty;

  if not FileExists(FileName) then Exit;

  Img := TFPMemoryImage.Create(0, 0);
  Resized := TFPMemoryImage.Create(16, 16);
  MS := TMemoryStream.Create;
  Writer := TFPWriterBMP.Create;

  try
    // Select the appropriate reader based on file extension
    case LowerCase(ExtractFileExt(FileName)) of
      '.png': Reader := TFPReaderPNG.Create;
      '.bmp': Reader := TFPReaderBMP.Create;
      '.jpg', '.jpeg': Reader := TFPReaderJPEG.Create;
      else
        Exit;
    end;

    try
      Img.LoadFromFile(FileName, Reader);
    finally
      Reader.Free;
    end;

    Canvas := TFPImageCanvas.Create(Resized);
    try
      // Fill the canvas with white before drawing the image
      Canvas.Brush.FPColor := colWhite;
      Canvas.FillRect(0, 0, 16, 16);

      // Draw the loaded image scaled to 16x16
      Canvas.StretchDraw(0, 0, 16, 16, Img);
    finally
      Canvas.Free;
    end;

    Resized.SaveToStream(MS, Writer);

    MS.Position := 0;
    Result := StreamToBase64(MS);

  finally
    Img.Free;
    Resized.Free;
    MS.Free;
    Writer.Free;
  end;
end;

class function TBase64.Base64ToBitmap(const Base64Str: string): Graphics.TBitmap;
var
  MS: TMemoryStream;
  Img: TFPMemoryImage;
  Reader: TFPReaderBMP;
begin
  Result := nil;
  if Base64Str = string.Empty then exit;
  MS := TMemoryStream.Create;
  Img := TFPMemoryImage.Create(0, 0);
  Reader := TFPReaderBMP.Create;
  try
    try
      // Decode the Base64 string into a memory stream
      Base64ToStream(Base64Str, MS);
      MS.Position := 0;

      // Load the BMP data from the stream and convert to TBitmap
      Img.LoadFromStream(MS, Reader);
      Result := FPImageToBitmap(Img);
    except
      // On any error ensure we do not return a partially constructed object
      if Assigned(Result) then FreeAndNil(Result);
      // Optionally re‑raise the exception: raise;
    end;
  finally
    Reader.Free;
    Img.Free;
    MS.Free;
  end;
end;

class function TBase64.AddBase64ToImageList(const Base64Str: string; AList: TImageList): integer;
var
  Bmp, FixedBmp: Graphics.TBitmap;
begin
  Result := -1;

  if (Base64Str = '') or not Assigned(AList) then Exit;

  Bmp := Base64ToBitmap(Base64Str);
  FixedBmp := Graphics.TBitmap.Create;
  try
    if Assigned(Bmp) and (Bmp.Width > 0) then
    begin
      FixedBmp.SetSize(16, 16);

      // Fill the background with white
      FixedBmp.Canvas.Brush.Color := clWhite;
      FixedBmp.Canvas.FillRect(0, 0, 16, 16);

      // Draw the decoded bitmap onto the prepared canvas
      FixedBmp.Canvas.Draw(0, 0, Bmp);

      // Add to the image list using white as the transparent color
      Result := AList.AddMasked(FixedBmp, clWhite);
    end;
  finally
    Bmp.Free;
    FixedBmp.Free;
  end;
end;

end.
