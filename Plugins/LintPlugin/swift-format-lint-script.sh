#!/bin/bash

# Step 1: Locate the swift-format tool
# Use xcrun to locate the swift-format binary. If not found, exit with an error message.
linter=$(xcrun --find swift-format)
if [ -z "$linter" ]; then
    echo "error: swift-format not found. Please install it via Swift Package Manager or Homebrew." >&2
    exit 1
fi

# Step 2: Resolve paths
PACKAGE_DIRECTORY=$1
CONFIG_PATH=$2

# Validate the provided arguments
if [ -z "$PACKAGE_DIRECTORY" ] || [ -z "$CONFIG_PATH" ]; then
    echo "error: Missing arguments." >&2
    exit 1
fi

# Display the provided paths for verification
echo "PACKAGE_DIRECTORY: $PACKAGE_DIRECTORY"
echo "CONFIG_PATH: $CONFIG_PATH"

# Check if the configuration file exists
if [ ! -f "$CONFIG_PATH" ]; then
    echo "error: Config file not found at $CONFIG_PATH. Ensure you provide a valid .swiftformat configuration file." >&2
    exit 1
fi

# Check if the package directory exists
if [ ! -d "$PACKAGE_DIRECTORY" ]; then
    echo "error: Directory $PACKAGE_DIRECTORY does not exist. Verify the package structure." >&2
    exit 1
fi

# Step 3: Run swift-format lint
# Use swift-format to lint the package directory based on the configuration file.
echo "Linting directory: $PACKAGE_DIRECTORY"
output=$("$linter" lint --configuration "$CONFIG_PATH" -r "$PACKAGE_DIRECTORY" 2>&1)


# Step 4: Parse and format the output for Xcode compatibility
# Process each line of the output and format it for Xcode's error/warning display.
echo "$output" | while IFS= read -r line; do
    # Match lines in the format: [file]:[line]:[column]: [level]: [message]
    if [[ $line =~ ^([^:]+):([0-9]+):([0-9]+):\ (warning|error|note):\ (.+)$ ]]; then
        file="${BASH_REMATCH[1]}"
        line_number="${BASH_REMATCH[2]}"
        column_number="${BASH_REMATCH[3]}"
        level="${BASH_REMATCH[4]}"
        message="${BASH_REMATCH[5]}"

        # Print the formatted output for Xcode
        echo "$file:$line_number:$column_number: $level: $message"
    else
        # Handle unmatched lines
        echo "No match for line: $line" >&2
    fi
done
