//-----------------------------------------------------------------------------------
//  Trayslate © 2026 by Alexander Tverskoy
//  Licensed under the GNU General Public License, Version 3 (GPL-3.0)
//  You may obtain a copy of the License at https://www.gnu.org/licenses/gpl-3.0.html
//-----------------------------------------------------------------------------------

unit languages;

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  translate;

type
  TAppValue = record
    Code: string;        // ISO code (ru, en, de ...)
    DisplayName: string; // Name shown in UI (English)
  end;

type
  TValueArray = array of TAppValue;

const
  SpecialCodes: array[0..1] of string = ('auto', 'empty');

function GetLanguages: TValueArray;

function GetCurrencyFiat: TValueArray;

function GetCurrencyCrypto: TValueArray;

function GetUnits: TValueArray;

function GetValues(AValueType: TValueType = vtNone; ASort: boolean = True): TValueArray;

function GetLanguageCodePairList(AValueType: TValueType): TStringList;

function GetLanguageDisplayStrings(AValueType: TValueType): TStringList;

function GetDisplayNamesFromCodeMap(ACodeMap: TStringList; AValueType: TValueType; Sort: boolean = False): TStringList;

function ExtractCodeFromItem(const ItemText: string): string;

implementation

function GetLanguages: TValueArray;
const
  Languages: array[0..267] of TAppValue = (
    // Languages
    (Code: 'auto'; DisplayName: 'Auto detect'),
    (Code: 'empty'; DisplayName: 'Auto detect'),
    (Code: 'ab'; DisplayName: 'Abkhazian'),
    (Code: 'awa'; DisplayName: 'Awadhi'),
    (Code: 'av'; DisplayName: 'Avar'),
    (Code: 'az'; DisplayName: 'Azerbaijani'),
    (Code: 'ay'; DisplayName: 'Aymara'),
    (Code: 'an'; DisplayName: 'Aragonese'),
    (Code: 'sq'; DisplayName: 'Albanian'),
    (Code: 'alz'; DisplayName: 'Alur'),
    (Code: 'am'; DisplayName: 'Amharic'),
    (Code: 'en'; DisplayName: 'English'),
    (Code: 'en-gb'; DisplayName: 'English (British)'),
    (Code: 'en-us'; DisplayName: 'English (American)'),
    (Code: 'ar'; DisplayName: 'Arabic'),
    (Code: 'hy'; DisplayName: 'Armenian'),
    (Code: 'as'; DisplayName: 'Assamese'),
    (Code: 'aa'; DisplayName: 'Afar'),
    (Code: 'af'; DisplayName: 'Afrikaans'),
    (Code: 'ace'; DisplayName: 'Acehnese'),
    (Code: 'ach'; DisplayName: 'Acholi'),
    (Code: 'ban'; DisplayName: 'Balinese'),
    (Code: 'bm'; DisplayName: 'Bambara'),
    (Code: 'eu'; DisplayName: 'Basque'),
    (Code: 'bci'; DisplayName: 'Baoulé'),
    (Code: 'ba'; DisplayName: 'Bashkir'),
    (Code: 'be'; DisplayName: 'Belarusian'),
    (Code: 'bal'; DisplayName: 'Balochi'),
    (Code: 'bem'; DisplayName: 'Bemba'),
    (Code: 'bn'; DisplayName: 'Bengali'),
    (Code: 'bew'; DisplayName: 'Betawi'),
    (Code: 'bik'; DisplayName: 'Bikol'),
    (Code: 'my'; DisplayName: 'Burmese'),
    (Code: 'bg'; DisplayName: 'Bulgarian'),
    (Code: 'bs'; DisplayName: 'Bosnian'),
    (Code: 'br'; DisplayName: 'Breton'),
    (Code: 'bua'; DisplayName: 'Buryat'),
    (Code: 'bho'; DisplayName: 'Bhojpuri'),
    (Code: 'cy'; DisplayName: 'Welsh'),
    (Code: 'war'; DisplayName: 'Waray'),
    (Code: 'hu'; DisplayName: 'Hungarian'),
    (Code: 've'; DisplayName: 'Venda'),
    (Code: 'vec'; DisplayName: 'Venetian'),
    (Code: 'wo'; DisplayName: 'Wolof'),
    (Code: 'vi'; DisplayName: 'Vietnamese'),
    (Code: 'gaa'; DisplayName: 'Ga'),
    (Code: 'haw'; DisplayName: 'Hawaiian'),
    (Code: 'ht'; DisplayName: 'Haitian Creole'),
    (Code: 'gl'; DisplayName: 'Galician'),
    (Code: 'kl'; DisplayName: 'Greenlandic'),
    (Code: 'el'; DisplayName: 'Greek'),
    (Code: 'ka'; DisplayName: 'Georgian'),
    (Code: 'gn'; DisplayName: 'Guarani'),
    (Code: 'gu'; DisplayName: 'Gujarati'),
    (Code: 'fa-AF'; DisplayName: 'Dari'),
    (Code: 'prs'; DisplayName: 'Dari Persian'),
    (Code: 'da'; DisplayName: 'Danish'),
    (Code: 'dz'; DisplayName: 'Dzongkha'),
    (Code: 'din'; DisplayName: 'Dinka'),
    (Code: 'doi'; DisplayName: 'Dogri'),
    (Code: 'dov'; DisplayName: 'Dombe'),
    (Code: 'dyu'; DisplayName: 'Dyula'),
    (Code: 'zu'; DisplayName: 'Zulu'),
    (Code: 'iba'; DisplayName: 'Iban'),
    (Code: 'iw'; DisplayName: 'Hebrew'),
    (Code: 'he'; DisplayName: 'Hebrew'),
    (Code: 'ig'; DisplayName: 'Igbo'),
    (Code: 'yi'; DisplayName: 'Yiddish'),
    (Code: 'ilo'; DisplayName: 'Ilocano'),
    (Code: 'id'; DisplayName: 'Indonesian'),
    (Code: 'iu-Latn'; DisplayName: 'Inuktut (Latin)'),
    (Code: 'iu'; DisplayName: 'Inuktut (Syllabics)'),
    (Code: 'ga'; DisplayName: 'Irish'),
    (Code: 'is'; DisplayName: 'Icelandic'),
    (Code: 'es'; DisplayName: 'Spanish'),
    (Code: 'es-419'; DisplayName: 'Spanish (Latin America)'),
    (Code: 'it'; DisplayName: 'Italian'),
    (Code: 'yo'; DisplayName: 'Yoruba'),
    (Code: 'kk'; DisplayName: 'Kazakh'),
    (Code: 'kn'; DisplayName: 'Kannada'),
    (Code: 'yue'; DisplayName: 'Cantonese'),
    (Code: 'kr'; DisplayName: 'Kanuri'),
    (Code: 'pam'; DisplayName: 'Kapampangan'),
    (Code: 'btx'; DisplayName: 'Karo'),
    (Code: 'ca'; DisplayName: 'Catalan'),
    (Code: 'kek'; DisplayName: 'Qʼeqchiʼ'),
    (Code: 'qu'; DisplayName: 'Quechua'),
    (Code: 'cgg'; DisplayName: 'Kiga'),
    (Code: 'kg'; DisplayName: 'Kongo'),
    (Code: 'rw'; DisplayName: 'Kinyarwanda'),
    (Code: 'ky'; DisplayName: 'Kyrgyz'),
    (Code: 'zh'; DisplayName: 'Chinese'),
    (Code: 'zh-CN'; DisplayName: 'Chinese (Simplified)'),
    (Code: 'zh-TW'; DisplayName: 'Chinese (Traditional)'),
    (Code: 'Zh-HANS'; DisplayName: 'Chinese (Simplified)'),
    (Code: 'zh-HANT'; DisplayName: 'Chinese (Traditional)'),
    (Code: 'ktu'; DisplayName: 'Kituba'),
    (Code: 'trp'; DisplayName: 'Kokborok'),
    (Code: 'kv'; DisplayName: 'Komi'),
    (Code: 'gom'; DisplayName: 'Konkani'),
    (Code: 'ko'; DisplayName: 'Korean'),
    (Code: 'co'; DisplayName: 'Corsican'),
    (Code: 'xh'; DisplayName: 'Xhosa'),
    (Code: 'kri'; DisplayName: 'Krio'),
    (Code: 'crh'; DisplayName: 'Crimean Tatar (Cyrillic)'),
    (Code: 'crh-Latn'; DisplayName: 'Crimean Tatar (Latin)'),
    (Code: 'ku'; DisplayName: 'Kurdish (Kurmanji)'),
    (Code: 'kmr'; DisplayName: 'Kurdish (Kurmanji)'),
    (Code: 'ckb'; DisplayName: 'Kurdish (Sorani)'),
    (Code: 'kha'; DisplayName: 'Khasi'),
    (Code: 'km'; DisplayName: 'Khmer'),
    (Code: 'lo'; DisplayName: 'Lao'),
    (Code: 'ltg'; DisplayName: 'Latgalian'),
    (Code: 'la'; DisplayName: 'Latin'),
    (Code: 'lv'; DisplayName: 'Latvian'),
    (Code: 'lij'; DisplayName: 'Ligurian'),
    (Code: 'li'; DisplayName: 'Limburgish'),
    (Code: 'ln'; DisplayName: 'Lingala'),
    (Code: 'lt'; DisplayName: 'Lithuanian'),
    (Code: 'lmo'; DisplayName: 'Lombard'),
    (Code: 'lg'; DisplayName: 'Luganda'),
    (Code: 'chm'; DisplayName: 'Meadow Mari'),
    (Code: 'luo'; DisplayName: 'Luo'),
    (Code: 'lb'; DisplayName: 'Luxembourgish'),
    (Code: 'mfe'; DisplayName: 'Mauritian Creole'),
    (Code: 'mad'; DisplayName: 'Madurese'),
    (Code: 'mai'; DisplayName: 'Maithili'),
    (Code: 'mak'; DisplayName: 'Makassar'),
    (Code: 'mk'; DisplayName: 'Macedonian'),
    (Code: 'mg'; DisplayName: 'Malagasy'),
    (Code: 'ms'; DisplayName: 'Malay'),
    (Code: 'ms-Arab'; DisplayName: 'Malay (Jawi)'),
    (Code: 'ml'; DisplayName: 'Malayalam'),
    (Code: 'dv'; DisplayName: 'Maldivian'),
    (Code: 'mt'; DisplayName: 'Maltese'),
    (Code: 'mam'; DisplayName: 'Mam'),
    (Code: 'mi'; DisplayName: 'Maori'),
    (Code: 'mr'; DisplayName: 'Marathi'),
    (Code: 'mwr'; DisplayName: 'Marwari'),
    (Code: 'mh'; DisplayName: 'Marshallese'),
    (Code: 'mni-Mtei'; DisplayName: 'Meiteilon (Manipuri)'),
    (Code: 'lus'; DisplayName: 'Mizo'),
    (Code: 'min'; DisplayName: 'Minangkabau'),
    (Code: 'mn'; DisplayName: 'Mongolian'),
    (Code: 'gv'; DisplayName: 'Manx'),
    (Code: 'ndc-ZW'; DisplayName: 'Ndau'),
    (Code: 'nr'; DisplayName: 'Ndebele (South)'),
    (Code: 'new'; DisplayName: 'Newari'),
    (Code: 'de'; DisplayName: 'German'),
    (Code: 'de-ch'; DisplayName: 'German (Switzerland)'),
    (Code: 'ne'; DisplayName: 'Nepali'),
    (Code: 'nl'; DisplayName: 'Dutch'),
    (Code: 'bm-Nkoo'; DisplayName: 'NKo'),
    (Code: 'no'; DisplayName: 'Norwegian'),
    (Code: 'nb'; DisplayName: 'Norwegian Bokmal'),
    (Code: 'nn'; DisplayName: 'Norwegian Nynorsk'),
    (Code: 'nus'; DisplayName: 'Nuer'),
    (Code: 'oc'; DisplayName: 'Occitan'),
    (Code: 'or'; DisplayName: 'Odia (Oriya)'),
    (Code: 'om'; DisplayName: 'Oromo'),
    (Code: 'os'; DisplayName: 'Ossetian'),
    (Code: 'pag'; DisplayName: 'Pangasinan'),
    (Code: 'pa'; DisplayName: 'Punjabi (Gurmukhi)'),
    (Code: 'pa-Arab'; DisplayName: 'Punjabi (Shahmukhi)'),
    (Code: 'pap'; DisplayName: 'Papiamento'),
    (Code: 'pl'; DisplayName: 'Polish'),
    (Code: 'pt'; DisplayName: 'Portuguese'),
    (Code: 'pt-PT'; DisplayName: 'Portuguese (Portugal)'),
    (Code: 'pt-BR'; DisplayName: 'Portuguese (Brazil)'),
    (Code: 'ps'; DisplayName: 'Pashto'),
    (Code: 'ro'; DisplayName: 'Romanian'),
    (Code: 'rn'; DisplayName: 'Rundi'),
    (Code: 'ru'; DisplayName: 'Russian'),
    (Code: 'sm'; DisplayName: 'Samoan'),
    (Code: 'sg'; DisplayName: 'Sango'),
    (Code: 'sa'; DisplayName: 'Sanskrit'),
    (Code: 'sat-Latn'; DisplayName: 'Santali (Latin)'),
    (Code: 'sat'; DisplayName: 'Santali (Ol Chiki)'),
    (Code: 'zap'; DisplayName: 'Zapotec'),
    (Code: 'ss'; DisplayName: 'Swati'),
    (Code: 'ceb'; DisplayName: 'Cebuano'),
    (Code: 'se'; DisplayName: 'Northern Sami'),
    (Code: 'crs'; DisplayName: 'Seychellois Creole'),
    (Code: 'nso'; DisplayName: 'Sepedi'),
    (Code: 'sr'; DisplayName: 'Serbian'),
    (Code: 'st'; DisplayName: 'Sesotho'),
    (Code: 'szl'; DisplayName: 'Silesian'),
    (Code: 'bts'; DisplayName: 'Simalungun'),
    (Code: 'si'; DisplayName: 'Sinhala'),
    (Code: 'sd'; DisplayName: 'Sindhi'),
    (Code: 'scn'; DisplayName: 'Sicilian'),
    (Code: 'sk'; DisplayName: 'Slovak'),
    (Code: 'sl'; DisplayName: 'Slovenian'),
    (Code: 'so'; DisplayName: 'Somali'),
    (Code: 'sw'; DisplayName: 'Swahili'),
    (Code: 'su'; DisplayName: 'Sundanese'),
    (Code: 'sus'; DisplayName: 'Susu'),
    (Code: 'tg'; DisplayName: 'Tajik'),
    (Code: 'ty'; DisplayName: 'Tahitian'),
    (Code: 'th'; DisplayName: 'Thai'),
    (Code: 'ber-Latn'; DisplayName: 'Tamazight'),
    (Code: 'ber'; DisplayName: 'Tamazight (Tifinagh)'),
    (Code: 'ta'; DisplayName: 'Tamil'),
    (Code: 'tt'; DisplayName: 'Tatar'),
    (Code: 'te'; DisplayName: 'Telugu'),
    (Code: 'tet'; DisplayName: 'Tetum'),
    (Code: 'bo'; DisplayName: 'Tibetan'),
    (Code: 'tiv'; DisplayName: 'Tiv'),
    (Code: 'ti'; DisplayName: 'Tigrinya'),
    (Code: 'bbc'; DisplayName: 'Toba Batak'),
    (Code: 'tpi'; DisplayName: 'Tok Pisin'),
    (Code: 'to'; DisplayName: 'Tongan'),
    (Code: 'tn'; DisplayName: 'Tswana'),
    (Code: 'ts'; DisplayName: 'Tsonga'),
    (Code: 'tyv'; DisplayName: 'Tuvan'),
    (Code: 'tcy'; DisplayName: 'Tulu'),
    (Code: 'tum'; DisplayName: 'Tumbuka'),
    (Code: 'tr'; DisplayName: 'Turkish'),
    (Code: 'tk'; DisplayName: 'Turkmen'),
    (Code: 'nhe'; DisplayName: 'Huastec Nahuatl'),
    (Code: 'udm'; DisplayName: 'Udmurt'),
    (Code: 'uz'; DisplayName: 'Uzbek'),
    (Code: 'ug'; DisplayName: 'Uyghur'),
    (Code: 'uk'; DisplayName: 'Ukrainian'),
    (Code: 'ur'; DisplayName: 'Urdu'),
    (Code: 'fo'; DisplayName: 'Faroese'),
    (Code: 'fa'; DisplayName: 'Persian'),
    (Code: 'fj'; DisplayName: 'Fijian'),
    (Code: 'tl'; DisplayName: 'Filipino'),
    (Code: 'fi'; DisplayName: 'Finnish'),
    (Code: 'fon'; DisplayName: 'Fon'),
    (Code: 'fr'; DisplayName: 'French'),
    (Code: 'fr-CA'; DisplayName: 'French (Canada)'),
    (Code: 'fy'; DisplayName: 'Frisian'),
    (Code: 'fur'; DisplayName: 'Friulian'),
    (Code: 'ff'; DisplayName: 'Fula'),
    (Code: 'ha'; DisplayName: 'Hausa'),
    (Code: 'hil'; DisplayName: 'Hiligaynon'),
    (Code: 'hi'; DisplayName: 'Hindi'),
    (Code: 'hmn'; DisplayName: 'Hmong'),
    (Code: 'hr'; DisplayName: 'Croatian'),
    (Code: 'hrx'; DisplayName: 'Hunsrik'),
    (Code: 'kac'; DisplayName: 'Jingpo'),
    (Code: 'rom'; DisplayName: 'Romani'),
    (Code: 'ch'; DisplayName: 'Chamorro'),
    (Code: 'ak'; DisplayName: 'Twi'),
    (Code: 'ny'; DisplayName: 'Chewa'),
    (Code: 'ce'; DisplayName: 'Chechen'),
    (Code: 'cs'; DisplayName: 'Czech'),
    (Code: 'lua'; DisplayName: 'Chiluba'),
    (Code: 'cnh'; DisplayName: 'Chin'),
    (Code: 'cv'; DisplayName: 'Chuvash'),
    (Code: 'chk'; DisplayName: 'Chuukese'),
    (Code: 'shn'; DisplayName: 'Shan'),
    (Code: 'sv'; DisplayName: 'Swedish'),
    (Code: 'sn'; DisplayName: 'Shona'),
    (Code: 'gd'; DisplayName: 'Scottish Gaelic'),
    (Code: 'ee'; DisplayName: 'Ewe'),
    (Code: 'eo'; DisplayName: 'Esperanto'),
    (Code: 'et'; DisplayName: 'Estonian'),
    (Code: 'yua'; DisplayName: 'Yucatec'),
    (Code: 'jw'; DisplayName: 'Javanese'),
    (Code: 'jv'; DisplayName: 'Javanese'),
    (Code: 'sah'; DisplayName: 'Yakut'),
    (Code: 'jam'; DisplayName: 'Jamaican Creole'),
    (Code: 'ja'; DisplayName: 'Japanese'),
    (Code: 'kaa'; DisplayName: 'Karakalpak'),
    (Code: 'lmr'; DisplayName: 'Lamalera')
    );
