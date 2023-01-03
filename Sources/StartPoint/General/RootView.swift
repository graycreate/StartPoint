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
        GeneralState.shared.rootWindow = window
        window!.rootViewController = RootHostingController(rootView: innerRootView)
      }
  }
  
  @ViewBuilder
  var innerRootView: some View {
    ZStack {
      content
        .preferredColorScheme(.none)
        .onAppear {
          GeneralState.shared.isPortrait = OritentionMode.isPortraitFromInit
        }
        .background {
          GeometryReader { geo in
            Color.clear
              .onRotate { isPortrait in
                runInMain {
                  withAnimation {
                    GeneralState.shared.isPortrait = isPortrait
                  }
                  GeneralState.shared.safeArea = geo.safeAreaInsets
                  log("------ SafeArea: \(GeneralState.shared.safeArea) , isPortrait: \(isPortrait)")
                }
              }
          }
        }
    }
    .environmentObject(GeneralState.shared)
    .preferredColorScheme(.dark)
  }
  
}

