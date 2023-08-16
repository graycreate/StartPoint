//
//  Colors.swift
//  
//
//  Created by GARY on 2023/1/7.
//

import SwiftUI


extension Color {
  
  public static let defaultPanel: [Color] = [
    .hex("#54d6fb"), .hex("#74a6ff"), .hex("#b08dfc"), .hex("#d257fd"), .hex("#ee719e"), .hex("#ff8e83"),
    .hex("#ffa57d"), .hex("#fec679"), .hex("#fed976"), .hex("#fff893"), .hex("#b1dc8b"), .hex("#b1c0ab"),
    .hex("#9eb7bd"), .hex("#b7a7b7"), .hex("#bbb1a6"), .hex("#643c15"), .hex("#5e5e5e"), .clear
  ]
  
  public static var randomColor: Color {
    defaultPanel[0...6].randomElement()!
  }
  
  public static let labelColor: Color = UIColor.label.color()
  public static let labelColorWeak: Color = UIColor.label.color().opacity(0.86)
  public static let valueColor: Color = labelColor.opacity(0.5)
  
  
}
