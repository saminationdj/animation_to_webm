# Image Sequence extractor and WebM encoder
## Help Section
This Command bat file does various things, usually in tandem, such as:
   1. Extracts images from various sources (preferbly short and loopable animations), such as:<br/>
      Flash SWF, GIF, MP4 and WebP (as well as other WebM);
   2. Upscales the extracted images with Waifu2x or Realesgran;
   3. Converts created folder to \*.webm with ffmpeg.
### Required software
* ffmpeg for encoding video: https://www.ffmpeg.org/
* waifu2x if using 2x upscaling: https://github.com/YukihoAA/waifu2x_snowshell
* Real-ESRGAN if using 4x upscaling: https://github.com/xinntao/real-esrgan
* JPEXS Decompiler for ffdec/flash extractor: https://github.com/jindrapetrik/jpexs-decompiler
* WebP Codec for webP anim_dump https://developers.google.com/speed/webp/download
* ImageMagick for GIF conversion https://imagemagick.org/
### Last tested versions
* ffmpeg:      Build date 2017-11-23
* waifu2x:     Snowshell 2.6.1
* Real-ESRGAN: 0.2.5 2022-04-24
* ffdec:       21.1.0
* LibWebP:      1.6.0
* ImageMagick: 6.8.8-9
### Notes on versions
* Although some programs tend to not change how their commandline works, I believe both ffmpeg and ImageMagick have a history of changing theirs. For best compatiblity with my scripts, try using the versions listed.
* This script is set to primarely use Real-ESRGAN, and I haven't tested the waifu2x one in over a year. If you wish to use waifu2x, you'll need to comment out the realesg one and uncomment the waifu2x one.
### General Notes
* Make sure that the files created in any process (either within here or outside) are not in two-digit filenames with leading zeros. Because of a quirk in DOS, numbers with leading zero (00 to 09) will be read as Octal, and will cause the scripts to act up.
* Because of how DOS sorts files, PRE-RENAMING is needed if filenames contain no leading zeros (outside the above Octal). This means for example that 10.txt will come before 2.txt, 209.txt before 3.txt etc... Hence why the PRE-RENAMING is needed, as it adds the value 10000 to each file, making them start sort better, for example 10001, 10002, 10003, 10100 etc...
### Note when using Flash SWF
* When using FFDec to extract images, it is prefered that you do not skip the Pre-renaming step as mentioned above, as FFDec exports them in digits without leading zero.
* Also, using `pause_2.txt` is recommended, as FFDec exports all images, so there may contain garbage images you do not want to be encoded as a frame in the video.
* Depending on how the images are stored, FFDec might export them as JPEG or PNG. To my knowledge, any video or animations are always JPEG, hence the need to use `jpg.txt`
### Tips for creating loops
* After extraction and using `pause_2.txt`, go into the created folder and move or remove any excess images you do not want in the looped video.
* If source file contains several loopable sections, create new folders for eacho seperate loop, and put those folders in the same folder as source.
* Then after you've encoded the first video, you can drag-n-drop the other folders into this bat-file to create seperate loops from the same video
### Create these text files for parameters
* jpg.txt
  * Set sequence-format to JPG (primarely for flash extraction). Default is PNG.
* prefix_\*.txt
  * Adds anything after _ as a prefix to the outputed filename (prefix_filename.webm).
* suffix_\*.txt
  * Adds anything after _ as a suffix to the outputed filename (filename_suffix.webm).<br/>
  Both prefix and suffix work at the same time.
* realreal.txt
  * x4 upscale using Normal settings. Default is Anime (very "smooth").
* unpause_1.txt
  * Script pauses by default after gathering parameters. This bypasses that pause.
* pause_2.txt
  * Pause after extraction (automaticly skipped if input is a folder).
* pause_3.txt
  * Pause after pre-renaming.
* pause_4.txt
  * Pause after upscaling.
* pause_5.txt
  * Pause after video creation.
* skip_2.txt / skip_extract.txt
  * Skip extraction (automatic if input is a folder).
* skip_3.txt / skip_rename.txt / skip_naming.txt
  * Skip renaming (filenames need to be anything other than 2 digits that might have a leading zero).
* skip_4.txt / skip_upscale.txt
  * Skip upscaling (just renames files to frame????.ext).
* skip_5.txt / skip_encode
  * Skip video creation.
* frame_\*.txt
  * Set framerate to whatever \* is (Default is 8, prefered max is 99).
* frame_file.txt
  * Add framerate to the end of the processed file(s) in 2 digits.<br/>
  Good for when you want to process multiple files in the same folder and don't want to constantly change the frame_\*.txt file.
* quality_\*.txt
  * Set libvpx video quality to whatever \* is (Default is 18, min is 4 and max is 63).
* autoexit.txt
  * Exit when done (useful for batch processing).
* movefinished.txt
  * Move video to a seperate Done folder.
* keepupscaled.txt
  * Keep the upscaled folder.
* deleteoriginals.txt
  * Delete originals (not implemented yet).
* delete.txt
  * Delete only the created folder.
* deletefilesource.txt
  * Delete only the source file.
* deleteall.txt
  * Delete both source file as well as created folder.

## Install Section:
1. Download and install/extract all the required software. At the moment only Real-ESRGAN is used.
2. Locate these lines and change them to their corresponding location:
   * `:: PROGRAM SETTINGS`
   * SET "pathtoffdec=Path\to\ffdec.bat"
   * SET "pathtowaifu=Path\to\waifu2x-*.exe"
   * SET "pathtorealesg=Path\to\realesrgan-*.exe"
   * SET "pathtoffmpeg=Path\to\ffmpeg.exe"
   * SET "pathtoimconvert=Path\to\convert.exe"
   * SET "pathtolibwebp=Path\to\anim_dump.exe"<br/>
   Note: Keep the quotation marks.<br/>
   Note: Some of these might come with different variations depending on your graphic card in use. Please pick the one that suits your hardware.

3. Change any of the variables under the `:: SOME DEFAULT SETTINGS` section if you wish to change the default settings.

## Usage Section:
1. Create any of the text files listed above of the custom parameters based on the various criteras your files have. You can edit the .BAT file to suit your needs, but it would be best to keep animations with similar process-steps in their own folders and create the text-files that suits their needs.
2. Drag and drop the animation file you wish to process. This .BAT only works with one file at a time, so it will ignore any multiple selected files.

## Referals
* https://ss64.com/ for most of the Windows Batch commands.
* Various Stackoverflows that I'm sure I have browsed and forgot to save...
