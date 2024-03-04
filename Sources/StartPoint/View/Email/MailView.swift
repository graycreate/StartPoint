//
//  MailView.swift
//  ULPB
//
//  Created by ghui on 2022/2/24.
//

import SwiftUI
import UIKit
import MessageUI
import DeviceKit

public struct MailView: UIViewControllerRepresentable {
  public var configure: ((MFMailComposeViewController) -> Void)?
  public var onResult: ((MailView.Result) -> Void)?
  @Environment(\.presentationMode) private var presentation
  
  public init(configure: ((MFMailComposeViewController) -> Void)? = nil,
              onResult: ((MailView.Result) -> Void)? = nil) {
    self.configure = configure
    self.onResult = onResult
  }
  
  public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
    let vc = MFMailComposeViewController()
    vc.mailComposeDelegate = context.coordinator
    configure?(vc)
    return vc
  }
  
  public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                     context: UIViewControllerRepresentableContext<MailView>) {
    
  }
  
  public func makeCoordinator() -> Coordinator {
    return Coordinator(presentation: presentation,
                       result: self.onResult)
  }
  
  public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    @Binding var presentation: PresentationMode
    var result: ((MailView.Result) -> Void)?
    
    init(presentation: Binding<PresentationMode>,
         result: ((MailView.Result) -> Void)?) {
      _presentation = presentation
      self.result = result
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
      defer {
        $presentation.wrappedValue.dismiss()
      }
      guard error == nil else {
        self.result?(.failed)
        return
      }
      self.result?(MailView.Result(rawValue: result.rawValue) ?? .failed)
    }
  }
  
  public enum Result: Int {
    case noMailClient = -1
    case cancelled = 0
    case saved = 1
    case sent = 2
    case failed = 3
    
    public init?(rawValue: Int) {
      switch rawValue {
        case -1: self = .noMailClient
        case 0: self = .cancelled
        case 1: self = .saved
        case 2: self = .sent
        case 3: self = .failed
        default: return nil
      }
    }
    
  }
  
}


public struct Mail {
  public private(set) var to: String = ""
  public private(set) var subject: String = "Feedback"
  public private(set) var body: String = Self.defaultBody
  
  private static var defaultBody: String {
    "AppVersion: " + Bundle.main.fullVersion + "\n"
    + "Device: " + Device.current.description + "\n"
    + "OSVersion: " + UIDevice.current.systemVersion + "\n"
  }
  

  private init() {}
  
  @discardableResult
  public static func to(_ to: String, subject: String = "Feedback") -> Self {
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
    
    let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
    let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    
    if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
      return gmailUrl
    } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
      return sparkUrl
    } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
      return outlookUrl
    } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
      return yahooMail
    }
    
    return nil
  }

  
}
