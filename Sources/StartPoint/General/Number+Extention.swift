//
//  Number+Extention.swift
//  
//
//  Created by GARY on 2023/2/5.
//

import Foundation


extension CGFloat {
  public func `in`(_ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
    var result: CGFloat = self < minValue ? minValue : self
    result = result > maxValue ? maxValue : result
    return result
  }
}
