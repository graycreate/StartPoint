//
//  File.swift
//
//
//  Created by Gray on 2023/11/12.
//

import Foundation
import UIKit
import SwiftUI

public struct FontKit {
  
  public static func printInstalledFonts() {
    for family in UIFont.familyNames {
      print(family)
      for names in UIFont.fontNames(forFamilyName: family){
        print("== \(names)")
      }
    }
  }
  
}


public extension Font.TextStyle {
  func rounded() -> Font {
    Font.system(self, design: .rounded)
  }
}
