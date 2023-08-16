//
//  Store.swift
//  DaysTill
//
//  Created by GARY on 2022/12/17.
//

import Foundation
import SwiftUI

open class GeneralState: ObservableObject {
  public static var shared: GeneralState = GeneralState()
  public static var sample: GeneralState {
    shared
  }
//  @Published public var deviceState: DeviceState = DeviceState()
  @Published public var autoHideIndicator: Bool = false
  @Published public var isPortrait: Bool = OritentionMode.isPortraitFromInit
  @Published public var safeArea: EdgeInsets = UIDevice.safeArea.edgeInset
  
  /// Root UI elements
  public var rootViewController: UIViewController? {
    return rootWindow?.rootViewController
  }
  public var rootWindow: UIWindow?
}
