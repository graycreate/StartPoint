//
//  AppGroup.swift
//
//
//  Created by Gray on 2023/11/19.
//

import Foundation

public enum AppGroup: String {
  case base
  case ulpb
  case dayStill
  
  public var rawValue: String {
    switch self {
    case .base:
      return "group.pro.lessmore"
    case .ulpb:
      return AppGroup.base.rawValue + ".ulpb"
    case .dayStill:
      return AppGroup.base.rawValue + ".daystill"
    }
  }

}
