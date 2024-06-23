//
//  VisualEffectBlur.swift
//  V2er
//
//  Created by Seth on 2020/6/15.
//  Copyright © 2020 lessmore.io. All rights reserved.
//

//import Foundation
import SwiftUI

#if canImport(UIKit)
struct VEBlur: UIViewRepresentable {
  var style: UIBlurEffect.Style = .systemMaterial
  var bg: Color = .clear
  var alpha: CGFloat = 1.0

    func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
      effectView.backgroundColor = bg.uiColor
      effectView.alpha = self.alpha
        return effectView
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
        uiView.backgroundColor = bg.uiColor
        uiView.alpha = self.alpha
    }
    
    // mark: bug here
//    var blurStyle: UIBlurEffect.Style = .systemThinMaterial
//        var vibrancyStyle: UIVibrancyEffectStyle = .label
//
//        func makeUIView(context: Context) -> UIVisualEffectView {
//            let effect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: blurStyle), style: vibrancyStyle)
//            let effectView = UIVisualEffectView(effect: effect)
//            return effectView
//        }
//
//        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
//            uiView.effect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: blurStyle), style: vibrancyStyle)
//        }
    
}
#endif
