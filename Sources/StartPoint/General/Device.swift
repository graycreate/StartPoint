//
//  Device.swift
//  V2er
//
//  Created by Seth on 2021/7/9.
//  Copyright © 2021 daystill.app. All rights reserved.
//

import Foundation
import UIKit
import DeviceKit


public extension UIDevice {
  
  static var safeArea: UIEdgeInsets {
    var result: UIEdgeInsets
    let isIPhoneMini = Device.current == .iPhone12Mini
    let defaultInsetTop = isIPhoneMini ? 50.0 : 47.0
    let defaultInsetBottom = 34.0
    result = UIEdgeInsets.init(top: defaultInsetTop, left: 0,
                               bottom: defaultInsetBottom, right: 0)
    return result;
  }
  
}

public extension UIWindow? {
  var displayCornerRadius: CGFloat {
    var radius: CGFloat = 53.0
    if let screen = self?.screen {
      radius = screen.value(forKey: "_displayCornerRadius") as? CGFloat ?? radius
    }
    log("radius result: \(radius)")
    return radius
  }
}
