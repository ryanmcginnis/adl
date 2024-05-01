#!/bin/bash
# archive.org stream downloader
# Downloads segmented video streams from archive.org and merges them into a single video file.

# Display help information
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    cat << EOF
Usage:
    $0 [URL] [OUTPUT_DIRECTORY]
Description:
    Downloads video streams from archive.org and merges them into a single video file.
EOF
    exit 0
fi

# Check for correct number of arguments and valid URL format
#if [ "$#" -eq 0 ] || ! [[ $# =~ ^https?://.*archive\\.org/ ]]; then
#    echo "Error: A valid URL starting with 'http://' or 'https://' and containing 'archive.org/' is required." >&2
#    exit 1
#fi

# Validate necessary commands are installed
check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: Required command '$1' is not installed or not in PATH." >&2
        return 1
    fi
}

check_dependency wget || exit 1
check_dependency xidel || exit 1
check_dependency ffmpeg || exit 1

# Set default output directory
DEFAULT_OUTPUT='/mnt/news/'
OUTPUT=''

if [ -d "$DEFAULT_OUTPUT" ]; then
    OUTPUT="$DEFAULT_OUTPUT"
elif [ -d "$2" ]; then
    OUTPUT="$2"
else
    echo 'Error: No output directory found.'
    exit 1
fi

echo "Output directory: $OUTPUT"

# Create a temporary folder
TEMPORARY=$(mktemp -d) && echo "Saving temporary files to $TEMPORARY"

# Get the list of segments for the URL provided
LINKS=$(xidel -s $1 -e "json(//input[@class='js-tv3-init']/@value)/(TV3.clipstream_clips)()")

# Verify URL and prepare filename
URL=$(echo $1 | awk -F 'details/' '{print $2}' | awk -F '/' '{print $1}')

if [ -z "$URL" ]; then
    echo "Error: URL was malformed after it was processed."
    exit 1
fi

# Download the segments to the temporary folder
if [ -n "$LINKS" ]; then
    COUNTER=0
    for i in $LINKS; do
        echo "Downloading $i"
        wget "$i" -O "$TEMPORARY"/"$URL"_"$COUNTER".mp4 || {
            echo "Download failed for $i" >&2
            exit 1
        }
        ((COUNTER++))
    done    
else
    echo "Error: Couldn't parse links."
    exit 1
fi

# Create a sequential list of the segments in the folder:
find "$TEMPORARY"/*.mp4 | sed 's:\\ :\\\\ :g' | sed 's/^/file /' > "$TEMPORARY"/segments.txt
sort --version-sort "$TEMPORARY"/segments.txt > "$TEMPORARY"/sorted.txt

echo "Merging segments..."
ffmpeg -f concat -safe 0 -i "$TEMPORARY"/sorted.txt -c copy "$OUTPUT/$URL".mp4 || {
    echo "Error during merge."
    exit 1
}

# Cleanup temporary files
echo "Removing temporary files in $TEMPORARY..."
rm -Rf "$TEMPORARY"
