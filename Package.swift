// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-editor-kit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "CompletionScoring", targets: ["CompletionScoring"]),
    ],
    targets: [
        .target(name: "CCompletionScoring"),
        .target(name: "CompletionScoring", dependencies: ["CCompletionScoring"]),
        .target(
            name: "CompletionScoringTestSupport",
            dependencies: ["CompletionScoring"],
            resources: [.copy("INPUTS")],
        ),
        .testTarget(
            name: "CompletionScoringTests",
            dependencies: ["CompletionScoring", "CompletionScoringTestSupport"],
        ),
        .testTarget(
            name: "CompletionScoringPerfTests",
            dependencies: ["CompletionScoring", "CompletionScoringTestSupport"],
        ),
    ],
    swiftLanguageModes: [.v6],
)

for target in package.targets where target.type != .system {
    target.swiftSettings = [
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("ImmutableWeakCaptures"),
    ]
}
