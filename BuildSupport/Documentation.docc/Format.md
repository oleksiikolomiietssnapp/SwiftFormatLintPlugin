# Format

Format code on-demand with write permissions.

The Format plugin applies formatting rules directly to your source files. Available for Swift Packages only. Run it on-demand using Xcode's right-click menu or command line. For Xcode projects, format files directly from the terminal using swift-format.

## Swift Packages: GUI

Right-click project/target → Services → Format

Approve write permissions and select target (or all).

@Video(source: "format-demo.mov", poster: "format-demo-poster.png")

## Swift Packages: CLI

Format entire package:

```bash
swift package plugin --allow-writing-to-package-directory Format
```

Format specific target:

```bash
swift package plugin --allow-writing-to-package-directory Format MyTarget
```

## Xcode Projects: Terminal

```bash
swift-format --in-place --recursive --parallel \
  --configuration YourApp/.swiftformat YourApp/
```

## How It Works

```swift
let process = Process()
process.executableURL = swiftFormatTool.url
process.arguments = [
    "--in-place",
    "--recursive",
    "--parallel",
    "--configuration", configPath,
    targetPath
]
process.run()
// 5-minute timeout prevents hangs
```

## Troubleshooting

**"swift-format not found"**: Verify `swift --version` shows 6.0+

**Write permissions prompt**: Expected behavior. Use `--allow-writing-to-package-directory` flag to skip

**Process timeout**: Check disk space with `df -h`. Verify `.swiftformat` exists and is valid JSON