var
  i: integer;
begin
  Result := [];
  SetLength(Result, Length(Languages));
  for i := 0 to High(Languages) do
    Result[i] := Languages[i];
end;

function GetCurrencyFiat: TValueArray;
const
  currency: array[0..150] of TAppValue = (
    (Code: 'AED'; DisplayName: 'United Arab Emirates Dirham'),
    (Code: 'AFN'; DisplayName: 'Afghan Afghani'),
    (Code: 'ALL'; DisplayName: 'Albanian Lek'),
    (Code: 'AMD'; DisplayName: 'Armenian Dram'),
    (Code: 'ANG'; DisplayName: 'Netherlands Antillean Guilder'),
    (Code: 'AOA'; DisplayName: 'Angolan Kwanza'),
    (Code: 'ARS'; DisplayName: 'Argentine Peso'),
    (Code: 'AUD'; DisplayName: 'Australian Dollar'),
    (Code: 'AWG'; DisplayName: 'Aruban Florin'),
    (Code: 'AZN'; DisplayName: 'Azerbaijani Manat'),
    (Code: 'BAM'; DisplayName: 'Bosnia and Herzegovina Convertible Mark'),
    (Code: 'BBD'; DisplayName: 'Barbados Dollar'),
    (Code: 'BDT'; DisplayName: 'Bangladeshi Taka'),
    (Code: 'BGN'; DisplayName: 'Bulgarian Lev'),
    (Code: 'BHD'; DisplayName: 'Bahraini Dinar'),
    (Code: 'BIF'; DisplayName: 'Burundian Franc'),
    (Code: 'BMD'; DisplayName: 'Bermudian Dollar'),
    (Code: 'BND'; DisplayName: 'Brunei Dollar'),
    (Code: 'BOB'; DisplayName: 'Boliviano'),
    (Code: 'BRL'; DisplayName: 'Brazilian Real'),
    (Code: 'BSD'; DisplayName: 'Bahamian Dollar'),
    (Code: 'BTN'; DisplayName: 'Bhutanese Ngultrum'),
    (Code: 'BWP'; DisplayName: 'Botswanan Pula'),
    (Code: 'BYN'; DisplayName: 'Belarusian Ruble'),
    (Code: 'BZD'; DisplayName: 'Belize Dollar'),
    (Code: 'CAD'; DisplayName: 'Canadian Dollar'),
    (Code: 'CDF'; DisplayName: 'Congolese Franc'),
    (Code: 'CHF'; DisplayName: 'Swiss Franc'),
    (Code: 'CLP'; DisplayName: 'Chilean Peso'),
    (Code: 'CNY'; DisplayName: 'Chinese Yuan'),
    (Code: 'COP'; DisplayName: 'Colombian Peso'),
    (Code: 'CRC'; DisplayName: 'Costa Rican Colón'),
    (Code: 'CUP'; DisplayName: 'Cuban Peso'),
    (Code: 'CVE'; DisplayName: 'Cape Verdean Escudo'),
    (Code: 'CZK'; DisplayName: 'Czech Koruna'),
    (Code: 'DJF'; DisplayName: 'Djiboutian Franc'),
    (Code: 'DKK'; DisplayName: 'Danish Krone'),
    (Code: 'DOP'; DisplayName: 'Dominican Peso'),
    (Code: 'DZD'; DisplayName: 'Algerian Dinar'),
    (Code: 'EGP'; DisplayName: 'Egyptian Pound'),
    (Code: 'ERN'; DisplayName: 'Eritrean Nakfa'),
    (Code: 'ETB'; DisplayName: 'Ethiopian Birr'),
    (Code: 'EUR'; DisplayName: 'Euro'),
    (Code: 'FJD'; DisplayName: 'Fijian Dollar'),
    (Code: 'FKP'; DisplayName: 'Falkland Islands Pound'),
    (Code: 'GBP'; DisplayName: 'British Pound Sterling'),
    (Code: 'GEL'; DisplayName: 'Georgian Lari'),
    (Code: 'GHS'; DisplayName: 'Ghanaian Cedi'),
    (Code: 'GMD'; DisplayName: 'Gambian Dalasi'),
    (Code: 'GNF'; DisplayName: 'Guinean Franc'),
    (Code: 'GTQ'; DisplayName: 'Guatemalan Quetzal'),
    (Code: 'GYD'; DisplayName: 'Guyanese Dollar'),
    (Code: 'HKD'; DisplayName: 'Hong Kong Dollar'),
    (Code: 'HRK'; DisplayName: 'Croatian Kuna'),
    (Code: 'HNL'; DisplayName: 'Honduran Lempira'),
    (Code: 'HTG'; DisplayName: 'Haitian Gourde'),
    (Code: 'HUF'; DisplayName: 'Hungarian Forint'),
    (Code: 'IDR'; DisplayName: 'Indonesian Rupiah'),
    (Code: 'ILS'; DisplayName: 'Israeli New Shekel'),
    (Code: 'INR'; DisplayName: 'Indian Rupee'),
    (Code: 'IQD'; DisplayName: 'Iraqi Dinar'),
    (Code: 'IRR'; DisplayName: 'Iranian Rial'),
    (Code: 'ISK'; DisplayName: 'Icelandic Króna'),
    (Code: 'JMD'; DisplayName: 'Jamaican Dollar'),
    (Code: 'JOD'; DisplayName: 'Jordanian Dinar'),
    (Code: 'JPY'; DisplayName: 'Japanese Yen'),
    (Code: 'KES'; DisplayName: 'Kenyan Shilling'),
    (Code: 'KGS'; DisplayName: 'Kyrgyzstani Som'),
    (Code: 'KHR'; DisplayName: 'Cambodian Riel'),
    (Code: 'KMF'; DisplayName: 'Comorian Franc'),
    (Code: 'KRW'; DisplayName: 'South Korean Won'),
    (Code: 'KWD'; DisplayName: 'Kuwaiti Dinar'),
    (Code: 'KYD'; DisplayName: 'Cayman Islands Dollar'),
    (Code: 'KZT'; DisplayName: 'Kazakhstani Tenge'),
    (Code: 'LAK'; DisplayName: 'Lao Kip'),
    (Code: 'LBP'; DisplayName: 'Lebanese Pound'),
    (Code: 'LKR'; DisplayName: 'Sri Lankan Rupee'),
    (Code: 'LRD'; DisplayName: 'Liberian Dollar'),
    (Code: 'LSL'; DisplayName: 'Lesotho Loti'),
    (Code: 'LYD'; DisplayName: 'Libyan Dinar'),
    (Code: 'MAD'; DisplayName: 'Moroccan Dirham'),
    (Code: 'MDL'; DisplayName: 'Moldovan Leu'),
    (Code: 'MGA'; DisplayName: 'Malagasy Ariary'),
    (Code: 'MKD'; DisplayName: 'Macedonian Denar'),
    (Code: 'MMK'; DisplayName: 'Myanmar Kyat'),
    (Code: 'MNT'; DisplayName: 'Mongolian Tögrög'),
    (Code: 'MOP'; DisplayName: 'Macanese Pataca'),
    (Code: 'MRU'; DisplayName: 'Mauritanian Ouguiya'),
    (Code: 'MUR'; DisplayName: 'Mauritian Rupee'),
    (Code: 'MVR'; DisplayName: 'Maldivian Rufiyaa'),
    (Code: 'MWK'; DisplayName: 'Malawian Kwacha'),
    (Code: 'MXN'; DisplayName: 'Mexican Peso'),
    (Code: 'MYR'; DisplayName: 'Malaysian Ringgit'),
    (Code: 'MZN'; DisplayName: 'Mozambican Metical'),
    (Code: 'NAD'; DisplayName: 'Namibian Dollar'),
    (Code: 'NGN'; DisplayName: 'Nigerian Naira'),
    (Code: 'NIO'; DisplayName: 'Nicaraguan Córdoba'),
    (Code: 'NOK'; DisplayName: 'Norwegian Krone'),
    (Code: 'NPR'; DisplayName: 'Nepalese Rupee'),
    (Code: 'NZD'; DisplayName: 'New Zealand Dollar'),
    (Code: 'OMR'; DisplayName: 'Omani Rial'),
    (Code: 'PAB'; DisplayName: 'Panamanian Balboa'),
    (Code: 'PEN'; DisplayName: 'Peruvian Sol'),
    (Code: 'PGK'; DisplayName: 'Papua New Guinean Kina'),
    (Code: 'PHP'; DisplayName: 'Philippine Peso'),
    (Code: 'PKR'; DisplayName: 'Pakistani Rupee'),
    (Code: 'PLN'; DisplayName: 'Polish Złoty'),
    (Code: 'PYG'; DisplayName: 'Paraguayan Guarani'),
    (Code: 'QAR'; DisplayName: 'Qatari Riyal'),
    (Code: 'RON'; DisplayName: 'Romanian Leu'),
    (Code: 'RSD'; DisplayName: 'Serbian Dinar'),
    (Code: 'RUB'; DisplayName: 'Russian Ruble'),
    (Code: 'RWF'; DisplayName: 'Rwandan Franc'),
    (Code: 'SAR'; DisplayName: 'Saudi Riyal'),
    (Code: 'SBD'; DisplayName: 'Solomon Islands Dollar'),
    (Code: 'SCR'; DisplayName: 'Seychellois Rupee'),
    (Code: 'SDG'; DisplayName: 'Sudanese Pound'),
    (Code: 'SEK'; DisplayName: 'Swedish Krona'),
    (Code: 'SGD'; DisplayName: 'Singapore Dollar'),
    (Code: 'SLL'; DisplayName: 'Sierra Leonean Leone'),
    (Code: 'SOS'; DisplayName: 'Somali Shilling'),
    (Code: 'SRD'; DisplayName: 'Surinamese Dollar'),
    (Code: 'SSP'; DisplayName: 'South Sudanese Pound'),
    (Code: 'STN'; DisplayName: 'São Tomé and Príncipe Dobra'),
    (Code: 'SYP'; DisplayName: 'Syrian Pound'),
    (Code: 'SZL'; DisplayName: 'Eswatini Lilangeni'),
    (Code: 'THB'; DisplayName: 'Thai Baht'),
    (Code: 'TJS'; DisplayName: 'Tajikistani Somoni'),
    (Code: 'TMT'; DisplayName: 'Turkmenistan Manat'),
    (Code: 'TND'; DisplayName: 'Tunisian Dinar'),
    (Code: 'TOP'; DisplayName: 'Tongan Paʻanga'),
    (Code: 'TRY'; DisplayName: 'Turkish Lira'),
    (Code: 'TTD'; DisplayName: 'Trinidad and Tobago Dollar'),
    (Code: 'TWD'; DisplayName: 'New Taiwan Dollar'),
    (Code: 'TZS'; DisplayName: 'Tanzanian Shilling'),
    (Code: 'UAH'; DisplayName: 'Ukrainian Hryvnia'),
    (Code: 'UGX'; DisplayName: 'Ugandan Shilling'),
    (Code: 'USD'; DisplayName: 'United States Dollar'),
    (Code: 'UYU'; DisplayName: 'Uruguayan Peso'),
    (Code: 'UZS'; DisplayName: 'Uzbekistani Som'),
    (Code: 'VES'; DisplayName: 'Venezuelan Sovereign Bolívar'),
    (Code: 'VND'; DisplayName: 'Vietnamese Dong'),
    (Code: 'VUV'; DisplayName: 'Vanuatu Vatu'),
    (Code: 'WST'; DisplayName: 'Samoan Tala'),
    (Code: 'XAF'; DisplayName: 'CFA Franc BEAC'),
    (Code: 'XCD'; DisplayName: 'East Caribbean Dollar'),
    (Code: 'XOF'; DisplayName: 'CFA Franc BCEAO'),
    (Code: 'XPF'; DisplayName: 'CFP Franc'),
    (Code: 'YER'; DisplayName: 'Yemeni Rial'),
    (Code: 'ZAR'; DisplayName: 'South African Rand'),
    (Code: 'ZMW'; DisplayName: 'Zambian Kwacha')
    );
