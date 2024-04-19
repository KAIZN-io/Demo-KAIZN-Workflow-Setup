#!/bin/bash

# Create or clear the summary file
echo "# Summary of Requirements" > SUMMARY.md

# Find all requirements.md files and append their content formatted into the summary
find . -name "requirements.md" | while read file; do
    echo "## Requirements from $(dirname "$file")" >> SUMMARY.md
    echo "" >> SUMMARY.md
    cat "$file" | sed 's/\]\s/\]\n/g' >> SUMMARY.md  # Ensures each requirement starts on a new line
    echo "" >> SUMMARY.md
done
