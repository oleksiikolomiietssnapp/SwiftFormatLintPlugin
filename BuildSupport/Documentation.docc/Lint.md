# Lint

Automatically check code formatting during builds.

The Lint plugin automatically verifies code formatting during each build, ensuring your codebase maintains consistent style. When formatting violations are detected, the build reports them with file locations and line numbers. Available for both Swift Packages and Xcode projects.

## Setup

### Swift Packages

Add to `Package.swift`:

```swift
.package(url: "https://github.com/Snapp-Mobile/SwiftFormatLintPlugin.git", from: "1.0.4")
```

```swift
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

## How It Works

```swift
let process = Process()
process.executableURL = swiftFormatTool.url
process.arguments = [
    "lint",
    "--parallel",
    "--configuration", configPath,
    "--strict"
]
process.run()
```

## Troubleshooting

**"swift-format not found"**: Verify `swift --version` shows 6.0+

**Lint plugin ignores config**: Ensure `.swiftformat` is in correct location (package root or source folder), file is readable, and in Build Phases

**Build hangs**: Plugin has 5-minute timeout. Check disk space with `df -h`