var
  i: integer;
begin
  Result := [];
  SetLength(Result, Length(currency));
  for i := 0 to High(currency) do
    Result[i] := currency[i];
end;

function GetCurrencyCrypto: TValueArray;
const
  CurrencyCrypto: array[0..149] of TAppValue = (
    (Code: 'BTC'; DisplayName: 'Bitcoin'),
    (Code: 'ETH'; DisplayName: 'Ether'),
    (Code: 'USDT'; DisplayName: 'Tether'),
    (Code: 'USDC'; DisplayName: 'USD Coin'),
    (Code: 'BNB'; DisplayName: 'Binance Coin'),
    (Code: 'XRP'; DisplayName: 'Ripple'),
    (Code: 'BUSD'; DisplayName: 'Binance USD'),
    (Code: 'ADA'; DisplayName: 'Cardano'),
    (Code: 'SOL'; DisplayName: 'Solana'),
    (Code: 'DOGE'; DisplayName: 'Dogecoin'),
    (Code: 'MATIC'; DisplayName: 'Polygon'),
    (Code: 'DOT'; DisplayName: 'Polkadot'),
    (Code: 'DAI'; DisplayName: 'Dai'),
    (Code: 'TRX'; DisplayName: 'TRON'),
    (Code: 'SHIB'; DisplayName: 'Shiba Inu'),
    (Code: 'WBTC'; DisplayName: 'Wrapped Bitcoin'),
    (Code: 'UNI'; DisplayName: 'Uniswap'),
    (Code: 'AVAX'; DisplayName: 'Avalanche'),
    (Code: 'LEO'; DisplayName: 'LEO Token'),
    (Code: 'LTC'; DisplayName: 'Litecoin'),
    (Code: 'LINK'; DisplayName: 'Chainlink'),
    (Code: 'ATOM'; DisplayName: 'Cosmos'),
    (Code: 'ETC'; DisplayName: 'Ethereum Classic'),
    (Code: 'FTT'; DisplayName: 'FTX Token'),
    (Code: 'XLM'; DisplayName: 'Stellar'),
    (Code: 'CRO'; DisplayName: 'Cronos'),
    (Code: 'XMR'; DisplayName: 'Monero'),
    (Code: 'NEAR'; DisplayName: 'NEAR Protocol'),
    (Code: 'ALGO'; DisplayName: 'Algorand'),
    (Code: 'QNT'; DisplayName: 'Quant'),
    (Code: 'BCH'; DisplayName: 'Bitcoin Cash'),
    (Code: 'VET'; DisplayName: 'VeChain'),
    (Code: 'LUNC'; DisplayName: 'Terra Classic'),
    (Code: 'FIL'; DisplayName: 'Filecoin'),
    (Code: 'FLOW'; DisplayName: 'Flow'),
    (Code: 'TON'; DisplayName: 'Toncoin'),
    (Code: 'HBAR'; DisplayName: 'Hedera'),
    (Code: 'APE'; DisplayName: 'ApeCoin'),
    (Code: 'EGLD'; DisplayName: 'MultiversX'),
    (Code: 'ICP'; DisplayName: 'Internet Computer'),
    (Code: 'XTZ'; DisplayName: 'Tezos'),
    (Code: 'MANA'; DisplayName: 'Decentraland'),
    (Code: 'SAND'; DisplayName: 'The Sandbox'),
    (Code: 'HT'; DisplayName: 'Huobi Token'),
    (Code: 'CHZ'; DisplayName: 'Chiliz'),
    (Code: 'EOS'; DisplayName: 'EOS'),
    (Code: 'AAVE'; DisplayName: 'Aave'),
    (Code: 'OKB'; DisplayName: 'OKB'),
    (Code: 'THETA'; DisplayName: 'Theta Network'),
    (Code: 'KCS'; DisplayName: 'KuCoin Token'),
    (Code: 'MKR'; DisplayName: 'Maker'),
    (Code: 'USDP'; DisplayName: 'Pax Dollar'),
    (Code: 'BSV'; DisplayName: 'Bitcoin SV'),
    (Code: 'AXS'; DisplayName: 'Axie Infinity'),
    (Code: 'TUSD'; DisplayName: 'TrueUSD'),
    (Code: 'ZEC'; DisplayName: 'Zcash'),
    (Code: 'USDD'; DisplayName: 'USDD'),
    (Code: 'BTT'; DisplayName: 'BitTorrent'),
    (Code: 'XEC'; DisplayName: 'eCash'),
    (Code: 'MIOTA'; DisplayName: 'IOTA'),
    (Code: 'USDN'; DisplayName: 'Neutrino USD'),
    (Code: 'CAKE'; DisplayName: 'PancakeSwap'),
    (Code: 'GRT'; DisplayName: 'The Graph'),
    (Code: 'HNT'; DisplayName: 'Helium'),
    (Code: 'NEO'; DisplayName: 'NEO'),
    (Code: 'PAXG'; DisplayName: 'PAX Gold'),
    (Code: 'FTM'; DisplayName: 'Fantom'),
    (Code: 'SNX'; DisplayName: 'Synthetix'),
    (Code: 'NEXO'; DisplayName: 'NEXO'),
    (Code: 'RUNE'; DisplayName: 'THORChain'),
    (Code: 'GT'; DisplayName: 'GateToken'),
    (Code: 'DASH'; DisplayName: 'Dash'),
    (Code: 'KLAY'; DisplayName: 'Klaytn'),
    (Code: 'CRV'; DisplayName: 'Curve DAO Token'),
    (Code: 'BAT'; DisplayName: 'Basic Attention Token'),
    (Code: 'ENJ'; DisplayName: 'Enjin Coin'),
    (Code: 'LDO'; DisplayName: 'Lido DAO'),
    (Code: 'FEI'; DisplayName: 'Fei USD'),
    (Code: 'TWT'; DisplayName: 'Trust Wallet Token'),
    (Code: 'CSPR'; DisplayName: 'Casper'),
    (Code: 'USTC'; DisplayName: 'TerraClassicUSD'),
    (Code: 'ZIL'; DisplayName: 'Zilliqa'),
    (Code: 'STX'; DisplayName: 'Stacks'),
    (Code: 'ENS'; DisplayName: 'Ethereum Name Service'),
    (Code: 'COMP'; DisplayName: 'Compound'),
    (Code: 'XDC'; DisplayName: 'XDC Network'),
    (Code: 'KAVA'; DisplayName: 'Kava'),
    (Code: 'MINA'; DisplayName: 'Mina'),
    (Code: 'DCR'; DisplayName: 'Decred'),
    (Code: 'CVX'; DisplayName: 'Convex Finance'),
    (Code: 'WAVES'; DisplayName: 'Waves'),
    (Code: 'RVN'; DisplayName: 'Ravencoin'),
    (Code: '1INCH'; DisplayName: '1inch'),
    (Code: 'LUNA'; DisplayName: 'Terra'),
    (Code: 'XEM'; DisplayName: 'NEM'),
    (Code: 'CELO'; DisplayName: 'Celo'),
    (Code: 'GMT'; DisplayName: 'GMT'),
    (Code: 'HOT'; DisplayName: 'Holo'),
    (Code: 'LRC'; DisplayName: 'Loopring'),
    (Code: 'KSM'; DisplayName: 'Kusama'),
    (Code: 'AR'; DisplayName: 'Arweave'),
    (Code: 'BTG'; DisplayName: 'Bitcoin Gold'),
    (Code: 'BNX'; DisplayName: 'BinaryX'),
    (Code: 'GUSD'; DisplayName: 'Gemini Dollar'),
    (Code: 'GNO'; DisplayName: 'Gnosis'),
    (Code: 'YFI'; DisplayName: 'yearn.finance'),
    (Code: 'ROSE'; DisplayName: 'Oasis Network'),
    (Code: 'QTUM'; DisplayName: 'Qtum'),
    (Code: 'ANKR'; DisplayName: 'Ankr'),
    (Code: 'RSR'; DisplayName: 'Reserve Rights'),
    (Code: 'GALA'; DisplayName: 'Gala'),
    (Code: 'KDA'; DisplayName: 'Kadena'),
    (Code: 'BTRST'; DisplayName: 'Braintrust'),
    (Code: 'TFUEL'; DisplayName: 'Theta Fuel'),
    (Code: 'GLM'; DisplayName: 'Golem'),
    (Code: 'IOTX'; DisplayName: 'IoTeX'),
    (Code: 'JST'; DisplayName: 'JUST'),
    (Code: 'CEL'; DisplayName: 'Celsius'),
    (Code: 'POLY'; DisplayName: 'Polymath'),
    (Code: 'ONE'; DisplayName: 'Harmony'),
    (Code: 'OMG'; DisplayName: 'OMG Network'),
    (Code: 'FLUX'; DisplayName: 'Flux'),
    (Code: 'BAL'; DisplayName: 'Balancer'),
    (Code: 'HIVE'; DisplayName: 'Hive'),
    (Code: 'BORA'; DisplayName: 'BORA'),
    (Code: 'LPT'; DisplayName: 'Livepeer'),
    (Code: 'ZRX'; DisplayName: '0x'),
    (Code: 'IOST'; DisplayName: 'IOST'),
    (Code: 'AMP'; DisplayName: 'Amp'),
    (Code: 'XYM'; DisplayName: 'Symbol'),
    (Code: 'ICX'; DisplayName: 'ICON'),
    (Code: 'GLMR'; DisplayName: 'Glimmer'),
    (Code: 'SUSHI'; DisplayName: 'SushiSwap'),
    (Code: 'CHSB'; DisplayName: 'SwissBorg'),
    (Code: 'WOO'; DisplayName: 'WOO Network'),
    (Code: 'SRM'; DisplayName: 'Serum'),
    (Code: 'ONT'; DisplayName: 'Ontology'),
    (Code: 'WAXP'; DisplayName: 'WAX'),
    (Code: 'XCH'; DisplayName: 'Chia'),
    (Code: 'SC'; DisplayName: 'Siacoin'),
    (Code: 'STORJ'; DisplayName: 'Storj'),
    (Code: 'KNC'; DisplayName: 'Kyber Network'),
    (Code: 'MXC'; DisplayName: 'MXC'),
    (Code: 'OP'; DisplayName: 'Optimism'),
    (Code: 'ZEN'; DisplayName: 'Horizen'),
    (Code: 'SXP'; DisplayName: 'Swipe'),
    (Code: 'AUDIO'; DisplayName: 'Audius'),
    (Code: 'NFT'; DisplayName: 'NFT'),
    (Code: 'SCRT'; DisplayName: 'Secret'),
    (Code: 'ABBC'; DisplayName: 'ABBC')
    );
