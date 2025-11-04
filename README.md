# SwiftFormatLintPlugin

A reusable Swift Package Manager plugin that integrates swift-format linting and formatting into your workflow.

## Features

- **Automatic Linting**: Runs swift-format lint checks before every build
- **Manual Formatting**: Format Swift files on-demand with the Format plugin
- **Parallel Processing**: Uses `--parallel` flag for faster performance
- **Dual Config Support**: Works with both `.swiftformat` and `.swift-format` files
- **SPM & Xcode Project Support**: Works with Swift packages and Xcode projects (Xcode 14+)
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
        .package(url: "https://github.com/Snapp-Mobile/SwiftFormatLintPlugin.git", from: "1.0.3")
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

## Xcode Project Setup

The plugin supports Xcode projects via `XcodeBuildToolPlugin` (Xcode 14+), but requires additional manual setup:

1. **Add package dependency**: File → Add Package Dependencies → Add SwiftFormatLintPlugin

2. **Enable plugin for each target**:
   - Select target → Build Phases → Run Build Tool Plug-ins
   - Click "+" and add "SwiftFormatPlugin"

3. **Add config file to project**:
   - Create `.swiftformat` in your project directory
   - Add the file to Xcode project (not just filesystem) so the plugin can discover it

4. **Verify swift-format**: Run `swift-format --version` to confirm installation

**Note**: Unlike SPM packages (automatic), Xcode projects require explicit Build Phase configuration.

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
- Xcode 14 or later (for Xcode project support via XcodeBuildToolPlugin)

## License

MIT License - see [LICENSE](LICENSE) file.
