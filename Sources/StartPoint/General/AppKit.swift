//
//  File.swift
//
//
//  Created by Gray on 2024/3/4.
//

import Foundation
import UIKit

public struct AppKit {}

public extension AppKit {
  
  static func openSetting() {
    UIApplication.openSettingsURLString.openURL()
  }
  
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
  
  //  openAppStoreReviewPage
  static func openAppStoreReviewPage(appID: String) {
    let url = appStoreAppPageUrl(appID: appID) + "?action=write-review"
    url.openURL()
  }
  
  static func openAppStorePage(appID: String) {
    appStoreAppPageUrl(appID: appID).openURL()
  }
  
  static func appStoreAppPageUrl(appID: String)-> String {
    "https://apps.apple.com/app/id\(appID)"
  }
  
}

public extension String {
  var url : URL? {
    URL(string: self)
  }
}
