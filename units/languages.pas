//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit languages;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  StdCtrls,
  stringshelper,
  translate;

type
  TAppValue = record
    Code: string;        // ISO code (ru, en, de ...)
    DisplayName: string; // Name shown in UI (English)
  end;

  TValueArray = array of TAppValue;

const
  SpecialCodes: array[0..1] of string = ('auto', 'empty');
  AutoDetect = 'Auto Detect';

type
  TAppValueHelper = record helper for TAppValue
    function DisplayText: string;                      // "DisplayName (Code)"
    class function ExtractCode(const ItemText: string): string; static;
  end;

type
  // Static class that holds all language/currency/unit data and operations
  TLanguages = class sealed
  strict private
    class procedure SortValues(var AValues: TValueArray); static;
  public
    // Data retrieval
    class function GetLanguages: TValueArray; static;
    class function GetCurrencyFiat: TValueArray; static;
    class function GetCurrencyCrypto: TValueArray; static;
    class function GetUnits: TValueArray; static;
    class function GetValues(AValueType: TValueType; ASort: boolean = True): TValueArray; static;

    // Utility methods
    class function GetLanguageCodePairList(AValueType: TValueType): TStringList; static;
    class function GetLanguageDisplayStrings(AValueType: TValueType): TStringList; static;
    class function GetDisplayNamesFromCodeMap(ACodeMap: TStringList; AValueType: TValueType; Sort: boolean = False): TStringList; static;
    class function GetDisplayName(const ACode: string): string; static;
    class function GetLanguageCodeDisplayPairs(AValueType: TValueType; ASort: boolean = False;
      AIncludeSpecial: boolean = False): TStringList; static;
    class function ExtractCodeFromItem(const ItemText: string): string; static;
    class function FindIndexByCode(const AStrings: TStrings; const ACode: string): integer; static;
    class function IsSpecialCode(const Value: string): boolean; static;
    class procedure SetComboBoxByCode(ComboBox: TComboBox; const Code: string); static;
  end;

implementation

{$include languages_data.inc}
{$include currency_data.inc}
{$include currencycrypto_data.inc}
{$include units_data.inc}

{%Region -fold [TAppValue Helper Implementation]}

function TAppValueHelper.DisplayText: string;
begin
  Result := Format('%s (%s)', [DisplayName, Code]);
end;

class function TAppValueHelper.ExtractCode(const ItemText: string): string;
var
  P: SizeInt;
begin
  P := RPos(' (', ItemText);
  if P > 0 then
    Result := Copy(ItemText, P + 2, Length(ItemText) - P - 2)
  else
    Result := ItemText;
end;

{%EndRegion}

{%Region -fold [TLanguages - Data Retrieval]}

class function TLanguages.GetLanguages: TValueArray;
var
  i: integer;
begin
  Result := [];
  SetLength(Result, Length(Languages_Data));
  for i := 0 to High(Languages_Data) do
    Result[i] := Languages_Data[i];
end;

class function TLanguages.GetCurrencyFiat: TValueArray;
var
  i: integer;
begin
  Result := [];
  SetLength(Result, Length(Currency_Data));
  for i := 0 to High(Currency_Data) do
    Result[i] := Currency_Data[i];
end;

class function TLanguages.GetCurrencyCrypto: TValueArray;
var
  i: integer;
begin
  Result := [];
  SetLength(Result, Length(CurrencyCrypto_Data));
  for i := 0 to High(CurrencyCrypto_Data) do
    Result[i] := CurrencyCrypto_Data[i];
end;

class function TLanguages.GetUnits: TValueArray;
var
  i: integer;
begin
  Result := [];
  SetLength(Result, Length(Units_Data));
  for i := 0 to High(Units_Data) do
    Result[i] := Units_Data[i];
end;

{%EndRegion}

{%Region -fold [TLanguages - GetValues and Sorting]}

class procedure TLanguages.SortValues(var AValues: TValueArray);
var
  i, j: integer;
  Temp: TAppValue;
begin
  for i := 1 to High(AValues) do
  begin
    Temp := AValues[i];
    j := i - 1;
    while (j >= 1) and (AValues[j].DisplayName > Temp.DisplayName) do
    begin
      AValues[j + 1] := AValues[j];
      Dec(j);
    end;
    AValues[j + 1] := Temp;
  end;
end;

class function TLanguages.GetValues(AValueType: TValueType; ASort: boolean): TValueArray;
var
  i: integer;
  Fiat, Crypto: TValueArray;
begin
  Result := [];
  case AValueType of
    vtNone:
      SetLength(Result, 0);
    vtLanguage:
      Result := GetLanguages;
    vtCurrencyAll:
    begin
      Fiat := GetCurrencyFiat;
      Crypto := GetCurrencyCrypto;
      SetLength(Result, Length(Fiat) + Length(Crypto));
      for i := 0 to High(Fiat) do
        Result[i] := Fiat[i];
      for i := 0 to High(Crypto) do
        Result[Length(Fiat) + i] := Crypto[i];
    end;
    vtCurrencyFiat:
      Result := GetCurrencyFiat;
    vtCurrencyCrypto:
      Result := GetCurrencyCrypto;
    vtUnit:
      Result := GetUnits;
    else
      SetLength(Result, 0);
  end;

  if ASort then
    SortValues(Result);
