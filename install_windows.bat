@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul

set "VDP_SOURCE=%~dp0"
set "VDP_TARGET=%LOCALAPPDATA%\DPV"
set "VDP_OLD_TARGET=%LOCALAPPDATA%\VDPRO-VANDANG"
set "VDP_EXE=%VDP_TARGET%\DPV.exe"
set "VDP_CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"

rem V134: once this installer is allowed to start, clear Mark-of-the-Web from the extracted DPV folder.
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -LiteralPath $env:VDP_SOURCE -Recurse -Force -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue" >nul 2>&1

if not exist "%VDP_CSC%" set "VDP_CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe"

echo.
echo ================================================
echo              DPV(R) V134 INSTALL SAFE - NUMBER SEQUENCE / MIXED ROTATION SAFE
echo ================================================
echo.

if not exist "%VDP_CSC%" (
  echo KHONG TIM THAY .NET FRAMEWORK 4.x COMPILER.
  echo Hay bat .NET Framework 4.8 trong Windows Features roi chay lai.
  pause
  exit /b 1
)

if not exist "%VDP_SOURCE%src\VDPRO.cs" (
  echo KHONG TIM THAY FILE NGUON: src\VDPRO.cs
  echo Hay giai nen TOAN BO file ZIP roi chay install_windows.bat trong thu muc da giai nen.
  pause
  exit /b 1
)

taskkill /IM DPV.exe /F >nul 2>&1
taskkill /IM VDPRO.exe /F >nul 2>&1
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$desk=[Environment]::GetFolderPath('Desktop');$registered='DPV'+[char]174;" ^
  "$links=@((Join-Path $desk ($registered+'.lnk')),(Join-Path $desk 'DPV.lnk'),(Join-Path $desk 'VDPRO - VANDANG.lnk'));" ^
  "foreach($p in $links){if(Test-Path -LiteralPath $p){Remove-Item -LiteralPath $p -Force}}" >nul 2>&1
if exist "%VDP_OLD_TARGET%" rmdir /S /Q "%VDP_OLD_TARGET%"

echo Dang sao chep DPV vao may...
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "$src=[IO.Path]::GetFullPath($env:VDP_SOURCE);$dst=$env:VDP_TARGET;" ^
  "if(-not (Test-Path -LiteralPath $dst)){New-Item -ItemType Directory -Path $dst -Force|Out-Null};" ^
  "$items=@('app','assets','bridge','src','README_VI.txt','VERSION.txt','V99_STABLE_README.txt','V100_BALANCED_README.txt','V101_STABLE_LAYOUT_README.txt','V103_LIVE_PREVIEW_README.txt','V104_FLUID_MOTION_README.txt','V102_AURORA_UI_README.txt','V93_EXACT_GAP_README.txt','VDP_V72_README.txt','VDP_V73_README.txt','VDP_V74_README.txt','VDP_V75_README.txt','VDP_V76_README.txt','VDP_V77_README.txt','VDP_V79_README.txt','VDP_V80_README.txt','V82_UNIFORM_GAP_README.txt','V83_EQUAL_GAP_README.txt','V84_MULTIPAGE_README.txt','V85_ACROBAT_COMBINE_README.txt','V86_INTERNAL_COMBINE_README.txt','V87_DEMI_FIX_README.txt','V92_MODERN_UI_README.txt','V96_LOW_LAG_README.txt','V98_CACHE_HOTFIX_README.txt','VDP_SAMPLE.csv','V81_LINK_FIX_README.txt','V105_PON_HOTFIX_README.txt','V106_NEW_LOGO_README.txt','V107_NATIVE_PON_FIX_README.txt','V108_ICON_README.txt','V111_COMPLETE_README.txt','V112_STARTUP_SAFE_README.txt','V113_STABLE_DIALOGS_README.txt','V114_VDP_SHEET_README.txt','V115_RESPONSIVE_FAST_README.txt','V129_QR_INFO_README.txt','V130_MANUAL_PREVIEW_FIX_README.txt','V131_MIXED_ROTATION_MAX_README.txt','V132_MIXED_ROTATION_SAFE_README.txt','V133_NUMBER_SEQUENCE_README.txt','uninstall_windows.bat');" ^
  "foreach($name in $items){$from=Join-Path $src $name;$to=Join-Path $dst $name;if(-not (Test-Path -LiteralPath $from)){throw ('Thieu file: '+$from)};if(Test-Path -LiteralPath $to){Remove-Item -LiteralPath $to -Recurse -Force};Copy-Item -LiteralPath $from -Destination $to -Recurse -Force}" 

if errorlevel 1 (
  echo.
  echo KHONG SAO CHEP DUOC FILE DPV.
  echo Hay giai nen ZIP vao thu muc ngan, vi du D:\DPV, roi chay lai.
  pause
  exit /b 1
)

if not exist "%VDP_TARGET%\src\VDPRO.cs" (
  echo.
  echo SAO CHEP CHUA DAY DU: thieu src\VDPRO.cs.
  pause
  exit /b 1
)

echo Dang tao DPV.exe...
"%VDP_CSC%" /nologo /codepage:65001 /target:winexe /platform:x64 /optimize+ ^
  /out:"%VDP_EXE%" ^
  /win32icon:"%VDP_TARGET%\assets\icon\DPV.ico" ^
  /reference:System.dll ^
  /reference:System.Core.dll ^
  /reference:System.Drawing.dll ^
  /reference:System.Windows.Forms.dll ^
  /reference:System.Web.Extensions.dll ^
  "%VDP_TARGET%\src\VDPRO.cs"

if errorlevel 1 (
  echo.
  echo KHONG TAO DUOC DPV.exe. Gui anh loi nay de duoc ho tro.
  pause
  exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$w=New-Object -ComObject WScript.Shell;$name='DPV'+[char]174;" ^
  "$s=$w.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) ($name+'.lnk')));" ^
  "$s.TargetPath=$env:VDP_EXE;$s.WorkingDirectory=$env:VDP_TARGET;$s.IconLocation=$env:VDP_EXE+',0';$s.Description=$name;$s.Save()" >nul 2>&1

echo.
echo CAI DAT HOAN TAT.
echo Co the mo DPV truoc hoac Illustrator truoc. DPV V134 INSTALL SAFE: Number Sequence + Mixed Rotation Safe + VDP/Duplex/QR/Manual Preview fixes.
echo.
start "" "%VDP_EXE%"
pause
endlocal
