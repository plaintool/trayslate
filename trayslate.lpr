//-----------------------------------------------------------------------------------
//  Trayslate © 2024 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

program trayslate;

{$mode objfpc}{$H+}
{$codepage utf8}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  SysUtils,
  openssl,
  opensslsockets,
  mainform,
  systemtool
  {$IFDEF WINDOWS}
  ,uDarkStyle
  ,uWin32WidgetSetDark
  {$ENDIF}
  ;

  {$R *.res}

begin
  RequireDerivedFormResource := True;
  Language := GetOSLanguage;
  Application.Title:='Trayslate';
  Application.Scaled:=True;
  Application.Initialize;
  InitSSLInterface;
  {$IFDEF WINDOWS}
  ApplyDarkStyle;
  {$ENDIF}
  Application.ShowMainForm := False;
  Application.CreateForm(TformTrayslate, formTrayslate);
  ApplicationTranslate(Language);
  Application.Run;
end.
