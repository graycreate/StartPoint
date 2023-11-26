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
}

extension View {
  var isPreview: Bool {
      Runtime.isPreview
  }
}
