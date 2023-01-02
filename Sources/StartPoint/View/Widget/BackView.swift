//
//  BackView.swift
//  RememDays
//
//  Created by GARY on 2022/12/17.
//

import SwiftUI

public struct BackView: View {
  @Environment(\.dismiss) var dismiss
  var onBackPressed: (()->Void)?
  
  public init(onBackPressed: ( () -> Void)? = nil) {
    self.onBackPressed = onBackPressed
  }
  
  public var body: some View {
    Button {
      onBackPressed?()
      dismiss()
    } label: {
      Image(systemName: "chevron.backward")
        .font(.title2.weight(.regular))
        .padding(.vertical, 10)
        .foregroundColor(.accent)
    }
  }
}

struct BackView_Previews: PreviewProvider {
  static var previews: some View {
    BackView()
      .debug(true)
  }
}
