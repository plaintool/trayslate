//-----------------------------------------------------------------------------------
//  Trayslator © 2024 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit mainform;

{$mode ObjFPC}{$H+}
{$codepage utf8}

interface

uses
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs, ExtCtrls;

type

  { TformTrayslator }

  TformTrayslator = class(TForm)
    trayIcon: TTrayIcon;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  formTrayslator: TformTrayslator;

implementation

uses langtool;

  {$R *.lfm}

  { TformTrayslator }

procedure TformTrayslator.FormCreate(Sender: TObject);
begin
  trayIcon.Icon := CreateTrayIconLang('RU');
end;

end.
