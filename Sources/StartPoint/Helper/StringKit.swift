//
//  File.swift
//  
//
//  Created by Gray on 2023/11/21.
//

import Foundation

public extension String {
  
  var localized: LocalizedStringResource {
    return LocalizedStringResource(stringLiteral: self)
  }
  
}
