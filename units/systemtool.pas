//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit systemtool;

{$mode ObjFPC}{$H+}
{$codepage utf8}

interface

uses
  Classes,
  Types,
  Forms,
  Controls,
  Menus,
  SysUtils,
  StrUtils,
  Graphics,
  IntfGraphics,
  Math,
  LCLIntf,
  LCLType,
  Dialogs,
  {$IFDEF WINDOWS}
  Windows,
  Registry,
  uDarkStyle,
  {$ENDIF}
  {$IFDEF Linux}
  Unix,
  LCLType,
  Process,
  opensslsockets,
  {$ENDIF}
  {$IFDEF MacOS}
  MacOSAll,
  opensslsockets,
  {$ENDIF}
  fpjson,
  jsonparser;

function ThemeColor(LightColor, DarkColor: TColor): TColor;

function ThemeValue(LightValue, DarkValue: integer): integer;

function IsDarkMode: boolean;

{$IFDEF WINDOWS}

function IsTaskbarDark: boolean;

{$ENDIF}

function SetCursorTo(Control: TControl; const ResName: string; CursorIndex: integer = 1001): boolean;

function SetFileTypeIcon(const Ext: string; IconIndex: integer): boolean;

procedure RegAutoStart(const AEnable: boolean; const AppName: string);

procedure BringToFrontNoFocus(AForm: TForm);

function IsWindows7: boolean;

function IsWindows11: boolean;

function GetTickCountXp: DWORD;

procedure SleepBusy(MS: integer);

procedure SleepLoop(ALoop: integer = 0; ASleep: integer = 0; AProcessMessages: boolean = True);

{ Tray Icon }

function CreateTrayIconLang(Form: TForm; const ALang1: string; const ALang2: string = string.Empty;
  ABackgroundColor: TColor = clNone; AFontColor: TColor = clWhite; AFontName: string = string.Empty): Graphics.TBitmap;

function CreateTrayIconProgress(AAngle: integer; ABackgroundColor: TColor = clNone; APenColor: TColor = clWhite): Graphics.TBitmap;

const
  ICON_SIZE = 16;

  DEF_FONT = 'Tahoma';
  DEF_NA = 'N/A';
  DEF_AUTO = '*';

implementation

function ThemeColor(LightColor, DarkColor: TColor): TColor;
begin
  {$IFDEF WINDOWS}
  if g_darkModeEnabled then
    Result := DarkColor
  else
    Result := LightColor;
  {$ELSE}
  Result := LightColor;
  {$ENDIF}
end;

function ThemeValue(LightValue, DarkValue: integer): integer;
begin
  {$IFDEF WINDOWS}
  if g_darkModeEnabled then
    Result := DarkValue
  else
    Result := LightValue;
  {$ELSE}
  Result := LightValue;
  {$ENDIF}
end;

function IsDarkMode: boolean;
begin
  {$IFDEF WINDOWS}
    Result := g_darkModeEnabled;
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

{$IFDEF WINDOWS}

function IsTaskbarDark: boolean;
var
  Reg: TRegistry;
begin
  // Default to dark mode, as it is the standard for Windows 10 and 11
  Result := True;
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    // Open the registry key where theme personalization settings are stored
    if Reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Themes\Personalize') then
    begin
      if Reg.ValueExists('SystemUsesLightTheme') then
      begin
        // SystemUsesLightTheme = 0 means the taskbar is DARK
        // SystemUsesLightTheme = 1 means it is LIGHT
        // We return True if it is dark (0)
        Result := Reg.ReadInteger('SystemUsesLightTheme') = 0;
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

{$ENDIF}

function SetCursorTo(Control: TControl; const ResName: string; CursorIndex: integer = 1001): boolean;
var
  ResStream: TResourceStream;
  Curs: TCursorImage;
begin
  Result := False;
  if not Assigned(Control) then Exit;

  ResStream := nil;
  Curs := TCursorImage.Create;
  try
    try
      ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
      ResStream.Position := 0;
      Curs.LoadFromStream(ResStream);
      Screen.Cursors[CursorIndex] := Curs.ReleaseHandle;
      Control.Cursor := CursorIndex;
      Result := True;
    except
      Result := False;
    end;
  finally
    ResStream.Free;
    Curs.Free;
  end;
end;

