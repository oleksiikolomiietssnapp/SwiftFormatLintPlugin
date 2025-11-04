// Copyright (c) 2025 Snapp Mobile Germany GmbH
// SPDX-License-Identifier: MIT

import Foundation
import PackagePlugin
#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin
#endif

/// A build tool plugin that runs swift-format linting on Swift source files.
/// Supports both Swift Package Manager and Xcode projects.
@main
struct LintPlugin: BuildToolPlugin {
    /// This entry point is called when operating on a Swift package.
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        // Get swift-format tool from the toolchain
        let swiftFormatTool = try context.tool(named: "swift-format")

        // Collect all Swift source files from the target
        guard let sourceTarget = target.sourceModule else {
            return []
        }

        let swiftSourceFiles = sourceTarget.sourceFiles
            .filter { $0.type == .source && $0.url.pathExtension == "swift" }
            .map { $0.url }

        Diagnostics.remark("Linting \(swiftSourceFiles.count) Swift file(s)...")

        guard !swiftSourceFiles.isEmpty else {
            return []
        }

        // Look for configuration file (supports both .swiftformat and .swift-format)
        let configurationURL = findConfigurationFile(in: context.package.directoryURL)

        // Build arguments for swift-format lint
        var arguments = [
            "lint",
            "--parallel"  // Enable parallel processing for faster linting
        ]

        // Add configuration if it exists
        if let configurationURL {
            let configPath = configurationURL.path(percentEncoded: false)
            Diagnostics.remark("Using swift-format configuration at \(configPath)")
            arguments += ["--configuration", configPath]
        } else {
            Diagnostics.warning("No .swiftformat or .swift-format configuration found. Using default swift-format rules.")
        }

        // IMPORTANT: Use absolute paths to avoid path resolution issues with prebuildCommand
        arguments += swiftSourceFiles.map { url in
            // Resolve to absolute path
            url.path(percentEncoded: false)
        }

        return [
            .prebuildCommand(
                displayName: "Running SwiftFormat Lint",
                executable: swiftFormatTool.url,
                arguments: arguments,
                environment: [:],
                outputFilesDirectory: context.pluginWorkDirectoryURL
            )
        ]
    }

    /// Finds configuration file in package root.
    /// Supports both .swiftformat and .swift-format naming conventions.
    private func findConfigurationFile(in packageDirectory: URL) -> URL? {
        let fileManager = FileManager.default
        let swiftformatConfig = packageDirectory.appending(path: ".swiftformat")
        let swiftFormatConfig = packageDirectory.appending(path: ".swift-format")

        // Prefer .swiftformat first
        if fileManager.fileExists(atPath: swiftformatConfig.path) {
            return swiftformatConfig
        }
        // Fall back to .swift-format
        if fileManager.fileExists(atPath: swiftFormatConfig.path) {
            return swiftFormatConfig
        }

        return nil
    }
}

#if canImport(XcodeProjectPlugin)
extension LintPlugin: XcodeBuildToolPlugin {
    /// Entry point for Xcode project targets.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        // Get swift-format tool from the toolchain
        let swiftFormatTool = try context.tool(named: "swift-format")

        // Collect all Swift source files from the target
        let swiftSourceFiles = target.inputFiles
            .filter { $0.type == .source && $0.url.pathExtension == "swift" }
            .map { $0.url }

        Diagnostics.remark("Linting \(swiftSourceFiles.count) Swift file(s) in Xcode project...")

        guard !swiftSourceFiles.isEmpty else {
            return []
        }

        // Look for .swiftformat configuration
        let configurationURL = target.inputFiles
            .first(where: { $0.url.lastPathComponent == ".swiftformat" || $0.url.lastPathComponent == ".swift-format" })?.url

        // Build arguments for swift-format lint
        var arguments = [
            "lint",
            "--parallel"  // Enable parallel processing for faster linting
        ]

        // Add configuration if it exists
        if let configurationURL {
            let configPath = configurationURL.path(percentEncoded: false)
            Diagnostics.remark("Using swift-format configuration at \(configPath)")
            arguments += ["--configuration", configPath]
        } else {
            Diagnostics.warning("No .swiftformat or .swift-format configuration found. Using default swift-format rules.")
        }

        // Add all source file paths (absolute paths)
        arguments += swiftSourceFiles.map { url in
            url.path(percentEncoded: false)
        }

        return [
            .prebuildCommand(
                displayName: "Running SwiftFormat Lint",
                executable: swiftFormatTool.url,
                arguments: arguments,
                environment: [:],
                outputFilesDirectory: context.pluginWorkDirectoryURL
            )
        ]
    }
}
#endif
