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
  var strokeWidth: CGFloat = 16
  var size: CGSize
  private var dragCircleSize: CGFloat {
    strokeWidth * 2
  }
  
  var effectiveWidth: Double { size.width - dragCircleSize }
  @State private var dragSaturationOffset = 0.0
  @State private var lastDragSaturationOffset = 0.0
  
  private var gradient: LinearGradient {
    let h = initColor.hue
    let b = initColor.b
    let colors: [Color] = [
      Color(hue: h, saturation: 0, brightness: b),
      Color(hue: h, saturation: initColor.s, brightness: b),
      Color(hue: h, saturation: 1.0, brightness: b),
    ]
    return LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
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
        .fill(.white)
        .overlay {
          Circle()
            .fill(slidingColor)
            .frame(width: dragCircleSize - 4)
        }
        .frame(width: dragCircleSize)
        .offset(x: effectiveWidth * (slidingColor.s))
        .gesture(DragGesture().onChanged(onDragChange(value:)).onEnded(onDragEnd(value:)))
    }
    .frame(width: size.width)
  }
  
  
  
  func onDragChange(value: DragGesture.Value) {
    dragSaturationOffset = value.translation.width / effectiveWidth
    let delta = dragSaturationOffset - lastDragSaturationOffset
    let newS = (slidingColor.s + delta).in(0.0001, 0.9999)
    slidingColor.changeHSB(s: newS)
    lastDragSaturationOffset = dragSaturationOffset
  }
  
  func onDragEnd(value: DragGesture.Value) {
    dragSaturationOffset = 0
    lastDragSaturationOffset = 0
  }
  
}

struct ColorSliderView_Previews: PreviewProvider {
  static var initColor: Color = .defaultPanel[2]
  @State static var selectedColor: Color = .defaultPanel[2]

  static var previews: some View {
    GeometryReader { geo in
      VStack {
        ColorSliderView(initColor: initColor, slidingColor: $selectedColor, size: geo.size)
      }
      .greedyFrame()
    }
    .padding(.horizontal)
    .visualBlur(bg: .black)
    .ignoresSafeArea()
  }
}
