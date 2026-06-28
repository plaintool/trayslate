//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit HotKeyHelper;

{$mode ObjFPC}{$H+}
{$modeswitch advancedrecords}   // <-- enables record helper in ObjFPC mode
{$codepage utf8}

interface

uses
  Classes,
  Menus,
  SysUtils,
  LCLType;

type
  THotKeyData = record
    Modifiers: cardinal;  // MOD_CONTROL, MOD_SHIFT...
    Key: word;            // virtual key code
  end;

  THotKeyDataHelper = record helper for THotKeyData
  public
    // Converts the hotkey to a human-readable string, e.g. "Ctrl+Shift+F1"
    function ToText: string;
    // Converts the hotkey to a TShortCut value
    function ToShortCut: TShortCut;
  end;

  TMouseMode = (
    mmShowTranslateButton,
    mmShowBalloonTranslation,
    mmShowPopupTranslation,
    mmShowMainWindow
    );

const
  {$IFDEF WINDOWS}
  HOTKEY_APP = 1;
  HOTKEY_TRANS_SWAP = 2;
  HOTKEY_TRANS_FROM_CLIPBOARD = 3;
  HOTKEY_TRANS_CLIPBOARD = 4;
  HOTKEY_TRANS_CLIPBOARD_POPUP = 5;
  HOTKEY_TRANS_FROM_CONTROL = 6;
  HOTKEY_TRANS_CONTROL = 7;
  HOTKEY_TRANS_CONTROL_POPUP = 8;

  HOTKEY_RECENT1 = 11;
  HOTKEY_RECENT2 = 12;
  HOTKEY_RECENT3 = 13;
  HOTKEY_RECENT4 = 14;
  HOTKEY_RECENT5 = 15;
  HOTKEY_RECENT6 = 16;
  HOTKEY_RECENT7 = 17;
  HOTKEY_RECENT8 = 18;
  HOTKEY_RECENT9 = 19;
  {$ENDIF}

  // Modifier flags for THotKeyData.Modifiers
  HOTKEY_CTRL  = 1 shl 1; // 2
  HOTKEY_SHIFT = 1 shl 2; // 4
  HOTKEY_ALT   = 1 shl 0; // 1
  HOTKEY_META  = 1 shl 3; // 8 (Win / Cmd)

implementation

{%Region -fold THotKeyDataHelper.ToText}
function THotKeyDataHelper.ToText: string;
begin
  Result := string.Empty;

  if (Self.Modifiers and HOTKEY_CTRL) <> 0 then
    Result := Result + 'Ctrl+';
  if (Self.Modifiers and HOTKEY_SHIFT) <> 0 then
    Result := Result + 'Shift+';
  if (Self.Modifiers and HOTKEY_ALT) <> 0 then
    Result := Result + 'Alt+';
  if (Self.Modifiers and HOTKEY_META) <> 0 then
    Result := Result + 'Win+';

  case Self.Key of
    0: ; // no key

    VK_RETURN: Result := Result + 'Enter';
    VK_SPACE: Result := Result + 'Space';
    VK_TAB: Result := Result + 'Tab';
    VK_ESCAPE: Result := Result + 'Esc';
    VK_BACK: Result := Result + 'Backspace';
    VK_DELETE: Result := Result + 'Delete';
    VK_INSERT: Result := Result + 'Insert';
    VK_HOME: Result := Result + 'Home';
    VK_END: Result := Result + 'End';
    VK_PRIOR: Result := Result + 'PageUp';
    VK_NEXT: Result := Result + 'PageDown';
    VK_LEFT: Result := Result + 'Left';
    VK_RIGHT: Result := Result + 'Right';
    VK_UP: Result := Result + 'Up';
    VK_DOWN: Result := Result + 'Down';

    // function keys
    VK_F1..VK_F24:
      Result := Result + 'F' + IntToStr(Self.Key - VK_F1 + 1);

    // numpad
    VK_NUMPAD0..VK_NUMPAD9:
      Result := Result + 'Num' + IntToStr(Self.Key - VK_NUMPAD0);

    VK_MULTIPLY: Result := Result + 'Num*';
    VK_ADD: Result := Result + 'Num Plus';
    VK_SUBTRACT: Result := Result + 'Num Minus';
    VK_DIVIDE: Result := Result + 'Num/';
    VK_DECIMAL: Result := Result + 'Num.';

    // special symbols
    VK_OEM_3: Result := Result + '`';       // ~ key (backtick)
    VK_OEM_MINUS: Result := Result + '-';
    VK_OEM_PLUS: Result := Result + '=';
    VK_OEM_4: Result := Result + '[';
    VK_OEM_6: Result := Result + ']';
    VK_OEM_5: Result := Result + '\';
    VK_OEM_1: Result := Result + ';';
    VK_OEM_7: Result := Result + '''';
    VK_OEM_COMMA: Result := Result + ',';
    VK_OEM_PERIOD: Result := Result + '.';
    VK_OEM_2: Result := Result + '/';

    else
      // fallback
      if (Self.Key >= 32) and (Self.Key <= 126) then
        Result := Result + Chr(Self.Key)
      else
        Result := Result + Format('VK_%d', [Self.Key]);
  end;
end;
{%EndRegion}

{%Region -fold THotKeyDataHelper.ToShortCut}
function THotKeyDataHelper.ToShortCut: TShortCut;
var
  Shift: TShiftState;
begin
  Shift := [];

  // Convert MOD_* to ShiftState
  if (Self.Modifiers and HOTKEY_CTRL) <> 0 then
    Include(Shift, ssCtrl);
  if (Self.Modifiers and HOTKEY_SHIFT) <> 0 then
    Include(Shift, ssShift);
  if (Self.Modifiers and HOTKEY_ALT) <> 0 then
    Include(Shift, ssAlt);

  Result := Menus.ShortCut(Self.Key, Shift);
end;
{%EndRegion}

end.
