//
//  File.swift
//
//
//  Created by Gray on 2024/3/4.
//

import Foundation
import UIKit

public struct AppKit {
  
}

public extension AppKit {
  
  static func openTwitterUserProfile(username: String) {
    let appURL = URL(string: "twitter://user?screen_name=\(username)")!
    let webURL = URL(string: "https://twitter.com/\(username)")!
    
    if UIApplication.shared.canOpenURL(appURL) {
      // If Twitter app is installed, open URL in Twitter app
      UIApplication.shared.open(appURL)
    } else {
      // If Twitter app is not installed, open URL in a web browser
      UIApplication.shared.open(webURL)
    }
  }
  
}
