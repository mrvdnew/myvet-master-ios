// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MyVet",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "MyVet",
            targets: ["MyVet"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MyVet",
            dependencies: [],
            path: ".",
            exclude: [
                "README.md",
                ".git",
                ".gitignore",
                "Package.swift"
            ],
            sources: [
                "MyVetApp.swift",
                "Models",
                "Views",
                "ViewModels",
                "Networking",
                "Theme",
                "Utils"
            ]
        )
    ]
)
