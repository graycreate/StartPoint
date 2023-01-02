//
//  BadgeTagView.swift
//  RememDays
//
//  Created by GARY on 2022/12/23.
//

import SwiftUI

struct BadgeTagView: View {
  var text = "LATER"
  var font = Font.footnote
  
    var body: some View {
      Text(text)
        .font(font)
        .fontWeight(.semibold)
        .padding(.vertical, 2)
        .padding(.horizontal, 6)
        .foregroundColor(.hex(0x2780D9, alpha: 0.8).adaptive())
        .background(Color.adaptiveWhite)
        .cornerRadius(6)
    }
}

struct BadgeTagView_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Rectangle().fill(.blue.gradient)
          .ignoresSafeArea()
        BadgeTagView()
      }
      .injectSample()
    }
}
