@echo off

:: For traditional MinGW, set prefix32 to empty string
:: For mingw-w32, set prefix32 to i686-w64-mingw32-
:: For mingw-w64, set prefix64 to x86_64-w64-mingw32-

set prefix32=i686-w64-mingw32-
set prefix64=x86_64-w64-mingw32-

taskkill /IM SuperF4.exe

if not exist build. mkdir build

:: %prefix32%gcc -o localization\export_l10n_ini.exe include\export_l10n_ini.c -lshlwapi
:: localization\export_l10n_ini.exe
:: exit /b

if "%1" == "all" (
	%prefix32%windres -o build\superf4.o include\superf4.rc

	echo.
	echo Building binaries
	%prefix32%gcc -o "build\SuperF4.exe" superf4.c build\superf4.o -mwindows -lshlwapi -lwininet -lcomctl32 -O2 -s
	if not exist "build\SuperF4.exe". exit /b

	if "%2" == "x64" (
		if not exist "build\x64". mkdir "build\x64"
		%prefix64%windres -o build\x64\superf4.o include\superf4.rc
		%prefix64%gcc -o "build\x64\SuperF4.exe" superf4.c build\x64\superf4.o -mwindows -lshlwapi -lwininet -lcomctl32 -O2 -s
		if not exist "build\x64\SuperF4.exe". exit /b
	)

	echo Building installer
	if "%2" == "x64" (
		makensis /V2 /Dx64 installer.nsi
	) else (
		makensis /V2 installer.nsi
	)
) else if "%1" == "x64" (
	if not exist "build\x64". mkdir "build\x64"
	%prefix64%windres -o build\x64\superf4.o include\superf4.rc
	%prefix64%gcc -o SuperF4.exe superf4.c build\x64\superf4.o -mwindows -lshlwapi -lwininet -lcomctl32 -g -DDEBUG
) else (
	%prefix32%windres -o build\superf4.o include\superf4.rc
	%prefix32%gcc -o SuperF4.exe superf4.c build\superf4.o -mwindows -lshlwapi -lwininet -lcomctl32 -g -DDEBUG

	if "%1" == "run" (
		start SuperF4.exe
	)
)
