//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit localize;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Forms,
  gettext,
  LazFileUtils,
  DefaultTranslator,
  Translations,
  LResources,
  LCLTranslator,
  {$IFDEF WINDOWS}
  Windows
  {$ENDIF}
  {$IFDEF LCLCarbon}
  MacOSAll
  {$ENDIF}
  ;

type
  { TLocalize }
  { Static class providing utilities for application localization,
    including OS language detection, translation loading and PO file helpers. }
  TLocalize = class
  public
  const
    { Default language code used as fallback }
    DEFAULT_LANG = 'en';
  public
    // Returns a two-letter ISO language code from the operating system user interface.
    class function GetOSLanguage: string; static;

    // Loads translations from a resource (or inline PoText) and applies them.
    // If AForm is specified only that form is translated; otherwise all forms and data modules.
    class function ApplicationTranslate(const Language: string; AForm: TCustomForm = nil; PoText: string = ''): boolean; static;

    // Extracts the language code from a .po file name (e.g., "app.ru.po" → "ru").
    class function GetLangCodeFromPoFile(const AFileName: string): string; static;

    // Reads the content of a .po file into a string. Returns an empty string on error.
    class function LoadCustomPoFile(const AFileName: string): string; static;
  end;

var
  Language: string;

implementation

{ TLocalize }

class function TLocalize.GetOSLanguage: string;
var
  fbl: string;
  {$IFDEF WINDOWS}
  l: string;
  {$ENDIF}
  {$IFDEF LCLCarbon}
  l: string;
  theLocaleRef: CFLocaleRef;
  locale: CFStringRef;
  buffer: StringPtr;
  bufferSize: CFIndex;
  encoding: CFStringEncoding;
  success: boolean;
  {$ENDIF}
begin
  fbl := '';
  {$IFDEF LCLCarbon}
  l := '';
  theLocaleRef := CFLocaleCopyCurrent;
  locale := CFLocaleGetIdentifier(theLocaleRef);
  encoding := 0;
  bufferSize := 256;
  buffer := new(StringPtr);
  success := CFStringGetPascalString(locale, buffer, bufferSize, encoding);
  if success then
    l := string(buffer^)
  else
    l := '';
  fbl := Copy(l, 1, 2);
  dispose(buffer);
  {$ELSE}
  {$IFDEF LINUX}
  fbl := Copy(GetEnvironmentVariable('LANG'), 1, 2);
  {$ELSE}
  l := '';
  GetLanguageIDs(l, fbl);
  {$ENDIF}
  {$ENDIF}
  Result := fbl;
end;

class function TLocalize.ApplicationTranslate(const Language: string; AForm: TCustomForm = nil; PoText: string = ''): boolean;
var
  Res: TResourceStream;
  PoStringStream: TStringStream;
  PoFile: TPOFile;
  LocalTranslator: TUpdateTranslator;
  i: integer;
  LangToUse: string;
  LangFound: boolean;
begin
  Result := False;
  Res := nil;
  PoStringStream := nil;
  PoFile := nil;
  LocalTranslator := nil;

  LangToUse := Language;

  try
    try
      PoFile := TPOFile.Create(False);
      if (PoText = '') then
      begin
        PoStringStream := TStringStream.Create('');

        try
          Res := TResourceStream.Create(HInstance, 'trayslate.' + LangToUse, RT_RCDATA);
          LangFound := True;
        except
          LangToUse := 'en';
          Res := TResourceStream.Create(HInstance, 'trayslate.en', RT_RCDATA);
          LangFound := False;
        end;

        Res.SaveToStream(PoStringStream);
        PoFile.ReadPOText(PoStringStream.DataString);
      end
      else
        PoFile.ReadPOText(PoText);

      if not Assigned(AForm) then
        Result := TranslateResourceStrings(PoFile);

      if Result or Assigned(AForm) then
      begin
        LocalTranslator := TPOTranslator.Create(PoFile);
        if Assigned(LRSTranslator) then
          LRSTranslator.Free;
        LRSTranslator := LocalTranslator;

        if Assigned(AForm) then
          LocalTranslator.UpdateTranslation(AForm)
        else
        begin
          for i := 0 to Screen.CustomFormCount - 1 do
            LocalTranslator.UpdateTranslation(Screen.CustomForms[i]);
          for i := 0 to Screen.DataModuleCount - 1 do
            LocalTranslator.UpdateTranslation(Screen.DataModules[i]);
        end;
      end;
    except
      Result := False;
    end;

    Result := Result and LangFound;
  finally
    if Assigned(LocalTranslator) then
    begin
      LRSTranslator := nil;
      LocalTranslator.Free;
    end
    else if Assigned(PoFile) then
      PoFile.Free;

    if Assigned(PoStringStream) then
      PoStringStream.Free;
    if Assigned(Res) then
      Res.Free;
  end;
end;

class function TLocalize.GetLangCodeFromPoFile(const AFileName: string): string;
var
  BaseName: string;
  ExtPos: integer;
  c1, c2: char;
begin
  Result := DEFAULT_LANG;

  if AFileName = '' then
    Exit;

  BaseName := ExtractFileName(AFileName);

  ExtPos := Pos('.po', LowerCase(BaseName));
  if ExtPos = 0 then
    Exit;

  BaseName := Copy(BaseName, 1, ExtPos - 1);

  if Length(BaseName) < 2 then
    Exit;

  c1 := BaseName[Length(BaseName) - 1];
  c2 := BaseName[Length(BaseName)];

  if (c1 in ['a'..'z', 'A'..'Z']) and (c2 in ['a'..'z', 'A'..'Z']) then
    Result := LowerCase(c1 + c2)
  else
    Result := DEFAULT_LANG;
end;

class function TLocalize.LoadCustomPoFile(const AFileName: string): string;
var
  FileContent: TStringList;
begin
  Result := '';

  if AFileName = '' then
    Exit;

  FileContent := TStringList.Create;
  try
    try
      FileContent.LoadFromFile(AFileName);
      Result := FileContent.Text;
    except
      Result := '';
    end;
  finally
    FileContent.Free;
  end;
end;

end.
