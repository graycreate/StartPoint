//
//  Colors.swift
//  DaysTill
//
//  Created by Gray on 2022/12/12.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
public typealias PlatformColor = UIColor
#elseif os(macOS)
import AppKit
public typealias PlatformColor = NSColor
#endif

public extension Color {
  private init(_ hex: Int, a: CGFloat = 1.0) {
    self.init(PlatformColor(hex: hex, alpha: a))
  }

  init(_ lightModeColor: @escaping @autoclosure () -> Color,
       dark darkModeColor: @escaping @autoclosure () -> Color) {
    self.init(PlatformColor(light: PlatformColor(lightModeColor()), dark: PlatformColor(darkModeColor())))
  }

  static func hex(_ hex: String, alpha: CGFloat = 1.0) -> Color {
    return PlatformColor.init(hex, alpha: alpha).color()
  }

  static func hex(_ hex: Int, alpha: CGFloat = 1.0) -> Color {
    return Color(hex, a: alpha)
  }

  static func hsb(_ h: CGFloat, _ s: CGFloat = 0.5, _ b: CGFloat = 1.0, a: CGFloat = 1.0) -> Color {
    Color(hue: h, saturation: s, brightness: b, opacity: a)
  }

  /// Scale the brightness of the color
  func scale(b factor: CGFloat) -> Color {
    let newB = self.hsba.b * factor
    return Color(hue: self.hsba.h, saturation: self.hsba.s, brightness: newB, opacity: self.hsba.a)
  }

  func darker(b: CGFloat = 0.95) -> Color {
    self.scale(b: b)
  }

  func lighter() -> Color {
    self.scale(b: 1.1)
  }

  func adaptive(night: Color? = nil, alpha: CGFloat = 0.85)-> Color {
    Color(self , dark: night ?? self.opacity(alpha))
  }

  func night(_ color: Color? = nil, alpha: CGFloat = 0.85) -> Color {
    self.adaptive(night: color, alpha: alpha)
  }

  func shape(_ hex: Int, alpha: CGFloat = 1.0) -> some View {
    return Self.hex(hex, alpha: alpha).frame(width: .infinity)
  }


  func shape() -> some View {
    self.frame(width: .infinity)
  }

  static let floatButtonBg = Color(.hex(0xffffff, alpha: 0.45) , dark: .hex(0x000000, alpha: 0.25))
//  static let border = hex(0xE8E8E8, alpha: 0.8).adaptive(night: .hex(0x212121))
//  static let border = hex(0xE8E8E8, alpha: 0.8).adaptive(night: .hex(0x212121))
  static let border = Color.secondary.opacity(0.12).adaptive()
  static let borderAccent = Color.secondary.opacity(0.4).night(alpha: 0.3)
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
  //  static let primaryColor = Color.black.adaptive(dark: .white)
  //  static let secondary = Color.black.adaptive(dark: .white)
  //  static let accent = Color.black.adaptive(dark: .white)
  //  static let accentDisabled = Color.gray.adaptive()
  //  static let deAccent = Color.white.adaptive(dark: .black)
  //  static let adaptiveWhite = Color.white.adaptive()

  //  static let bg = hex(0xF5F5F5)
  static let bg = hex(0xededed)
  static let titleGradStartColor = hex(0xE6B800)
  static let titleGradEndColor = hex(0x45D9D5)

  var platformColor: PlatformColor {
    return PlatformColor(self)
  }

  var hsba: HSBA {
    return self.platformColor.hsba
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

  @discardableResult
  mutating func changeHSB(hue: CGFloat? = nil, s: CGFloat? = nil, b: CGFloat? = nil, a: CGFloat? = nil) -> Color {
    let hsba = self.hsba
    self = .hsb(hue ?? hsba.h, s ?? hsba.s, b ?? hsba.b, a: a ?? hsba.a)
    return self
  }

}



public extension PlatformColor {
  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    let components = (
      R: CGFloat((hex >> 16) & 0xff) / 255,
      G: CGFloat((hex >> 08) & 0xff) / 255,
      B: CGFloat((hex >> 00) & 0xff) / 255
    )
    self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
  }

