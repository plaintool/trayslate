//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit Consts;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  SysUtils,
  LCLIntf;


  { Commin Types }

type
  TMouseMode = (
    mmShowTranslateButton,
    mmShowBalloonTranslation,
    mmShowPopupTranslation,
    mmShowMainWindow
    );

  { Common Consts }

resourcestring
  rappname = 'Trayslate';

const
  REPO = 'plaintool/trayslate';
  APP_NAME = 'trayslate';

  {$IFDEF WINDOWS}
  HOTKEY_APP = 1;
  HOTKEY_TRANS_SWAP = 2;
  HOTKEY_TRANS_FROM_CLIPBOARD = 3;
  HOTKEY_TRANS_CLIPBOARD = 4;
  HOTKEY_TRANS_CLIPBOARD_POPUP = 5;
  HOTKEY_TRANS_FROM_CONTROL = 6;
  HOTKEY_TRANS_CONTROL = 7;
  HOTKEY_TRANS_CONTROL_POPUP = 8;
  HOTKEY_TRANS_OCR = 9;

  HOTKEY_RECENT1 = 11;
  HOTKEY_RECENT2 = 12;
  HOTKEY_RECENT3 = 13;
  HOTKEY_RECENT4 = 14;
  HOTKEY_RECENT5 = 15;
  HOTKEY_RECENT6 = 16;
  HOTKEY_RECENT7 = 17;
  HOTKEY_RECENT8 = 18;
  HOTKEY_RECENT9 = 19;

  HOTKEY_FAST_ALLOW_HOTKEYS = 20;
  HOTKEY_FAST_ENABLE_MOUSEMODE = 21;
  HOTKEY_FAST_MOUSEMODE_CTRL = 22;
  HOTKEY_FAST_AUTO_SWAP = 23;
  HOTKEY_FAST_AUTO_ADD_LANG_PAIRS = 24;
  HOTKEY_FAST_REAL_TIME = 25;
  HOTKEY_FAST_AUTO_COPY = 26;
  HOTKEY_FAST_VERTICAL_SPLIT = 27;
  HOTKEY_FAST_AUTO_HEIGHT = 28;
  HOTKEY_FAST_HIDE_CONTROLS = 29;
  HOTKEY_FAST_SPELL_CHECK = 30;
  {$ENDIF}

  { Main Form }

const
  DOUBLE_ENTER_INTERVAL = 200; // ms
  HOTKEY_INTERVAL = 100; // ms
  MOUSE_MODE_INTERVAL = 100; // ms
  MOUSE_MODE_DELTA = 10; // pixel
  MOUSE_DBL_INTERVAL = 500; // ms
  BUTTON_DELTA = 10;
  THREADS_WAIT_TIME = 5000; // ms

  MIDDLE_MOUSE = 'Middle-Click';
  DEF_LANGDETECT = 'languagedetect.ini';

  ICON_SIZE = 16;

  DEF_FONT = 'Tahoma';
  DEF_NA = 'N/A';
  DEF_AUTO = '*';
  DEF_AUTO_TEXT = 'auto';
  DEF_SMALL = 8;
  DEF_MINI = 7;
  DEF_TINY = 6;
  DEF_MICRO = 5;

resourcestring
  rswap = 'Swap (%s) with text (%s)';
  rtranslate = 'Translate (Ctrl ¦ Shift + Enter, Triple Enter)';
  rtranslatestop = 'Stop Translation (Esc)';
  rnoconfig = 'Configuration file not found! Create it in the configuration editor.';
  rtoremovepair = ' to remove pair';
  rremovepair = 'Are you sure you want to remove the pair "%s"?';
  ropenpofiletr = 'Language File (*.po)|*.po';
  renter = 'Enter';
  renterparameter = 'Enter the required parameter';
  rautodetect = 'Auto Detect';
  rcancel = 'Cancel';
  rcopytoclipboard = 'Copy To Clipboard';
  rtranslateinmainwindow = 'Translate In Main Window';
  rtranslateinpopup = 'Translate In Popup';
  rnorecognized = 'No text was recognized in the selected area. Try selecting a different region.';
  rocrneedlang = 'Screen OCR requires a specific source language. Please choose one in settings instead of automatic detection.';
  rocrnopacks = 'No OCR language packs are installed on this system.';
  rocrlanguagenotsupported = 'No OCR engine is installed for language "%s".' + LineEnding + 'Supported languages: %s';

  { Form Popup }

resourcestring
  rlockheight = 'Lock Height';
  runlockheight = 'Unlock Height';

implementation

end.
