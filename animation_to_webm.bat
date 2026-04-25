:: Converting a set of files to .webm
:: DO NOT PUT ANYTHING ELSE IN THE SAME FOLDER!!!!
:: To be used with extracted SWF files
::

@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION

TITLE Image extractor and WebM encoder
ECHO ^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*
ECHO ^*^*^*^*^*  Image extractor and WebM encoder  ^*^*^*^*^*
ECHO ^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*^*
ECHO:

SET inputcheck=%~1

IF NOT DEFINED inputcheck (
  ECHO:
  ECHO  ERROR: You did not input any file. Doing Nothing.
  ECHO:
  ECHO        Help Section:
  ECHO:
  ECHO:
  ECHO        This Command bat file does various things, usually in tandem, such as:
  ECHO     1. Extracts images from various sources, such as:
  ECHO        Flash SWF, GIF, MP4 and WebP ^(as well as other WebM^);
  ECHO     2. Upscales the extracted images with Waifu2x or Realesgran;
  ECHO     3. Converts created folder to *.webm with ffmpeg.
  ECHO:
  ECHO:
  ECHO  Required software:
  ECHO        ffmpeg for encoding video: https://www.ffmpeg.org/
  ECHO        waifu2x if using 2x upscaling: https://github.com/YukihoAA/waifu2x_snowshell
  ECHO        Real-ESRGAN if using 4x upscaling: https://github.com/xinntao/real-esrgan
  ECHO        JPEXS Decompiler for ffdec/flash extractor: https://github.com/jindrapetrik/jpexs-decompiler
  ECHO:
  ECHO  Last tested versions:
  ECHO        ffmpeg:      Build date 2017-11-23
  ECHO        waifu2x:     Snowshell 2.6.1
  ECHO        Real-ESRGAN: 0.2.5 2022-04-24
  ECHO        ffdec:       21.1.0
  ECHO:
  ECHO:
  ECHO  Press any button for further details or instructions & PAUSE > nul & ECHO: & ECHO:
  ECHO  NOTE: Make sure that the files created in any process ^(either within here or outside^)
  ECHO        are not in two-digit filenames with leading zeros. Because of a quirk in DOS,
  ECHO        numbers with leading zero ^(00 to 09^) will be read as Octal, and will cause
  ECHO        the scripts to act up.
  ECHO  NOTE: Because of how DOS sorts files, PRE-RENAMING is needed if filenames contain no
  ECHO        leading zeros ^(outside the above Octal^). This means for example that
  ECHO        10.txt will come before 2.txt, 209.txt before 3.txt etc...
  ECHO        Hence why the PRE-RENAMING is needed, as it adds the value 10000 to each file,
  ECHO        making them start sort better, for example 10001, 10002, 10003, 10100 etc...
  ECHO:
  ECHO:
  ECHO  Note when using Flash SWF:
  ECHO        When using FFDec to extract images, it is prefered that you do not skip the
  ECHO        Pre-renaming step as mentioned above, as FFDec exports them in digits without
  ECHO        leading zero. Also, using pause2.txt is recommended, as FFDec exports all images,
  ECHO        so there may contain garbage images you do not want to be encoded as a frame
  ECHO        in the video. Depending on how the images are stored, FFDec might export them
  ECHO        as JPEG or PNG. To my knowledge, any video or animations are always JPEG, hence
  ECHO        the need to use jpg.txt
  ECHO:
  ECHO:
  ECHO  Tips for creating loops.
  ECHO        After extraction and using pause2.txt, go into the created folder and move or
  ECHO        remove any excess images you do not want in the looped video. If source file
  ECHO        contains several loopable sections, create new folders for eacho seperate loop,
  ECHO        and put those folders in the same folder as source. Then after you've encoded
  ECHO        the first video, you can drag-n-drop the other folders into this bat-file to
  ECHO        create seperate loops from the same video.
  ECHO:
  ECHO:
  ECHO  Press any button for final set of details or instructions & PAUSE > nul & ECHO: & ECHO:
  ECHO  Create these text files for parameters:
  ECHO     jpg.txt               Set sequence-format to JPG ^(primarely for flash extraction, default is PNG^)
  ECHO     prefix_^*.txt          Adds anything after _ as a prefix to the outputed filename ^(prefix_filename.webm^)
  ECHO     suffix_^*.txt          Adds anything after _ as a suffix to the outputed filename ^(filename_suffix.webm^)
  ECHO                           Both prefix and suffix work at the same time
  ECHO     realreal.txt          x4 upscale using Normal settings ^(Anime settings are default^)
  ECHO     unpause1.txt          Script pauses by default after gathering parameters. This bypasses that pause.
  ECHO     pause2.txt            Pause after extraction ^(automaticly skipped if input is a folder^)
  ECHO     pause3.txt            Pause after pre-renaming
  ECHO     pause4.txt            Pause after upscaling
  ECHO     pause5.txt            Pause after video creation
  ECHO     skip2.txt             Skip extraction ^(automatic if input is a folder^)
  ECHO     skip3.txt             Skip renaming ^(filenames need to anything other than 2 digits that might have a leading zero^)
  ECHO     skip4.txt             Skip upscaling ^(just renames files to frame^?^?^?^?.ext^)
  ECHO     skip5.txt             Skip video creation
  ECHO     frame^*.txt            Set framerate to whatever ^* is ^(Default is 8, max is 99^)
  ECHO     framefile.txt         Add framerate to the end of the processed file^(s^) in 2 digits.
  ECHO     quality^*.txt          Set video quality to whatever ^* is ^(Default is 18, max is 63^)
  ECHO     autoexit.txt          Exit when done ^(useful for batch processing^)
  ECHO     movefinished.txt      Move video to a seperate Done folder
  ECHO     keepupscaled.txt      Keep the upscaled folder
  ECHO     deleteoriginals.txt   Delete originals ^(not implemented yet^)
  ECHO     delete.txt            Delete only the created folder
  ECHO     deletefilesource.txt  Delete only the source file
  ECHO     deleteall.txt         Delete both source file as well as created folder
  ECHO:
  ECHO  Press any button to exit
  PAUSE > nul
  EXIT
 )



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Pre processing / gathering parameters
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: PROGRAM SETTINGS
SET "pathtoffdec=C:\PathtoProgram.exe"
SET "pathtowaifu=C:\PathtoProgram.exe"
SET "pathtorealesg=C:\PathtoProgram.exe"
SET "pathtoffmpeg=C:\PathtoProgram.exe"
SET "pathtoimconvert=C:\PathtoProgram.exe"
SET "pathtolibwebp=C:\PathtoProgram.exe"

