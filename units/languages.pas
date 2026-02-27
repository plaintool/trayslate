unit languages;

interface

uses
  Classes,
  SysUtils,
  StrUtils;

type
  TAppLanguage = record
    Code: string;        // ISO code (ru, en, de ...)
    DisplayName: string; // Name shown in UI (English)
  end;

type
  TAppLanguageArray = array of TAppLanguage;

function GetLanguages: TAppLanguageArray;

function GetLanguageCodePairList: TStringList;

function GetLanguageDisplayStrings: TStringList;

function GetDisplayNamesFromCodeMap(ACodeMap: TStringList): TStringList;

function ExtractCodeFromItem(const ItemText: string): string;

implementation

function GetLanguages: TAppLanguageArray;
const
  Languages: array[0..248] of TAppLanguage = (
    (Code: 'auto';     DisplayName: 'Auto detect'),
    (Code: 'ab';       DisplayName: 'Abkhazian'),
    (Code: 'awa';      DisplayName: 'Awadhi'),
    (Code: 'av';       DisplayName: 'Avar'),
    (Code: 'az';       DisplayName: 'Azerbaijani'),
    (Code: 'ay';       DisplayName: 'Aymara'),
    (Code: 'sq';       DisplayName: 'Albanian'),
    (Code: 'alz';      DisplayName: 'Alur'),
    (Code: 'am';       DisplayName: 'Amharic'),
    (Code: 'en';       DisplayName: 'English'),
    (Code: 'ar';       DisplayName: 'Arabic'),
    (Code: 'hy';       DisplayName: 'Armenian'),
    (Code: 'as';       DisplayName: 'Assamese'),
    (Code: 'aa';       DisplayName: 'Afar'),
    (Code: 'af';       DisplayName: 'Afrikaans'),
    (Code: 'ace';      DisplayName: 'Acehnese'),
    (Code: 'ach';      DisplayName: 'Acholi'),
    (Code: 'ban';      DisplayName: 'Balinese'),
    (Code: 'bm';       DisplayName: 'Bambara'),
    (Code: 'eu';       DisplayName: 'Basque'),
    (Code: 'bci';      DisplayName: 'Baoulé'),
    (Code: 'ba';       DisplayName: 'Bashkir'),
    (Code: 'be';       DisplayName: 'Belarusian'),
    (Code: 'bal';      DisplayName: 'Balochi'),
    (Code: 'bem';      DisplayName: 'Bemba'),
    (Code: 'bn';       DisplayName: 'Bengali'),
    (Code: 'bew';      DisplayName: 'Betawi'),
    (Code: 'bik';      DisplayName: 'Bikol'),
    (Code: 'my';       DisplayName: 'Burmese'),
    (Code: 'bg';       DisplayName: 'Bulgarian'),
    (Code: 'bs';       DisplayName: 'Bosnian'),
    (Code: 'br';       DisplayName: 'Breton'),
    (Code: 'bua';      DisplayName: 'Buryat'),
    (Code: 'bho';      DisplayName: 'Bhojpuri'),
    (Code: 'cy';       DisplayName: 'Welsh'),
    (Code: 'war';      DisplayName: 'Waray'),
    (Code: 'hu';       DisplayName: 'Hungarian'),
    (Code: 've';       DisplayName: 'Venda'),
    (Code: 'vec';      DisplayName: 'Venetian'),
    (Code: 'wo';       DisplayName: 'Wolof'),
    (Code: 'vi';       DisplayName: 'Vietnamese'),
    (Code: 'gaa';      DisplayName: 'Ga'),
    (Code: 'haw';      DisplayName: 'Hawaiian'),
    (Code: 'ht';       DisplayName: 'Haitian Creole'),
    (Code: 'gl';       DisplayName: 'Galician'),
    (Code: 'kl';       DisplayName: 'Greenlandic'),
    (Code: 'el';       DisplayName: 'Greek'),
    (Code: 'ka';       DisplayName: 'Georgian'),
    (Code: 'gn';       DisplayName: 'Guarani'),
    (Code: 'gu';       DisplayName: 'Gujarati'),
    (Code: 'fa-AF';    DisplayName: 'Dari'),
    (Code: 'da';       DisplayName: 'Danish'),
    (Code: 'dz';       DisplayName: 'Dzongkha'),
    (Code: 'din';      DisplayName: 'Dinka'),
    (Code: 'doi';      DisplayName: 'Dogri'),
    (Code: 'dov';      DisplayName: 'Dombe'),
    (Code: 'dyu';      DisplayName: 'Dyula'),
    (Code: 'zu';       DisplayName: 'Zulu'),
    (Code: 'iba';      DisplayName: 'Iban'),
    (Code: 'iw';       DisplayName: 'Hebrew'),
    (Code: 'ig';       DisplayName: 'Igbo'),
    (Code: 'yi';       DisplayName: 'Yiddish'),
    (Code: 'ilo';      DisplayName: 'Ilocano'),
    (Code: 'id';       DisplayName: 'Indonesian'),
    (Code: 'iu-Latn';  DisplayName: 'Inuktut (Latin)'),
    (Code: 'iu';       DisplayName: 'Inuktut (Syllabics)'),
    (Code: 'ga';       DisplayName: 'Irish'),
    (Code: 'is';       DisplayName: 'Icelandic'),
    (Code: 'es';       DisplayName: 'Spanish'),
    (Code: 'it';       DisplayName: 'Italian'),
    (Code: 'yo';       DisplayName: 'Yoruba'),
    (Code: 'kk';       DisplayName: 'Kazakh'),
    (Code: 'kn';       DisplayName: 'Kannada'),
    (Code: 'yue';      DisplayName: 'Cantonese'),
    (Code: 'kr';       DisplayName: 'Kanuri'),
    (Code: 'pam';      DisplayName: 'Kapampangan'),
    (Code: 'btx';      DisplayName: 'Karo'),
    (Code: 'ca';       DisplayName: 'Catalan'),
    (Code: 'kek';      DisplayName: 'Qʼeqchiʼ'),
    (Code: 'qu';       DisplayName: 'Quechua'),
    (Code: 'cgg';      DisplayName: 'Kiga'),
    (Code: 'kg';       DisplayName: 'Kongo'),
    (Code: 'rw';       DisplayName: 'Kinyarwanda'),
    (Code: 'ky';       DisplayName: 'Kyrgyz'),
    (Code: 'zh-CN';    DisplayName: 'Chinese'),
    (Code: 'ktu';      DisplayName: 'Kituba'),
    (Code: 'trp';      DisplayName: 'Kokborok'),
    (Code: 'kv';       DisplayName: 'Komi'),
    (Code: 'gom';      DisplayName: 'Konkani'),
    (Code: 'ko';       DisplayName: 'Korean'),
    (Code: 'co';       DisplayName: 'Corsican'),
    (Code: 'xh';       DisplayName: 'Xhosa'),
    (Code: 'kri';      DisplayName: 'Krio'),
    (Code: 'crh';      DisplayName: 'Crimean Tatar (Cyrillic)'),
    (Code: 'crh-Latn'; DisplayName: 'Crimean Tatar (Latin)'),
    (Code: 'ku';       DisplayName: 'Kurdish (Kurmanji)'),
    (Code: 'ckb';      DisplayName: 'Kurdish (Sorani)'),
    (Code: 'kha';      DisplayName: 'Khasi'),
    (Code: 'km';       DisplayName: 'Khmer'),
    (Code: 'lo';       DisplayName: 'Lao'),
    (Code: 'ltg';      DisplayName: 'Latgalian'),
    (Code: 'la';       DisplayName: 'Latin'),
    (Code: 'lv';       DisplayName: 'Latvian'),
    (Code: 'lij';      DisplayName: 'Ligurian'),
    (Code: 'li';       DisplayName: 'Limburgish'),
    (Code: 'ln';       DisplayName: 'Lingala'),
    (Code: 'lt';       DisplayName: 'Lithuanian'),
    (Code: 'lmo';      DisplayName: 'Lombard'),
    (Code: 'lg';       DisplayName: 'Luganda'),
    (Code: 'chm';      DisplayName: 'Meadow Mari'),
    (Code: 'luo';      DisplayName: 'Luo'),
    (Code: 'lb';       DisplayName: 'Luxembourgish'),
    (Code: 'mfe';      DisplayName: 'Mauritian Creole'),
    (Code: 'mad';      DisplayName: 'Madurese'),
    (Code: 'mai';      DisplayName: 'Maithili'),
    (Code: 'mak';      DisplayName: 'Makassar'),
    (Code: 'mk';       DisplayName: 'Macedonian'),
    (Code: 'mg';       DisplayName: 'Malagasy'),
    (Code: 'ms';       DisplayName: 'Malay'),
    (Code: 'ms-Arab';  DisplayName: 'Malay (Jawi)'),
    (Code: 'ml';       DisplayName: 'Malayalam'),
    (Code: 'dv';       DisplayName: 'Maldivian'),
    (Code: 'mt';       DisplayName: 'Maltese'),
    (Code: 'mam';      DisplayName: 'Mam'),
    (Code: 'mi';       DisplayName: 'Maori'),
    (Code: 'mr';       DisplayName: 'Marathi'),
    (Code: 'mwr';      DisplayName: 'Marwari'),
    (Code: 'mh';       DisplayName: 'Marshallese'),
    (Code: 'mni-Mtei'; DisplayName: 'Meiteilon (Manipuri)'),
    (Code: 'lus';      DisplayName: 'Mizo'),
    (Code: 'min';      DisplayName: 'Minangkabau'),
    (Code: 'mn';       DisplayName: 'Mongolian'),
    (Code: 'gv';       DisplayName: 'Manx'),
    (Code: 'ndc-ZW';   DisplayName: 'Ndau'),
    (Code: 'nr';       DisplayName: 'Ndebele (South)'),
    (Code: 'new';      DisplayName: 'Newari'),
    (Code: 'de';       DisplayName: 'German'),
    (Code: 'ne';       DisplayName: 'Nepali'),
    (Code: 'nl';       DisplayName: 'Dutch'),
    (Code: 'bm-Nkoo';  DisplayName: 'NKo'),
    (Code: 'no';       DisplayName: 'Norwegian'),
    (Code: 'nus';      DisplayName: 'Nuer'),
    (Code: 'oc';       DisplayName: 'Occitan'),
    (Code: 'or';       DisplayName: 'Odia (Oriya)'),
    (Code: 'om';       DisplayName: 'Oromo'),
    (Code: 'os';       DisplayName: 'Ossetian'),
    (Code: 'pag';      DisplayName: 'Pangasinan'),
    (Code: 'pa';       DisplayName: 'Punjabi (Gurmukhi)'),
    (Code: 'pa-Arab';  DisplayName: 'Punjabi (Shahmukhi)'),
    (Code: 'pap';      DisplayName: 'Papiamento'),
    (Code: 'pl';       DisplayName: 'Polish'),
    (Code: 'pt';       DisplayName: 'Portuguese (Brazil)'),
    (Code: 'pt-PT';    DisplayName: 'Portuguese (Portugal)'),
    (Code: 'ps';       DisplayName: 'Pashto'),
    (Code: 'ro';       DisplayName: 'Romanian'),
    (Code: 'rn';       DisplayName: 'Rundi'),
    (Code: 'ru';       DisplayName: 'Russian'),
    (Code: 'sm';       DisplayName: 'Samoan'),
    (Code: 'sg';       DisplayName: 'Sango'),
    (Code: 'sa';       DisplayName: 'Sanskrit'),
    (Code: 'sat-Latn'; DisplayName: 'Santali (Latin)'),
    (Code: 'sat';      DisplayName: 'Santali (Ol Chiki)'),
    (Code: 'zap';      DisplayName: 'Zapotec'),
    (Code: 'ss';       DisplayName: 'Swati'),
    (Code: 'ceb';      DisplayName: 'Cebuano'),
    (Code: 'se';       DisplayName: 'Northern Sami'),
    (Code: 'crs';      DisplayName: 'Seychellois Creole'),
    (Code: 'nso';      DisplayName: 'Sepedi'),
    (Code: 'sr';       DisplayName: 'Serbian'),
    (Code: 'st';       DisplayName: 'Sesotho'),
    (Code: 'szl';      DisplayName: 'Silesian'),
    (Code: 'bts';      DisplayName: 'Simalungun'),
    (Code: 'si';       DisplayName: 'Sinhala'),
    (Code: 'sd';       DisplayName: 'Sindhi'),
    (Code: 'scn';      DisplayName: 'Sicilian'),
    (Code: 'sk';       DisplayName: 'Slovak'),
    (Code: 'sl';       DisplayName: 'Slovenian'),
    (Code: 'so';       DisplayName: 'Somali'),
    (Code: 'sw';       DisplayName: 'Swahili'),
    (Code: 'su';       DisplayName: 'Sundanese'),
    (Code: 'sus';      DisplayName: 'Susu'),
    (Code: 'tg';       DisplayName: 'Tajik'),
    (Code: 'ty';       DisplayName: 'Tahitian'),
    (Code: 'th';       DisplayName: 'Thai'),
    (Code: 'ber-Latn'; DisplayName: 'Tamazight'),
    (Code: 'ber';      DisplayName: 'Tamazight (Tifinagh)'),
    (Code: 'ta';       DisplayName: 'Tamil'),
    (Code: 'tt';       DisplayName: 'Tatar'),
    (Code: 'te';       DisplayName: 'Telugu'),
    (Code: 'tet';      DisplayName: 'Tetum'),
    (Code: 'bo';       DisplayName: 'Tibetan'),
    (Code: 'tiv';      DisplayName: 'Tiv'),
    (Code: 'ti';       DisplayName: 'Tigrinya'),
    (Code: 'bbc';      DisplayName: 'Toba Batak'),
    (Code: 'tpi';      DisplayName: 'Tok Pisin'),
    (Code: 'to';       DisplayName: 'Tongan'),
    (Code: 'tn';       DisplayName: 'Tswana'),
    (Code: 'ts';       DisplayName: 'Tsonga'),
    (Code: 'tyv';      DisplayName: 'Tuvan'),
    (Code: 'tcy';      DisplayName: 'Tulu'),
    (Code: 'tum';      DisplayName: 'Tumbuka'),
    (Code: 'tr';       DisplayName: 'Turkish'),
    (Code: 'tk';       DisplayName: 'Turkmen'),
    (Code: 'nhe';      DisplayName: 'Huastec Nahuatl'),
    (Code: 'udm';      DisplayName: 'Udmurt'),
    (Code: 'uz';       DisplayName: 'Uzbek'),
    (Code: 'ug';       DisplayName: 'Uyghur'),
    (Code: 'uk';       DisplayName: 'Ukrainian'),
    (Code: 'ur';       DisplayName: 'Urdu'),
    (Code: 'fo';       DisplayName: 'Faroese'),
    (Code: 'fa';       DisplayName: 'Persian'),
    (Code: 'fj';       DisplayName: 'Fijian'),
    (Code: 'tl';       DisplayName: 'Filipino'),
    (Code: 'fi';       DisplayName: 'Finnish'),
    (Code: 'fon';      DisplayName: 'Fon'),
    (Code: 'fr';       DisplayName: 'French'),
    (Code: 'fr-CA';    DisplayName: 'French (Canada)'),
    (Code: 'fy';       DisplayName: 'Frisian'),
    (Code: 'fur';      DisplayName: 'Friulian'),
    (Code: 'ff';       DisplayName: 'Fula'),
    (Code: 'ha';       DisplayName: 'Hausa'),
    (Code: 'hil';      DisplayName: 'Hiligaynon'),
    (Code: 'hi';       DisplayName: 'Hindi'),
    (Code: 'hmn';      DisplayName: 'Hmong'),
    (Code: 'hr';       DisplayName: 'Croatian'),
    (Code: 'hrx';      DisplayName: 'Hunsrik'),
    (Code: 'kac';      DisplayName: 'Jingpo'),
    (Code: 'rom';      DisplayName: 'Romani'),
    (Code: 'ch';       DisplayName: 'Chamorro'),
    (Code: 'ak';       DisplayName: 'Twi'),
    (Code: 'ny';       DisplayName: 'Chewa'),
    (Code: 'ce';       DisplayName: 'Chechen'),
    (Code: 'cs';       DisplayName: 'Czech'),
    (Code: 'lua';      DisplayName: 'Chiluba'),
    (Code: 'cnh';      DisplayName: 'Chin'),
    (Code: 'cv';       DisplayName: 'Chuvash'),
    (Code: 'chk';      DisplayName: 'Chuukese'),
    (Code: 'shn';      DisplayName: 'Shan'),
    (Code: 'sv';       DisplayName: 'Swedish'),
    (Code: 'sn';       DisplayName: 'Shona'),
    (Code: 'gd';       DisplayName: 'Scottish Gaelic'),
    (Code: 'ee';       DisplayName: 'Ewe'),
    (Code: 'eo';       DisplayName: 'Esperanto'),
    (Code: 'et';       DisplayName: 'Estonian'),
    (Code: 'yua';      DisplayName: 'Yucatec'),
    (Code: 'jw';       DisplayName: 'Javanese'),
    (Code: 'sah';      DisplayName: 'Yakut'),
    (Code: 'jam';      DisplayName: 'Jamaican Creole'),
    (Code: 'ja';       DisplayName: 'Japanese')
  );
