//
//  DebouncedButton.swift
//
//
//  Created by Gray on 2024/2/14.
//

import SwiftUI

public struct DebouncedButton<Label: View>: View {
  // 按钮的动作，使用@escaping标记因为它会在初始化之后的某个时间点被调用
  let action: () -> Void
  
  // 标签的视图构建器
  let label: () -> Label
  
  // 防抖时间间隔, specified in seconds
  private var debounceInterval: TimeInterval = 0.5
  
  // 记录上一次按钮点击时间
  @State private var lastClickTime = Date(timeIntervalSince1970: 0)
  
  public init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
    self.action = action
    self.label = label
  }
  
  public func debounceInterval(_ interval: TimeInterval) -> DebouncedButton {
    var button = self
    button.debounceInterval = interval
    return button
  }
  
  public var body: some View {
    Button {
      let now = Date()
      if now.timeIntervalSince(lastClickTime) > debounceInterval {
        lastClickTime = now
        action()
      } else {
        log("debounce")
      }
    } label: {
      label()
    }
  }
  
}

// Add a modifier to change the debounce interval

