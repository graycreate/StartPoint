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
