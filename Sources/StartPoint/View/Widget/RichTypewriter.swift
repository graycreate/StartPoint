//
//  TextWriter.swift
//  ULPB
//
//  Created by Gray on 2024/1/29.
//

import SwiftUI

public struct RichTypewriterView: View {
  var attText: AttributedString
  var startTyping: Bool? = nil
  var keepBounds: Bool = false
  var hapic: Bool = false
  var speed: CGFloat = 1.0
  let onComplete: () -> Void
  
  public init(_ attText: AttributedString? = " ",
              startTyping: Bool? = nil,
              keepBounds: Bool = false,
              hapic: Bool = false,
              speed: CGFloat = 1.0,
              onComplete: @escaping () -> Void = {}
  ) {
    self.attText = attText ?? " "
    self.startTyping = startTyping
    self.keepBounds = keepBounds
    self.hapic = hapic
    self.speed = speed
    self.onComplete = onComplete
  }
  
  public init(_ text: String,
              startTyping: Bool? = nil,
              keepBounds: Bool = false,
              hapic: Bool = false,
              speed: CGFloat = 1.0
  ) {
    self.init(AttributedString(text), startTyping: startTyping, keepBounds: keepBounds, hapic: hapic, speed: speed)
  }
  

  @State private var animatedText: AttributedString = " "
  @State private var typingTask: Task<Void, Error>?
  
  public var body: some View {
    
    let typer = Text(animatedText)
      .onAppear() {
        if startTyping == nil {
          animateText()
        }
      }
      .onChange(of: attText) { _ in
        log("text changed: \(attText)")
        animateText()
      }
      .onChange(of: self.startTyping) { startTyping in
        if startTyping == true {
          log("startTyping: \(true)")
          animateText()
        }
      }
    
    if self.keepBounds {
      let baseBoundView = Text(self.attText)
        .opacity(0)
      baseBoundView
        .overlay {
          typer
        }
    } else {
      typer
    }
  }
  
  private func animateText() {
    log("animateText()")
    typingTask?.cancel()
    
    typingTask = Task {
      self.animatedText = self.attText
      self.animatedText.setAttributes(AttributeContainer().foregroundColor(.clear))
      
      log("animateText.length: \(animatedText)")
      var index = animatedText.startIndex
      while index < animatedText.endIndex {
        try Task.checkCancellation()
        // Update the style
        let range = animatedText.startIndex...index
        copyAttributes(range: range)
        if self.hapic {
          hapticFeedback(.light)
        }
        // Wait
        let typingDelay: Duration = .milliseconds(80 / self.speed)
        try await Task.sleep(for: typingDelay)
        
        // Advance the index, character by character
        index = animatedText.index(afterCharacter: index)
      }
      delay {
        self.onComplete()
      }
    }
  }
  
  private func copyAttributes(range: ClosedRange<AttributedString.Index>) {
    for run in self.attText[range].runs {
      let runRange = run.range
      let attributes = run.attributes
      self.animatedText[runRange].setAttributes(attributes)
    }
  }
  
  
}

// Usage example
struct RichTypewriterViewPreview: PreviewProvider {
  static var text: AttributedString {
    var attributedString = AttributedString("Hello, Twitter! This is a typewriter animation.")
    let range = attributedString.range(of: "typewriter")!
    attributedString[range].foregroundColor = .red
    return attributedString
  }
  @State static var startTyping = false
  
  static var previews: some View {
    VStack {
      Text(self.text)
      RichTypewriterView(text, startTyping: nil)
        .font(.title)
        .padding()
        .forceClickable()
        .background(.blue.opacity(0.1))
        .debug()
        .onTapGesture {
          Self.startTyping = true
          log("onTapGesture: startTyping: \(Self.startTyping)")
        }
    }
  }
}
