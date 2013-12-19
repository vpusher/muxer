# Subtitle Muxer

## Overview

This tool make the subtitle merging into video file ridiculously easy.

It is widely based on the famous [MKVMerge](http://www.bunkus.org/videotools/mkvtoolnix/doc/mkvmerge.html) cli tool.

## Use

Mux a specific video file:

`$> mux <path_to_the_video_file>`

Mux all the video files contained in a directory :

`$> mux <path_to_directory>`

## File I/O

As input, this tool only takes **MATROSKA (.mkv)** video file at this time. The subtitles files to merge into the video file should be placed in the same directory. They also need to have the same filename with the specific extension by language: **.en.srt**, **.fr.srt**.

The output/merged file will be named like the video source file but with the **.VOST.mkv** extension.

**To know:**

* Video and subtitles source files are not modified.
* When processed, each subtitles files is re-encoded into UTF-8 to avoid display artifacts. The best pratice is to directly use UTF-8 encoded files.

## Example

```bash
$> ls
my_video_file.en.srt
my_video_file.fr.srt
my_video_file.mkv
$> mux my_video_file.mkv
[...]
$> ls
my_video_file.en.srt
my_video_file.fr.srt
my_video_file.mkv
my_video_file.VOST.mkv
```
