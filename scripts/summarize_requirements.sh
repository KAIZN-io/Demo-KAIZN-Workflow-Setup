#!/bin/bash

# Create or clear the summary file
echo "# Summary of Requirements" > SUMMARY.md

# Fetch all commit messages into an array
commit_messages=()
while IFS= read -r line; do
    commit_messages+=("$line")
done < <(git log --pretty=format:%s)

# Find all requirements.md files, sort them, and append their content formatted into the summary
find . -name "requirements.md" | sort | while read file; do
    directory=$(dirname "$file")
    echo "## Requirements from $directory" >> SUMMARY.md
    echo "| Requirement ID | Description | Present in Git History |" >> SUMMARY.md
    echo "|----------------|-------------|-----------------------|" >> SUMMARY.md
    # Ensure that all lines, including those that might end without a newline, are read
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue  # Skip empty lines
        # Extract requirement ID
        req_id=$(echo "$line" | grep -o '\[.*\]')
        # Escape brackets for use in sed
        escaped_req_id=$(echo "$req_id" | sed 's/[][]/\\&/g')
        # Extract the description text
        description=$(echo "$line" | sed -e "s/^$escaped_req_id //")
        # Initialize a flag to false
        found="No"
        # Check if the requirement ID is present in any commit message
        for msg in "${commit_messages[@]}"; do
            if [[ "$msg" == *"$req_id"* ]]; then
                found="Yes"
                break
            fi
        done
        echo "| $req_id | $description | $found |" >> SUMMARY.md
    done < "$file"
    echo "" >> SUMMARY.md
done
