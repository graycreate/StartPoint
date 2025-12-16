//
//  File.swift
//
//
//  Created by Gray on 2024/3/5.
//

import Foundation
#if os(iOS)
import UIKit
#endif
import SwiftUI

/// duration: Millisecond to delay, defaut is 5 ms, animation if not nil, will run with animation
@discardableResult
public func dispatch(delay: Double = 0, animation: Animation? = nil, execute work: @escaping @convention(block) () -> Void) -> DispatchWorkItem {
  let workItem = DispatchWorkItem {
    if animation != nil {
      withAnimation(animation) {
        work()
      }
    } else {
      work()
    }
  }
  DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(delay)), execute: workItem)
  return workItem
}

/// duration: Millisecond to delay, defaut is 5 ms
@discardableResult
public func delay(_ duration: Double = 5, with animation: Animation? = nil, _ work: @escaping @convention(block) () -> Void) -> DispatchWorkItem {
  return dispatch(delay: duration, animation: animation, execute: work)
}

#if os(iOS)
public func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
  let impactHeavy = UIImpactFeedbackGenerator(style: style)
  impactHeavy.impactOccurred()
}
#endif
