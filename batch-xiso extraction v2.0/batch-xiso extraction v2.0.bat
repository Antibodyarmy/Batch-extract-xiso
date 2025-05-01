@echo OFF
chcp 65001 >nul
setlocal enabledelayedexpansion
:: Enable ANSI colors
for /f "delims=" %%i in ('echo prompt $E^| cmd') do set "ESC=%%i"

:: Define extract-xiso command (edit -q or -Q here) (to keep systemupdate folder remove -s) 
set "xiso_cmd=extract-xiso -x -q -s -d"

:: Check if extract-xiso is available
where extract-xiso >nul 2>&1
if errorlevel 1 (
    echo %ESC%[1;91mError: extract-xiso not found in PATH or current directory.%ESC%[0m
    echo Please ensure extract-xiso is installed and accessible.
    pause
    exit /b 1
)

::======================
::  INTRO BANNER
::======================
echo:
echo %ESC%[1;92mBatch XISO Extraction script v2.0%ESC%[0m
echo:

::======================
::  RELEASE NOTES
::======================
echo:
echo %ESC%[1;96m========================================= %ESC%[0m
echo %ESC%[1;96mRelease Notes - v2.0 %ESC%[0m
echo %ESC%[1;91m- SKIPS SYSTEM UPDATE FOLDERS BY DEFAULT %ESC%[0m
echo %ESC%[1;96m- Folder Selection (default: output) %ESC%[0m
echo %ESC%[1;96m- Auto Extraction without pauses %ESC%[0m
echo %ESC%[1;96m- Improved Colored Progress Bar %ESC%[0m
echo %ESC%[1;96m- Option to delete ISOs after extraction %ESC%[0m
echo %ESC%[1;96m- Full detailed logging with summary %ESC%[0m
echo %ESC%[1;96m- Edit line 8 edit command (removing -q/-Q will only output to logfile) %ESC%[0m
echo %ESC%[1;96m========================================= %ESC%[0m
echo:
echo:

::======================
::  Folder setup
::======================
set "subdir="
set /p "subdir=Enter output folder name for extracted games (default: output): "
if "!subdir!"=="" set "subdir=output"
if not exist "!subdir!" mkdir "!subdir!"

::======================
::  Delete after extract?
::======================
set "choice="
set /p choice=Delete source ISO files after extracting? (Y/[N]) 
if not '!choice!'=='' set choice=!choice:~0,1!

::======================
::  Create log file
::======================
set "logfile=!subdir!\extract_log.txt"
echo Extraction Log - %date% %time% > "!logfile!"
echo Output folder: !subdir! >> "!logfile!"
echo Delete after extract: !choice! >> "!logfile!"
echo Start time: %date% %time% >> "!logfile!"
echo ---------------------------------------- >> "!logfile!"

::======================
::  Find ISO files
::======================
dir /b *.iso > infile.txt
set /a total=0
for /f %%F in (infile.txt) do set /a total+=1

if !total!==0 (
    echo %ESC%[1;91mNo ISO files found. Exiting...%ESC%[0m
    echo No ISO files found. >> "!logfile!"
    pause
    exit /b 1
)

echo Found !total! ISO files.
echo Found !total! ISO files. >> "!logfile!"
echo. >> "!logfile!"

set /a current=0
set /a success=0
set /a errors=0

::======================
::  Process each ISO
::======================
for /f "tokens=*" %%A in (infile.txt) do (
    set /a current+=1
    set "iso_file=%%A"
    set "iso_name=%%~nA"

    set /a progress=99 * !current! / !total!
    set /a barCount=!progress! / 2
    set /a spaceCount=50 - !barCount!

    set "bar="
    set "spaces="
    for /L %%B in (1,1,!barCount!) do set "bar=!bar!█"
    for /L %%S in (1,1,!spaceCount!) do set "spaces=!spaces!░"

    echo:
    set "progressLine=[%ESC%[1;92m!bar!%ESC%[0m%ESC%[1;90m!spaces!%ESC%[0m] !progress!%% complete - Extracting \"%%A\""
    echo !progressLine!
    echo:
    set "extractLine=%ESC%[1;96m=== Extracting ISO !current!/!total!: \"%%A\" ===%ESC%[0m"
    echo !extractLine!
    echo:
    :: Run extract-xiso; uses xiso_cmd from line 8
    echo === Extracting ISO !current!/!total!: \"%%A\" === >> "!logfile!"
    set "cmd=!xiso_cmd! \"!subdir!\%%~nA\" \"%%A\""
    echo Running: !cmd! >> "!logfile!"

    :: Run extract-xiso with appropriate output handling
    set "tempfile=%TEMP%\extract-xiso-%current%.tmp"
    if !has_quiet! equ 0 (
        :: Quiet mode: redirect output to log file only
        !xiso_cmd! "!subdir!\%%~nA" "%%A" >> "!logfile!" 2>&1
    ) else (
        :: Non-quiet mode: real-time output to CMD and log via temp file
        !xiso_cmd! "!subdir!\%%~nA" "%%A" 2>&1 | powershell -Command "$input | Tee-Object -FilePath '!tempfile!' -Encoding UTF8"
        if exist "!tempfile!" (
            type "!tempfile!" >> "!logfile!" 2>nul
            del "!tempfile!" 2>nul
        )
    )

    if errorlevel 1 (
        echo %ESC%[1;91m[ERROR] extract-xiso failed for \"%%A\"%ESC%[0m
        echo [ERROR] extract-xiso failed for \"%%A\" >> "!logfile!"
        set /a errors+=1
    ) else (
        set /a success+=1
    )

    if /I "!choice!"=="Y" (
        echo %ESC%[1;91mDeleting: \"%%A\"%ESC%[0m
        del "%%A"
        if errorlevel 1 (
            echo [ERROR] Failed to delete \"%%A\" >> "!logfile!"
        ) else (
            echo Deleted source ISO: \"%%A\" >> "!logfile!"
        )
    )

    echo. >> "!logfile!"
)

::======================
::  Finished
::======================
echo:
echo %ESC%[1;92mBatch XISO extraction complete.%ESC%[0m
echo Extraction Summary:
echo Successfully extracted: !success!
echo Failed extractions: !errors!
echo:
echo Batch XISO extraction complete. >> "!logfile!"
echo End time: %date% %time% >> "!logfile!"
echo Extraction Summary: >> "!logfile!"
echo Successfully extracted: !success! >> "!logfile!"
echo Failed extractions: !errors! >> "!logfile!"
echo Done. >> "!logfile!"
pause
exit /b