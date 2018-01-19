// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(macOS)
let fuseLibVersion = Version(1, 0, 0)
let fuseLibUrl = "https://github.com/botov/COSXFUSE"
#elseif os(Linux)
let fuseLibVersion = Version(1, 0, 0)
let fuseLibUrl = "https://github.com/botov/CLINUXFUSE"
#else
fatalError("Unsupported OS")
#endif

let package = Package(
	name: "HelloWorldWFS",
	dependencies: [.package(url: fuseLibUrl, from: fuseLibVersion)],
    targets: [
        .target(
            name: "HelloWorldFS"
        )
    ]
)
