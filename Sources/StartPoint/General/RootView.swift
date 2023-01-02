//
//  RootView.swift
//  ULPB
//
//  Created by ghui on 2022/3/19.
//

import Foundation
import SwiftUI

public struct RootView<Content: View> : View {
  @EnvironmentObject private var store: BaseStore
  var content: Content
  
  public init(@ViewBuilder content: ()-> Content) {
    self.content = content()
  }
  
  public var body:some View {
    EmptyView()
      .withHostingWindow { window in
        window!.rootViewController = RootHostingController(rootView: innerRootView)
        BaseStore.shared.rootWindow = window
      }
  }
  
  @ViewBuilder
  var innerRootView: some View {
    ZStack {
      content
        .background {
          GeometryReader { geo in
            Color.clear
              .onRotate { isPortrait in
                runInMain {
                  store.safeArea = geo.safeAreaInsets
                  log("------ SafeArea: \(store.safeArea) , isPortrait: \(isPortrait)")
                }
              }
          }
        }
    }
  }
  
}