function SetFileTypeIcon(const Ext: string; IconIndex: integer): boolean;
var
  AppPath: string;
  {$IFDEF WINDOWS}
  Reg: TRegistry;
  IconPath: string;
  {$ENDIF}
  {$IFDEF Linux}
  //ThemeFile: TextFile;
  MimeFile: TextFile;
  DesktopFile: TextFile;
  MimeType: string;
  UserHome: string;
  {$ENDIF}
  {$IFDEF MacOS}
  PlistFile: TextFile;
  BundlePath: string;
  UserHome: string;
  {$ENDIF}

  {$IFDEF Linux}
  procedure SaveIconFromResources(const ResName, OutputPath: string; ResType: PChar = RT_RCDATA);
  var
    ResourceStream: TResourceStream;
    FileStream: TFileStream;
  begin
    try
      // Open the resource stream (ResName is the name of the resource, e.g., "icon.png")
      ResourceStream := TResourceStream.Create(HInstance, ResName, ResType);
      try
        // Create the output file
        FileStream := TFileStream.Create(OutputPath, fmCreate);
        try
          // Copy the content of the resource to the file
          FileStream.CopyFrom(ResourceStream, ResourceStream.Size);
        finally
          FileStream.Free; // Free the file stream
        end;
      finally
        ResourceStream.Free; // Free the resource stream
      end;
      Writeln('Icon successfully saved to: ', OutputPath); // Success message
    except
      on E: Exception do
        Writeln('Error while saving the icon: ', E.Message); // Error message
    end;
  end;
  {$ENDIF}
