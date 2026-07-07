//-----------------------------------------------------------------------------------
//  darkutils.pas Unit © 2026 by Alexander Tverskoy
//  Licensed under the MIT License
//  You may obtain a copy of the License at https://opensource.org/licenses/MIT
//-----------------------------------------------------------------------------------

unit darkutils;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  Graphics,
 {$IFDEF WINDOWS}
  uDarkStyle,
  Registry;
{$ENDIF}

type
  TDarkUtils = class
  public
    // Returns the appropriate color based on the current dark mode state.
    class function ThemeColor(LightColor, DarkColor: TColor): TColor; static;

    // Returns the appropriate integer value based on the current dark mode state.
    class function ThemeValue(LightValue, DarkValue: Integer): Integer; static;

    // Indicates whether the system is currently in dark mode.
    class function IsDarkMode: Boolean; static;

    // Detects whether the Windows taskbar is using a dark theme.
    // This method is only effective on Windows; on other platforms it returns False.
    class function IsTaskbarDark: Boolean; static;
  end;

implementation

{$IFDEF WINDOWS}
uses
  Windows;  // for KEY_READ constant
{$ENDIF}

class function TDarkUtils.ThemeColor(LightColor, DarkColor: TColor): TColor;
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

class function TDarkUtils.ThemeValue(LightValue, DarkValue: Integer): Integer;
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

class function TDarkUtils.IsDarkMode: Boolean;
begin
  {$IFDEF WINDOWS}
    Result := g_darkModeEnabled;
  {$ELSE}
    Result := False;
  {$ENDIF}
end;

{$IFDEF WINDOWS}

class function TDarkUtils.IsTaskbarDark: Boolean;
var
  Reg: TRegistry;
begin
  // Default to dark mode, as it is the standard for Windows 10 and 11
  Result := True;
  Reg := TRegistry.Create;
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

end.
