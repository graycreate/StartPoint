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
