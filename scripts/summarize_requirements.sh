#!/bin/bash

# Create or clear the summary file
echo "# Summary of Requirements" > SUMMARY.md

# Find all requirements.md files, sort them, and append their content formatted into the summary
find . -name "requirements.md" | sort | while read file; do
    directory=$(dirname "$file")
    echo "## Requirements from $directory" >> SUMMARY.md
    echo "| Requirement ID | Present in Git History |" >> SUMMARY.md
    echo "|----------------|------------------------|" >> SUMMARY.md
    # Ensure that all lines, including those that might end without a newline, are read
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue  # Skip empty lines
        # Extract requirement ID and escape special characters for regex use in git log
        req_id=$(echo "$line" | grep -o '\[.*\]')
        # Check if the requirement ID is present in the git commit history
        if git log --all --grep="$req_id" > /dev/null; then
            echo "| $line | Yes |" >> SUMMARY.md
        else
            echo "| $line | No |" >> SUMMARY.md
        fi
    done < "$file"
    echo "" >> SUMMARY.md
done
