////
////  RootView.swift
////  ULPB
////
////  Created by ghui on 2022/4/24.
////
//
//import SwiftUI
//
//public struct InnelRootView<Content: View>: View {
//    @EnvironmentObject private var store: BaseStore
//    let content: Content
//
//  public init(@ViewBuilder content: () -> Content) {
//    self.content = content()
//  }
//
//    public var body: some View {
//
//
//    }
//}
//
//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//      InnelRootView {
//        Text("TestView")
//      }
//        .injectSample(.sample)
//    }
//}
