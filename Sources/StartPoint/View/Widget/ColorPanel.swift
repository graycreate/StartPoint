//
//  SwiftUIView.swift
//  
//
//  Created by GARY on 2023/1/4.
//

import SwiftUI


public struct ColorPanel: View {
  @Binding public var initColor: Color
  @Binding public var slidingColor: Color
  public var padding: CGFloat = 10
  private var colors: [Color] = Color.defaultPanel
  
  public init(initColor: Binding<Color>, slidingColor: Binding<Color>, padding: CGFloat = 10) {
    self._initColor = initColor
    self._slidingColor = slidingColor
    self.padding = padding
  }
  
  public var body: some View {
    VStack(spacing: padding) {
      HStack(spacing: padding) {
        ForEach(0..<6) { index in
          ColorDotView(color: colors[index], selectedColor: $initColor, slidingColor: $slidingColor)
        }
      }
      HStack(spacing: padding) {
        ForEach(6..<12) { index in
          ColorDotView(color: colors[index], selectedColor: $initColor, slidingColor: $slidingColor)
        }
      }
      HStack(spacing: padding) {
        ForEach(12..<18) { index in
          ColorDotView(color: colors[index], selectedColor: $initColor, slidingColor: $slidingColor)
        }
      }
    }
    .padding(.bottom, 60)
    .overlay {
      GeometryReader { geo in
        VStack {
          Spacer()
          ColorSliderView(initColor: initColor, slidingColor: $slidingColor, size: geo.size)
        }
      }
    }
    
  }
  
}

extension Color: Identifiable {
  public var id: Self { self }
}

struct ColorDotView: View {
  var color: Color = .clear
  @Binding var selectedColor: Color
  @Binding public var slidingColor: Color
  
  static let scale: CGFloat = 0.8
  let size: CGFloat = 48 * scale
  let innerSize: CGFloat = 38 * scale
  
  var active: Bool {
    color == selectedColor
  }
  
  var body: some View {
    Circle()
      .strokeBorder(.blue.opacity(0.9).gradient, lineWidth: 2.8 * Self.scale)
      .frame(width: size, height: size)
      .opacity(active ? 1 : 0)
      .overlay {
        Circle()
          .strokeBorder(.black.opacity(0.1), lineWidth: 2 * Self.scale)
          .background(Circle().fill(color))
          .frame(width: innerSize, height: innerSize)
      }
      .onTapGesture {
        selectedColor = self.color
        slidingColor = self.color
      }
  }
}

struct ColorPanel_Previews: PreviewProvider {
  @State static var initColor: Color = .defaultPanel[2]
  @State static var slidingColor: Color = .defaultPanel[2]
  static var previews: some View {
    ColorPanel(initColor: $initColor, slidingColor: $slidingColor)
  }
}
