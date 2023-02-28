#!/bin/bash

# Initial announcement

echo "Pruning files."

sleep 1s

# Store current directory size (pre-prune)

unpruned="$(du -sh)"

# Define cache files
previews="Rendered - ********-****-****-****-************"
cfa="********-****-****-****-************+********-****-****-****-************ *****.cfa"
pek="********-****-****-****-************+********-****-****-****-************ *****.pek"

# Create array from tree command and grep search

readarray -t cachefiles < <(tree -fi | grep -e "$previews" -e "$cfa" -e "$pek")

# Delete all matching files

for file in "${cachefiles[@]}"; do
	rm "$file";
	echo "'$file' has been removed.";
done


#Closing announcement

echo "All files have been processed."
sleep 1s
echo "Old size was $unpruned"
sleep 1s
echo "New size is $(du -sh)"
