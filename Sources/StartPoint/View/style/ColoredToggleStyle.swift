//
//  File.swift
//
//
//  Created by Gray on 2024/3/19.
//

import SwiftUI

public struct ColoredToggleStyle: ToggleStyle {
  var label = ""
  var onColor = Color(UIColor.systemGreen)
  var offColor = Color(UIColor.systemGray5)
  var thumbColor = Color.white
  
  public init(label: String = "", onColor: Color = Color(UIColor.systemGreen), offColor: Color = Color(UIColor.systemGray5), thumbColor: Color = Color.white) {
    self.label = label
    self.onColor = onColor
    self.offColor = offColor
    self.thumbColor = thumbColor
  }

  private let thumbSize: CGFloat = 30
  private let width: CGFloat = 52
  private let capsuleRadius: CGFloat = 99
  private let padding: CGFloat = 1.8
  
  public func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      if !label.isEmpty {
        Text(label)
        Spacer()
      }
      Button {
        withAnimation(.easeInOut(duration: 0.3)) {
          configuration.isOn.toggle()
        }
      } label: {
        RoundedRectangle(cornerRadius: capsuleRadius, style: .circular)
          .fill(configuration.isOn ? onColor : offColor)
          .frame(width: self.width, height: self.thumbSize)
          .overlay(alignment: configuration.isOn ? .trailing : .leading) {
            Circle()
              .fill(thumbColor)
              .shadow(radius: 1, x: 0, y: 0.6)
              .padding(self.padding)
          }
      }
    }
  }
}

#Preview {
  
  VStack {
    Toggle("Toggle ON", isOn: .constant(true))
      .toggleStyle(ColoredToggleStyle(label: "Custom Toggle"))
    
    Toggle("Toggle OFF", isOn: .constant(false))
      .toggleStyle(ColoredToggleStyle(label: "Custom Toggle"))
    
    Toggle("Toggle Default", isOn: .constant(true))
    Toggle("Toggle Default", isOn: .constant(false))
  }
  .padding()
//  .background(.ultraThickMaterial)
}
