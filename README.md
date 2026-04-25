# Image extractor and WebM encoder

## Help Section:


This Command bat file does various things, usually in tandem, such as:
   1. Extracts images from various sources, such as:
      Flash SWF, GIF, MP4 and WebP (as well as other WebM);
   2. Upscales the extracted images with Waifu2x or Realesgran;
   3. Converts created folder to *.webm with ffmpeg.

### Required software:
* ffmpeg for encoding video: https://www.ffmpeg.org/
* waifu2x if using 2x upscaling: https://github.com/YukihoAA/waifu2x_snowshell
* Real-ESRGAN if using 4x upscaling: https://github.com/xinntao/real-esrgan
* JPEXS Decompiler for ffdec/flash extractor: https://github.com/jindrapetrik/jpexs-decompiler
### Last tested versions:
* ffmpeg:      Build date 2017-11-23
* waifu2x:     Snowshell 2.6.1
* Real-ESRGAN: 0.2.5 2022-04-24
* ffdec:       21.1.0

### General Notes
* Make sure that the files created in any process (either within here or outside) are not in two-digit filenames with leading zeros. Because of a quirk in DOS, numbers with leading zero (00 to 09) will be read as Octal, and will cause the scripts to act up.
* Because of how DOS sorts files, PRE-RENAMING is needed if filenames contain no leading zeros (outside the above Octal). This means for example that 10.txt will come before 2.txt, 209.txt before 3.txt etc... Hence why the PRE-RENAMING is needed, as it adds the value 10000 to each file, making them start sort better, for example 10001, 10002, 10003, 10100 etc...

### Note when using Flash SWF:
When using FFDec to extract images, it is prefered that you do not skip the Pre-renaming step as mentioned above, as FFDec exports them in digits without leading zero. Also, using pause2.txt is recommended, as FFDec exports all images, so there may contain garbage images you do not want to be encoded as a frame in the video. Depending on how the images are stored, FFDec might export them as JPEG or PNG. To my knowledge, any video or animations are always JPEG, hence the need to use jpg.txt


### Tips for creating loops
After extraction and using pause2.txt, go into the created folder and move or remove any excess images you do not want in the looped video. If source file contains several loopable sections, create new folders for eacho seperate loop, and put those folders in the same folder as source. Then after you've encoded the first video, you can drag-n-drop the other folders into this bat-file to create seperate loops from the same video

### Create these text files for parameters:
* jpg.txt
  * Set sequence-format to JPG (primarely for flash extraction, default is PNG)
* prefix_*.txt
  * Adds anything after _ as a prefix to the outputed filename (prefix_filename.webm)
* suffix_*.txt
  * Adds anything after _ as a suffix to the outputed filename (filename_suffix.webm)<br/>
Both prefix and suffix work at the same time
* realreal.txt
  * x4 upscale using Normal settings (Anime settings are default)
* unpause1.txt
  * Script pauses by default after gathering parameters. This bypasses that pause.
* pause2.txt
  * Pause after extraction (automaticly skipped if input is a folder)
* pause3.txt
  * Pause after pre-renaming
* pause4.txt
  * Pause after upscaling
* pause5.txt
  * Pause after video creation
* skip2.txt
  * Skip extraction (automatic if input is a folder)
* skip3.txt
  * Skip renaming (filenames need to anything other than 2 digits that might have a leading zero)
* skip4.txt
  * Skip upscaling (just renames files to frame????.ext)
* skip5.txt
  * Skip video creation
* frame*.txt
  * Set framerate to whatever * is (Default is 8, max is 99)
* framefile.txt
  * Add framerate to the end of the processed file(s) in 2 digits.
* quality*.txt
  * Set video quality to whatever * is (Default is 18, max is 63)
* autoexit.txt
  * Exit when done (useful for batch processing)
* movefinished.txt
  * Move video to a seperate Done folder
* keepupscaled.txt
  * Keep the upscaled folder
* deleteoriginals.txt
  * Delete originals (not implemented yet)
* delete.txt
  * Delete only the created folder
* deletefilesource.txt
  * Delete only the source file
* deleteall.txt
  * Delete both source file as well as created folder

## Install Section:
1. Download and install/extract all the required software. At the moment only Real-ESRGAN is used.
2. Locate these lines and change them to their corresponding location:
   * `:: PROGRAM SETTINGS`
   * SET "pathtoffdec=C:\PathtoProgram.exe"
   * SET "pathtowaifu=C:\PathtoProgram.exe"
   * SET "pathtorealesg=C:\PathtoProgram.exe"
   * SET "pathtoffmpeg=C:\PathtoProgram.exe"
   * SET "pathtoimconvert=C:\PathtoProgram.exe"
   * SET "pathtolibwebp=C:\PathtoProgram.exe"  
Note: Keep the quotation marks.
3. Change any of the variables under the `:: SOME DEFAULT SETTINGS` section if you wish to change the default settings.

## Usage Section:
1. Create any of the text files listed above of the custom parameters based on the various criteras your files have. You can edit the .BAT file to suit your needs, but it would be best to keep animations with similar process-steps in their own folders and create the text-files that suits their needs.
2. Drag and drop the animation file you wish to process. This .BAT only works with one file at a time, so it will ignore any multiple selected files.

## Referals
* https://ss64.com/ for most of the Windows Batch commands.
* Various Stackoverflows that I'm sure I have browsed and forgot to save...
