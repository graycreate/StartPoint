//
//  File.swift
//
//
//  Created by Gray on 2024/3/4.
//

#if canImport(UIKit)
import Foundation

import SwiftUI

public struct ShareSheet: UIViewControllerRepresentable {
  var items: [Any]
  
  public init(items: [Any]) {
    self.items = items
  }
  
  public func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
    return controller
  }
  
  public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#endif
