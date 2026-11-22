<div align="center">

# swift-editor-kit

**Building blocks for Swift code editors.**<br>
Swift packages for the parts of an editor that a language server keeps to itself.

[![CI](https://img.shields.io/github/actions/workflow/status/mozharovsky/swift-editor-kit/ci.yml?branch=main&label=CI&style=flat-square)](https://github.com/mozharovsky/swift-editor-kit/actions/workflows/ci.yml)
[![license](https://img.shields.io/badge/license-Apache%202.0-4c1?style=flat-square)](./LICENSE.txt)
[![swift](https://img.shields.io/badge/Swift-6.2%2B-555?style=flat-square)](#requirements)

[Quick start](#quick-start) · [Modules](#modules) · [Origin](#origin) · [Requirements](#requirements) · [License](#license)

</div>

## Overview

An editor that offers code completion has to decide which candidates match what you typed and in
which order they appear. sourcekit-lsp solves this in its CompletionScoring module, but the module
is internal to sourcekit-lsp and other packages cannot import it.

swift-editor-kit publishes such modules as ordinary Swift libraries with a public API. Each module
keeps the upstream code and its tests, with only the changes that a standalone package needs.

## Quick start

Add the package to your `Package.swift` and depend on the module you need.

```swift
dependencies: [
    .package(url: "https://github.com/mozharovsky/swift-editor-kit.git", from: "0.1.0"),
],
targets: [
    .target(
        name: "Editor",
        dependencies: [.product(name: "CompletionScoring", package: "swift-editor-kit")],
    ),
],
```

This example keeps the candidates that match `citie` and orders them best first.

```swift
import CompletionScoring

let names = ["cities", "citizens", "CInt(truncatingIfNeeded:)", "count"]
let batch = CandidateBatch(candidates: names, contentType: .codeCompletionSymbol)
let pattern = Pattern(text: "citie")
let matches = pattern.scoredMatches(across: [batch], precision: .fast).map { match in
    MatchCollator.Match(
        batchIndex: match.batchIndex, candidateIndex: match.candidateIndex, groupID: nil,
        score: CompletionScore(textComponent: match.textScore, semanticComponent: 1),
    )
}
let best = MatchCollator.selectBestMatches(
    for: pattern, from: matches, in: [batch], influencingTokenizedIdentifiers: [],
    orderingTiesBy: { $0.candidateIndex < $1.candidateIndex },
)
print(best.map { names[$0.candidateIndex] }) // ["cities"]
```

## Modules

- **CompletionScoring** scores completion candidates against a typed pattern. `Pattern` matches
  and scores candidate names, `CompletionScore` combines that text score with a semantic score,
  and `MatchCollator` culls weak matches and orders the rest. It comes from sourcekit-lsp.

## Origin

[NOTICE](./NOTICE) records the upstream project, tag, and commit of each module, and every change
made to it. A changed file also carries a notice below its license header.

A module moves to a newer upstream tag in a pull request of its own. The pull request replaces the
module's sources and tests with the new tag and applies the changes in NOTICE again.

## Requirements

- Swift 6.2 or later.
- macOS 14, iOS 17, or Linux.

## License

The package is licensed under the Apache License 2.0 with the Runtime Library Exception, the
license of the upstream code. See [LICENSE.txt](./LICENSE.txt) and [NOTICE](./NOTICE).
