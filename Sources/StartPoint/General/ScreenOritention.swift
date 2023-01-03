//
//  ScreenOritention.swift
//  MyClock
//
//  Created by ghui on 2022/4/17.
//

import Foundation
import UIKit


public enum OritentionMode: Int {
  case auto = 0
  case portrait = 1
  case landscape = 2
  
  public static func build(from intValue: Int) -> OritentionMode {
    switch intValue {
    case 0:
      return .auto
    case 1:
      return .portrait
    case 2:
      return .landscape
    default:
      return .auto
    }
  }
  
 public static var current: OritentionMode {
   let rawValue: Int = Persist.read(key: Prefs.SCREEN_ORITATION_MODE)
    return OritentionMode(rawValue: rawValue)!
  }
  
  public var toSystemMode: UIInterfaceOrientationMask {
    let supportMode: UIInterfaceOrientationMask
    if OritentionMode.current == .portrait {
      supportMode = .portrait
    } else if OritentionMode.current == .landscape {
      supportMode = .landscape
    } else {
      supportMode = .all
    }
    return supportMode
  }
  
  public static func update() {
    let oritentionMode = OritentionMode.current
    let supportMode = oritentionMode.toSystemMode
    UIDevice.current.setValue(supportMode.toUIInterfaceOrientation.rawValue, forKey: "orientation")
    UIViewController.attemptRotationToDeviceOrientation()
    log(tag: "onRotate", "update current support Mode to: \(supportMode), oritentionMode: \(oritentionMode)")
    runInMain(delay: 50) {
      if oritentionMode == .auto {
        let isPortrait = !UIDevice.current.orientation.isLandscape
        GeneralState.shared.isPortrait = isPortrait
      } else {
        GeneralState.shared.isPortrait = (oritentionMode == .portrait)
      }
    }
  }
}

public extension UIInterfaceOrientationMask {
  public var toUIInterfaceOrientation: UIInterfaceOrientation {
    switch self {
    case .portrait:
      return .portrait
    case .landscape:
      return  .landscapeRight
    case .all:
      fallthrough
    default:
      return .unknown
    }
  }
}

public extension OritentionMode {
  public static var isPortraitFromInit: Bool {
    var result: Bool?
    let oritention = OritentionMode.current
    if oritention == .portrait {
      result = true
    } else if oritention == .landscape {
      result = false
    } else {
//      result = GlobalState.shared.rootWindow?.windowScene?.interfaceOrientation.isPortrait
      if result == nil {
        log("UIApplication.shared.currentScene?.interfaceOrientation is nil")
        let deviceOrientation = UIDevice.current.orientation
        result = !deviceOrientation.isLandscape
        log("final isLandscape: \(deviceOrientation.isLandscape), isPortrait: \(deviceOrientation.isPortrait), deviceOrientation: \(deviceOrientation)")
      }
    }
    return result!
  }
}



