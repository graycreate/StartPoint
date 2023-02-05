//
//  Colors.swift
//  RememDays
//
//  Created by GARY on 2022/12/12.
//

import Foundation
import SwiftUI

public extension Color {
  private init(_ hex: Int, a: CGFloat = 1.0) {
    self.init(UIColor(hex: hex, alpha: a))
  }
  
  init(_ lightModeColor: @escaping @autoclosure () -> Color,
       dark darkModeColor: @escaping @autoclosure () -> Color) {
    self.init(UIColor(light: UIColor(lightModeColor()), dark: UIColor(darkModeColor())))
  }
  
  static func hex(_ hex: String, alpha: CGFloat = 1.0) -> Color {
    return UIColor.init(hex, alpha: alpha).color()
  }
  
  static func hex(_ hex: Int, alpha: CGFloat = 1.0) -> Color {
    return Color(hex, a: alpha)
  }
  
  static func hsb(_ h: CGFloat, s: CGFloat = 0.5, b: CGFloat = 1.0, a: CGFloat = 1.0) -> Color {
    Color(hue: h, saturation: s, brightness: b, opacity: a)
  }
  
  func adaptive(dark: Color? = nil)-> Color {
    Color(self , dark: dark ?? self.opacity(0.8))
  }
  
  func shape(_ hex: Int, alpha: CGFloat = 1.0) -> some View {
    return Self.hex(hex, alpha: alpha).frame(width: .infinity)
  }
  
  
  public func shape() -> some View {
    self.frame(width: .infinity)
  }
  
  static let floatButtonBg = Color(.hex(0xffffff, alpha: 0.45) , dark: .hex(0x000000, alpha: 0.25))
  static let border = hex(0xE8E8E8, alpha: 0.8).adaptive(dark: .hex(0x212121))
  static let lightGray = hex(0xF5F5F5)
  static let almostClear = hex(0xFFFFFF, alpha: 0.000001)
  static let debugColor = hex(0xFF0000, alpha: 0.1)
  //    static let bodyText = hex(0x555555)
  static let bodyText = Color(.hex(0x000000, alpha: 0.75) , dark: .gray)
  static let tintColor = hex(0xf19937)
  //    static let bgColor = hex(0xF2F1F5)
  static let bgLight = hex(0xF2F1F5)
  static let bgDark = Color.black
  static let bgColor = Color(.hex(0xF2F1F5), dark: Color.black)
  static let itemBg: Color = .white
  static let dim = hex(0x000000, alpha: 0.6)
  //    static let url = hex(0x60c2d4)
  static let url = hex(0x778087)
  static let greenTint = hex(0x7AB757)
  static let testColor = Color(.hex(0xff00ff), dark: .hex(0x00ffff))
  static let light = Color(.hex(0xffffff), dark: .hex(0x1c1c1e))
  static let shadow = Color(Color.gray.opacity(0.5), dark: Color.clear)
  //    static let accent = Color(Color.orange, dark: Color.orange.opacity(0.8))
  //    static let testColor = adaptive(.hex(0xff00ff), dark: .hex(0x00ff00))
  
  static let articlePracticedColor = Color(.black , dark: .black.opacity(0.8))
  static let articleUnPracticeColor = Color(.black.opacity(0.4) , dark: .black.opacity(0.4))
  
  
  // New Color
  static let primaryColor = Color.black.adaptive(dark: .white)
  static let secondary = Color.black.adaptive(dark: .white)
  static let accent = Color.black.adaptive(dark: .white)
  static let accentDisabled = Color.gray.adaptive()
  static let deAccent = Color.white.adaptive(dark: .black)
  static let adaptiveWhite = Color.white.adaptive()
  
  //  static let bg = hex(0xF5F5F5)
  static let bg = hex(0xededed)
  static let titleGradStartColor = hex(0xEDC72F)
  static let titleGradEndColor = hex(0x45D9D5)
  
  var uiColor: UIColor {
    return UIColor(self)
  }
  
  var hsba: HSBA {
    return self.uiColor.hsba
  }
  
  var hue: CGFloat {
    self.hsba.h
  }
  
  var s: CGFloat {
    self.hsba.s
  }
  
  var b: CGFloat {
    self.hsba.b
  }
  
  var a: CGFloat {
    self.hsba.a
  }
  
  mutating func changeHSB(hue: CGFloat? = nil, s: CGFloat? = nil, b: CGFloat? = nil, a: CGFloat? = nil) {
    let hsba = self.hsba
    self = .hsb(hue ?? hsba.h, s: s ?? hsba.s, b: b ?? hsba.b, a: a ?? hsba.a)
  }
  
}



public extension UIColor {
  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    let components = (
      R: CGFloat((hex >> 16) & 0xff) / 255,
      G: CGFloat((hex >> 08) & 0xff) / 255,
      B: CGFloat((hex >> 00) & 0xff) / 255
    )
    self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
  }
  
  convenience init(
    light lightModeColor: @escaping @autoclosure () -> UIColor,
    dark darkModeColor: @escaping @autoclosure () -> UIColor) {
      self.init { traitCollection in
        switch traitCollection.userInterfaceStyle {
          case .light:
            return lightModeColor()
          case .dark:
            return darkModeColor()
          @unknown default:
            return lightModeColor()
        }
      }
    }
  
  convenience init(_ hex: String, alpha: CGFloat = 1.0) {
      var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
      
      if cString.hasPrefix("#") { cString.removeFirst() }
      
      if cString.count != 6 {
        self.init("ff0000") // return red color for wrong hex input
        return
      }
      
      var rgbValue: UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)
      
      self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha)
    }
  
  func color() -> Color {
    return Color(self)
  }
  
  var hsba: HSBA {
    var hsba = HSBA.clear
    self.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
    return hsba
  }
  
}

public extension String? {
  var color: Color {
    return .hex(self ?? "#000000")
  }
}

public extension String {
  var color: Color {
    return .hex(self)
  }
}

public extension Int {
  var color: Color {
    return .hex(self)
  }
  
  var int64: Int64 {
    Int64(self)
  }
}

public extension Int64 {
  var int: Int {
    Int(truncatingIfNeeded: self)
  }
  
  var color: Color {
    return self.int.color
  }
  
}

public extension Color {
  @available(iOS 15, *)
  var gradient: LinearGradient {
    return LinearGradient(colors: [self], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
  }
}

public struct HSBA {
  public var h: CGFloat
  public var s: CGFloat
  public var b: CGFloat
  public var a: CGFloat
  
  public static var clear: HSBA {
    return HSBA(h: 0, s: 0, b: 0, a: 0)
  }
}



struct Color_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      Color.black.frame(width: 100, height: 100)
      Color.hex(0xFBFBFB).frame(width: 100, height: 100)
      Color.hex(0x00FF00, alpha: 0.2)
        .frame(width: 100, height: 100)
      Color.red.gradient
        .frame(width: 100, height: 100)
      Color.hex(0xFF00FF).frame(width: 100, height: 100)
      Color.tintColor.frame(width: 100, height: 100)
      Color.lightGray.frame(width: 100, height: 100)
      Color.border.frame(width: 100, height: 100).opacity(0.5)
      
      Color.testColor.frame(width: 100, height: 100)
        .colorScheme(.dark)
    }
    
  }
}
