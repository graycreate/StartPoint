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
  var strokeWidth: CGFloat = 13
  var size: CGSize
  private var dragCircleSize: CGFloat {
    strokeWidth * 2.6
  }
  
  var effectiveWidth: Double { size.width - dragCircleSize }
  @State private var dragSaturationOffset = 0.0
  @State private var lastDragSaturationOffset = 0.0
  
  private var gradient: LinearGradient {
    let h = initColor.hue
    let s = initColor.s
    let b = initColor.b
    var colors: [Color]
    if shouldChangeBrightness {
      if b == 0 {
        colors = [
          Color(hue: h, saturation: s, brightness: 1),
          Color(hue: h, saturation: s, brightness: b),
        ]
      } else if b == 1 {
        colors = [
          Color(hue: h, saturation: s, brightness: b),
          Color(hue: h, saturation: s, brightness: 0),
        ]
      } else {
        colors = [
          Color(hue: h, saturation: s, brightness: 1),
          Color(hue: h, saturation: s, brightness: b),
          Color(hue: h, saturation: s, brightness: 0),
        ]
      }
    } else {
      colors = [
        Color(hue: h, saturation: 0, brightness: b),
        Color(hue: h, saturation: s, brightness: b),
        Color(hue: h, saturation: 1.0, brightness: b),
      ]
    }
    return LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
  }
  
  private var shouldChangeBrightness: Bool {
    return initColor.hue == 0 && initColor.s == 0
  }
  
  private var modifiableElement: CGFloat {
    if shouldChangeBrightness {
      return slidingColor.b
    }
    return slidingColor.s
  }
  
  
  var body: some View {
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: 20)
        .fill(gradient)
        .frame(width: size.width, height: strokeWidth)
        .overlay {
          RoundedRectangle(cornerRadius: 20)
            .stroke(.black.opacity(0.08), lineWidth: 2)
        }
      Circle()
        .fill(.white)
        .overlay {
          Circle()
            .fill(slidingColor)
            .frame(width: dragCircleSize - 4)
        }
        .frame(width: dragCircleSize)
        .offset(x: effectiveWidth * (progress))
        .gesture(DragGesture().onChanged(onDragChange(value:)).onEnded(onDragEnd(value:)))
    }
    .frame(width: size.width)
  }
  
  private var progress: CGFloat {
    if shouldChangeBrightness {
      return 1 - modifiableElement
    }
    
    return modifiableElement
  }
  
  
  
  func onDragChange(value: DragGesture.Value) {
    dragSaturationOffset = value.translation.width / effectiveWidth
    let delta = dragSaturationOffset - lastDragSaturationOffset
    if shouldChangeBrightness {
      let modified = (modifiableElement - delta).in(0.0001, 0.9999)
      slidingColor.changeHSB(b: modified)
    } else {
      let modified = (modifiableElement + delta).in(0.0001, 0.9999)
      slidingColor.changeHSB(s: modified)
    }
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
