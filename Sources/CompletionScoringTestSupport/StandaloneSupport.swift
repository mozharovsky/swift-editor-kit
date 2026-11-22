//===----------------------------------------------------------------------===//
//
// This source file is part of swift-completion-scoring.
//
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// The upstream test support takes these helpers from other sourcekit-lsp
// modules. This file replaces them so that the package builds on its own.
//
//===----------------------------------------------------------------------===//

import Foundation

/// A Boolean that several threads read and write under a lock.
final class AtomicBool: @unchecked Sendable {
  private let lock = NSLock()
  private var storage: Bool

  init(initialValue: Bool) {
    storage = initialValue
  }

  var value: Bool {
    get { lock.withLock { storage } }
    set { lock.withLock { storage = newValue } }
  }
}

extension FileManager {
  /// Creates a file at a URL and throws when the file cannot be created.
  func createFile(at url: URL, contents data: Data?) throws {
    guard createFile(atPath: url.path, contents: data) else {
      throw CocoaError(.fileWriteUnknown, userInfo: [NSFilePathErrorKey: url.path])
    }
  }
}
