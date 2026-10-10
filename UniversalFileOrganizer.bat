@echo off
setlocal EnableExtensions DisableDelayedExpansion
title Universal File Organizer

REM Organizes files directly inside the selected target folder.
REM Automatically detects existing custom category folders (e.g., Image, Photos, Pictures).

if not "%~1"=="" (set "TARGET=%~f1") else (set "TARGET=%CD%")
if not exist "%TARGET%\" (echo Target folder not found: "%TARGET%" & pause & exit /b 1)
pushd "%TARGET%" || (echo Cannot access target folder. & pause & exit /b 1)

echo Target folder: "%CD%"
echo Folders will be created ONLY when matching files exist.
echo Existing category folders (like Photos/Images) will be reused.
echo.
echo ===================================================
echo  Press 'Y' to Start Organizing, or 'N' to Cancel.
echo ===================================================

choice /M "Are you sure you want to continue" /C YN /N
if errorlevel 2 (
    echo.
    echo Operation cancelled by user.
    popd 
    timeout /t 3 >nul
    exit /b 0
)

REM --- Call subroutine to process categories ---
call :ProcessCategory "Images" "jpg jpeg jpe jfif png apng gif bmp dib tif tiff webp avif heic heif ico cur svg raw cr2 cr3 nef nrw arw srf sr2 dng raf orf rw2 pef psd ai eps" "Image Photos Pictures"
call :ProcessCategory "Videos" "mp4 m4v mkv mov avi wmv flv f4v webm mpg mpeg m2v ts mts m2ts vob ogv 3gp 3g2 rm rmvb divx dv" "Video Movies"
call :ProcessCategory "Audio" "mp3 wav aac m4a flac alac ogg oga opus wma aiff aif mid midi amr ac3 dts ape au caf" "Music Sounds"
call :ProcessCategory "Documents" "pdf doc docx odt rtf txt md markdown tex pages djvu epub mobi azw azw3 chm" "Document Docs"
call :ProcessCategory "Spreadsheets" "xls xlsx xlsm xlsb ods csv tsv numbers" "Spreadsheet"
call :ProcessCategory "Presentations" "ppt pptx pptm odp key" "Presentation"
call :ProcessCategory "Archives" "zip rar 7z tar gz tgz bz2 xz zst cab iso img wim dmg lz lzma lzh arj ace" "Archive Zip"
call :ProcessCategory "Code" "html htm css scss sass less js mjs cjs ts tsx jsx json xml yaml yml toml ini cfg conf env sql py pyw ipynb java class jar c cpp h hpp cs vb fs go rs php phtml rb swift kt kts dart lua pl pm r sh bash zsh bat cmd ps1 psd1 psm1 vbs reg" "Codes Source"
call :ProcessCategory "Executables" "exe msi msp msix appx appxbundle com scr dll sys ocx apk aab deb rpm appimage" "Apps Software"
call :ProcessCategory "Fonts" "ttf otf woff woff2 eot fon fnt" "Font"
call :ProcessCategory "3D_Design" "obj stl fbx blend glb gltf dae 3ds max ma mb skp step stp iges igs dwg dxf" "3D Models Design"
call :ProcessCategory "Disk_Images" "vhd vhdx vmdk vdi qcow2" "DiskImage ISOs"
call :ProcessCategory "Certificates_Keys" "pem crt cer der pfx p12 p7b p7c key pub asc gpg" "Certificates Keys"
call :ProcessCategory "Backups" "bak old backup bkp tmp temp dump sqlbak" "Backup"

echo.
echo ===================================================
echo  Done! Organization complete successfully.
echo ===================================================
popd
pause
exit /b 0

---------------------------------------------------------------------------
:ProcessCategory
REM %1 = Default Folder Name
REM %2 = Extensions List
REM %3 = Aliases (Alternative existing folder names)

set "DEST="
REM Check if default folder exists
if exist "%~1\" set "DEST=%~1"

REM Check if any alias folder exists (if default wasn't found)
if not defined DEST (
    for %%A in (%~3) do (
        if exist "%%A\" (
            set "DEST=%%A"
            goto :FoundFolder
        )
    )
)

:FoundFolder
REM If no folder exists yet, check if matching files exist before creating one
if not defined DEST (
    for %%E in (%~2) do (
        if exist "*.%%E" (
            set "DEST=%~1"
            md "%~1" >nul 2>&1
            goto :MoveFiles
        )
    )
) else (
    goto :MoveFiles
)
goto :EOF

:MoveFiles
for %%E in (%~2) do (
    for %%F in ("*.%%E") do (
        if exist "%%~fF" (
            if not exist "%DEST%\%%~nxF" (
                move "%%~fF" "%DEST%\" >nul
            )
        )
    )
)
goto :EOF