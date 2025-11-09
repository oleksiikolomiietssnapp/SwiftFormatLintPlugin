# SwiftFormatLintPlugin

A Swift Package Manager plugin that integrates swift-format linting and formatting into your build pipeline.

## Overview

Two plugins for code formatting with **parallel processing** and **dual config support** (`.swiftformat` or `.swift-format`):

| Plugin | Type | Usage | Availability |
|--------|------|-------|---------------|
| **Lint** | Build tool | Auto-check at build time | Swift Packages & Xcode projects (Xcode 14+) |
| **Format** | Command | On-demand formatting | Swift Packages only |

## Quick Setup

### Swift Packages

Add to `Package.swift`:
```swift
.package(url: "https://github.com/Snapp-Mobile/SwiftFormatLintPlugin.git", from: "1.0.4"),

.target(
    name: "YourTarget",
    plugins: [.plugin(name: "Lint", package: "SwiftFormatLintPlugin")]
)
```

Then create `.swiftformat` in your package root:
```json
{
  "version": 1,
  "lineLength": 120,
  "indentation": {"spaces": 4},
  "respectsExistingLineBreaks": true
}
```

### Xcode Projects

1. File → Add Package Dependencies → Add SwiftFormatLintPlugin
2. Select target → Build Phases → Run Build Tool Plug-ins → "+" → Add "Lint"
3. Create `.swiftformat` in your **source folder** (where `.swift` files are):
   ```
   MyApp/                          ← NOT here
   ├── MyApp.xcodeproj/
   ├── MyApp/                      ← Place .swiftformat HERE
   │   ├── .swiftformat
   │   ├── ContentView.swift
   │   └── Assets.xcassets
   └── MyAppTests/
   ```
4. Add `.swiftformat` to your Xcode project (file navigator) and target (Build Phases)

## Running Format Plugin

The Format plugin formats code on-demand (Swift Packages only):

**Via Xcode GUI (packages only):**
- Right-click on project/target → Select "Format" → Approve permissions

**Via command line (packages):**
```bash
swift package plugin --allow-writing-to-package-directory Format
swift package plugin --allow-writing-to-package-directory Format YourTarget
```

**Note:** Format plugin is only available for Swift Packages. For Xcode projects, format directly from terminal:
```bash
swift-format --in-place --recursive --parallel --configuration YourApp/.swiftformat YourApp/
```

## Requirements

- Swift 6.0+
- swift-format tool (included in Xcode)
- Xcode 14+ (for Xcode project support)

## Troubleshooting

### "swift-format not found" error

Ensure you have Swift 6.0+ installed and run `swift-format --version` to verify it's available (included with Xcode).

### Lint plugin not finding `.swiftformat` configuration

The plugin uses swift-format's default rules if config is missing.

**Check:**
- `.swiftformat` is in the **correct location** (package root for packages, source folder for Xcode projects)
- File is added to your Xcode project (visible in file navigator)
- For Xcode projects, file must be in Build Phases
- File permissions are readable: `ls -la .swiftformat`

**Verify it's running:**
- Build with verbose output: `swift build -v` or `xcodebuild -verbose`
- Look for "Running SwiftFormat Lint" in output

### Build hangs or is slow

The Lint plugin has a 5-minute timeout. If slower:
- Check disk space: `df -h`
- Disable background processes consuming I/O
- Try building a smaller target first

## License

MIT License - see [LICENSE](LICENSE) file.
