//
//  RootView.swift
//  ULPB
//
//  Created by ghui on 2022/3/19.
//

import Foundation
import SwiftUI

/// ZStack with some extra features
public struct RootView<Content: View> : View {
  var content: Content
  
  public init(@ViewBuilder content: ()-> Content) {
    self.content = content()
  }
  
  public var body:some View {
    ZStack {
      content
        .background {
          GeometryReader { geo in
            Color.clear
              .onAppear {
                GeneralState.shared.isPortrait = OritentionMode.isPortraitFromInit
                GeneralState.shared.safeArea = geo.safeAreaInsets
              }
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
  }
  
}

