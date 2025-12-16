//
//  File.swift
//
//
//  Created by Gray on 2024/3/4.
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit

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
#elseif os(macOS)
import AppKit

public struct ShareSheet: NSViewRepresentable {
  var items: [Any]

  public init(items: [Any]) {
    self.items = items
  }

  public func makeNSView(context: Context) -> NSView {
    return NSView()
  }

  public func updateNSView(_ nsView: NSView, context: Context) {}

  public func showPicker(from view: NSView) {
    let picker = NSSharingServicePicker(items: items)
    picker.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
  }
}
#endif
