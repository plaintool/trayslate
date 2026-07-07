//-----------------------------------------------------------------------------------
//  Helpers Package © 2026 by Alexander Tverskoy
//  Licensed under the MIT License
//  You may obtain a copy of the License at https://opensource.org/licenses/MIT
//-----------------------------------------------------------------------------------

unit osutils;

{$mode ObjFPC}{$H+}
{$codepage utf8}

interface

uses
  Classes,
  Forms,
  Controls,
  SysUtils,
  Graphics,
  Math,
  DateUtils,
  LCLIntf,
  LCLType,
  Dialogs,
  {$IFDEF WINDOWS}
  Windows,
  Registry,
  {$ENDIF}
  {$IFDEF Linux}
  Unix,
  Process,
  {$ENDIF}
  {$IFDEF MacOS}
  MacOSAll,
  {$ENDIF}
  fpjson, jsonparser;

type
  TOS = class
  public
    class function SetCursorTo(Control: TControl; const ResName: string; CursorIndex: integer = 1001): boolean; static;
    class function SetFileTypeIcon(const Ext: string; IconIndex: integer): boolean; static;
    class procedure RegAutoStart(const AEnable: boolean; const AppName: string); static;
    class procedure BringToFrontNoFocus(AForm: TForm); static;
    class function IsWindows7: boolean; static;
    class function IsWindows11: boolean; static;
    class function GetTickCountXp: DWORD; static;
    class procedure SleepBusy(MS: integer); static;
    class procedure SleepLoop(ALoop: integer = 0; ASleep: integer = 0; AProcessMessages: boolean = True); static;
    class function GetTimestamp: int64; static;
    class function GetTimestampMod(const SourceText: string): string;
    class function GetRandom(ALength: integer): int64; static;
  end;

implementation

class function TOS.SetCursorTo(Control: TControl; const ResName: string; CursorIndex: integer = 1001): boolean;
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

class function TOS.SetFileTypeIcon(const Ext: string; IconIndex: integer): boolean;
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

class procedure TOS.RegAutoStart(const AEnable: boolean; const AppName: string);
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

class procedure TOS.BringToFrontNoFocus(AForm: TForm);
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

class function TOS.IsWindows7: boolean;
begin
  {$IFDEF WINDOWS}
  Result := (Win32MajorVersion = 6) and (Win32MinorVersion = 1);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

class function TOS.IsWindows11: boolean;
begin
  {$IFDEF WINDOWS}
  Result := (Win32MajorVersion >= 10) and (Win32BuildNumber >= 22000);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

class function TOS.GetTickCountXp: DWORD;
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

class procedure TOS.SleepBusy(MS: integer);
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

class procedure TOS.SleepLoop(ALoop: integer = 0; ASleep: integer = 0; AProcessMessages: boolean = True);
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

class function TOS.GetTimestamp: int64;
var
  SystemTime: TFileTime = (dwLowDateTime: 0; dwHighDateTime: 0);
  Bias: int64;
begin
  // Get current system time in UTC (100-nanosecond intervals since January 1, 1601)
  GetSystemTimeAsFileTime(SystemTime);

  // Combine into a single 64-bit integer
  Result := int64(SystemTime.dwHighDateTime) shl 32 or SystemTime.dwLowDateTime;

  // Difference in 100-nanosecond intervals between 1601 and 1970
  Bias := 116444736000000000;

  // Convert to Unix Timestamp in milliseconds
  Result := (Result - Bias) div 10000;
end;

class function TOS.GetTimestampMod(const SourceText: string): string;
var
  i, TotalI, id: integer;
  CurrentMillis, Timestamp: int64;
begin
  // 1. Counting char
  TotalI := 0;
  for i := 1 to Length(SourceText) do
    if SourceText[i] = 'i' then
      Inc(TotalI);

  // 2. Take the current Unix time in milliseconds (UTC)
  //    assumes TOS.GetTimestamp returns Int64
  CurrentMillis := TOS.GetTimestamp;

  // 3. If there are no 'i' characters, return the timestamp unchanged
  if TotalI = 0 then
    Timestamp := CurrentMillis
  else
  begin
    // 4. Calculate the divisor
    id := TotalI + 1;

    // 5. Round up to the next multiple of id
    //    (matches the original JavaScript implementation)
    Timestamp := CurrentMillis - (CurrentMillis mod id) + id;
  end;

  // 6. Return as a string (ready to insert into JSON)
  Result := IntToStr(Timestamp);
end;

class function TOS.GetRandom(ALength: integer): int64;
var
  MinVal, MaxVal: int64;
begin
  if ALength > 18 then ALength := 18;
  if ALength < 1 then ALength := 1;

  MinVal := Trunc(Power(10, ALength - 1));
  MaxVal := Trunc(Power(10, ALength)) - 1;

  // Note: Randomize should be called once during app startup
  Result := MinVal + RandomRange(0, MaxVal - MinVal + 1);
end;

end.
