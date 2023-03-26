//
//  SwiftUIView.swift
//  
//
//  Created by GARY on 2023/3/20.
//

import SwiftUI

public struct BottomSheetView<Content: View, AnchorView: View>: View {
  @Binding var isShowing: Bool
  var content: Content
  let anchorView: AnchorView
  
  init(isShowing: Binding<Bool>, @ViewBuilder content: ()-> Content, anchorView: AnchorView) {
    self._isShowing = isShowing
    self.content = content()
    self.anchorView = anchorView
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
      self.anchorView
      if (isShowing) {
        self.dimView
          .zIndex(0)
        self.content
          .overlay(alignment: .topTrailing) {
            Button {
              dismiss()
            } label: {
              Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 27, weight: .semibold))
                .foregroundStyle(UIColor.systemGray2.color())
                .clipShape(Circle())
            }
          }
          .padding(.vertical)
          .padding(.horizontal)
          .background(.regularMaterial)
          .clip(radius: 36)
          .transition(.move(edge: .bottom))
          .zIndex(1)
      }
    }
    .greedyFrame(.bottom)
    .ignoresSafeArea()
    .animation(.easeInOut, value: isShowing)
  }
  
  private var dimView: some View {
    Color.black
      .opacity(0.3)
      .transition(.opacity)
      .ignoresSafeArea()
      .transition(.opacity)
      .onTapGesture {
        dismiss()
      }
  }
  
  private func dismiss() {
    withAnimation(.easeInOut(duration: 0.26)) {
      isShowing.toggle()
    }
  }
  
}

public extension View {
  func bottomSheet<Content: View>(isShowing: Binding<Bool>, @ViewBuilder content: ()-> Content) -> BottomSheetView<Content, Self> {
    BottomSheetView(isShowing: isShowing, content: content, anchorView: self)
  }
}

public struct SheetTitle: View {
    let title: String
    
    public init(_ title: String) {
      self.title = title
    }
    
    public var body: some View {
      Text(title)
        .font(.system(size: 21, weight: .semibold))
        .bold()
        .lineLimit(1)
        .foregroundColor(.labelColorWeek)
        .padding(.bottom, 16)
    }
  }

struct SwiftUIView_Previews: PreviewProvider {
  @State static var isShowing = true
  
  static var previews: some View {
    Text("Title")
      .bottomSheet(isShowing: $isShowing) {
        Text("Content")
      }
  }
  
}