var
  i: integer;
begin
  Result := [];
  SetLength(Result, Length(CurrencyCrypto));
  for i := 0 to High(CurrencyCrypto) do
    Result[i] := CurrencyCrypto[i];
end;

function GetUnits: TValueArray;
const
  Units: array[0..166] of TAppValue = (
    (Code: 'acre'; DisplayName: 'acre - area'),
    (Code: 'angstrom'; DisplayName: 'angstrom - length'),
    (Code: 'b'; DisplayName: 'bit - information'),
    (Code: 'B'; DisplayName: 'byte - information'),
    (Code: 'bbl'; DisplayName: 'beer barrel - volume'),
    (Code: 'cd'; DisplayName: 'candela - luminous intensity'),
    (Code: 'ch'; DisplayName: 'chain - length'),
    (Code: 'cm'; DisplayName: 'centimeter - length'),
    (Code: 'cm2'; DisplayName: 'square centimeter - area'),
    (Code: 'cm3'; DisplayName: 'cubic centimeter - volume'),
    (Code: 'cwt'; DisplayName: 'hundredweight - mass'),
    (Code: 'cycle'; DisplayName: 'cycle - angle'),
    (Code: 'day'; DisplayName: 'day - time'),
    (Code: 'deg'; DisplayName: 'degree - angle'),
    (Code: 'degC'; DisplayName: 'degree Celsius - temperature'),
    (Code: 'degF'; DisplayName: 'degree Fahrenheit - temperature'),
    (Code: 'degR'; DisplayName: 'degree Rankine - temperature'),
    (Code: 'dL'; DisplayName: 'deciliter - volume'),
    (Code: 'dm'; DisplayName: 'decimeter - length'),
    (Code: 'dm2'; DisplayName: 'square decimeter - area'),
    (Code: 'dm3'; DisplayName: 'cubic decimeter - volume'),
    (Code: 'dr'; DisplayName: 'dram - mass'),
    (Code: 'Eb'; DisplayName: 'exabit - information'),
    (Code: 'EB'; DisplayName: 'exabyte - information'),
    (Code: 'Eib'; DisplayName: 'exbibit - information'),
    (Code: 'EiB'; DisplayName: 'exbibyte - information'),
    (Code: 'fA'; DisplayName: 'femtoampere - current'),
    (Code: 'fcd'; DisplayName: 'femtocandela - luminous intensity'),
    (Code: 'fg'; DisplayName: 'femtogram - mass'),
    (Code: 'fL'; DisplayName: 'femtoliter - volume'),
    (Code: 'fm'; DisplayName: 'femtometer - length'),
    (Code: 'fm2'; DisplayName: 'square femtometer - area'),
    (Code: 'fm3'; DisplayName: 'cubic femtometer - volume'),
    (Code: 'fmol'; DisplayName: 'femtomole - amount of substance'),
    (Code: 'fN'; DisplayName: 'femtonewton - force'),
    (Code: 'fs'; DisplayName: 'femtosecond - time'),
    (Code: 'ft'; DisplayName: 'foot - length'),
    (Code: 'g'; DisplayName: 'gram - mass'),
    (Code: 'gal'; DisplayName: 'gallon - volume'),
    (Code: 'Gb'; DisplayName: 'gigabit - information'),
    (Code: 'GB'; DisplayName: 'gigabyte - information'),
    (Code: 'Gcd'; DisplayName: 'gigacandela - luminous intensity'),
    (Code: 'Gib'; DisplayName: 'gibibit - information'),
    (Code: 'GiB'; DisplayName: 'gibibyte - information'),
    (Code: 'GN'; DisplayName: 'giganewton - force'),
    (Code: 'Gm'; DisplayName: 'gigameter - length'),
    (Code: 'Gm2'; DisplayName: 'square gigameter - area'),
    (Code: 'Gm3'; DisplayName: 'cubic gigameter - volume'),
    (Code: 'Gmol'; DisplayName: 'gigamole - amount of substance'),
    (Code: 'grad'; DisplayName: 'gradian - angle'),
    (Code: 'gr'; DisplayName: 'grain - mass'),
    (Code: 'gtt'; DisplayName: 'drop - volume'),
    (Code: 'h'; DisplayName: 'hour - time'),
    (Code: 'ha'; DisplayName: 'hectare - area'),
    (Code: 'hL'; DisplayName: 'hectoliter - volume'),
    (Code: 'hm'; DisplayName: 'hectometer - length'),
    (Code: 'hm2'; DisplayName: 'square hectometer - area'),
    (Code: 'hm3'; DisplayName: 'cubic hectometer - volume'),
    (Code: 'hogshead'; DisplayName: 'hogshead - volume'),
    (Code: 'in'; DisplayName: 'inch - length'),
    (Code: 'K'; DisplayName: 'kelvin - temperature'),
    (Code: 'kA'; DisplayName: 'kiloampere - current'),
    (Code: 'kb'; DisplayName: 'kilobit - information'),
    (Code: 'kB'; DisplayName: 'kilobyte - information'),
    (Code: 'kcd'; DisplayName: 'kilocandela - luminous intensity'),
    (Code: 'kg'; DisplayName: 'kilogram - mass'),
    (Code: 'Kib'; DisplayName: 'kibibit - information'),
    (Code: 'KiB'; DisplayName: 'kibibyte - information'),
    (Code: 'kL'; DisplayName: 'kiloliter - volume'),
    (Code: 'km'; DisplayName: 'kilometer - length'),
    (Code: 'km2'; DisplayName: 'square kilometer - area'),
    (Code: 'km3'; DisplayName: 'cubic kilometer - volume'),
    (Code: 'kN'; DisplayName: 'kilonewton - force'),
    (Code: 'ktonne'; DisplayName: 'kilotonne - mass'),
    (Code: 'L'; DisplayName: 'liter - volume'),
    (Code: 'l'; DisplayName: 'liter - volume'),
    (Code: 'lb'; DisplayName: 'pound - mass'),
    (Code: 'lbf'; DisplayName: 'pound force - force'),
    (Code: 'li'; DisplayName: 'link - length'),
    (Code: 'm'; DisplayName: 'meter - length'),
    (Code: 'm2'; DisplayName: 'square meter - area'),
    (Code: 'm3'; DisplayName: 'cubic meter - volume'),
    (Code: 'mA'; DisplayName: 'milliampere - current'),
    (Code: 'MA'; DisplayName: 'megaampere - current'),
    (Code: 'Mb'; DisplayName: 'megabit - information'),
    (Code: 'MB'; DisplayName: 'megabyte - information'),
    (Code: 'mcd'; DisplayName: 'millicandela - luminous intensity'),
    (Code: 'Mcd'; DisplayName: 'megacandela - luminous intensity'),
    (Code: 'mg'; DisplayName: 'milligram - mass'),
    (Code: 'Mib'; DisplayName: 'mebibit - information'),
    (Code: 'MiB'; DisplayName: 'mebibyte - information'),
    (Code: 'mil'; DisplayName: 'mil - length'),
    (Code: 'min'; DisplayName: 'minute - time'),
    (Code: 'mL'; DisplayName: 'milliliter - volume'),
    (Code: 'mm'; DisplayName: 'millimeter - length'),
    (Code: 'mm2'; DisplayName: 'square millimeter - area'),
    (Code: 'mm3'; DisplayName: 'cubic millimeter - volume'),
    (Code: 'mN'; DisplayName: 'millinewton - force'),
    (Code: 'MN'; DisplayName: 'meganewton - force'),
    (Code: 'mol'; DisplayName: 'mole - amount of substance'),
    (Code: 'ms'; DisplayName: 'millisecond - time'),
    (Code: 'nA'; DisplayName: 'nanoampere - current'),
    (Code: 'ncd'; DisplayName: 'nanocandela - luminous intensity'),
    (Code: 'ng'; DisplayName: 'nanogram - mass'),
    (Code: 'nL'; DisplayName: 'nanoliter - volume'),
    (Code: 'nm'; DisplayName: 'nanometer - length'),
    (Code: 'nm2'; DisplayName: 'square nanometer - area'),
    (Code: 'nm3'; DisplayName: 'cubic nanometer - volume'),
    (Code: 'nmol'; DisplayName: 'nanomole - amount of substance'),
    (Code: 'nN'; DisplayName: 'nanonewton - force'),
    (Code: 'ns'; DisplayName: 'nanosecond - time'),
    (Code: 'N'; DisplayName: 'newton - force'),
    (Code: 'obl'; DisplayName: 'oil barrel - volume'),
    (Code: 'oz'; DisplayName: 'ounce - mass'),
    (Code: 'pA'; DisplayName: 'picoampere - current'),
    (Code: 'Pb'; DisplayName: 'petabit - information'),
    (Code: 'PB'; DisplayName: 'petabyte - information'),
    (Code: 'pcd'; DisplayName: 'picocandela - luminous intensity'),
    (Code: 'Pib'; DisplayName: 'pebibit - information'),
    (Code: 'PiB'; DisplayName: 'pebibyte - information'),
    (Code: 'pL'; DisplayName: 'picoliter - volume'),
    (Code: 'pm'; DisplayName: 'picometer - length'),
    (Code: 'pm2'; DisplayName: 'square picometer - area'),
    (Code: 'pm3'; DisplayName: 'cubic picometer - volume'),
    (Code: 'pmol'; DisplayName: 'picomole - amount of substance'),
    (Code: 'pN'; DisplayName: 'piconewton - force'),
    (Code: 'ps'; DisplayName: 'picosecond - time'),
    (Code: 'pt'; DisplayName: 'pint - volume'),
    (Code: 'qt'; DisplayName: 'quart - volume'),
    (Code: 'rad'; DisplayName: 'radian - angle'),
    (Code: 'rd'; DisplayName: 'rod - length'),
    (Code: 's'; DisplayName: 'second - time'),
    (Code: 'sqch'; DisplayName: 'square chain - area'),
    (Code: 'sqft'; DisplayName: 'square foot - area'),
    (Code: 'sqin'; DisplayName: 'square inch - area'),
    (Code: 'sqmi'; DisplayName: 'square mile - area'),
    (Code: 'sqmil'; DisplayName: 'square mil - area'),
    (Code: 'sqrd'; DisplayName: 'square rod - area'),
    (Code: 'sqyd'; DisplayName: 'square yard - area'),
    (Code: 'stone'; DisplayName: 'stone - mass'),
    (Code: 'tablespoon'; DisplayName: 'tablespoon - volume'),
    (Code: 'Tb'; DisplayName: 'terabit - information'),
    (Code: 'TB'; DisplayName: 'terabyte - information'),
    (Code: 'teaspoon'; DisplayName: 'teaspoon - volume'),
    (Code: 'Tib'; DisplayName: 'tebibit - information'),
    (Code: 'TiB'; DisplayName: 'tebibyte - information'),
    (Code: 'ton'; DisplayName: 'ton - mass'),
    (Code: 'tonne'; DisplayName: 'tonne - mass'),
    (Code: 'uA'; DisplayName: 'microampere - current'),
    (Code: 'ucd'; DisplayName: 'microcandela - luminous intensity'),
    (Code: 'ug'; DisplayName: 'microgram - mass'),
    (Code: 'uL'; DisplayName: 'microliter - volume'),
    (Code: 'um'; DisplayName: 'micrometer - length'),
    (Code: 'um2'; DisplayName: 'square micrometer - area'),
    (Code: 'um3'; DisplayName: 'cubic micrometer - volume'),
    (Code: 'umol'; DisplayName: 'micromole - amount of substance'),
    (Code: 'uN'; DisplayName: 'micronewton - force'),
    (Code: 'us'; DisplayName: 'microsecond - time'),
    (Code: 'Yb'; DisplayName: 'yottabit - information'),
    (Code: 'YB'; DisplayName: 'yottabyte - information'),
    (Code: 'yd'; DisplayName: 'yard - length'),
    (Code: 'Yib'; DisplayName: 'yobibit - information'),
    (Code: 'YiB'; DisplayName: 'yobibyte - information'),
    (Code: 'Zb'; DisplayName: 'zettabit - information'),
    (Code: 'ZB'; DisplayName: 'zettabyte - information'),
    (Code: 'Zib'; DisplayName: 'zebibit - information'),
    (Code: 'ZiB'; DisplayName: 'zebibyte - information')
    );