:: SOME DEFAULT SETTINGS
SET fps=8
SET searchformat=.png
SET realanime=realesrgan-x4plus-anime -s 4 -v
SET realreal=realesrgan-x4plus -s 4 -v
SET realesgsetting=%realanime%
SET crf=18
:: lower = better quality. Recommended is around 18-22 to keep size somewhat down.

:: MANUAL SWITCHES
:: Remove value to disable
SET deleteme=
SET originalscopied=
SET deletefilesource=
SET skip2=
SET skip3=
SET skip4=
SET pause1=
SET pause2=
SET pause3=
SET pause4=
SET pause5=
SET autoexit=
SET keepupscaled=
SET deloriginals=
SET movenew=

:: FILE-BASED SWITCHES
IF EXIST "unpause1.txt" SET unpause1=1
IF EXIST "pause2.txt" SET pause2=1
IF EXIST "pause3.txt" SET pause3=1
IF EXIST "pause4.txt" SET pause4=1
IF EXIST "pause5.txt" SET pause5=1
IF EXIST "skip2.txt" SET skip2=1
IF EXIST "skip3.txt" SET skip3=1
IF EXIST "skip4.txt" SET skip4=1
IF EXIST "skip5.txt" SET skip5=1
IF EXIST "skipextract.txt" SET skip2=1
IF EXIST "skipnaming.txt" SET skip3=1
IF EXIST "skipupscale.txt" SET skip4=1
IF EXIST "skipencode.txt" SET skip5=1
IF EXIST "frame*.txt" (
    IF NOT EXIST "framefile.txt" (
      FOR %%G in (frame*.txt) DO ( SET "frame=%%G" ) & SET "fps=!frame:~5,-4!" 
    )
)
IF EXIST "quality*.txt" (
  FOR %%G in (quality*.txt) DO ( SET "quality=%%G" ) & SET "crf=!quality:~7,-4!"
)
IF EXIST "autoexit.txt" SET autoexit=1
IF EXIST "movefinished.txt" SET movenew=1
IF EXIST "keepupscaled.txt" SET keepupscaled=1
IF EXIST "deleteoriginals.txt" SET deloriginals=1
IF EXIST "deletefilesource.txt" SET deletefilesource=1
IF EXIST "realreal.txt" SET realesgsetting=%realreal%
IF EXIST "suffix_*.txt" ( FOR %%G in (suffix_*.txt) DO ( SET "suffix_=%%G" ) & SET "suffix=_!suffix_:~7,-4!" )
IF EXIST "prefix_*.txt" ( FOR %%G in (prefix_*.txt) DO ( SET "prefix_=%%G" ) & SET "prefix=!prefix_:~7,-4!_" )
IF EXIST "jpg.txt" SET searchformat=.jpg

