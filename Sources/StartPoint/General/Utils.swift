//
//  Utils.swift
//  V2er
//
//  Created by Seth on 2021/7/4.
//  Copyright © 2021 daystill.app. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

private let loggable: Bool = true
public let TAG = "DEBUG_TAG: "

public func log(tag: String = .empty, _ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file) {
  if !loggable {
    return
  }
#if DEBUG
  let filename = (file as NSString).lastPathComponent
  var finalTag = tag
  if finalTag.isEmpty {
    finalTag = filename
  }
  print(TAG + finalTag, items, separator, terminator)
#endif
}


public func isSimulator() -> Bool {
#if (arch(i386) || arch(x86_64)) && os(iOS)
  return true
#endif
  return false
}



/// Publisher to read keyboard changes.
protocol KeyboardReadable {
  var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers.Merge(
      NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { _ in true },
      
      NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in false }
    )
    .eraseToAnyPublisher()
  }
}

public func notEmpty(_ strs: String?...) -> Bool {
  for str in strs {
    if let str = str {
      if str.isEmpty { return false }
    } else { return false }
  }
  return true
}

extension URL {
  init?(_ url: String) {
    self.init(string: url)
  }
  
  public func start() {
    UIApplication.shared.openURL(self)
  }
}

extension String {
  public func openURL() {
    let url = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    URL(string: url)?.start()
  }
}

struct MailHelper {
  
  static public func createEmailUrl(subject: String, body: String, to: String) -> URL? {
    let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    
    let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
    let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
    
    if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
      return gmailUrl
    } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
      return outlookUrl
    } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
      return yahooMail
    } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
      return sparkUrl
    }
    
    return defaultUrl
  }
  
}

public extension Bundle {
  
  var shortVersion: String {
    if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
      return result
    } else {
      assert(false)
      return ""
    }
  }
  
  var buildVersion: String {
    if let result = infoDictionary?["CFBundleVersion"] as? String {
      return result
    } else {
      assert(false)
      return ""
    }
  }
  
  var fullVersion: String {
    return "\(shortVersion) (\(buildVersion))"
  }
  
   static func bundleID() -> String {
    Bundle.main.bundleIdentifier!
  }
  
}

