//
//  ColorSliderView.swift
//  
//
//  Created by GARY on 2023/1/6.
//

import SwiftUI

struct ColorSliderView: View {
  var initColor: Color
  @Binding var slidingColor: Color
  var size: CGSize = .zero
  var strokeWidth: CGFloat
  @State private var offsetX: CGFloat
  @State private var progress: CGFloat
  private var dragCircleSize: CGFloat
  
  init(initColor: Color, slidingColor: Binding<Color>, size: CGSize, strokeWidth: CGFloat = 16) {
    self.initColor = initColor
    self._slidingColor = slidingColor
    self.size = size
    self.strokeWidth = strokeWidth
    let progress = max(0, min(1, (slidingColor.raw.s / initColor.s) * 0.5))
    self.progress = progress
    let dragCircleSize = strokeWidth * 2
    self.dragCircleSize = dragCircleSize
    self.offsetX = progress  * (size.width - dragCircleSize)
    log("init ----- offsetX: \(offsetX), progress: \(progress)")
  }
  
  private var gradient: LinearGradient {
    let h = initColor.hue
    let b = initColor.b
    let colors: [Color] = [
      Color(hue: h, saturation: startSaturation, brightness: b),
      Color(hue: h, saturation: initColor.s, brightness: b),
      Color(hue: h, saturation: endSaturation, brightness: b),
    ]
    return LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
  }
  
  private var startSaturation: CGFloat {
    max(0.0, initColor.s - 0.5)
  }
  
  private var endSaturation: CGFloat {
    min(1.0, initColor.s + 0.5)
  }
  
  
  
  private var saturation: CGFloat {
    (endSaturation - startSaturation) * progress + startSaturation
  }
  
  
  var body: some View {
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: 20)
        .fill(gradient)
        .frame(width: size.width, height: strokeWidth)
        .overlay {
          RoundedRectangle(cornerRadius: 20)
            .stroke(.black.opacity(0.02), lineWidth: 2)
        }
      Circle()
        .stroke(.white, lineWidth: 2)
        .background {
          Circle()
            .fill(slidingColor)
        }
        .frame(width: dragCircleSize)
        .offset(x: offsetX)
        .gesture(DragGesture().onChanged(onDrag(value:)))
    }
    .frame(width: size.width)
    
  }
  
  
  func onDrag(value: DragGesture.Value) {
    let dragX = value.location.x
    offsetX = min(size.width - dragCircleSize, max(0, dragX))
    progress = offsetX / (size.width - dragCircleSize)
    slidingColor.changeHSB(s: saturation)
    log("dragX: \(dragX), offSetX: \(offsetX), --> range: \(size.width - dragCircleSize)")
  }
  
}

struct SwiftUIView_Previews: PreviewProvider {
  @State static var initColor: Color = .defaultPanel[2]
  @State static var selectedColor: Color = .defaultPanel[2]
  
  static var previews: some View {
    GeometryReader { geo in
      VStack {
        ColorSliderView(initColor: initColor, slidingColor: $selectedColor, size: geo.size)
      }
      .greedyFrame()
    }
    .padding(.horizontal)
    .visualBlur()
    .ignoresSafeArea()
  }
}
