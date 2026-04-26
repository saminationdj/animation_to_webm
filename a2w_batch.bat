::This bat file can be placed in the directory of the files that need processing.
::As long as the %batfile% is updated correctly, it should always work on all non-UNC paths.
@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION
SET "batfile=Path\To\animation_to_webm.bat"
SET filelist=_files_to_process.txt
SET filescount=0
SET file=1

:: Please only edit these line below
SET searchword=*
SET searchformat=.webp
DIR %folderparameter% /B %searchword%%searchformat% > %filelist%
SET filesonly=
SET foldersonly=
:: end of editable lines

IF DEFINED filesonly (
  SET "folderparameter=/A:-D"
) ELSE IF DEFINED foldersonly (
  SET "folderparameter=/A:D"
)

FOR /F "tokens=1,2* delims=," %%G in (%filelist%) DO (
  SET /a "filescount=filescount + 1"
)
ECHO %filescount% files to process.

FOR /F %%G in (%filelist%) DO (
  SET filetoprocess=%%~G
  SET filetoprocessx=%%~nG
  TITLE Processing file !file! of %filescount%
  ECHO Processing file %%~G ^(!file! of %filescount%^)
  IF EXIST "!filetoprocessx!.webm" (
    ECHO WARNING: File !filetoprocessx!.webm already exist. Doing nothing.
  ) ELSE (
    START "%%~G" /min /wait %batfile% "!filetoprocess!"
  )
  SET /a "file=file + 1"
)

DEL %filelist%

PAUSE

EXIT
