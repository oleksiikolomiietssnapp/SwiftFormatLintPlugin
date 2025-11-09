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

The plugin folder structure reflects this naming:
```
Plugins/
├── LintPlugin/     (build tool - runs lint checks)
└── FormatPlugin/   (command plugin - manual formatting)
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
3. **Create `.swiftformat` configuration file** (see below for placement)

### `.swiftformat` File Placement

Place the `.swiftformat` configuration file in your **source folder** (where your Swift source files are), not at the project root or inside `.xcodeproj`:

```
MyApp/                          ← Project folder (NOT here)
├── MyApp.xcodeproj/
├── MyApp/                      ← Source folder - place .swiftformat HERE!
│   ├── .swiftformat            ← Configuration file
│   ├── ContentView.swift
│   ├── MyAppApp.swift
│   └── Assets.xcassets
└── MyAppTests/
    └── MyAppTests.swift
```

**Important:** For the Lint plugin to find the configuration:
1. Place `.swiftformat` in your source folder
2. Add it to your Xcode project in the file navigator (so Xcode tracks it)
3. The SDK will automatically discover it during the build process

## Configuration

Create a `.swiftformat` configuration file in your source folder for projects and package root for packages. See [swift-format documentation](https://github.com/apple/swift-format) for full options.

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

## Troubleshooting

### "swift-format not found" error

The plugin requires swift-format to be installed in your Swift toolchain.

**Solution:**
- Ensure you have a recent Swift version installed (6.0+)
- swift-format is included with Xcode
- Run `swift-format --version` to verify it's available

### Build hangs with Lint plugin

The Lint plugin has a 5-minute timeout to prevent indefinite hangs, but extremely slow disk I/O could cause delays.

**Solution:**
- Check if your disk is full: `df -h`
- Try building a smaller target first
- Disable other background processes consuming I/O

### Lint plugin not finding `.swiftformat` configuration

The Lint plugin can't locate your configuration file, so it uses swift-format defaults.

**Solution:**
- Verify `.swiftformat` is in your **source folder** (where your `.swift` files are), not at the project root or inside `.xcodeproj`
- Confirm the file is added to your Xcode project (visible in file navigator)
- For Xcode projects, the file must be explicitly added to the target in Build Phases
- Check file permissions: `ls -la .swiftformat` (should be readable)
- Build with verbose output to see if the plugin finds the config: `xcodebuild -verbose`

### "Configuration file not found" warning

This is normal if you don't have a `.swiftformat` configuration file. The plugin will use swift-format's default rules.

**Solution (optional):**
- Create `.swiftformat` in your source folder to customize rules
- See [swift-format documentation](https://github.com/apple/swift-format) for configuration options

### FormatPlugin fails with "Permission denied"

The Format plugin needs write permission to your source files.

**Solution:**
- Ensure your project files are writable: `ls -l Sources/`
- Approve the permission prompt when running the plugin
- Check disk permissions: `chmod u+w Sources/**/*.swift`

### No output from Lint plugin during build

This is normal behavior. The Lint plugin runs silently unless there are formatting issues.

**To verify it's running:**
- Build with verbose output: `swift build -v` or `xcodebuild -verbose`
- Look for "Running SwiftFormat Lint" in the output
- The plugin will show warnings if formatting issues are found

## License

MIT License - see [LICENSE](LICENSE) file.
