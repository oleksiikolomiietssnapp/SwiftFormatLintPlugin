# Changelog

## [1.0.5] - 2025-11-04

### Added
- Add CHANGELOG.md

## [1.0.4] - 2025-11-04

### Added
- Error handling for FormatPlugin process execution to prevent crashes
- 5-minute timeout mechanism to prevent indefinite hangs during operations
- File count diagnostics to LintPlugin showing number of Swift files being processed
- Separate diagnostic messages for SPM and Xcode builds
- Comprehensive troubleshooting section in README covering:
  - swift-format installation issues
  - Build hang solutions
  - Configuration file guidance
  - Permission troubleshooting
  - Verification steps

### Changed
- Standardized all logging to use Diagnostics API instead of print() calls
- Removed emoji from success messages for better CI/CD compatibility
- Enhanced error handling for FileManager operations in both plugins

### Fixed
- Process execution failures that could crash the build
- Indefinite hangs when swift-format gets stuck
- Configuration file access errors

## [1.0.3] - 2025-10-25

### Added
- Transfer to Snapp-Mobile organization as official repository
- Initial public release

## [1.0.2] - 2025-10-21

### Fixed
- Add minimal build target to satisfy SPM requirements

## [1.0.1] - 2025-10-17

### Changed
- Clarify Xcode project support requirements and setup steps
- Update README documentation

## [1.0.0] - 2025-10-14

### Added
- Initial implementation of SwiftFormatLintPlugin
- BuildToolPlugin for swift-format linting in Swift packages
- CommandPlugin for manual formatting
- Dual plugin support: Lint (build tool) and Format (command plugin)
- Parallel processing for faster operations
- Dual configuration support (.swiftformat and .swift-format)
- Support for both Swift Package Manager and Xcode projects
