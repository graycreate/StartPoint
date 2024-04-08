//
//  ImageLabelView.swift
//  
//
//  Created by Gray on 2023/3/11.
//

import SwiftUI


@available(iOS 17.0, *)
public struct ImageLabelView<BadgeView: View, RightView: View>: View {
  var systemName: String = ""
  var text: LocalizedStringKey = ""
  var values: [String] = []
  var rightIcon: String
  var rightView: RightView?
  var badgeView: BadgeView?
  var type: SectionItemType
  var radius: CGFloat = 22
  
  private let strokeSize = 1.0
  
  public init(systemName: String = "",
       title: LocalizedStringKey = "",
       values: [String] = [],
       rightIcon: String = "chevron.forward",
       type: SectionItemType = .single,
       radius: CGFloat = 22,
       @ViewBuilder rightView: () -> RightView? = { EmptyView() },
       @ViewBuilder badgeView: () -> BadgeView? = { EmptyView() }
  ) {
    self.systemName = systemName
    self.text = title
    self.values = values
    self.rightIcon = rightIcon
    self.type = type
    self.radius = radius
    self.rightView = rightView()
    self.badgeView = badgeView()
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
        HStack {
          Text(text)
            .font(.system(size: 19, weight: .medium, design: .rounded))
            .lineLimit(1)
            .foregroundColor(Color.labelColorWeak)
          self.badgeView
        }
        if multiValue {
          let valueText: String = values.filter{ $0.notEmpty() }.joined(separator: ", ")
          Text(valueText)
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
        .fixedSize(horizontal: true, vertical: false)
      if rightIcon.notEmpty() {
        Image(systemName: rightIcon)
          .font(.system(size: 15, weight: .semibold, design: .rounded))
          .foregroundColor(valueColor)
      }
    }
    .animation(.easeInOut, value: multiValue)
    .frame(minHeight: 60)
    .padding(.horizontal, 12)
    .background(self.cardBGColor)
    .clip(radius: self.type == .single ? 18 : self.radius, corners: self.corners, strokeSize: self.strokeSize)
    .overlay(alignment: .top) {
      if self.type == .middle || self.type == .bottom {
        self.cardBGColor
          .frame(height: self.strokeSize)
          .padding(.horizontal, self.strokeSize)
      }
    }
  }
  
  var corners: UIRectCorner {
    switch self.type {
      case .single: return .allCorners
      case .top: return [.topLeft, .topRight]
      case .middle: return []
      case .bottom: return [.bottomLeft, .bottomRight]
    }
  }
  
  fileprivate let cardBGColor = Color.white.night(.hex(0x2a2a2b))
  
  public enum SectionItemType {
    case top, middle, bottom, single
  }
  
}


//#Preview {
//  if #available(iOS 17.0, *) {
//    ImageLabelView()
//  }
//}
