#define MyAppName "Trayslate"
#define FileHandle FileOpen("..\VERSION")
#define MyAppVersion Trim(FileRead(FileHandle))
#if FileHandle
  #expr FileClose(FileHandle)
#endif
#define MyAppPublisher "Alexander Tverskoy"
#define MyAppURL "https://github.com/plaintool/trayslate"
#define MyAppExeName "trayslate.exe"

[Setup]
AppId={{D1E4B5C2-8F9A-4B6D-AB12-3F7C9E4D8A21}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
UninstallDisplayIcon={app}\trayslate.exe
DefaultDirName={autopf}\{#MyAppName}
ArchitecturesAllowed=x64compatible x86 arm64
ArchitecturesInstallIn64BitMode=x64compatible arm64
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=.\
OutputBaseFilename=trayslate-{#MyAppVersion}-any-x86-x64
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "arabic"; MessagesFile: "compiler:Languages\Arabic.isl"
Name: "belarusian"; MessagesFile: "compiler:Languages\Belarusian.isl"
Name: "chinese"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "greek"; MessagesFile: "compiler:Languages\Greek.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "hindi"; MessagesFile: "compiler:Languages\Hindi.isl"
Name: "indonesian"; MessagesFile: "compiler:Languages\Indonesian.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "romanian"; MessagesFile: "compiler:Languages\Romanian.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "swedish"; MessagesFile: "compiler:Languages\Swedish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; 64-bit
Source: "..\{#MyAppExeName}"; DestDir: "{app}"; DestName: "{#MyAppExeName}"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "..\libcrypto-1_1-x64.dll"; DestDir: "{app}"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "..\libssl-1_1-x64.dll"; DestDir: "{app}"; Check: Is64BitInstallMode; Flags: ignoreversion
; 32-bit
Source: "..\trayslate32.exe"; DestDir: "{app}"; DestName: "{#MyAppExeName}"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "..\libcrypto-1_1.dll"; DestDir: "{app}"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "..\libssl-1_1.dll"; DestDir: "{app}"; Check: not Is64BitInstallMode; Flags: ignoreversion
; License
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
; Config files in a subfolder
Source: "..\config\google-get-apis.ini";        DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\google-get-clients5.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\google-post.ini";       DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\google-get-dictionary.ini";       DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\microsofttranslator.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\mymemory.ini";         DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\simplytranslate-google.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\papago.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\languagedetect.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\wiktionary.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\marketshost.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\coinconvert.ini"; DestDir: "{app}\config"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent