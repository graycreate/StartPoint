//
//  File.swift
//
//
//  Created by Gray on 2023/1/2.
//

import SwiftUI

#if os(iOS)
import UIKit

class RootHostingController<Content: View>: UIHostingController<Content> {

  override var prefersHomeIndicatorAutoHidden: Bool {
    let autoHide = GeneralState.shared.autoHideIndicator
//    log("autoHide HomeIndicator: \(autoHide)")
    return autoHide
  }

  override var shouldAutorotate: Bool {
    true
  }

}
#endif
