//
//  File.swift
//
//
//  Created by Gray on 2023/11/24.
//

import Foundation
import SwiftUI

public struct Runtime {
  public static var isPreview: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
  }
  
  public static var isDebug: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
  }
  
}

public extension View {
  var isPreview: Bool {
    Runtime.isPreview
  }
}


public extension View {
#if os(iOS)
  func onBackground(_ f: @escaping () -> Void) -> some View {
    self.onReceive(
      NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
      perform: { _ in f() }
    )
  }
  
  func onForeground(_ f: @escaping () -> Void) -> some View {
    self.onReceive(
      NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
      perform: { _ in f() }
    )
  }
#else
  func onBackground(_ f: @escaping () -> Void) -> some View {
    self.onReceive(
      NotificationCenter.default.publisher(for: NSApplication.willResignActiveNotification),
      perform: { _ in f() }
    )
  }
  
  func onForeground(_ f: @escaping () -> Void) -> some View {
    self.onReceive(
      NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification),
      perform: { _ in f() }
    )
  }
#endif
}
