//
//  Colors.swift
//  
//
//  Created by Gray on 2023/1/7.
//

import SwiftUI

#if canImport(UIKit)

extension Color {
  
  public static let defaultPanel: [Color] = [
    .hex("#4BBFE0"), .hex("#74a6ff"), .hex("#b08dfc"), .hex("#d257fd"), .hex("#ee719e"), .hex("#ff8e83"),
    .hex("#ffa57d"), .hex("#FFCC00"), .hex("#fec679"), .hex("#fed976"), .hex("#b1dc8b"), .hex("#b1c0ab"),
    .hex("#9eb7bd"), .hex("#b7a7b7"), .hex("#bbb1a6"), .hex("#643c15"), .hex("#5e5e5e"), .clear
    
//    .hex("#348ABD"), .hex("#5E81AC"), .hex("#7B61FF"), .hex("#A33EA1"), .hex("#C2185B"), .hex("#FF7F50"),
//    .hex("#E67E22"), .hex("#F39C12"), .hex("#F1C40F"), .hex("#D4AC0D"), .hex("#27AE60"), .hex("#7F8C8D"),
//    .hex("#16A085"), .hex("#8E44AD"), .hex("#D5B48E"), .hex("#6E2C00"), .hex("#424949"), .clear
    
//    .hex("#3498DB"), .hex("#5D6D7E"), .hex("#8E44AD"), .hex("#C0392B"), .hex("#D35400"), .hex("#E74C3C"),
//    .hex("#F39C12"), .hex("#F4D03F"), .hex("#F7DC6F"), .hex("#F9E79F"), .hex("#2ECC71"), .hex("#AAB7B8"),
//    .hex("#1ABC9C"), .hex("#9B59B6"), .hex("#D5D8DC"), .hex("#784212"), .hex("#7B7D7D"), .clear
  ]
  
  public static var randomColor: Color {
    defaultPanel[0...6].randomElement()!
  }
  
  public static let labelColor: Color = UIColor.label.color()
  public static let labelColorWeak: Color = UIColor.label.color().opacity(0.86)
  public static let valueColor: Color = labelColor.opacity(0.5)
  
  
}


struct Colors_Previews: PreviewProvider {
  static var previews: some View {
    ScrollView {
      VStack {
        ForEach(Color.defaultPanel, id: \.self) { color in
          color
            .frame(height: 70)
            .overlay {
              Text("Hello")
                .foregroundColor(.white)
                .bold()
            }
        }
        .clipCorner(20)
      }
      .padding()
    }
  }
}

#endif
