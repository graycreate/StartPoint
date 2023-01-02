//
//  Store.swift
//  RememDays
//
//  Created by GARY on 2022/12/17.
//

import Foundation
import SwiftUI

open class BaseStore: ObservableObject {
  public static var shared: BaseStore = BaseStore()
  public static var sample: BaseStore {
    shared
  }
  @Published public var deviceState: DeviceState = DeviceState()
  
  /// Root UI elements
  public var rootViewController: UIViewController? {
    return rootWindow?.rootViewController
  }
  public var rootWindow: UIWindow?
}
