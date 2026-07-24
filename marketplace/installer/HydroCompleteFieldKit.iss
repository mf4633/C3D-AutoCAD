; Inno Setup script — Survey & Parcel Field Kit installer
; 1. Install Inno Setup 6: https://jrsoftware.org/isinfo.php
; 2. Run scripts/package-marketplace.ps1 first
; 3. Open this file in Inno Setup Compiler → Build
;
; Requires admin (Autodesk Marketplace guideline).

#define MyAppName "Survey & Parcel Field Kit"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Michael Flynn, PE"
#define MyAppURL "https://hydrocomplete.com"
#define BundleSource "..\..\dist\HydroCompleteFieldKit_v1\HydroCompleteFieldKit.bundle"

[Setup]
; Must match ProductCode in PackageContents.xml (scripts/package-marketplace.ps1).
AppId={{717A5504-F411-4AF2-B1BD-245343975734}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
; {commonappdata} = %ProgramData%. Both %ProgramData% and %ProgramFiles% are
; valid autoloader roots, but the docs and the local-test instructions printed by
; package-marketplace.ps1 both say %ProgramData% -- keep all three in agreement so
; the path you test is the path you ship.
DefaultDirName={commonappdata}\Autodesk\ApplicationPlugins\HydroCompleteFieldKit.bundle
DefaultGroupName={#MyAppName}
DisableDirPage=yes
DisableProgramGroupPage=yes
OutputDir=..\..\dist\HydroCompleteFieldKit_v1
OutputBaseFilename=HydroCompleteFieldKit_Setup
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64

[Files]
Source: "{#BundleSource}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Field Kit Help"; Filename: "{app}\Help\quickstart.html"

[UninstallDelete]
Type: filesandordirs; Name: "{app}"