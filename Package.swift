// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SwiftLintPlugin",
    platforms: [
        .macOS(.v13),
        .iOS(.v14),
        .watchOS(.v6),
        .tvOS(.v14)
    ],
    products: [
        .plugin(
            name: "SwiftLint",
            targets: ["SwiftLint"]
        ),
        .plugin(
            name: "SwiftLintFix",
            targets: ["SwiftLintFix"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.51.0/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "9fbfdf1c2a248469cfbe17a158c5fbf96ac1b606fbcfef4b800993e7accf43ae"
        ),
        .plugin(
            name: "SwiftLint",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),

            .plugin(
                name: "SwiftLintFix",
                capability: .command(
                    intent: .sourceCodeFormatting(),
                    permissions: [.writeToPackageDirectory(reason: "Fixes fixable lint issues")]
                ),
                dependencies: ["SwiftLintBinary"]
            ),
            .plugin(
                name: "SwiftLintCommand",
                capability: .command(
                    intent: .sourceCodeFormatting(),
                    permissions: [.writeToPackageDirectory(reason: "lint issues")]
                ),
                dependencies: ["SwiftLintBinary"]
            )
    ]
)
