# archive.org stream downloader

Stream-only items in the archive are available on the website in 60-second segments.
This script parses the available metadata to create a single copy for research purposes.

## Requirements


Before you run it, open the script and set the `DEFAULT_OUTPUT` variable to your preferred path.

The script is compatible with items marked `Stream Only`.

Install the following dependencies:

* ffmpeg
* wget
* xidel

## Installation

Clone the repo and make the script executable (like `chmod +x`).

## Run the script

To run the script, just pass the fully qualified URL.
For example:

```
$ adl.sh https://archive.org/details/KTVU_20111013_050000_Ten_OClock_News
```

## Known issue

Depending on the video codec and the means of playback, the video may show a visual abberation.
This might be fixed by adjusting the `ffmpeg` options, or by encoding the clips before they're combined.
