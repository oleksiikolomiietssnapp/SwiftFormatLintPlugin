# SwiftFormatLintPlugin

A Swift Package Manager plugin that integrates swift-format linting and formatting into your build pipeline.

## Plugins

Two complementary plugins for code formatting:

- **`Lint`**: Automatic build-time checks (build tool plugin)
- **`Format`**: On-demand code fixing (command plugin)

Both use swift-format with **parallel processing**, **dual config support** (`.swiftformat` or `.swift-format`), and work with **SPM & Xcode projects** (Xcode 14+).

## Installation

Add to your `Package.swift`:

```swift
.package(url: "https://github.com/Snapp-Mobile/SwiftFormatLintPlugin.git", from: "1.0.3")
```

Add the `Lint` plugin to your target to automatically check formatting during builds:

```swift
.target(
    name: "YourTarget",
    plugins: [
        .plugin(name: "Lint", package: "SwiftFormatLintPlugin")
    ]
)
```

## Manual Formatting (Optional)

The `Format` command plugin auto-fixes formatting issues on-demand:

```bash
# Format all targets
swift package plugin --allow-writing-to-package-directory Format

# Format specific target(s)
swift package plugin --allow-writing-to-package-directory Format YourTarget
```

**In Xcode:**
1. Right-click on your project or target
2. Select "Format" from the plugins menu
3. Approve the permission to modify files

## Xcode Projects

The `Lint` plugin works automatically in Swift packages. For Xcode projects (Xcode 14+):

1. File → Add Package Dependencies → Add SwiftFormatLintPlugin
2. Select target → Build Phases → Run Build Tool Plug-ins → "+" → Add "Lint"
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
