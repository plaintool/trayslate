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
  Dialogs,
  ExtCtrls,
  Menus,
  ActnList,
  StdCtrls,
  translate;

type

  { TformTrayslator }

  TformTrayslator = class(TForm)
    aExit: TAction;
    ActionList: TActionList;
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    MenuExit: TMenuItem;
    PopupTray: TPopupMenu;
    TrayIcon: TTrayIcon;
    procedure aExitExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
  private
    Trans: TTranslate;
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
  Trans := TTranslate.Create;
  TrayIcon.Icon := CreateTrayIconLang(UpperCase(Trans.TargetLang));
end;

procedure TformTrayslator.FormDestroy(Sender: TObject);
begin
  Trans.Free;
end;

procedure TformTrayslator.TrayIconClick(Sender: TObject);
begin
  if not Visible then
    Show
  else
    Hide;
end;

procedure TformTrayslator.aExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TformTrayslator.Button1Click(Sender: TObject);
begin
  Trans.Url := 'https://translate.googleapis.com/translate_a/single?client=gtx&dt=t&sl={source}&tl={target}&q={text}';
  Trans.TextToTranslate := Memo1.Text;
  Memo2.Text := Trans.TransJson;
end;

end.