begin
  Result := False; // Initialize result to false

  {$IFDEF WINDOWS}
  try
    Reg := TRegistry.Create;
    AppPath := Application.ExeName;
    Reg.RootKey := HKEY_CLASSES_ROOT;

    // Create a key for the file extension
    if Reg.OpenKey(Ext, True) then
    begin
      Reg.WriteString('', 'trayslate'); // Assign the class name
      Reg.CloseKey;
    end;

    // Create a key for Trayslate
    if Reg.OpenKey('trayslate\DefaultIcon', True) then
    begin
      IconPath := Format('%s,%d', [AppPath, IconIndex]);
      Reg.WriteString('', IconPath); // Set the icon path
      Reg.CloseKey;
    end;

    // Create a key for opening the file
    if Reg.OpenKey('trayslate\shell\open\command', True) then
    begin
      Reg.WriteString('', Format('"%s" "%%1"', [AppPath])); // Command to open the file
      Reg.CloseKey;
    end;

    Result := True; // Set result to true if all operations succeeded
  except
    on E: Exception do
    begin
      // Handle any exceptions here (optional: log the error)
    end;
  end;

  Reg.Free; // Free the registry object
  {$ENDIF}

  {$IFDEF Linux}
  try
    AppPath := Application.ExeName;
    MimeType := 'application/x-trayslate';
    UserHome := GetEnvironmentVariable('HOME');

    // Create necessary directories if they do not exist
    ForceDirectories(UserHome + '/.local/share/mime/packages/');
    ForceDirectories(UserHome + '/.local/share/applications/');
    //ForceDirectories(UserHome + '/.local/share/icons/hicolor/48x48/mimetypes');

    //SaveIconFromResources('X-TASKDOC', UserHome + '/.local/share/icons/hicolor/48x48/mimetypes/x-taskdoc.png');

    // Create the index.theme file for the icon theme
    //AssignFile(ThemeFile, UserHome + '/.local/share/icons/hicolor/index.theme');
    //Rewrite(ThemeFile);
    //Writeln(ThemeFile, '[Icon Theme]');
    //Writeln(ThemeFile, 'Name=Hicolor');
    //Writeln(ThemeFile, 'Comment=Fallback icon theme');
    //Writeln(ThemeFile, 'Hidden=true');
    //Writeln(ThemeFile, 'Directories=48x48/mimetypes');
    //Writeln(ThemeFile, '');
    //Writeln(ThemeFile, '[48x48/mimetypes]');
    //Writeln(ThemeFile, 'Size=48'); // Specify available icon sizes
    //Writeln(ThemeFile, 'Type=Fixed'); // Type can be Fixed or Scalable
    //CloseFile(ThemeFile);

    // Create a .xml file for MIME type
    AssignFile(MimeFile, UserHome + '/.local/share/mime/packages/x-trayslate.xml');
    Rewrite(MimeFile);
    Writeln(MimeFile, '<?xml version="1.0" encoding="UTF-8"?>');
    Writeln(MimeFile, '<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">');
    Writeln(MimeFile, '  <mime-type type="', MimeType, '">');
    Writeln(MimeFile, '    <comment>Trayslate file</comment>');
    Writeln(MimeFile, '    <glob pattern="*', Ext, '"/>');
    //Writeln(MimeFile, '    <icon name="x-taskdoc"/>');
    Writeln(MimeFile, '  </mime-type>');
    Writeln(MimeFile, '</mime-info>');
    CloseFile(MimeFile);

    // Create a .desktop file
    AssignFile(DesktopFile, UserHome + '/.local/share/applications/x-trayslate.desktop');
    Rewrite(DesktopFile);
    Writeln(DesktopFile, '[Desktop Entry]');
    Writeln(DesktopFile, 'Name=Trayslate');
    Writeln(DesktopFile, 'Exec=', AppPath, ' %f');
    Writeln(DesktopFile, 'Type=Application');
    Writeln(DesktopFile, 'MimeType=', MimeType);
    CloseFile(DesktopFile);

    // Update MIME database
    if (FpSystem('xdg-mime install --mode user ' + UserHome + '/.local/share/mime/packages/x-trayslate.xml') = 0) and
       (FpSystem('xdg-icon-resource install --context mimetypes --size 48 ' + UserHome + '/.local/share/icons/hicolor/48x48/mimetypes/x-taskdoc.png x-taskdoc') = 0) and
       (FpSystem('update-mime-database ' + UserHome + '/.local/share/mime') = 0) and
       (FpSystem('gtk-update-icon-cache '+UserHome+'/.local/share/icons/hicolor -f') = 0) and
       (FpSystem('xdg-desktop-menu install --mode user ' + UserHome + '/.local/share/applications/x-trayslate.desktop') = 0)
       then
    begin
      Result := True; // Indicate success
    end
    else
    begin
      // Log error or handle failure
      Writeln('Error updating MIME database or desktop menu.');
    end;
  except
    on E: Exception do
    begin
      Writeln('Error: ', E.Message); // Print the error message for diagnosis
      Exit;
    end;
  end;
  {$ENDIF}

  {$IFDEF MacOS}
  try
    AppPath := Application.ExeName;
    UserHome := GetEnvironmentVariable('HOME');
    BundlePath := UserHome + '/Library/Application Support/Trayslate'; // Define a bundle path for the app

    // Create directory for app support if it does not exist
    if not DirectoryExists(BundlePath) then
      CreateDir(BundlePath);

    // Create a .plist file for the application
    AssignFile(PlistFile, BundlePath + '/com.example.trayslate.plist'); // Adjust the bundle identifier as needed
    Rewrite(PlistFile);
    Writeln(PlistFile, '<?xml version="1.0" encoding="UTF-8"?>');
    Writeln(PlistFile, '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">');
    Writeln(PlistFile, '<plist version="1.0">');
    Writeln(PlistFile, '<dict>');
    Writeln(PlistFile, '  <key>CFBundleTypeDeclarations</key>');
    Writeln(PlistFile, '  <array>');
    Writeln(PlistFile, '    <dict>');
    Writeln(PlistFile, '      <key>CFBundleTypeName</key>');
    Writeln(PlistFile, '      <string>Trayslate file</string>');
    Writeln(PlistFile, '      <key>CFBundleTypeRole</key>');
    Writeln(PlistFile, '      <string>Editor</string>');
    Writeln(PlistFile, '      <key>LSItemContentTypes</key>');
    Writeln(PlistFile, '      <array>');
    Writeln(PlistFile, '        <string>public.data</string>'); // Adjust the content type as needed
    Writeln(PlistFile, '      </array>');
    Writeln(PlistFile, '      <key>LSHandlerRank</key>');
    Writeln(PlistFile, '      <string>Owner</string>');
    Writeln(PlistFile, '      <key>CFBundleTypeIconFile</key>');
    Writeln(PlistFile, '      <string>your_icon.icns</string>'); // Replace with your icon file
    Writeln(PlistFile, '    </dict>');
    Writeln(PlistFile, '  </array>');
    Writeln(PlistFile, '</dict>');
    Writeln(PlistFile, '</plist>');
    CloseFile(PlistFile);


    // Associate the file extension with the application
    FpSystem(Format('duti -s com.example.trayslate .%s public.data', [Ext])); // Adjust the bundle identifier as needed

    Result := True; // Set result to true if all operations succeeded
  except
    on E: Exception do
    begin
      // Handle file creation error
      Exit;
    end;
  end;
  {$ENDIF}
end;

procedure RegAutoStart(const AEnable: boolean; const AppName: string);
var
  Reg: TRegistry;
  ExeName: string;
  OldName: string;
