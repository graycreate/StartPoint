//
//  File.swift
//
//
//  Created by Gray on 2023/11/12.
//

import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SwiftUI

public struct FontKit {

#if os(iOS)
  public static func printInstalledFonts() {
    for family in UIFont.familyNames {
      print(family)
      for names in UIFont.fontNames(forFamilyName: family){
        print("== \(names)")
      }
    }
  }
#elseif os(macOS)
  public static func printInstalledFonts() {
    let fontManager = NSFontManager.shared
    for family in fontManager.availableFontFamilies {
      print(family)
      if let members = fontManager.availableMembers(ofFontFamily: family) {
        for member in members {
          print("== \(member)")
        }
      }
    }
  }
#endif

}


public extension Font.TextStyle {
  func rounded() -> Font {
    Font.system(self, design: .rounded)
  }
}