var
  i, j: Integer;
  Temp: TAppLanguage;
begin
  Result := [];
  SetLength(Result, Length(Languages));
  for i := 0 to High(Languages) do
    Result[i] := Languages[i];

  for i := 1 to High(Result) do
  begin
    Temp := Result[i];
    j := i - 1;
    while (j >= 1) and (Result[j].DisplayName > Temp.DisplayName) do
    begin
      Result[j + 1] := Result[j];
      Dec(j);
    end;
    Result[j + 1] := Temp;
  end;
end;

function GetLanguageCodePairList: TStringList;
var
  Langs: array of TAppLanguage;
  L: TAppLanguage;
begin
  Result := TStringList.Create;
  try
    Langs := GetLanguages;
    for L in Langs do
      Result.Add(L.Code + '=' + L.Code);
  except
    Result.Free;
    raise;
  end;
end;

function GetLanguageDisplayStrings: TStringList;
var
  Langs: array of TAppLanguage;
  L: TAppLanguage;
begin
  Result := TStringList.Create;
  Langs := GetLanguages;
  for L in Langs do
    Result.Add(L.DisplayName + ' (' + L.Code + ')');
end;

function GetDisplayNamesFromCodeMap(ACodeMap: TStringList): TStringList;
var
  Langs: array of TAppLanguage;
  LangMap: TStringList;          // List of "code=displayname" for lookup
  i, idx: Integer;
  Key, ApiValue: string;
