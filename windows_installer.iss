; MyAppInstaller.iss
[Setup]
AppName=structogrammar
AppVersion=1.0
DefaultDirName={autopf}\structogrammar
DefaultGroupName=structogrammar
OutputBaseFilename=structogrammar_installer
Compression=lzma
SolidCompression=yes

[Files]
Source: "build\windows\runner\Release\structogrammar.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\structogrammar"; Filename: "{app}\structogrammar.exe"