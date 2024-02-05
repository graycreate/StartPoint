//
//  TextWriter.swift
//  ULPB
//
//  Created by Gray on 2024/1/29.
//

import SwiftUI

public struct TypewriterView: View {
  let text: String
  var startTyping: Bool? = nil
  var keepBounds: Bool = false
  var hapic: Bool = false
  
  public init(_ text: String,
              startTyping: Bool? = nil,
              keepBounds: Bool = false,
              hapic: Bool = false
  ) {
    self.text = text
    self.startTyping = startTyping
    self.animatedText = animatedText
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
      .onChange(of: text) { _ in
        log(tag: "onboard","text changed: \(text)")
        animateText()
      }
      .onChange(of: self.startTyping) { startTyping in
        if startTyping == true {
          log(tag: "onboard","startTyping: \(true)")
          animateText()
        }
      }
    
    if self.keepBounds {
      let baseBoundView = Text(self.text)
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
    typingTask?.cancel()
    
    typingTask = Task {
      let defaultAttributes = AttributeContainer()
      animatedText = AttributedString(text,
                                      attributes: defaultAttributes.foregroundColor(.clear)
      )
      
      var index = animatedText.startIndex
      while index < animatedText.endIndex {
        try Task.checkCancellation()
        
        // Update the style
        animatedText[animatedText.startIndex...index]
          .setAttributes(defaultAttributes)
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
}

// Usage example
struct TypewriterViewPreview: PreviewProvider {
  @State static var text = "Hello, Twitter! This is a typewriter animation."
  @State static var startTyping = true
  
  static var previews: some View {
    TypewriterView(text, startTyping: nil)
      .font(.title)
      .padding()
      .forceClickable()
      .debug()
      .onTapGesture {
        Self.startTyping.toggle()
      }
  }
}
