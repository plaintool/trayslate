//-----------------------------------------------------------------------------------
//  Trayslator © 2024 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

program trayslator;

{$mode objfpc}{$H+}
{$codepage utf8}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  SysUtils,
  opensslsockets,
  mainform,
  langtool,
  systemtool;

  {$R *.res}

begin
  RequireDerivedFormResource := True;
  Language := GetOSLanguage;
  DefaultFormatSettings.DecimalSeparator := '.';
  Application.Title:='Trayslator';
  Application.Scaled:=True;
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TformTrayslator, formTrayslator);
  ApplicationTranslate(Language);
  Application.Run;
end.
