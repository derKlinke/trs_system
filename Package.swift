// swift-tools-version: 6.0
// swift-format-ignore-file

import PackageDescription

let package = Package(name: "trs_system",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(name: "trs_system",
                targets: ["trs_system"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "trs_system",
                resources: [
                    .process("sound/audio_files"),
                    .process("styles/fonts/custom_fonts"),
                ]),

        .testTarget(name: "trs_system-snapshot",
                    dependencies: ["trs_system"]),
    ])
