//
//  GlobalState.swift
//  GlobalState
//
//  Created by ghui on 2021/9/12.
//  Copyright © 2021 daystill.app. All rights reserved.
//

import Foundation
import SwiftUI

public struct DeviceState {
  public var autoHideIndicator: Bool = true
#if os(iOS)
  public var safeArea: EdgeInsets = UIDevice.safeArea.edgeInset
#else
  public var safeArea: EdgeInsets = EdgeInsets()
#endif
}
