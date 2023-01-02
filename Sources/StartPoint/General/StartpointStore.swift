//
//  Store.swift
//  RememDays
//
//  Created by GARY on 2022/12/17.
//

import Foundation
import SwiftUI

open class StartpointStore: ObservableObject {
  @Published public var showProInfoPage: Bool = false
  public static var shared: StartpointStore = StartpointStore()
  public static var sample: StartpointStore {
    shared
  }
  @Published public var safeArea: EdgeInsets = UIDevice.topSafeAreaInset().edgeInset
  
}
