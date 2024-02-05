//
//  TextWriter.swift
//  ULPB
//
//  Created by Gray on 2024/1/29.
//

import SwiftUI

public struct RichTypewriterView: View {
  let attText: AttributedString
  var startTyping: Bool? = nil
  var keepBounds: Bool = false
  var hapic: Bool = false
  
  public init(_ attText: AttributedString = " ",
              startTyping: Bool? = nil,
              keepBounds: Bool = false,
              hapic: Bool = false
  ) {
    self.attText = attText
    self.startTyping = startTyping
    self.animatedText = attText
    self.typingTask = typingTask
    self.keepBounds = keepBounds
    self.hapic = hapic
  }
  
  public init(_ text: String,
              startTyping: Bool? = nil,
              keepBounds: Bool = false,
              hapic: Bool = false
  ) {
    self.attText = AttributedString(text)
    self.startTyping = startTyping
    self.animatedText = attText
    self.typingTask = typingTask
    self.keepBounds = keepBounds
    self.hapic = hapic
  }
  
  private let typingDelay: Duration = .milliseconds(50)
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
        try await Task.sleep(for: typingDelay)
        
        // Advance the index, character by character
        index = animatedText.index(afterCharacter: index)
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
    attributedString[range].backgroundColor = .red
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
