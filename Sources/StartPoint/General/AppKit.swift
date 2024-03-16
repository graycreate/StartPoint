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
  
  
  static var name: String {
    if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
      log("App Name: \(appName)")
      return appName
    }
    
    if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
      log("App Name: \(appName)")
      return appName
    }
    
    return ""
  }
  
  static func getAppIcons(defaultIconName: String = "AppIcon") -> [String] {
      var iconNames: [String] = [defaultIconName]
      
      // 访问 Info.plist 中关于替代图标的配置
      if let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: AnyObject],
         let alternateIconsDictionary = iconsDictionary["CFBundleAlternateIcons"] as? [String: AnyObject] {
          
          for (iconName, _) in alternateIconsDictionary {
              // 将图标名称添加到数组中
              iconNames.append(iconName)
          }
      }
      
      return iconNames
  }
  
  static func setAppIcon(_ iconName: String) {
      // 如果是默认图标，传入 nil
      if iconName == "AppIcon" {
          UIApplication.shared.setAlternateIconName(nil)
      } else {
          UIApplication.shared.setAlternateIconName(iconName)
      }
  }
  
}

public extension String {
  var url : URL? {
    URL(string: self)
  }
}



