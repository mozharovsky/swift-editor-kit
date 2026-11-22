//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
// Modified from the sourcekit-lsp original. See NOTICE for the changes.
//
//===----------------------------------------------------------------------===//

import Foundation

extension MatchCollator {
  /// The result of best match selection.
  public struct Selection: Sendable {
    /// The precision used during matching, which varies based on the number of candidates and the input pattern length.
    public var precision: Pattern.Precision
    public var matches: [Match]
  }
}
