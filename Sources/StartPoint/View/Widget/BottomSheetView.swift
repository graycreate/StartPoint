//
//  SwiftUIView.swift
//  
//
//  Created by GARY on 2023/3/20.
//

import SwiftUI

public struct BottomSheetView<Content: View, AnchorView: View>: View {
  @Binding var isShowing: Bool
  let title: String
  var content: Content
  let anchorView: AnchorView
  
  
  init(isShowing: Binding<Bool>, title: String, @ViewBuilder content: ()-> Content, anchorView: AnchorView) {
    self._isShowing = isShowing
    self.title = title
    self.content = content()
    self.anchorView = anchorView
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
      self.anchorView
      self.dimView
        .zIndex(0)
      if (isShowing) {
        VStack(spacing: 14) {
          self.titleBarView
          self.content
//            .padding(.horizontal, 2)
        }
        .padding(30)
        .padding(.top, 0)
//        .background(.ultraThickMaterial) // Toggle issue, untint color invisiable
        .visualBlur(bg: .white.dark(.black).opacity(0.5), style: .systemThickMaterial)
        .clip(radius: 38)
        .padding(.horizontal, 12)
        .padding(.bottom, 26)
        .transition(.move(edge: .bottom))
        .zIndex(1)
      }
    }
    .ignoresSafeArea()
    .animation(self.animation, value: isShowing)
  }
  
  @ViewBuilder
  private var titleBarView: some View {
    HStack(alignment: .top) {
      SheetTitle(self.title)
      Spacer()
      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark.circle.fill")
          .symbolRenderingMode(.hierarchical)
          .font(.system(size: 27, weight: .semibold))
          .foregroundStyle(UIColor.systemGray3.color())
          .clipShape(Circle())
      }
      .padding(.trailing, -5)
    }
  }
  
  private var animation: Animation {
    .easeInOut
//    .speed(1.3)
//    .spring(
//      response: 0.45,
//      dampingFraction: 0.85,
//      blendDuration: 1
//    )
//    .speed(1.3)
  }
  
  private var dimAnimation: Animation {
    .easeInOut
    .speed(0.5)
    .delay(1.1)
  }
  
  private var dimView: some View {
    Color.black.opacity(isShowing ? 0.4 : 0.0)
      .ignoresSafeArea()
      .onTapGesture {
        dismiss()
      }
  }
  
  private func dismiss() {
    withAnimation(self.animation) {
      isShowing.toggle()
    }
  }
  
}

public extension View {
  func bottomSheet<Content: View>(isShowing: Binding<Bool>, title: String, @ViewBuilder content: ()-> Content) -> BottomSheetView<Content, Self> {
    BottomSheetView(isShowing: isShowing, title: title, content: content, anchorView: self)
  }
}

private struct SheetTitle: View {
  let title: String
  
  public init(_ title: String) {
    self.title = title
  }
  
  public var body: some View {
    Text(title)
      .font(.system(size: 19, weight: .semibold, design: .rounded))
      .bold()
      .lineLimit(1)
      .foregroundColor(.labelColorWeak)
      .greedyWidth(.leading)
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  @State static var isShowing = true
  
  static var previews: some View {
    Text("Title")
      .bottomSheet(isShowing: $isShowing, title: "Test") {
        Text("Content")
          .greedyWidth()
          .frame(height: 300)
          .background(.white)
      }
  }
  
}