begin
  ExeName := '"' + ParamStr(0) + '"';

  OldName := 'Trayslate';

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) then
    begin
      // Remove old entry only if name changed
      if (AppName <> OldName) and Reg.ValueExists(OldName) then
        Reg.DeleteValue(OldName);

      if AEnable then
        Reg.WriteString(AppName, ExeName)
      else
      begin
        if Reg.ValueExists(AppName) then
          Reg.DeleteValue(AppName);

        // also clean legacy key when disabling
        if Reg.ValueExists(OldName) then
          Reg.DeleteValue(OldName);
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure BringToFrontNoFocus(AForm: TForm);
begin
  {$IFDEF WINDOWS}
    SetWindowPos(
      AForm.Handle,
      HWND_TOPMOST,
      0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW
    );

    SetWindowPos(
      AForm.Handle,
      HWND_NOTOPMOST,
      0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE
    );
  {$ELSE}
  AForm.BringToFront;
  {$ENDIF}
end;

function IsWindows7: boolean;
begin
  {$IFDEF WINDOWS}
  Result := (Win32MajorVersion = 6) and (Win32MinorVersion = 1);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function IsWindows11: boolean;
begin
  {$IFDEF WINDOWS}
  Result := (Win32MajorVersion >= 10) and (Win32BuildNumber >= 22000);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function GetTickCountXp: DWORD;
  {$IFDEF WINDOWS}
type
  TGetTickCount64 = function: QWORD; stdcall;
var
  h: THandle;
  p: TGetTickCount64;
  {$ENDIF}
begin
  {$IFDEF WINDOWS}
  h := GetModuleHandle('kernel32.dll');
  if h <> 0 then
    Pointer(p) := GetProcAddress(h, 'GetTickCount64')
  else
    Pointer(p) := nil;
  if Assigned(p) then
    Result := DWORD(p())
  else
    Result := GetTickCount;
  {$ELSE}
  // For Linux, macOS and other platforms, use the built-in function from LclIntf
  Result := LclIntf.GetTickCount64;
  {$ENDIF}
end;

procedure SleepBusy(MS: integer);
{$IFDEF WINDOWS}
var
  StartTick: DWORD;
{$ENDIF}
begin
  {$IFDEF WINDOWS}
  StartTick := GetTickCountXp;
  while (GetTickCountXp - StartTick) < DWORD(MS) do
    Application.ProcessMessages;
  {$ELSE}
  // non Windows fallback – simple sleep, no message processing
  Sleep(MS);
  {$ENDIF}
end;

procedure SleepLoop(ALoop: integer = 0; ASleep: integer = 0; AProcessMessages: boolean = True);
var
  i: integer;
begin
  if ALoop > 0 then
    for i := 1 to ALoop do
    begin
      if AProcessMessages then
        Application.ProcessMessages;
      if ASleep > 0 then
        SleepBusy(ASleep);
    end;
end;

{ Tray Icon }

function CreateTrayIconLang(Form: TForm; const ALang1: string; const ALang2: string = string.Empty;
  ABackgroundColor: TColor = clNone; AFontColor: TColor = clWhite; AFontName: string = string.Empty): Graphics.TBitmap;
var
  Bmp: Graphics.TBitmap;
  IntfImg: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  rect, rect1, rect2: TRect;
  delta: integer;
  Value: string;

  function FormatValue(const Value: string; DefSize: integer = 8): string;
  begin
    Result := Value;

    if Result = string.Empty then Result := DEF_NA;

    if Pos('-', Result) > 0 then
      Result := LeftStr(Result, Pos('-', Result + '-') - 1);

    if (Length(Result) = 3) then
      Bmp.Canvas.Font.Size := Form.ScaleScreenTo96(5)
    else
    begin
      if (LowerCase(Result) = 'auto') then
      begin
        Bmp.Canvas.Font.Size := Form.ScaleScreenTo96(8);
        Result := DEF_AUTO;
      end
      else
      begin
        Bmp.Canvas.Font.Size := Form.ScaleScreenTo96(DefSize);
        Result := Result.Substring(0, 2);
      end;
    end;
  end;

