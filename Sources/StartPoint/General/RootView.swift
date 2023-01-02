//
//  RootView.swift
//  ULPB
//
//  Created by ghui on 2022/3/19.
//

import Foundation
import SwiftUI

public struct RootView<Content: View> : View {
  var content: Content
  
  public init(@ViewBuilder content: ()-> Content) {
    self.content = content()
  }
  
  public var body:some View {
    EmptyView()
      .withHostingWindow { window in
        BaseStore.shared.rootWindow = window
        window!.rootViewController = RootHostingController(rootView: innerRootView)
      }
  }
  
  @ViewBuilder
  var innerRootView: some View {
    ZStack {
      content
        .onAppear {
          BaseStore.shared.deviceState.isPortrait = OritentionMode.isPortraitFromInit
        }
        .background {
          GeometryReader { geo in
            Color.clear
              .onRotate { isPortrait in
                runInMain {
                  withAnimation {
                    BaseStore.shared.deviceState.isPortrait = isPortrait
                  }
                  BaseStore.shared.safeArea = geo.safeAreaInsets
                  log("------ SafeArea: \(BaseStore.shared.safeArea) , isPortrait: \(isPortrait)")
                }
              }
          }
        }
    }
  }
  
}

