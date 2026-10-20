//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

program Trayslate;

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
  Consts,
  AppInstance,
  MainForm,
  Localize
  {$IFDEF WINDOWS}
  ,uDarkStyle
  ,uWin32WidgetSetDark
  {$ENDIF}
  ;

  {$R *.res}

begin
  {$IFDEF DEBUG}
  GlobalSkipIfNoLeaks := True;
  {$ENDIF}

  RequireDerivedFormResource := True;
  Language := TLocalize.GetOSLanguage;
  Application.Title := 'Trayslate';
  Application.Scaled := True;
  Application.Initialize;
  if not AcquireSingleInstance then
  begin
    SendToExistingInstance(ParamStr(1));
    Halt;
  end;
  Randomize;
  InitSSLInterface;
  {$IFDEF WINDOWS}
  ApplyDarkStyle;
  {$ENDIF}
  Application.ShowMainForm := False;
  Application.CreateForm(TformTrayslate, formTrayslate);
  SetAppInstanceMessageEvent(@formTrayslate.OnAppInstanceMessage);
  TLocalize.ApplicationTranslate(APP_NAME, Language, nil, TLocalize.LoadCustomPoFile(formTrayslate.CustomPoFile));
  TLocalize.UpdatePackageTranslations(APP_NAME, 'checkupdates', Language, ['CheckUpdates']);
  Application.Run;
end.
