# SwiftFormatLintPlugin

A Swift Package Manager plugin that integrates swift-format linting and formatting into your build pipeline.

## Features

- **Automatic Linting**: Runs swift-format lint checks before every build
- **Manual Formatting**: Format Swift files on-demand via command plugin
- **Parallel Processing**: Uses `--parallel` flag for faster performance
- **Dual Config Support**: Works with both `.swiftformat` and `.swift-format` files
- **SPM & Xcode Support**: Works with Swift packages and Xcode projects (Xcode 14+)

## Installation

Add to your `Package.swift`:

```swift
.package(url: "https://github.com/Snapp-Mobile/SwiftFormatLintPlugin.git", from: "1.0.3")
```

Enable the lint plugin in your target:

```swift
.target(
    name: "YourTarget",
    plugins: [
        .plugin(name: "SwiftFormatPlugin", package: "SwiftFormatLintPlugin")
    ]
)
```

## Usage

### Format Plugin (Manual)

Run manually to auto-fix formatting issues:

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

## Xcode Projects

SPM plugins work automatically in Swift packages. For Xcode projects (Xcode 14+):

1. File → Add Package Dependencies → Add SwiftFormatLintPlugin
2. Select target → Build Phases → Run Build Tool Plug-ins → "+" → Add "SwiftFormatPlugin"
3. Create `.swiftformat` in your project root and add it to Xcode project (not just filesystem)

## Configuration

Create a `.swiftformat` configuration file in your package root. See [swift-format documentation](https://github.com/apple/swift-format) for full options.

Example:

```json
{
  "version": 1,
  "lineLength": 120,
  "indentation": {
    "spaces": 4
  },
  "respectsExistingLineBreaks": true
}
```

## Requirements

- Swift 6.0+
- swift-format tool (included in Xcode)
- Xcode 14+ (for Xcode project support)

## License

MIT License - see [LICENSE](LICENSE) file.
