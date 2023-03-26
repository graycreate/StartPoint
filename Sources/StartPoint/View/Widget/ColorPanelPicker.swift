//
//  SwiftUIView.swift
//  
//
//  Created by GARY on 2023/1/4.
//

import SwiftUI


public struct ColorPanelPicker: View {
  @Binding public var baseColor: Color
  @Binding public var resultColor: Color
  public var padding: CGFloat = 12
  private var colors: [Color] = Color.defaultPanel
  
  public init(initColor: Binding<Color>, slidingColor: Binding<Color>) {
    self._baseColor = initColor
    self._resultColor = slidingColor
  }
  
  public var body: some View {
    Grid(horizontalSpacing: padding) {
      GridRow {
        ForEach(0..<6) { index in
          ColorDotView(color: colors[index], selectedColor: $baseColor, slidingColor: $resultColor)
        }
      }
      GridRow {
        ForEach(6..<12) { index in
          ColorDotView(color: colors[index], selectedColor: $baseColor, slidingColor: $resultColor)
        }
      }
      GridRow {
        ForEach(12..<18) { index in
          ColorDotView(color: colors[index], selectedColor: $baseColor, slidingColor: $resultColor)
        }
      }
    }
    .padding(.bottom, 60)
    .overlay {
      GeometryReader { geo in
        VStack {
          Spacer()
          ColorSliderView(initColor: baseColor, slidingColor: $resultColor, size: geo.size)
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
  var gradient: Bool = true
  
  static let scale: CGFloat = 0.8
  let size: CGFloat = 54 * scale
  let innerSize: CGFloat = 44 * scale
  
  var active: Bool {
    color == selectedColor
  }
  
  var body: some View {
    Circle()
      .strokeBorder(.blue.opacity(0.9), lineWidth: 2.8 * Self.scale)
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
    ColorPanelPicker(initColor: $initColor, slidingColor: $slidingColor)
  }
}
