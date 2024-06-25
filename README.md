# archive.org stream downloader

Stream-only items in the archive are available on the website in 60-second segments.
This script parses the available metadata to create a single copy for research purposes.

## Requirements

Before you run it, open the script and set the `DEFAULT_OUTPUT` variable to your preferred path. Alternatively, you can provide a destination at the command line. 

The script is compatible with items marked `Stream Only`.

Install the following dependencies:

* ffmpeg
* libssl
* wget
* [xidel](https://www.videlibri.de/xidel.html)

## Installation

Clone the repo and make the script executable (like `chmod +x`).

## Run the script

To run the script, just pass the fully qualified URL.
For example, if you have set a default output destination:

```
adl https://archive.org/details/KTVU_20111013_050000_Ten_OClock_News
```

To manually specify the output destination:

```
adl https://archive.org/details/KTVU_20111013_050000_Ten_OClock_News /OUTPUT_DIRECTORY/
```

## Known issue

Depending on the video codec and the means of playback, the video may show a visual aberration.
This might be fixed by adjusting the `ffmpeg` options, or by encoding the clips before they're combined.
