#define MyAppName      "Trayslate"

// --- Version resolving ---
#ifndef MyVersion
  #define FileHandle FileOpen("..\VERSION")
  #if FileHandle
    #define MyVersion Trim(FileRead(FileHandle))
    #expr FileClose(FileHandle)
  #else
    #define MyVersion "0.0.0"
  #endif
#endif

#define MyAppVersion   MyVersion
#define MyAppPublisher "Alexander Tverskoy"
#define MyAppURL       "https://github.com/plaintool/trayslate"
#define MyAppExeName   "trayslate.exe"
#define MyAppExeName32 "trayslate32.exe"
#define CurrentYear    GetDateTimeString('yyyy','','')

[Setup]
AppId={{D1E4B5C2-8F9A-4B6D-AB12-3F7C9E4D8A21}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}

VersionInfoDescription={#MyAppName} installer
VersionInfoProductName={#MyAppName}
VersionInfoVersion={#MyAppVersion}

AppCopyright={#CurrentYear} {#MyAppPublisher}

AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

UninstallDisplayName={#MyAppName} {#MyAppVersion}
UninstallDisplayIcon={app}\{#MyAppExeName}

RestartApplications=no

ShowLanguageDialog=yes
UsePreviousLanguage=no
LanguageDetectionMethod=uilanguage

LicenseFile=.\LICENSE.rtf

WizardStyle=modern

SetupIconFile=..\{#MyAppName}.ico
WizardSmallImageFile=.\wizardsmallimagefile.png

DefaultDirName={autopf}\{#MyAppName}
ArchitecturesAllowed=x64compatible x86
ArchitecturesInstallIn64BitMode=x64compatible
DisableProgramGroupPage=yes
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=.\
OutputBaseFilename={#MyAppName}-{#MyAppVersion}-any-x86-x64
Compression=lzma
SolidCompression=yes

[Code]

procedure KillTrayslate();
var
  ResultCode: Integer;
begin
  Exec(
    ExpandConstant('{sys}\taskkill.exe'),
    '/F /IM trayslate.exe /T',
    '',
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode
  );
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
    KillTrayslate();
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
    KillTrayslate();
end;

#include "innosetup_languages.iss£

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
#define MyAppExe "..\" + MyAppExeName
#ifexist MyAppExe
; 64-bit
Source: "..\{#MyAppExeName}"; DestDir: "{app}"; DestName: "{#MyAppExeName}"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "..\libcrypto-1_1-x64.dll"; DestDir: "{app}"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "..\libssl-1_1-x64.dll"; DestDir: "{app}"; Check: Is64BitInstallMode; Flags: ignoreversion
#endif

#define MyAppExe32 "..\" + MyAppExeName32
#ifexist MyAppExe32
; 32-bit
Source: "..\{#MyAppExeName32}"; DestDir: "{app}"; DestName: "{#MyAppExeName}"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "..\libcrypto-1_1.dll"; DestDir: "{app}"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "..\libssl-1_1.dll"; DestDir: "{app}"; Check: not Is64BitInstallMode; Flags: ignoreversion
#endif
; License
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\THIRD_PARTIES"; DestDir: "{app}"; Flags: ignoreversion
; Config files in a subfolder
Source: "..\config\google-get-apis.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\google-get-clients5.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\google-post.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\google-webtran.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\simplytranslate-google.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\microsofttranslator.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\laratranslate.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\deepl.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\yandex.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\mymemory.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\reverso.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\google-get-dictionary.ini";       DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\wiktionary.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\marketshost.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\coinconvert.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\mathjs.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\LLM7-ai-api.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\LLM7-ai-api-ask.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\pollinations-ai-api.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\pollinations-ai-api-ask.ini"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "..\config\languagedetect.ini"; DestDir: "{app}\config"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