end;

{%EndRegion}

{%Region -fold [TLanguages - Utility Methods]}

class function TLanguages.GetLanguageCodePairList(AValueType: TValueType): TStringList;
var
  Langs: array of TAppValue;
  i: integer;
begin
  Result := TStringList.Create;
  Result.TrailingLineBreak := False;
  try
    Langs := GetValues(AValueType, False);
    for i := 0 to Length(Langs) - 1 do
      Result.Add(Langs[i].Code + '=' + Langs[i].Code);
  except
    Result.Free;
    raise;
  end;
end;

class function TLanguages.GetLanguageDisplayStrings(AValueType: TValueType): TStringList;
var
  Langs: array of TAppValue;
  L: TAppValue;
begin
  Result := TStringList.Create;
  Langs := GetValues(AValueType);
  for L in Langs do
    Result.Add(L.DisplayName + ' (' + L.Code + ')');
end;

class function TLanguages.GetDisplayNamesFromCodeMap(ACodeMap: TStringList; AValueType: TValueType; Sort: boolean): TStringList;
var
  Langs: array of TAppValue;
  LangMap: TStringList;
  i, j, idx: integer;
  Key, ApiValue, DisplayString: string;
  SpecialsList, OthersList: TStringList;
  IsSpecial: boolean;
  CaseSensitiveSearch: boolean;
begin
  Result := TStringList.Create;
  try
    Langs := GetValues(AValueType);
    LangMap := TStringList.Create;
    try
      CaseSensitiveSearch := AValueType in [vtUnit, vtNone];
      LangMap.CaseSensitive := CaseSensitiveSearch;

      for i := 0 to High(Langs) do
        LangMap.Add(Langs[i].Code + '=' + Langs[i].DisplayName);

      SpecialsList := TStringList.Create;
      OthersList := TStringList.Create;
      try
        for i := 0 to ACodeMap.Count - 1 do
        begin
          if Trim(ACodeMap[i]) = string.Empty then
            Continue;

          Key := Trim(ACodeMap.Names[i]);
          ApiValue := Trim(ACodeMap.ValueFromIndex[i]);

          if (Key = string.Empty) or (ApiValue = string.Empty) then
            Continue;

          if CaseSensitiveSearch then
            idx := LangMap.IndexOfName(Key)
          else
            idx := LangMap.IndexOfNameIgnoreCase(Key);

          if idx >= 0 then
            DisplayString := LangMap.ValueFromIndex[idx] + ' (' + ApiValue + ')'
          else
            DisplayString := Key;

          IsSpecial := False;
          for j := Low(SpecialCodes) to High(SpecialCodes) do
            if SameText(Key, SpecialCodes[j]) then
            begin
              IsSpecial := True;
              Break;
            end;

          if IsSpecial then
            SpecialsList.Add(DisplayString)
          else
            OthersList.Add(DisplayString);
        end;

        if Sort then
        begin
          SpecialsList.Sort;
          OthersList.Sort;
        end;

        Result.Assign(SpecialsList);
        Result.AddStrings(OthersList);
      finally
        SpecialsList.Free;
        OthersList.Free;
      end;
    finally
      LangMap.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TLanguages.GetDisplayName(const ACode: string): string;
var
  Langs: array of TAppValue;
  i: integer;
begin
  Result := '';
  Langs := GetLanguages;
  for i := 0 to High(Langs) do
    if SameText(Langs[i].Code, ACode) then
      Exit(Langs[i].DisplayName);
end;

class function TLanguages.GetLanguageCodeDisplayPairs(AValueType: TValueType; ASort: boolean; AIncludeSpecial: boolean): TStringList;
var
  Langs: array of TAppValue;
  L: TAppValue;
begin
  Result := TStringList.Create;
  try
    Langs := GetValues(AValueType, ASort);
    for L in Langs do
    begin
      if not AIncludeSpecial and IsSpecialCode(L.Code) then
        Continue;
      Result.Add(L.DisplayName + ' (' + L.Code + ')');
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TLanguages.ExtractCodeFromItem(const ItemText: string): string;
begin
  Result := TAppValue.ExtractCode(ItemText);
end;

class function TLanguages.FindIndexByCode(const AStrings: TStrings; const ACode: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to AStrings.Count - 1 do
    if ExtractCodeFromItem(AStrings[i]) = ACode then
      Exit(i);
end;

class function TLanguages.IsSpecialCode(const Value: string): boolean;
var
  i: integer;
begin
  for i := Low(SpecialCodes) to High(SpecialCodes) do
    if SpecialCodes[i] = Value then
      Exit(True);
  Result := False;
end;

class procedure TLanguages.SetComboBoxByCode(ComboBox: TComboBox; const Code: string);
var
  i: integer;
begin
  for i := 0 to ComboBox.Items.Count - 1 do
  begin
    if SameText(ExtractCodeFromItem(ComboBox.Items[i]), Code) then
    begin
      ComboBox.ItemIndex := i;
      Exit;
    end;
  end;
end;

{%EndRegion}

end.