begin
  Result := TStringList.Create;
  try
    // Retrieve the master language list
    Langs := GetLanguages;

    // Build a map from language code to display name (unsorted, because IndexOfName works on any list)
    LangMap := TStringList.Create;
    try
      for i := 0 to High(Langs) do
        LangMap.Add(Langs[i].Code + '=' + Langs[i].DisplayName);

      // Process each entry in the input code map
      for i := 0 to ACodeMap.Count - 1 do
      begin
        if Trim(ACodeMap[i]) = '' then
          Continue; // Skip empty lines

        Key := Trim(ACodeMap.Names[i]);               // Left part (language code)
        ApiValue := Trim(ACodeMap.ValueFromIndex[i]); // Right part (API code)

        if (Key = '') or (ApiValue = '') then
          Continue; // Skip malformed lines

        // Look up the key using IndexOfName (linear search, acceptable for ~250 items)
        idx := LangMap.IndexOfName(Key);
        if idx >= 0 then
          // Found: add "DisplayName (ApiCode)"
          Result.Add(LangMap.ValueFromIndex[idx] + ' (' + ApiValue + ')')
        else
          // Not found: fallback
          Result.Add(ApiValue);
      end;
    finally
      LangMap.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function ExtractCodeFromItem(const ItemText: string): string;
var
  P: Integer;
begin
  Result := '';
  // Find the last occurrence of " (" to handle cases where DisplayName itself contains parentheses
  P := RPos(' (', ItemText);
  if P > 0 then
    // Copy the substring between '(' and ')'
    Result := Copy(ItemText, P + 2, Length(ItemText) - P - 2);
end;

end.
