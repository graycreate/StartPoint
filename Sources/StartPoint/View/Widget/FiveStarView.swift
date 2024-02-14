//
//  FiveStarView.swift
//  ULPB
//
//  Created by Gray on 2024/1/27.
//

import SwiftUI

public struct FiveStarView: View {
  let count: Int = 5
  var color: Color?
  
 public init(color: Color? = nil) {
    self.color = color
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      ForEach (0..<count) { index in
        Image(systemName: "star.fill")
          .font(.callout)
          .foregroundColor(color ?? Color.accentColor)
      }
    }
  }
}

#Preview {
  FiveStarView()
}
