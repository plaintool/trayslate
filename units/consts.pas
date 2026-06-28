//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit consts;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  LCLIntf;

  { Common Consts }

resourcestring
  rappname = 'Trayslate';

const
  REPO = 'plaintool/trayslate';

  { Main Form }

resourcestring
  rswap = 'Swap (%s) with text (%s)';
  rnoconfig = 'Configuration file not found! Create it in the configuration editor.';
  rtoremovepair = ' to remove pair';
  rremovepair = 'Are you sure you want to remove the pair "%s"?';
  ropenpofiletr = 'Language File (*.po)|*.po';
  renter = 'Enter';
  renterparameter = 'Enter the required parameter';
  rautodetect = 'Auto Detect';

const
  DOUBLE_ENTER_INTERVAL = 200; // ms
  HOTKEY_INTERVAL = 500; // ms
  MOUSE_MODE_INTERVAL = 100; // ms
  MOUSE_MODE_DELTA = 10; // pixel
  MOUSE_DBL_INTERVAL = 500; // ms
  BUTTON_DELTA = 10;

  MIDDLE_MOUSE = 'Middle-Click';
  DEF_LANGDETECT = 'languagedetect.ini';

implementation

end.
