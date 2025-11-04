// Copyright (c) 2025 Snapp Mobile Germany GmbH
// SPDX-License-Identifier: MIT

import Foundation
import PackagePlugin

/// A command plugin that formats Swift source files using swift-format.
/// This plugin can be run manually to auto-fix formatting issues.
@main
struct FormatPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        // Get swift-format tool from the toolchain
        let swiftFormatTool = try context.tool(named: "swift-format")

        // Look for configuration file (supports both .swiftformat and .swift-format)
        let configurationURL = findConfigurationFile(in: context.package.directoryURL)

        // Collect all targets or specific targets from arguments
        var targetsToFormat: [SourceModuleTarget] = []

        if arguments.isEmpty {
            // Format all targets if no arguments provided
            targetsToFormat = context.package.targets.compactMap { $0.sourceModule }
        } else {
            // Format specific targets mentioned in arguments
            for targetName in arguments {
                if let target = context.package.targets.first(where: { $0.name == targetName })?.sourceModule {
                    targetsToFormat.append(target)
                } else {
                    Diagnostics.warning("Target '\(targetName)' not found. Skipping.")
                }
            }
        }

        guard !targetsToFormat.isEmpty else {
            Diagnostics.error("No targets to format.")
            return
        }

        // Collect all Swift source files from targets
        var allSourceFiles: [URL] = []
        for target in targetsToFormat {
            let swiftFiles = target.sourceFiles
                .filter { $0.type == .source && $0.url.pathExtension == "swift" }
                .map { $0.url }
            allSourceFiles.append(contentsOf: swiftFiles)
        }

        guard !allSourceFiles.isEmpty else {
            Diagnostics.warning("No Swift files found to format.")
            return
        }

        // Build arguments for swift-format
        var formatArguments = [
            "format",
            "--in-place",  // Modify files in place
            "--parallel"   // Use parallel processing
        ]

        // Add configuration if it exists
        if let configurationURL {
            let configPath = configurationURL.path(percentEncoded: false)
            Diagnostics.remark("Using swift-format configuration at \(configPath)")
            formatArguments += ["--configuration", configPath]
        } else {
            Diagnostics.warning("No .swiftformat or .swift-format configuration found. Using default swift-format rules.")
        }

        // Add all source file paths
        formatArguments += allSourceFiles.map { $0.path(percentEncoded: false) }

        // Print what we're about to do
        print("Formatting \(allSourceFiles.count) Swift files in \(targetsToFormat.count) target(s)...")

        // Execute swift-format
        let process = Process()
        process.executableURL = swiftFormatTool.url
        process.arguments = formatArguments

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        // Handle output
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        if let output = String(data: outputData, encoding: .utf8), !output.isEmpty {
            print(output)
        }

        if let errorOutput = String(data: errorData, encoding: .utf8), !errorOutput.isEmpty {
            printError(errorOutput)
        }

        if process.terminationStatus == 0 {
            print("✅ Formatting completed successfully!")
        } else {
            Diagnostics.error("swift-format failed with exit code \(process.terminationStatus)")
        }
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

// Helper for printing to stderr
fileprivate func printError(_ message: String) {
    if let data = message.data(using: .utf8) {
        FileHandle.standardError.write(data)
    }
}