:: IMPORTANT VARIABLES
:: Try not to edit these
SET file=%~1
SET fileonly=%~nx1
SET fileext=%~x1
SET folder=%~n1
SET folderpath=%~dp1
SET newname=%prefix%%folder%%suffix%.webm
SET search=frame%%04d%searchformat%
SET filescount=0
SET currentfile=1

:: EXTRA CHECKS
IF EXIST "framefile.txt" ( ECHO: & ECHO Getting FPS from filename & SET fps=%folder:~-2% )

TITLE %fileonly%, Starting
ECHO:
ECHO Parameters:
ECHO Source file/folder: %file%
ECHO Folderpath only:    %folderpath%
ECHO Filename only:      %fileonly%
ECHO Output folder:      %folder%
ECHO Encoding criteria:  %search%
ECHO Output framerate:   %fps%
ECHO Output quality:     %crf%
ECHO Output prefix:      %prefix%
ECHO Output suffix:      %suffix%
ECHO Output file:        %newname%
ECHO:
ECHO Path to executables
SET pathto
ECHO:
ECHO Realesgran settings: %realesgsetting%
ECHO:
IF EXIST "delete.txt" ( ECHO Delete file exist. Folder will be deleted after process & SET deleteme=1 )
IF EXIST "deletefilesource.txt" ( ECHO Delete source file exist. Source file will be deleted after process )
IF EXIST "deleteall.txt" ( ECHO Deleteall file exist. Folder and source files will be deleted after process & SET deleteme=2 )
IF EXIST "%folder%_processing.txt" ( ECHO File or Folder are already being processed. Doing nothing & PAUSE & GOTO :SKIPALL )

ECHO:
IF DEFINED skip2 ECHO Skipping Extraction
IF DEFINED skip3 ECHO Skipping Pre-renaming
IF DEFINED skip4 ECHO Skipping Upscaling
IF DEFINED skip5 ECHO Skipping Encoding

IF NOT DEFINED unpause1 ( ECHO: & ECHO Pre-settings done & PAUSE )

ECHO Processing %folder% > %folder%_processing.txt



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Extraction process
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TITLE %fileonly%, Extracting
ECHO:
IF DEFINED skip2 ( ECHO Skipping extraction & GOTO :SKIPEXT )
IF /I "%fileonly%" == "%folder%" (
  ECHO Folder "%folder%" already exists. No extra files extracted
  GOTO :SKIPEXT
) ELSE IF /I "%fileext%" == ".swf" (
  ECHO %time% Step 2: Extracting images from Flash file
  :: CALL "%pathtoffdec%" -format image:png -export image "%folderpath%\%folder%" "%file%"
  CALL "%pathtoffdec%" -export image "%folderpath%\%folder%" "%file%"
) ELSE IF /I "%fileext%" == ".gif" (
  ECHO %time% Step 2: Extracting frames from GIF file
  ECHO Pre-renaming will be automatically skipped. & SET skip3=1
  MD "%folder%"
  "%pathtoimconvert%" "%file%" -coalesce "%folder%\%%04d.png"
) ELSE IF /I "%fileext%" == ".mp4" (
  ECHO %time% Step 2: Extracting frames from MP4
  ECHO Pre-renaming will be automatically skipped. & SET skip3=1
  MD "%folder%"
  "%pathtoffmpeg%" -v error -i "%file%" -qscale 0 "%folder%\%%04d.png"
) ELSE IF /I "%fileext%" == ".webm" (
  ECHO %time% Step 2: Extracting frames from already existing WebM. & ECHO Remember to rename the file before typing y when encoding if you wish to keep it.
  ECHO Pre-renaming will be automatically skipped. & SET skip3=1
  MD "%folder%"
  "%pathtoffmpeg%" -v error -i "%file%" -qscale 0 "%folder%\%%04d.png"
) ELSE IF /I "%fileext%" == ".webp" (
  ECHO %time% Step 2: Extracting frames from a WebP
  ECHO Pre-renaming will be automatically skipped. & SET skip3=1
  MD "%folder%"
  "%pathtolibwebp%" -prefix "" -folder "%folder%" "%file%"
) ELSE (
  ECHO Input is not of an acceptable format. Doing nothing.
  DEL "%folder%_processing.txt"
  PAUSE
  EXIT
)
IF DEFINED pause2 ( TITLE Extraction done: %fileonly% & PAUSE )
:SKIPEXT



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Pre-naming process
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TITLE %fileonly%, Pre-naming
ECHO:
ECHO %time% Step 3: Listing files that are in the folder
CD %folder%
DIR /B *%searchformat% > files.txt