var
  i: integer;
begin
  Result := [];
  SetLength(Result, Length(Units));
  for i := 0 to High(Units) do
    Result[i] := Units[i];
end;

function GetValues(AValueType: TValueType = vtNone; ASort: boolean = True): TValueArray;
var
  i, j: integer;
  Temp: TAppValue;
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
  begin
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
end;

function GetLanguageCodePairList(AValueType: TValueType): TStringList;
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

function GetLanguageDisplayStrings(AValueType: TValueType): TStringList;
var
  Langs: array of TAppValue;
  L: TAppValue;
begin
  Result := TStringList.Create;
  Langs := GetValues(AValueType);
  for L in Langs do
    Result.Add(L.DisplayName + ' (' + L.Code + ')');
end;

function GetDisplayNamesFromCodeMap(ACodeMap: TStringList; AValueType: TValueType; Sort: boolean = False): TStringList;
var
  Langs: array of TAppValue;
  LangMap: TStringList;          // List of "code=displayname" for lookup
  i, j, idx: integer;
  Key, ApiValue, DisplayString: string;
  SpecialsList, OthersList: TStringList;
  IsSpecial: boolean;
  CaseSensitiveSearch: boolean;
begin
  Result := TStringList.Create;
  try
    // Retrieve the master language list
    Langs := GetValues(AValueType);

    // Build a map from language code to display name
    LangMap := TStringList.Create;
    try
      CaseSensitiveSearch := AValueType in [vtUnit, vtNone];
      LangMap.CaseSensitive := CaseSensitiveSearch;

      for i := 0 to High(Langs) do
        LangMap.Add(Langs[i].Code + '=' + Langs[i].DisplayName);

      // Create temporary lists for special and normal items
      SpecialsList := TStringList.Create;
      OthersList := TStringList.Create;
      try
        // Process each entry in the input code map
        for i := 0 to ACodeMap.Count - 1 do
        begin
          if Trim(ACodeMap[i]) = string.Empty then
            Continue; // Skip empty lines

          Key := Trim(ACodeMap.Names[i]);               // Left part (language code)
          ApiValue := Trim(ACodeMap.ValueFromIndex[i]); // Right part (API code)

          if (Key = string.Empty) or (ApiValue = string.Empty) then
            Continue; // Skip malformed lines

          // Look up the key using IndexOfName
          if CaseSensitiveSearch then
            idx := LangMap.IndexOfName(Key) // case-sensitive for vtUnit
          else
            idx := LangMap.IndexOfName(Key); // case-insensitive for others

          if idx >= 0 then
            DisplayString := LangMap.ValueFromIndex[idx] + ' (' + ApiValue + ')'
          else
            DisplayString := ApiValue;

          // Check if the key is in the special codes list (case-insensitive)
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

function ExtractCodeFromItem(const ItemText: string): string;
var
  P: integer;
begin
  Result := '';
  P := RPos(' (', ItemText);
  if P > 0 then
    Result := Copy(ItemText, P + 2, Length(ItemText) - P - 2)
  else
    Result := ItemText;
end;

end.
