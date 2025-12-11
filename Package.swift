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
    dependencies: [
        // Networking
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.0"),
        
        // UI/UX
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        
        // Data Persistence
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.0.0"),
        
        // JSON Decoding
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
        
        // Logging
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.0"),
        
        // Async/Await Support
        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "MyVet",
            dependencies: [
                "Alamofire",
                "SnapKit",
                .product(name: "RealmSwift", package: "realm-swift"),
                "SwiftyJSON",
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "MyVetTests",
            dependencies: ["MyVet"],
            path: "Tests"
        ),
    ]
)
