#!/bin/bash

# Create or clear the summary file
echo "# Summary of Requirements" > SUMMARY.md

# Find all requirements.md files, sort them, and append their content formatted into the summary
find . -name "requirements.md" | sort | while read file; do
    directory=$(dirname "$file")
    echo "## Requirements from $directory" >> SUMMARY.md
    echo "" >> SUMMARY.md
    # Ensure that all lines, including those that might end without a newline, are read
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue  # Skip empty lines
        echo "- $line" >> SUMMARY.md
    done < "$file"
    echo "" >> SUMMARY.md
done