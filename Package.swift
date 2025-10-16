// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftFormatLintPlugin",
    products: [
        .plugin(
            name: "SwiftFormatPlugin",
            targets: ["SwiftFormatPlugin"]
        ),
        .plugin(
            name: "FormatPlugin",
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
