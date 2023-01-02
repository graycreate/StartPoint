//
//  NavBar.swift
//  RememDays
//
//  Created by GARY on 2022/12/12.
//

import SwiftUI

public struct NavBar<LeftView, CenterView, RightView>: View where LeftView: View, CenterView: View, RightView: View {
  
  let leftView: LeftView?
  let centerView: CenterView
  let rightView: RightView?
  
  public init(@ViewBuilder leftView: () -> LeftView = { EmptyView() } ,
              @ViewBuilder centerView: () -> CenterView = { Text("Title")},
              @ViewBuilder rightView: () -> RightView = { EmptyView() }) {
    self.leftView = leftView()
    self.centerView = centerView()
    self.rightView = rightView()
  }
  
  public var body: some View {
    NavbarView {
      ZStack {
        HStack(alignment: .center, spacing: 4) {
          leftView
          Spacer()
          rightView
        }
        HStack(alignment: .center) {
          centerView
        }
      }
    }
  }
}

public struct NavbarView<Content: View>: View {
  @EnvironmentObject private var store: BaseStore
  let content: Content
  let paddingH: CGFloat
  let hideDivider: Bool
  
  public init(paddingH: CGFloat = 12, hideDivider: Bool = true, @ViewBuilder content: () -> Content) {
    self.content = content()
    self.paddingH = paddingH
    self.hideDivider = hideDivider
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Color.clear.frame(height: store.deviceState.safeArea.top)
      HStack(alignment: .center, spacing: 0) {
        self.content
          .padding(.vertical, 4)
      }
      .greedyWidth()
      Divider()
        .opacity(hideDivider ? 0.0 : 1.0)
    }
    .greedyWidth()
    .padding(.horizontal, self.paddingH)
    .frame(minHeight: 50)
    .forceClickable()
    .visualBlur()
    .navigationBarHidden(true)
    .ignoresSafeArea(.container)
  }
}

struct NavBar_Previews: PreviewProvider {
  static var previews: some View {
    NavBar {
      BackView()
    } centerView: {
      Text("NavBar")
        .font(.title)
        .padding(.vertical, 20)
    } rightView: {
      Text("Save")
    }
    .injectSample()
  }
}

