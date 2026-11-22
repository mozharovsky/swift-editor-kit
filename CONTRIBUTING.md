# Contributing to swift-editor-kit

Thank you for helping. This guide covers setup, the rules for upstream code, and how changes land.
[AGENTS.md](AGENTS.md) holds the full standards.

## Setup

You need Swift 6.2 or later. On macOS, select Xcode through `DEVELOPER_DIR` and leave the global
selection unchanged.

```sh
xcrun swift build --build-tests
xcrun swift test
```

On Linux, run the same commands without `xcrun`.

## Upstream code

Each module keeps the code of its upstream project. A change to an upstream file needs a reason
that the standalone package imposes, and [NOTICE](NOTICE) records it. Report a bug in the
scoring itself to the upstream project.

## Making a change

Keep each pull request to one concern. Commit subjects follow Conventional Commits in the form
`type(scope): summary`, and the body explains why the change is needed.

Every commit carries a `Signed-off-by` trailer. By signing off, you certify the
[Developer Certificate of Origin](https://developercertificate.org) for the commit. Use
`git commit -s` to add the trailer.

## License

By contributing, you agree that your contributions are licensed under the Apache License 2.0 with
the Runtime Library Exception in [LICENSE.txt](LICENSE.txt).
