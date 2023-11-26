//
//  File.swift
//
//
//  Created by Gray on 2023/11/12.
//

import Foundation
import UIKit

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


