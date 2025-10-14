# SwiftFormatLintPlugin

A reusable Swift Package Manager plugin that integrates swift-format linting and formatting into your workflow.

## Features

- **Automatic Linting**: Runs swift-format lint checks before every build
- **Manual Formatting**: Format Swift files on-demand with the Format plugin
- **Parallel Processing**: Uses `--parallel` flag for faster performance
- **Dual Config Support**: Works with both `.swiftformat` and `.swift-format` files
- **Xcode Compatible**: Works with both SPM and Xcode projects
- **Better Diagnostics**: Shows which configuration file is being used
- **Zero Configuration**: Just add as a dependency and go

## Installation

Add this plugin as a dependency to your `Package.swift`:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "YourPackage",
    dependencies: [
        .package(url: "https://github.com/yourusername/SwiftFormatLintPlugin.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTarget",
            plugins: [
                .plugin(name: "SwiftFormatPlugin", package: "SwiftFormatLintPlugin")
            ]
        )
    ]
)
```

## Usage

### Lint Plugin (Automatic)

The lint plugin runs automatically before every build. Just add it to your target's plugins and it will check your code:

```swift
.target(
    name: "YourTarget",
    plugins: [
        .plugin(name: "SwiftFormatPlugin", package: "SwiftFormatLintPlugin")
    ]
)
```

### Format Plugin (Manual)

The format plugin can be run manually to auto-fix formatting issues:

```bash
# Format all targets
swift package plugin --allow-writing-to-package-directory FormatPlugin

# Format specific target(s)
swift package plugin --allow-writing-to-package-directory FormatPlugin YourTarget
```

**In Xcode:**
1. Right-click on your project or target
2. Select "FormatPlugin" from the plugins menu
3. Approve the permission to modify files

## Configuration

Create a `.swiftformat` or `.swift-format` configuration file in your package root. Example:

```json
{
  "version": 1,
  "lineLength": 120,
  "indentation": {
    "spaces": 4
  },
  "respectsExistingLineBreaks": true,
  "lineBreakBeforeControlFlowKeywords": false,
  "lineBreakBeforeEachArgument": false
}
```

## Requirements

- Swift 6.0 or later
- swift-format tool installed (included in Xcode or available via Swift toolchain)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

Copyright 2025 Oleksii Kolomiiets

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
