// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TaskFocusApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TaskFocusApp",
            targets: ["TaskFocusApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "TaskFocusApp",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ]
        )
    ]
)
