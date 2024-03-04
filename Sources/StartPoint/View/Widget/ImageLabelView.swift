//
//  ImageLabelView.swift
//  
//
//  Created by GARY on 2023/3/11.
//

import SwiftUI


public struct ImageLabelView<RightView: View>: View {
  var systemName: String = ""
  var text: String = ""
  var values: [String] = []
  var rightIcon: String
  var rightView: RightView?
  var type: SectionItemType
  
  public init(systemName: String = "",
       title: String = "",
       values: [String] = [],
       rightIcon: String = "chevron.forward",
       type: SectionItemType = .single,
       @ViewBuilder rightView: () -> RightView? = { EmptyView() }) {
    self.systemName = systemName
    self.text = title
    self.values = values
    self.rightIcon = rightIcon
    self.type = type
    self.rightView = rightView()
  }
  
  var multiValue: Bool {
    values.count > 1
  }
  
  var valueColor: Color {
    .labelColor.opacity(0.5)
  }
  
  public var body: some View {
    HStack {
      if systemName.notEmpty() {
        Image(systemName: systemName)
          .font(.system(size: 19, weight: .medium, design: .rounded))
          .foregroundColor(Color.labelColorWeak)
      }
      VStack(alignment: .leading, spacing: 2.4) {
        Text(text)
          .font(.system(size: 19, weight: .medium, design: .rounded))
          .foregroundColor(Color.labelColorWeak)
        if multiValue {
          Text(values.joined(separator: ", "))
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .multilineTextAlignment(.leading)
            .foregroundColor(valueColor)
            .greedyWidth(.leading)
        }
      }
      Spacer()
      if !multiValue {
        Text(values.first ?? .empty)
          .font(16, weight: .medium, design: .rounded)
          .lineLimit(1)
          .foregroundColor(valueColor)
      }
      rightView
      if rightIcon.notEmpty() {
        Image(systemName: rightIcon)
          .font(.system(size: 15, weight: .semibold, design: .rounded))
          .foregroundColor(valueColor)
      }
    }
    .animation(.easeInOut, value: multiValue)
    .frame(minHeight: 60)
    .padding(.horizontal, 12)
    .background(cardBGColor)
    .clip(radius: 22, corners: self.corners)
  }
  
  var corners: UIRectCorner {
    switch self.type {
      case .single: return .allCorners
      case .top: return [.topLeft, .topRight]
      case .middle: return []
      case .bottom: return [.bottomLeft, .bottomRight]
    }
  }
  
  fileprivate let cardBGColor = Color.white.adaptive(night: .gray.opacity(0.1))
  
  public enum SectionItemType {
    case top, middle, bottom, single
  }
  
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//      ImageLabelView()
//    }
//}
