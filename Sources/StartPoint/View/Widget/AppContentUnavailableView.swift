//
//  AppContentUnavailableView.swift
//  ULPB
//
//  Created by Gray on 2024/1/24.
//

import SwiftUI

public struct AppContentUnavailableView: View {
  
  public init() {}
  
  public var body: some View {
    if #available(iOS 17.0, macOS 14.0, *) {
      ContentUnavailableView(
        "No Internet Connection",
        systemImage: "wifi.exclamationmark",
        description: Text("Please check your connection and try again.")
      )
    } else {
      // Fallback on earlier versions
      VStack(alignment: .center) {
        Image(systemName: "wifi.exclamationmark")
          .font(.largeTitle)
          .scaleEffect(1.4)
          .foregroundColor(.secondary)
          .padding(.bottom, 10)
        Text("No Internet Connection")
          .font(.title2)
        Text("Please check your connection and try again.")
          .font(.callout)
          .foregroundColor(.secondary)
      }
      .greedyFrame()
    }
  }
}

#Preview {
  AppContentUnavailableView()
    .background(.regularMaterial)
}
