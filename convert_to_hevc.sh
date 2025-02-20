#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg is not installed. Please install it first."
    exit 1
fi

# Check if any arguments were provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 file1.mov [file2.mov ...]"
    echo "or: $0 *.mov"
    exit 1
fi

# Process each input file
for input_file in "$@"; do
    # Check if file exists and is a .mov file
    if [[ ! -f "$input_file" || "${input_file##*.}" != "mov" ]]; then
        echo "Skipping '$input_file' - not a .mov file or doesn't exist"
        continue
    }

    # Get the filename without extension
    filename=$(basename "$input_file" .mov)
    directory=$(dirname "$input_file")
    output_file="${directory}/${filename}.mp4"

    echo "Converting: $input_file -> $output_file"

    # Convert using FFmpeg
    # -c:v libx265: H.265/HEVC video codec
    # -preset medium: Balance between speed and compression
    # -crf 23: Constant Rate Factor (lower = better quality, larger file)
    # -c:a aac: AAC audio codec
    # -b:a 128k: Audio bitrate
    ffmpeg -i "$input_file" \
           -c:v libx265 \
           -preset medium \
           -crf 23 \
           -c:a aac \
           -b:a 128k \
           -y "$output_file" 2>/dev/null

    # Check if conversion was successful
    if [ $? -eq 0 ]; then
        echo "Conversion successful. Deleting source file: $input_file"
        rm "$input_file"
    else
        echo "Conversion failed for $input_file. Source file not deleted."
        # Remove failed output file if it exists
        [ -f "$output_file" ] && rm "$output_file"
    fi

    echo "----------------------------------------"
done

echo "Conversion process complete!"
