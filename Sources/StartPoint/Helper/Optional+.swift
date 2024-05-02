//
//  File.swift
//
//
//  Created by Gray on 2024/5/2.
//

import Foundation

public extension Optional {
  var description: String {
    switch self {
      case .some(let value):
        return "\(value)"
      case .none:
        return "nil"
    }
  }
}

public extension DefaultStringInterpolation {
  public mutating func appendInterpolation<T>(_ optional: T?) {
    appendInterpolation(String(describing: optional))
  }
}
