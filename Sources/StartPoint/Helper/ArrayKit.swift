//
//  File.swift
//  
//
//  Created by Gray on 2023/12/3.
//

import Foundation

public extension ArraySlice {
  var array: [Element] {
        return Array(self)
    }
}

public extension Array where Element: Equatable {
  func random(excluding excludedElements: Element...) -> Element? {
    let filteredElements = self.filter { !excludedElements.contains($0) }
    guard !filteredElements.isEmpty else { return nil }
    return filteredElements.randomElement()
  }
}

