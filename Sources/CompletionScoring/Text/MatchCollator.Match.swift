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
  public struct Match: Sendable {
    /// For client use, has no meaning to CompletionScoring, useful when mapping Match instances back to
    /// higher level constructs.
    public var identifier: Int

    public var batchIndex: Int

    public var candidateIndex: Int

    /// Items with the same (groupID, batchID) sort together. Initially used to locate types with their initializers.
    public var groupID: Int?

    public var score: CompletionScore

    public init(batchIndex: Int, candidateIndex: Int, groupID: Int?, score: CompletionScore) {
      self.init(
        identifier: 0,
        batchIndex: batchIndex,
        candidateIndex: candidateIndex,
        groupID: groupID,
        score: score
      )
    }

    public init(identifier: Int, batchIndex: Int, candidateIndex: Int, groupID: Int?, score: CompletionScore) {
      self.identifier = identifier
      self.batchIndex = batchIndex
      self.candidateIndex = candidateIndex
      self.groupID = groupID
      self.score = score
    }
  }
}
