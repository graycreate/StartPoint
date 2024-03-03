//
//  Castable.swift
//  ULPB
//
//  Created by Gray on 2024/1/24.
//

import Foundation

public protocol SafeCastable {
  static func cast(from value: Any?, default: Self) -> Self
}

public extension SafeCastable {
  static func cast(from value: Any?, default: Self) -> Self {
    return value as? Self ?? `default`
  }
}

// MARK: - Implementations
extension String: SafeCastable {
}

extension Int: SafeCastable {
}

extension Double: SafeCastable {
}

extension Bool: SafeCastable {
}

extension Array: SafeCastable {
}
