//
//  File.swift
//  
//
//  Created by Gray on 2023/3/19.
//

import SwiftUI

public struct ShrunkButton: ButtonStyle {
  let factor: CGFloat
  public init(factor: CGFloat = 0.95) {
    self.factor = factor
  }
  
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .opacity(configuration.isPressed ? 1 : 1)
      .scaleEffect(configuration.isPressed ? factor : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
  }
}

//public extension ButtonStyle {
// static var shrunkk: any ButtonStyle { ShrunkButton() }
//}

public extension ButtonStyle {
  static func shrunk(_ factor: CGFloat = 0.98) -> some ButtonStyle {
    ShrunkButton(factor: factor)
  }
}

//public let shrunkenButtonStyle: any ButtonStyle = ShrunkButton()
