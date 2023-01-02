//
//  File.swift
//  
//
//  Created by GARY on 2023/1/2.
//

import SwiftUI

class RootHostingController<Content: View>: UIHostingController<Content> {
  
  override var prefersHomeIndicatorAutoHidden: Bool {
    let autoHide = BaseStore.shared.deviceState.autoHideIndicator
    log("autoHide HomeIndicator: \(autoHide)")
    return autoHide
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return OritentionMode.current.toSystemMode
  }
  
  override var shouldAutorotate: Bool {
    true
  }

}
