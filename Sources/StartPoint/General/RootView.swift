//
//  RootView.swift
//  ULPB
//
//  Created by ghui on 2022/4/24.
//

import SwiftUI

public struct RootView<Content: View>: View {
    @EnvironmentObject private var store: BaseStore
    let content: Content
  
  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

    public var body: some View {
        ZStack {
          content
        }
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

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
      RootView {
        Text("TestView")
      }
        .injectSample(.sample)
    }
}