  convenience init(
    light lightModeColor: @escaping @autoclosure () -> PlatformColor,
    dark darkModeColor: @escaping @autoclosure () -> PlatformColor) {
#if os(iOS)
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
#elseif os(macOS)
      self.init(name: nil) { appearance in
        if appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
          return darkModeColor()
        } else {
          return lightModeColor()
        }
      }
#endif
    }

  convenience init(_ hex: String, alpha: CGFloat? = nil) {
      var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

      if cString.hasPrefix("#") { cString.removeFirst() }

      var rgbValue: UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)

      let r, g, b, a: CGFloat
      if cString.count == 8 { // ARGB格式，包括透明度
          a = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
          r = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
          g = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
          b = CGFloat(rgbValue & 0x000000FF) / 255.0
      } else { // RGB格式，不包括透明度
          r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
          g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
          b = CGFloat(rgbValue & 0x0000FF) / 255.0
          a = alpha ?? 1.0 // 使用默认透明度值
      }

      self.init(red: r, green: g, blue: b, alpha: a)
  }



  func color() -> Color {
    return Color(self)
  }

  var hsba: HSBA {
    var hsba = HSBA.clear
#if os(iOS)
    self.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
#elseif os(macOS)
    if let rgbColor = self.usingColorSpace(.sRGB) {
      rgbColor.getHue(&hsba.h, saturation: &hsba.s, brightness: &hsba.b, alpha: &hsba.a)
    }
#endif
    return hsba
  }

  var hex: String {
    cgColor.toHex() ?? ""
  }

  var p3Hex: String {
    guard let displayP3Color = self.cgColor.converted(to: CGColorSpace(name: CGColorSpace.displayP3)!, intent: .defaultIntent, options: nil) else {
      return ""
    }
    return displayP3Color.toHex() ?? ""
  }

}

public extension String? {
  var color: Color {
    guard let hex = self else {
      return .clear
    }
    return .hex(hex)
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
  var hex: String {
    self.platformColor.hex
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

extension PlatformColor {

  func isLight(threshold: Double = 0.5) -> Bool {
    self.getLightBrightness().0
  }

  // Whether this color is a light color
  func getLightBrightness(threshold: Double = 0.5) -> (Bool, Double) {
    let originalCGColor = self.cgColor
    // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
    // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
    let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
    guard let components = RGBCGColor?.components else {
      return (false, 0)
    }
    guard components.count >= 3 else {
      return (false, 0)
    }

    let brightness = Double(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
    let isLight = (brightness > threshold)
    return (isLight, brightness)
  }

  func relativeLuminance() -> CGFloat {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
#if os(iOS)
    self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
#elseif os(macOS)
    if let rgbColor = self.usingColorSpace(.sRGB) {
      rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
#endif

    let components = [red, green, blue].map { (component: CGFloat) -> CGFloat in
      return (component <= 0.03928) ? (component / 12.92) : pow((component + 0.055) / 1.055, 2.4)
    }

    return 0.2126 * components[0] + 0.7152 * components[1] + 0.0722 * components[2]
  }

  func contrastRatio(with color: PlatformColor) -> CGFloat {
    let luminance1 = self.relativeLuminance()
    let luminance2 = color.relativeLuminance()
    let brighter = max(luminance1, luminance2)
    let darker = min(luminance1, luminance2)
    return (brighter + 0.05) / (darker + 0.05)
  }



}

extension Color {
  func isLight(threshold: Double = 0.5)-> Bool {
    self.platformColor.isLight(threshold: threshold)
  }

  public func adjustedTextColor(minimumContrastRatio: Double = 2) -> Color {
    // Assume the default text colors are white and black
    let whiteText: Color = .white
    let blackText: Color = .black

    // Calculate the contrast ratio with white and black text
    let contrastRatioWithWhite = self.platformColor.contrastRatio(with: whiteText.platformColor)
    let contrastRatioWithBlack = self.platformColor.contrastRatio(with: blackText.platformColor)

    if contrastRatioWithWhite >= minimumContrastRatio {
      let diff = contrastRatioWithWhite / minimumContrastRatio
      let opacity = max(0.9, 6 / diff)
      return whiteText.opacity(opacity)
    } else if contrastRatioWithBlack >= minimumContrastRatio {
      let diff = contrastRatioWithBlack / minimumContrastRatio
      let opacity = max(0.8, 4 / diff)
      return blackText.opacity(opacity)
    } else {
      // If neither color meets the minimum contrast ratio,
      // return the one with the higher contrast ratio
      return (contrastRatioWithWhite > contrastRatioWithBlack) ? whiteText : blackText
    }
  }


//  public func adjustedTextColor(threshold: Double = 0.5) -> Color {
//    let (isLight, brightness) = self.platformColor.getLightBrightness(threshold: threshold)
//    if isLight {
//      return .black.opacity(1 - brightness * 0.36)
//    } else {
//      return .white.opacity(min (1, brightness * 3))
//    }
//  }

}


extension CGColor {
  func toHex() -> String? {
    guard let components = components else { return nil }

    if components.count == 2 {
      let value = components[0]
      let alpha = components[1]
      // RGBA
      return String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(alpha*255)), lroundf(Float(value*255)), lroundf(Float(value*255)), lroundf(Float(value*255)))
    }

    guard components.count == 4 else { return nil }

    let red   = components[0]
    let green = components[1]
    let blue  = components[2]
    let alpa  = components[3]

    let hexString = String(format: "#%02lX%02lX%02lX%02lX",lroundf(Float(alpa*255)), lroundf(Float(red*255)), lroundf(Float(green*255)), lroundf(Float(blue*255)))

    return hexString
  }
}


struct Color_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      Color.black.frame(width: 100, height: 100)
      Color.hex(0xFBFBFB).frame(width: 100, height: 100)
      Color.hex(0x00FF00, alpha: 0.2)
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
