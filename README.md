# archive.org stream downloader

Stream-only items in the archive are available on the website in 60-second segments.
This script parses the available metadata to create a single copy for research purposes.

## Known issue

Depending on the video codec and the means of playback, the video may show a visual abberation.
This might be fixed by adjusting the `ffmpeg` options, or by encoding the clips before they're combined.
