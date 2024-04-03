//
//  File.swift
//  
//
//  Created by Gray on 2024/3/4.
//

import Foundation
import UIKit
import DeviceKit
import MessageUI

public struct Mail {
  public private(set) var to: String = ""
  public private(set) var subject: String = AppKit.name + " Feedback"
  public private(set) var body: String = Self.defaultBody
  
  private static var defaultBody: String {
    "AppVersion: " + Bundle.main.fullVersion + "\n"
    + "Device: " + Device.current.description + "\n"
    + "OSVersion: " + UIDevice.current.systemVersion + "\n"
  }
  

  private init() {}
  
  @discardableResult
  public static func to(_ to: String, subject: String = AppKit.name + " Feedback") -> Self {
    var mail = Mail()
    mail.to = to
    mail.subject = subject
    return mail
  }
  
  public func append(key: String, value: String)-> Self {
    var mail = self
    mail.body += key + ": " + value + "\n"
    return mail
  }
  
}

extension Mail {
  public func canSendBy1stPartyClient() -> Bool {
    MFMailComposeViewController.canSendMail()
  }
  
  public func canSendBy3rdPartyClient() -> Bool {
    if Self.createEmailUrl(mail: self) != nil {
      return true
    }
    return false
  }
  
  @discardableResult
  public func sendBy3rdPartyClient() -> Bool {
    guard canSendBy3rdPartyClient() else {
      return false
    }
    let emailUrl = Self.createEmailUrl(mail: self)!
    UIApplication.shared.open(emailUrl)
    return true
  }
  
  public static func createEmailUrl(mail: Mail) -> URL? {
    let to = mail.to
    let subjectEncoded = mail.subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    // Append a line before body with html
    let prefix: String = "<br /> <br /> <br /> <br /> <br /> <br /> <hr>"
    let subfix: String = "<hr>"
    let body = prefix + mail.body + subfix
    let bodyEncoded = body.replacingOccurrences(of: "\n", with: "<br />").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    
    let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
    let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let airmailUrl = URL(string: "airmail://compose?to=\(to)&subject=\(subjectEncoded)&htmlBody=\(bodyEncoded)")

      if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
          return sparkUrl
      } else if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
          return gmailUrl
      } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
          return outlookUrl
      } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
          return yahooMail
      } else if let airmailUrl = airmailUrl, UIApplication.shared.canOpenURL(airmailUrl) {
          return airmailUrl
      }
    
    return nil
  }

  
}
