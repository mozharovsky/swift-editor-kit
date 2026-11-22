# swift-editor-kit agent instructions

This file is the single source of instructions for people and coding agents who change the
repository. `CLAUDE.md` contains only `@AGENTS.md`, which Claude Code resolves as an import.

## Project map

The root Swift package publishes each module as a library product. A module keeps the layout of
its upstream project, so its sources, C shims, test support, and tests sit in directories of their
upstream names under `Sources` and `Tests`.

- `CompletionScoring` scores completion candidates. `CCompletionScoring` holds its C helper,
  `CompletionScoringTestSupport` holds the helpers of its tests, and `CompletionScoringTests` and
  `CompletionScoringPerfTests` hold its XCTest suites.

## Upstream code

[NOTICE](NOTICE) records the upstream project, tag, and commit of each module and lists every
change made to the upstream code. Keep the upstream code as close to its tag as the package
allows, so that a later tag applies without conflicts.

- Change upstream files only when the package cannot build or test without the change. Access
  levels, Sendable conformances that public access requires, and imports of modules that the
  package does not have are such changes. A fix or a feature belongs upstream.
- Every changed upstream file carries the line
  `// Modified from the sourcekit-lsp original. See NOTICE for the changes.` below its license
  header. NOTICE describes the change in the same pull request.
- Keep the upstream formatting. The repository runs no formatter or linter over upstream files.
- Public access covers the module's own types, protocols, and their members. Extensions of
  standard library types keep package access, so they stay out of the files that import the
  module.
- A move to a newer upstream tag replaces the module's directories with the tag's files, applies
  the changes in NOTICE again, and updates the tag and commit in NOTICE. It lands in a pull
  request of its own.

A new module arrives in its own pull request. It brings its upstream tests, adds its entries to
NOTICE, the project map, and the README, and keeps the license of its upstream project
compatible with Apache 2.0.

## Toolchain

The package builds with Swift 6.2 or later in the Swift 6 language mode. On macOS, select Xcode
for each command with `DEVELOPER_DIR` and invoke Swift through `xcrun swift`. Bare `swift` can
resolve another installed toolchain. Never change the machine's global Xcode selection.

## Checks

Run these checks before every commit.

```sh
xcrun swift build --build-tests
xcrun swift test
```

The GitHub workflow runs the same build and tests on macOS and on Linux, and it checks that every
commit of a pull request carries a sign-off.

## Swift standards

Code that the repository writes itself, such as `Package.swift` and test support that replaces a
missing upstream module, follows these rules. Use the Swift 6 language mode with complete
concurrency checking. Do not force unwrap, force cast, use `try!`, or declare an implicitly
unwrapped optional. Write an access modifier only when it changes Swift's default, and never write
`internal`.

## Dependencies

The package has no dependencies. A dependency arrives in its own pull request, which states why
the package needs it and which module uses it.

## Prose

Write plain prose for a busy reader. Use short declarative sentences with one idea each. Use
paragraphs by default and lists only for content that is a list. Avoid em dashes, semicolons,
filler, rhetorical questions, and exclamation marks. Documentation describes current behavior.

The README is the project's landing page. It says what the package is for and gives a quick start,
the modules, the origin of the code, the requirements, and the license.

## Commits and pull requests

Commit subjects follow `type(scope): summary` with an optional scope. Types are `feat`, `fix`,
`docs`, `refactor`, `test`, `perf`, `ci`, `build`, and `chore`. Scopes are module names in
lower case, such as `completion-scoring`, and `docs` and `ci`. Subjects stay under 72 characters.
Bodies explain why.

Every non-merge commit carries a `Signed-off-by` trailer for the Developer Certificate of Origin.
Use `git commit -s`.

Every change reaches `main` through a pull request. Pull request descriptions follow
`.github/PULL_REQUEST_TEMPLATE.md`. They state the change, the checks that ran with their
results, the checks that did not run, and the known limitations.

A release is a semantic version tag on `main`, such as `0.1.0`.

## Never do

- Never change upstream code for a reason that NOTICE does not record.
- Never commit anything under `.build` or `.cache`.
- Never add telemetry or analytics.
