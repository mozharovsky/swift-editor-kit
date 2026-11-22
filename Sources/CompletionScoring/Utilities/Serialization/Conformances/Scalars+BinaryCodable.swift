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

protocol IntegerBinaryCodable: BinaryCodable {
  static var zero: Self { get }
  init(littleEndian: Self)
  var littleEndian: Self { get }
}

extension IntegerBinaryCodable {
  public init(_ decoder: inout BinaryDecoder) throws {
    var littleEndianRepresentation = Self.zero
    try decoder.read(rawBytesInto: &littleEndianRepresentation)
    self.init(littleEndian: littleEndianRepresentation)
  }

  public func encode(_ encoder: inout BinaryEncoder) {
    encoder.write(rawBytesOf: littleEndian)
  }
}

extension UInt8: IntegerBinaryCodable {}
extension UInt16: IntegerBinaryCodable {}
extension UInt32: IntegerBinaryCodable {}
extension UInt64: IntegerBinaryCodable {}
extension Int8: IntegerBinaryCodable {}
extension Int16: IntegerBinaryCodable {}
extension Int32: IntegerBinaryCodable {}
extension Int64: IntegerBinaryCodable {}

extension Int: BinaryCodable {
  public init(_ decoder: inout BinaryDecoder) throws {
    let value64 = try Int64(&decoder)
    // Only possible when crossing architectures.
    self = try Int(exactly: value64).unwrap(orThrow: "Could not coerce \(value64) to an Int")
  }

  public func encode(_ encoder: inout BinaryEncoder) {
    Int64(self).encode(&encoder)
  }
}

extension UInt: BinaryCodable {
  public init(_ decoder: inout BinaryDecoder) throws {
    let value64 = try UInt64(&decoder)
    // Only possible when crossing architectures.
    self = try UInt(exactly: value64).unwrap(orThrow: "Could not coerce \(value64) to a UInt")
  }

  public func encode(_ encoder: inout BinaryEncoder) {
    UInt64(self).encode(&encoder)
  }
}

extension Bool: BinaryCodable {
  public init(_ decoder: inout BinaryDecoder) throws {
    let representation = try UInt8(&decoder)
    if representation <= 1 {
      self = (representation == 1)
    } else {
      // No type checking in this thing, so fail rather than swallow the error to help detect unbalanced calls.
      throw GenericError("\(representation) was not a bool")
    }
  }

  public func encode(_ encoder: inout BinaryEncoder) {
    UInt8(self ? 1 : 0).encode(&encoder)
  }
}

protocol FloatingPointBinaryCodable: BinaryCodable, BinaryFloatingPoint {
  associatedtype BitPatternType: BinaryInteger & BinaryCodable
  init(bitPattern: BitPatternType)
  var bitPattern: BitPatternType { get }
}

extension FloatingPointBinaryCodable {
  public init(_ decoder: inout BinaryDecoder) throws {
    try self.init(bitPattern: BitPatternType(&decoder))
  }

  public func encode(_ encoder: inout BinaryEncoder) {
    encoder.write(bitPattern)
  }
}
extension Float: FloatingPointBinaryCodable {
  typealias BitPatternType = UInt32
}

extension Double: FloatingPointBinaryCodable {
  typealias BitPatternType = UInt64
}
