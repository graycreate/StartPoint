//
//  File.swift
//
//
//  Created by Gray on 2023/11/21.
//

import Foundation
import SwiftUI

public extension String {
  fileprivate static func localizedString(for key: String,
                              locale: Locale = .current) -> String {
    let language = locale.languageCode
    if let path = Bundle.main.path(forResource: language, ofType: "lproj"), let bundle = Bundle(path: path) {
      let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
      return localizedString
    }
    return ""
  }
  
    @available(macOS 10.15, *)
    var localized: LocalizedStringKey {
    LocalizedStringKey(self)
  }
}

@available(macOS 10.15, *)
public extension LocalizedStringKey {
  var stringKey: String? {
    Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
  }
  
  func stringValue(locale: Locale = .current) -> String {
    return .localizedString(for: self.stringKey ?? "", locale: locale)
  }
  
  var isEmpty: Bool {
    stringValue().isEmpty
  }
  
  var notEmpty: Bool {
    !isEmpty
  }
  
}

@available(macOS 10.15, *)
extension LocalizedStringKey: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.stringKey)
  }
}
