//
//  SwiftUIView.swift
//
//
//  Created by Gray on 2023/3/30.
//
#if canImport(UIKit)
import SwiftUI


struct RedDotViewModifier: ViewModifier {
  @Binding var show: Bool
  var alignment: Alignment = .topTrailing
  var offsetX: CGFloat
  var offsetY: CGFloat
  let badgeColor: Color = .hex(0xFF3B30)
  
  func body(content: Content) -> some View {
    if show {
      content
        .overlay {
          ZStack(alignment: alignment) {
            Color.almostClear
            Image(systemName: "circle.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 8)
              .foregroundColor(self.badgeColor)
              .padding(0)
              .offset(x: offsetX, y: offsetY)
          }
        }
//        .onTapGesture {
//          self.show = false
//        }
    } else {
      content
    }
    
  }
}

public extension View {
  func redDot(show: Binding<Bool>, alignment: Alignment = .topTrailing,
              offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> some View {
    self.modifier(RedDotViewModifier(show: show, alignment: alignment,
                                     offsetX: offsetX, offsetY: offsetY))
  }
}


#Preview {
  
  Text("DaysTill")
    .redDot(show: .constant(true))
    .previewLayout(.sizeThatFits)
    .padding()
    .background(Color.gray)
    .previewDisplayName("RedDotViewModifier")
}

#endif
