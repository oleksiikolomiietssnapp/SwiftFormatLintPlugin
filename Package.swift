// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Copyright (c) 2025 Snapp Mobile Germany GmbH
// SPDX-License-Identifier: MIT

import PackageDescription

let package = Package(
    name: "SwiftFormatLintPlugin",
    products: [
        .plugin(
            name: "Lint",
            targets: ["SwiftFormatPlugin"]
        ),
        .plugin(
            name: "Format",
            targets: ["FormatPlugin"]
        )
    ],
    targets: [
        .target(
            name: "SwiftFormatLintPlugin",
            path: "BuildSupport"
        ),
        .plugin(
            name: "SwiftFormatPlugin",
            capability: .buildTool()
        ),
        .plugin(
            name: "FormatPlugin",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "Format Swift source files in place")
                ]
            )
        ),
    ]
)