:: Count the number of files to process
FOR /F "tokens=1,2* delims=," %%G in (files.txt) DO (
  IF /I "%%~xG" == "%searchformat%" (
    SET /a "filescount=filescount + 1"
  )
)
ECHO !filescount! files to process.

ECHO:
ECHO Pre-naming files to numbers
IF DEFINED skip3 ( ECHO Skipping pre-naming enirely. & ECHO As DOS does not read files in natural order ^(2 before 10 etc^), make sure that the file order works. & GOTO :SKIPREN )
MD Original
FOR /F %%G in (files.txt) DO (
  IF /I "%%~xG" == "%searchformat%" (
    SET /a newname2="%%~nG"
    SET /a "newname2=newname2 + 10000"
    ::ECHO renaming %%~nG%%~xG to prenaming!newname2:~1,4!%%~xG
    COPY %%~nG%%~xG Original\%%~nG%%~xG > nul
    REN %%~nG%%~xG prenaming!newname2:~1,4!%%~xG > nul
  )
)
ECHO Updating filelist
DIR /B *%searchformat% > files.txt
SET originalscopied=1

ECHO Done pre-naming files
:SKIPREN
IF DEFINED pause3 ( TITLE Pre-renaming done: %fileonly% & PAUSE )



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Upscaling process
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TITLE %fileonly%, Upscaling
ECHO:
ECHO %time% Step 4: Upscaling files
IF DEFINED skip4 ( ECHO Skipping upscale, will just rename. )
IF NOT DEFINED originalscopied MD Original
SET /a newname3="10001"
FOR /F %%G in (files.txt) DO (
  IF /I "%%~xG" == "%searchformat%" (
    IF DEFINED skip4 (
      ::ECHO Renaming %%~nG%%~xG to frame!newname3:~1,4!%%~xG
      COPY %%~nG%%~xG Original\%%~nG%%~xG > nul
      REN %%~nG%%~xG frame!newname3:~1,4!%%~xG > nul
      SET /a "newname3=newname3 + 1"
    ) ELSE IF EXIST "Upscaled\frame0001%searchformat%" (
      IF DEFINED keepupscaled (
        ECHO Upscaled already exists, so no need to upscale again.
        SET search=Upscaled\frame%%04d%searchformat%
        GOTO :SKIPREN2
      )
    ) ELSE (
      TITLE Upscaling !currentfile! of !filescount! ^(%fileonly%^)
      SET /a "currentfile=currentfile + 1"
      START "" /B /WAIT "%pathtorealesg%" -i "%%~nG%%~xG" -o "frame!newname3:~1,4!%%~xG" -n %realesgsetting%
      IF NOT DEFINED originalscopied MOVE %%~nG%%~xG Original\%%~nG%%~xG
      IF DEFINED originalscopied DEL %%~nG%%~xG
      SET /a "newname3=newname3 + 1"
    )
  )
)
:SKIPREN2
IF DEFINED pause4 ( TITLE Upscaling done: %fileonly% & PAUSE )



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Encoding process
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TITLE %fileonly%, Encoding
ECHO:
ECHO %time% Step 5: Converting files to video
IF DEFINED skip5 ( ECHO Skipping video encoding & GOTO :SKIPENC )
START "" /B /WAIT "%pathtoffmpeg%" -f image2 -framerate %fps% -i "%search%" -pix_fmt yuv420p -c:v libvpx -crf %crf% -b:v 10M "..\%newname%"
::-vf "scale=iw/2:ih/2"
:SKIPENC

TITLE %fileonly%, Moving
MD Upscaled
MOVE *%searchformat% "Upscaled" > nul
MOVE Original\*%searchformat% "" > nul
RD Original
IF NOT DEFINED keepupscaled RD /S /Q Upscaled



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Post process
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TITLE %fileonly%, Deleting
ECHO:
ECHO Note: If you press any button from now on instead of just shutting down the command prompt, the folder and it's contents will be moved to Recycle Bin. So please verify that the output file works.

DEL files.txt
CD ..
DEL %folder%_processing.txt

IF DEFINED pause5 ( TITLE %fileonly% done & PAUSE )

IF DEFINED deleteme RD /S /Q "%folder%"
IF "%deleteme%" == "2" (
  DEL %folder%.mp4
  DEL %folder%.swf
  DEL %folder%.gif
  DEL %folder%.webp
)
IF DEFINED deletefilesource (
  DEL %folder%.mp4
  DEL %folder%.swf
  DEL %folder%.gif
  DEL %folder%.webp
)

IF DEFINED movenew (
  IF NOT EXIST Done MD Done
  MOVE %newname% Done\
)

:SKIPALL

IF DEFINED autoexit EXIT
