//
//  SegmentView.swift
//
//
//  Created by GARY on 2023/7/26.
//

import SwiftUI

public struct SegmentedView: View  {
  @Binding public var selection: String
  public var options: [String]
  public var corner: CGFloat
  public var textSize: CGFloat = 17
  /// Private
  @Namespace private var namespace
  @State private var childHeight: CGFloat = 0
  private let extraPadding = 2.0
  
  public init(selection: Binding<String>, options: [String], corner: CGFloat = 99.0, textSize: CGFloat = 17) {
    self._selection = selection
    self.options = options
    self.corner = corner
    self.textSize = textSize
  }
  
  public var body: some View {
    GeometryReader { geo in
      HStack(spacing: 0) {
        ForEach(options, id: \.self) { option in
          Button {
            withAnimation {
              self.selection = option
            }
          } label: {
            ItemView(text: option, isSelected: option == self.selection, namespace: self.namespace, width: (geo.size.width - extraPadding * 2) / CGFloat(options.count), textSize: self.textSize, corner: self.corner)
              .readSize { size in
                self.childHeight = size.height
              }
          }
          .buttonStyle(ShrunkButton())
        }
      }
      .padding(extraPadding)
      .background {
        Color.hex(0x767680, alpha: 0.08)
          .night(.hex(0x767680, alpha: 0.24))
      }
      .clip(radius: self.corner)
    }
    .frame(height: self.childHeight + extraPadding * 2)
  }
  
}


fileprivate struct ItemView: View {
  var text: String
  var isSelected: Bool
  var namespace: Namespace.ID
  var width: CGFloat
  var textSize: CGFloat
  var corner: CGFloat
  
  var body: some View {
    Text(text)
      .font(.system(size: self.textSize, weight: .medium, design: .rounded))
      .opacity(self.isSelected ? 1.0 : 0.8)
      .padding(.horizontal, 16)
      .padding(.vertical, 14)
      .frame(width: self.width)
      .background {
        if isSelected {
          Color.white.night(.hex(0x636366))
            .clipCorner(self.corner)
            .matchedGeometryEffect(id: "item", in: namespace)
        }
      }
      .forceClickable()
  }
}

#Preview {
  @State var selection: String = "111"
  @State var options = ["111", "222", "333"]
  
  return VStack {
    SegmentedView(selection: $selection, options: options, corner: 19)
      .colorScheme(.light)
      .padding()
      .background(.white)
    
    SegmentedView(selection: $selection, options: options, corner: 19)
      .colorScheme(.dark)
      .padding()
      .background(.black.opacity(0.85))
  }
  .padding()
}

