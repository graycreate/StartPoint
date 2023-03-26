//
//  SheetPageIndicator.swift
//  Remember
//
//  Created by GARY on 2022/12/22.
//

import SwiftUI

public struct DragIndicator: View {
  var color: Color = .labelColor
  var progress: CGFloat = 0.0
  var length: CGFloat = 40
  
  public init(color: Color = .labelColor.opacity(0.5), progress: CGFloat = 0.0, length: CGFloat = 40) {
    self.color = color
    self.progress = max(0, progress)
    self.length = length
  }
  
  var height: CGFloat {
    length / 4
  }
  
  var width: CGFloat {
    length
  }
  
  public var body: some View {
    Path { path in
      path.move(to: CGPoint(x: 0.00, y: 0))
      path.addLine(to: CGPoint(x: width / 2, y: min(progress , 1.0) * height))
      path.addLine(to: CGPoint(x: width, y: 0))
    }
    .stroke(color, style: StrokeStyle(lineWidth: 5.5, lineCap: .round, lineJoin: .round))
    .frame(width: length, height: height)
    // TODO - Add visual effect to stroke
  }
}

struct SheetPageIndicator_Previews: PreviewProvider {
  static var previews: some View {
    DragIndicator(progress: 1.0)
  }
}