begin
  IntfImg := TLazIntfImage.Create(ICON_SIZE, ICON_SIZE);
  Bmp := Graphics.TBitmap.Create;
  try
    Bmp.SetSize(ICON_SIZE, ICON_SIZE);  // standard tray icon size

    // set background
    if ABackgroundColor = clNone then
    begin
      Bmp.Canvas.Brush.Color := clFuchsia;
      Bmp.Canvas.Font.Quality := fqNonAntialiased;
      Bmp.TransparentColor := clFuchsia;
      Bmp.Transparent := True;
    end
    else
      Bmp.Canvas.Brush.Color := ABackgroundColor;
    Bmp.Canvas.Brush.Style := bsSolid;
    rect := Types.Rect(0, 0, Bmp.Width, Bmp.Height);
    Bmp.Canvas.FillRect(rect);

    // set text style
    Bmp.Canvas.Font.Name := ifthen(AFontName = string.Empty, DEF_FONT, AFontName);
    Bmp.Canvas.Font.Color := AFontColor;
    Bmp.Canvas.Font.Style := [fsBold];

    if (ALang2 = string.Empty) then
    begin
      // draw text centered
      Value := FormatValue(ALang1);
      DrawText(Bmp.Canvas.Handle, PChar(Value), Length(Value), rect,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
    else
    begin
      // upper half
      Value := FormatValue(ALang1, 7);
      rect1 := Types.Rect(rect.Left, rect.Top, rect.Right, (rect.Top + rect.Bottom) div 2);
      DrawText(Bmp.Canvas.Handle, PChar(Value), Length(Value), rect1,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);

      // lower half
      Value := FormatValue(ALang2, 7);
      delta := ifthen(Value = DEF_AUTO, 3, 0);
      rect2 := Types.Rect(rect.Left, (rect.Top + rect.Bottom) div 2 + delta, rect.Right, rect.Bottom + delta);
      DrawText(Bmp.Canvas.Handle, PChar(Value), Length(Value), rect2,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;

    IntfImg.LoadFromBitmap(Bmp.Handle, Bmp.MaskHandle);

    // Copy it to a TBitmap
    IntfImg.CreateBitmaps(ImgHandle, ImgMaskHandle, False);
    Bmp.Handle := ImgHandle;
    Bmp.MaskHandle := ImgMaskHandle;

    // create icon from bitmap
    Result := Bmp;
  finally
    IntfImg.Free;
  end;
end;

function CreateTrayIconProgress(AAngle: integer; ABackgroundColor: TColor = clNone; APenColor: TColor = clWhite): Graphics.TBitmap;
var
  TempIntfImg: TLazIntfImage;
  ImgHandle, ImgMaskHandle: HBitmap;
  TempBitmap: Graphics.TBitmap;
  cx, cy, r: integer;
  p1x, p1y, p2x, p2y: integer;
  a1, a2: double;
begin
  TempIntfImg := TLazIntfImage.Create(ICON_SIZE, ICON_SIZE);
  TempBitmap := Graphics.TBitmap.Create;

  try
    TempBitmap.SetSize(ICON_SIZE, ICON_SIZE);

    // transparent background
    TempBitmap.Canvas.AntialiasingMode := amOn;

    if ABackgroundColor = clNone then
    begin
      TempBitmap.Canvas.Brush.Color := clFuchsia;
      TempBitmap.Transparent := True;
      TempBitmap.TransparentColor := clFuchsia;
    end
    else
      TempBitmap.Canvas.Brush.Color := ABackgroundColor;

    TempBitmap.Canvas.FillRect(Types.Rect(0, 0, ICON_SIZE, ICON_SIZE));
    TempBitmap.Canvas.Pen.Color := APenColor;
    TempBitmap.Canvas.Pen.Width := 3;

    cx := ICON_SIZE div 2;
    cy := ICON_SIZE div 2;
    r := (ICON_SIZE div 2) - 2;

    a1 := DegToRad(AAngle);
    a2 := DegToRad(AAngle + 180);

    // arc points
    p1x := cx + Round(r * Cos(a1));
    p1y := cy + Round(r * Sin(a1));

    p2x := cx + Round(r * Cos(a2));
    p2y := cy + Round(r * Sin(a2));
    TempBitmap.Canvas.Arc(
      cx - r, cy - r,
      cx + r, cy + r,
      p1x, p1y,
      p2x, p2y
      );

    // create mask through TLazIntfImage
    TempIntfImg.LoadFromBitmap(TempBitmap.Handle, TempBitmap.MaskHandle);
    TempIntfImg.CreateBitmaps(ImgHandle, ImgMaskHandle, False);

    TempBitmap.Handle := ImgHandle;
    TempBitmap.MaskHandle := ImgMaskHandle;

    Result := TempBitmap;
  finally
    TempIntfImg.Free;
  end;
end;

end.
