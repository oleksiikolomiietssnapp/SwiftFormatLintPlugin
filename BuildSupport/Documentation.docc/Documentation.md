# ``SwiftFormatLintPlugin``

Integrate swift-format linting and formatting into your build pipeline.

SwiftFormatLintPlugin provides two complementary plugins for automated code formatting. The Lint plugin enforces formatting rules automatically during builds, while the Format plugin applies formatting on-demand. Both support Swift Packages and Xcode projects, with parallel processing for performance and flexible configuration options:

| Plugin | Type | Usage | Availability |
|--------|------|-------|---------------|
| **Lint** | Build tool | Auto-check at build time | Swift Packages & Xcode projects |
| **Format** | Command | On-demand formatting | Swift Packages only |

Both plugins feature parallel processing and dual config support (`.swiftformat` or `.swift-format`).

## Requirements

- Swift 6.0+
- swift-format tool (included in Xcode)
- Xcode 14+ (for Xcode project support)

View the project on [GitHub](https://github.com/Snapp-Mobile/SwiftFormatLintPlugin).

## Topics

### Plugins

- <doc:Lint>
- <doc:Format>
