//
//  SwiftUIView.swift
//  
//
//  Created by Gray on 2023/3/20.
//

import SwiftUI

public struct BottomSheetView<TitleView: View, Content: View, AnchorView: View>: View {
  @Binding var isShowing: Bool
  var titleView: TitleView
  var content: Content
  let anchorView: AnchorView
  
  @State private var scaleY: CGFloat = 1.0
  @State private var dragOffset: CGFloat = 0
  
  @State private var size: CGSize = .zero
  
  var radius: CGFloat {
    // 446 -> 36
    // 290 -> 28
    // 28 <= radius <= 36
    let height = self.size.height
    if height <= 290 {
      return 30
    } else if height < 446 {
      return 30 + (height - 290) / (446 - 290) * (36 - 30)
    } else {
      return 36
    }
  }

  public init(isShowing: Binding<Bool>, @ViewBuilder titleView: ()-> TitleView, @ViewBuilder content: ()-> Content, anchorView: AnchorView) {
    self._isShowing = isShowing
    self.titleView = titleView()
    self.content = content()
    self.anchorView = anchorView
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
      self.anchorView
        .zIndex(0)
      if (isShowing) {
      self.dimView
        .transition(.opacity.animation(.easeInOut(duration: 0.3)))
        .zIndex(1)
        VStack(spacing: 14) {
          self.titleBarView
          if #available(iOS 17.0, *) {
            self.content
              .geometryGroup()
          } else {
            // Fallback on earlier versions
            self.content
          }
//            .padding(.horizontal, 2)
        }
        .padding(30)
        .padding(.top, 0)
        .background {
          Color.clear
          .visualBlur(style: .systemThickMaterial, color: .white.night(.black).opacity(0.5))
          .clip(radius: self.radius, strokeColor: Color.borderAccent)
          .scaleEffect(self.scaleY)
        }
        .offset(y: self.dragOffset)
        .gesture(DragGesture()
          .onChanged { gesture in
            let scrollTop = gesture.translation.height < 0
              withAnimation {
                self.scaleY = scrollTop ? 1.01 : 0.99
                let offset = gesture.translation.height
                if offset > 0 {
                  self.dragOffset = min(offset, 16)
                } else {
                  self.dragOffset = max(offset, -16)
                }
              }
          }
          .onEnded { value in
            withAnimation(.bouncy) {
              self.scaleY = 1.0
              self.dragOffset = 0
            }
          })
        .padding(.horizontal, 12)
        .padding(.bottom, 26)
        .readSize { size in
          self.size = size
          log("size: \(size)")
        }
        .transition(.move(edge: .bottom))
        .zIndex(2)
      }
    }
    .ignoresSafeArea()
    .animation(self.animation, value: isShowing)
  }
  
  @ViewBuilder
  private var titleBarView: some View {
    HStack(alignment: .top) {
      self.titleView
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
    .bouncy
//    .default
//    .easeInOut
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
    Color.black.opacity(0.4)
      .ignoresSafeArea()
      .onTapGesture {
        dismiss()
      }
  }
  
  private func dismiss() {
    haptic()
    withAnimation(self.animation) {
      isShowing.toggle()
    }
  }
  
}

public extension View {
  func bottomSheet<TitleView: View, Content: View>(isShowing: Binding<Bool>, titleView: ()-> TitleView, @ViewBuilder content: ()-> Content) -> BottomSheetView<TitleView, Content, Self> {
    BottomSheetView(isShowing: isShowing, titleView: titleView, content: content, anchorView: self)
  }
  
  func bottomSheet<Content: View>(isShowing: Binding<Bool>, title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
      BottomSheetView(isShowing: isShowing, titleView: { SheetTitle(title) }, content: content, anchorView: self)
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
