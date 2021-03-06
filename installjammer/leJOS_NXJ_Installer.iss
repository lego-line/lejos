#preproc ispp
#if VER < EncodeVer(5,4,3)
  #error Use Inno Setup 5.4.3(unicode) or newer
#endif
#ifndef UNICODE
  #error Use the unicode build of Inno Setup
#endif

#ifndef MyAppVersion
  #define MyAppVersion "0.9.1beta-2"
#endif
#define MinFantomVersion "1,1,3"

; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
#define MyAppID "253252E2-EFAE-4AA8-96B6-0828619E536C"

[Setup]
AppId={{{#MyAppID}}
AppName=leJOS NXJ
AppVersion={#MyAppVersion}
AppVerName=leJOS NXJ {#MyAppVersion}
OutputBaseFilename=leJOS_NXJ_{#MyAppVersion}_win32_setup
AppPublisher=The leJOS Team
AppPublisherURL=http://www.lejos.org/
AppSupportURL=http://www.lejos.org/
AppUpdatesURL=http://www.lejos.org/
SetupIconFile=../org.lejos.website/htdocs/lejos.ico
DefaultDirName={pf}\leJOS NXJ
DefaultGroupName=leJOS NXJ
AllowNoIcons=true
SolidCompression=yes
Compression=lzma2/max
OutputDir=.
ChangesEnvironment=yes
MinVersion=0,5.0
WizardImageFile=img\WizardImage.bmp
WizardImageStretch=no
WizardImageBackColor=clWhite
WizardSmallImageFile=img\WizardSmallImage.bmp
UninstallFilesDir={app}\uninst

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
LaunchProgram=Launch NXJ Flash utility
JDKSelectCaption=Select a Java Development Kit
JDKSelectDescription=Select a Java Development Kit for use with leJOS NXJ

[Types]
Name: "compact"; Description: "Compact installation"
Name: "minimal"; Description: "Minimal installation"
Name: "full"; Description: "Full installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom
  
[Components]
Name: "main"; Description: "leJOS Development Kit"; Types: full compact minimal custom; Flags: fixed disablenouninstallwarning
Name: "docs"; Description: "Documentation"; Types: full compact; Flags: disablenouninstallwarning
Name: "docs\apinxt"; Description: "API Documentation (NXT)"; Types: full compact; Flags: disablenouninstallwarning
Name: "docs\apipc"; Description: "API Documentation (PC)"; Types: full compact; Flags: disablenouninstallwarning
Name: "extras"; Description: "Additional Sources"; Types: full; Flags: disablenouninstallwarning
Name: "extras\samples"; Description: "Sample and Example Projects"; Types: full; Flags: disablenouninstallwarning
Name: "extras\sources"; Description: "Sources of leJOS Development Kit"; Types: full; Flags: disablenouninstallwarning

[Files]
; Extract helper script to {app}, since {tmp} refers to the temp folder of the admin, and might
; not even be accessible by the original user when using postinstall/runasoriginaluser in [Run]
Source: "scripts\startNxjFlash.bat"; DestDir: "{app}"; Flags: deleteafterinstall
Source: "..\release\build\bin_windows\*"; DestDir: "{app}"; Excludes: "docs"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: main
Source: "..\release\build\bin_windows\docs\pc\*"; DestDir: "{app}\docs\pc"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: docs\apipc
Source: "..\release\build\bin_windows\docs\nxt\*"; DestDir: "{app}\docs\nxt"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: docs\apinxt
Source: "..\release\build\samples\*"; DestDir: "{code:ExtrasDirPage_GetSamplesFolder}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: extras\samples
Source: "..\release\build\source\*"; DestDir: "{code:ExtrasDirPage_GetSourcesFolder}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: extras\sources

[Icons]
Name: "{group}\API Documentation (PC)"; Filename: "{app}\docs\pc\index.html"; Components: docs\apipc
Name: "{group}\API Documentation (NXT)"; Filename: "{app}\docs\nxt\index.html"; Components: docs\apinxt
Name: "{group}\NXJ Flash"; Filename: "{app}\bin\nxjflashg.bat"; Flags: closeonexit runminimized
Name: "{group}\NXJ Browse"; Filename: "{app}\bin\nxjbrowse.bat"; Flags: closeonexit runminimized
Name: "{group}\NXJ Charting Logger"; Filename: "{app}\bin\nxjchartinglogger.bat"; Flags: closeonexit runminimized
Name: "{group}\NXJ Control"; Filename: "{app}\bin\nxjcontrol.bat"; Flags: closeonexit runminimized
Name: "{group}\NXJ Console Viewer"; Filename: "{app}\bin\nxjconsoleviewer.bat"; Flags: closeonexit runminimized
Name: "{group}\NXJ Data Viewer"; Filename: "{app}\bin\nxjdataviewer.bat"; Flags: closeonexit runminimized
Name: "{group}\NXJ Image Convertor"; Filename: "{app}\bin\nxjimage.bat"; Flags: closeonexit runminimized
Name: "{group}\NXJ Map Command"; Filename: "{app}\bin\nxjmapcommand.bat"; Flags: closeonexit runminimized
Name: "{group}\NXJ Monitor"; Filename: "{app}\bin\nxjmonitor.bat"; Flags: closeonexit runminimized
Name: "{group}\Uninstall LeJOS"; Filename: "{uninstallexe}"

[Registry]
; Delete LEJOS_NXT_JAVA_HOME and NXJ_HOME value for current user and set new value globally
Root: HKCU; Subkey: "Environment"; ValueType: none; ValueName: "NXJ_HOME"; Flags: deletevalue
Root: HKCU; Subkey: "Environment"; ValueType: none; ValueName: "LEJOS_NXT_JAVA_HOME"; Flags: deletevalue

[Run]
; startNxjFlash.bat will terminate immediately, and hence we don't use the nowait flag.
; Not using the nowait flag also makes sure that the batch file can be deleted successfully.
WorkingDir: "{app}"; Filename: "{app}\startNxjFlash.bat"; Parameters: "{code:JDKSelect_GetSelectionQuoted}"; Description: "{cm:LaunchProgram}"; Flags: postinstall skipifsilent runhidden

#include "include\Tools.iss"
#include "include\Fantom.iss"
#include "include\ModPath.iss"
#include "include\JDKSelect.iss"
#include "include\ExtrasDirPage.iss"
#include "include\UnInstall.iss"

[Code] 
  function JDKSelect_GetSelectionQuoted(Param: String): String;
  begin
    Result := AddQuotes(JDKSelect_GetSelection(Param));
  end;

  procedure CurStepChanged(CurStep: TSetupStep);
  var
    Data: String;
  begin
    if CurStep = ssPostInstall then
    begin
      try
        GetEnvVar('Path', Data);
        SetExpEnvVar('Path', ModPath_Append(Data, ExpandConstant('{app}\bin')));
      except
        ShowExceptionMessage;
      end;
      try
        SetEnvVar('NXJ_HOME', ExpandConstant('{app}'));
      except
        ShowExceptionMessage;
      end;
      try
        SetEnvVar('LEJOS_NXT_JAVA_HOME', JDKSelect_GetSelection('dummy param'));
      except
        ShowExceptionMessage;
      end;
    end;   
  end;
  
  procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
  var
    Data: String;
  begin
    if CurUninstallStep = usUninstall then
    begin
      try
        GetEnvVar('Path', Data);
        SetEnvVar('Path', ModPath_Delete(Data, ExpandConstant('{app}\bin')));
      except
        ShowExceptionMessage;
      end;
      try
        DeleteEnvVar('NXJ_HOME');
      except
        ShowExceptionMessage;
      end;
      try
        DeleteEnvVar('LEJOS_NXT_JAVA_HOME');
      except
        ShowExceptionMessage;
      end;
    end;   
  end;
  
  function NextButtonClick(curPageID: Integer): Boolean;
  var
    ID : String;
  begin
    if curPageID = wpWelcome then
    begin
      Result := DetectOutdatedFantom({#MinFantomVersion});
      if not Result then Exit;     
    end;
    
    if curPageID = wpReady then
    begin
      ID := '{#MyAppID}' 
      Result := UninstallInstallJammer(ID);
      if not Result then Exit;     
      Result := UninstallInnoSetup(ID);
      if not Result then Exit;     
    end;
    
    Result := true;
  end;
   
  function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
    MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
  begin
    Result := MemoDirInfo + NewLine;
    if IsComponentSelected('extras\samples') then
    begin
      Result := Result + Space + ExtrasDirPage_GetSamplesFolder('') + NewLine;
    end;
    if IsComponentSelected('extras\sources') then
    begin
      Result := Result + Space + ExtrasDirPage_GetSourcesFolder('') + NewLine;
    end;
    if MemoGroupInfo > '' then
    begin
      Result := Result + NewLine;    
      Result := Result + MemoGroupInfo + NewLine;
    end;
    Result := Result + NewLine;
    Result := Result + MemoTypeInfo + NewLine;
    Result := Result + NewLine;
    Result := Result + MemoComponentsInfo + NewLine;
    // Result := Result + NewLine;    
    // Result := Result + MemoTasksInfo + NewLine;  
  end;

  procedure InitializeWizard();
  begin
    JDKSelect_CreatePage(wpUserInfo);
    ExtrasDirPage_CreatePage(wpSelectComponents);    
  end;

//#expr SaveToFile("debug.iss")
