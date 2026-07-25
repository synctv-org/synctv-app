#ifndef AppVersion
  #error AppVersion is required
#endif

#ifndef SourceDirectory
  #error SourceDirectory is required
#endif

#ifndef OutputDirectory
  #error OutputDirectory is required
#endif

#ifndef OutputBaseFilename
  #error OutputBaseFilename is required
#endif

#ifndef AppUrl
  #error AppUrl is required
#endif

#ifndef AppArchitecture
  #error AppArchitecture is required
#endif

#define AppExecutable "SyncTV.exe"
#define AppPublisher "SyncTV"

[Setup]
AppId={{652B01DD-488F-4914-880E-8C897065343A}
AppName=SyncTV
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppUrl}
AppSupportURL={#AppUrl}/issues
AppUpdatesURL={#AppUrl}/releases
DefaultDirName={autopf}\SyncTV
DefaultGroupName=SyncTV
DisableProgramGroupPage=yes
OutputDir={#OutputDirectory}
OutputBaseFilename={#OutputBaseFilename}
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExecutable}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
#if AppArchitecture == "arm64"
ArchitecturesAllowed=arm64
ArchitecturesInstallIn64BitMode=arm64
#else
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
#endif
CloseApplications=yes
RestartApplications=yes
MinVersion=10.0.17763

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#SourceDirectory}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\SyncTV"; Filename: "{app}\{#AppExecutable}"
Name: "{autodesktop}\SyncTV"; Filename: "{app}\{#AppExecutable}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExecutable}"; Description: "{cm:LaunchProgram,SyncTV}"; Flags: nowait postinstall skipifsilent
