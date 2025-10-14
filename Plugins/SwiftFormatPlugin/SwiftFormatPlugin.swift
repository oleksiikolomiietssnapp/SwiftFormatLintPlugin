// Copyright 2025 Oleksii Kolomiiets
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import PackagePlugin
#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin
#endif

/// A build tool plugin that runs swift-format linting on Swift source files.
/// Supports both Swift Package Manager and Xcode projects.
@main
struct SwiftFormatPlugin: BuildToolPlugin {
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
        let swiftformatConfig = packageDirectory.appending(path: ".swiftformat")
        let swiftFormatConfig = packageDirectory.appending(path: ".swift-format")

        // Prefer .swiftformat first
        if FileManager.default.fileExists(atPath: swiftformatConfig.path) {
            return swiftformatConfig
        }
        // Fall back to .swift-format
        if FileManager.default.fileExists(atPath: swiftFormatConfig.path) {
            return swiftFormatConfig
        }

        return nil
    }
}

#if canImport(XcodeProjectPlugin)
extension SwiftFormatPlugin: XcodeBuildToolPlugin {
    /// Entry point for Xcode project targets.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        // Get swift-format tool from the toolchain
        let swiftFormatTool = try context.tool(named: "swift-format")

        // Collect all Swift source files from the target
        let swiftSourceFiles = target.inputFiles
            .filter { $0.type == .source && $0.url.pathExtension == "swift" }
            .map { $0.url }

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
            Diagnostics.warning("No .swiftformat configuration found. Using default swift-format rules.")
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
