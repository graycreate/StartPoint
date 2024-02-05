//
//  NavBar.swift
//  DaysTill
//
//  Created by GARY on 2022/12/12.
//

import SwiftUI

public struct NavBar<LeftView, CenterView, RightView, BottomView>: View where LeftView: View, CenterView: View, RightView: View, BottomView: View {
  
  let leftView: LeftView?
  let centerView: CenterView
  let rightView: RightView?
  let bottomView: BottomView?
  
  public init(@ViewBuilder leftView: () -> LeftView = { EmptyView() } ,
              @ViewBuilder centerView: () -> CenterView = { Text("Title")},
              @ViewBuilder rightView: () -> RightView = { EmptyView() },
              @ViewBuilder bottomView: () -> BottomView = { EmptyView() }) {
    self.leftView = leftView()
    self.centerView = centerView()
    self.rightView = rightView()
    self.bottomView = bottomView()
  }
  
  public var body: some View {
    NavbarView {
      VStack(spacing: 0) {
        ZStack {
          HStack(alignment: .center, spacing: 0) {
            leftView
            Spacer()
            rightView
          }
          HStack(alignment: .center, spacing: 0) {
            centerView
          }
        }
        bottomView
      }
    }
  }
}

public struct NavbarView<Content: View>: View {
  @EnvironmentObject private var state: GeneralState
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
      Color.clear.frame(height: state.safeArea.top)
      HStack(alignment: .center, spacing: 0) {
        self.content
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
    } bottomView: {
      Text("BottomView")
    }
    .environmentObject(GeneralState.sample)
  }
}

