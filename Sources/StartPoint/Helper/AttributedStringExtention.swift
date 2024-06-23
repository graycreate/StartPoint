//
//  AttributedString+.swift
//  ULPB
//
//  Created by Gray on 2024/2/6.
//

#if canImport(UIKit)

import Foundation
import SwiftUI

public extension AttributedString {
    func bold(_ font: Font? = nil) -> AttributedString {
        var attrStr = self
        let targetFont = font ?? self.font
        attrStr.runs.forEach { run in
          attrStr[run.range].font = targetFont?.bold()
        }
        return attrStr
    }
    
    func color(_ color: Color) -> AttributedString {
        var attrStr = self
        attrStr.runs.forEach { run in
            attrStr[run.range].foregroundColor = color
        }
        return attrStr
    }
    
    func underline() -> AttributedString {
        var attrStr = self
        attrStr.runs.forEach { run in
            attrStr[run.range].underlineStyle = .single
        }
        return attrStr
    }
    
    func italic(_ font: Font? = nil) -> AttributedString {
        let targetFont = font ?? self.font
        var attrStr = self
        attrStr.runs.forEach { run in
          attrStr[run.range].font = targetFont?.italic()
        }
        return attrStr
    }
    
    func fontSize(_ size: CGFloat) -> AttributedString {
        var attrStr = self
        attrStr.runs.forEach { run in
            attrStr[run.range].font = Font.system(size: size)
        }
        return attrStr
    }
    
    func backgroundColor(_ color: Color) -> AttributedString {
        var attrStr = self
        attrStr.runs.forEach { run in
            attrStr[run.range].backgroundColor = color
        }
        return attrStr
    }
    
    func strikethrough(_ active: Bool = true, color: Color? = nil) -> AttributedString {
        var attrStr = self
        attrStr.runs.forEach { run in
            attrStr[run.range].strikethroughStyle = active ? .single : nil
            if let color = color {
              attrStr[run.range].strikethroughColor = color.uiColor
            }
        }
        return attrStr
    }
  
}

public extension String {
    func bold(_ font: Font? = nil) -> AttributedString {
        AttributedString(self).bold(font)
    }
    
    func color(_ color: Color) -> AttributedString {
        AttributedString(self).color(color)
    }
    
    func underline() -> AttributedString {
        AttributedString(self).underline()
    }
    
    func italic() -> AttributedString {
        AttributedString(self).italic()
    }
    
    func fontSize(_ size: CGFloat) -> AttributedString {
        AttributedString(self).fontSize(size)
    }
    
    func backgroundColor(_ color: Color) -> AttributedString {
        AttributedString(self).backgroundColor(color)
    }
    
    func strikethrough(_ active: Bool = true, color: Color? = nil) -> AttributedString {
        AttributedString(self).strikethrough(active, color: color)
    }
    
}

public extension AttributedString {
  func notEmpty()-> Bool {
    return !self.characters.isEmpty
  }
}


struct AttributedStringExtentionPreview: PreviewProvider {
  static let attributedString = "This is a text".bold() + " with color".color(.red) + " and underline".underline().bold().color(.blue) + " strikethrough".strikethrough()
  
  static var previews: some View {
    Text(attributedString)
      .font(.title)
      .foregroundStyle(.cyan)
  }
}

#endif
