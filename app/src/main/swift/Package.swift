// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "jniBridge",
    products:[
        .library(
            name: "jniBridge", 
            type: .dynamic, 
            targets:["jniBridge"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftJava/java_swift.git", from: "2.1.1"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "jniBridge", dependencies: ["java_swift", "SwiftProtobuf"], path: "Sources"),
    ],
    swiftLanguageVersions: [4]
)
