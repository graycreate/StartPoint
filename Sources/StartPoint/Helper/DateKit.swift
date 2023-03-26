//
//  Date.swift
//  
//
//  Created by GARY on 2023/3/13.
//

import Foundation

public extension Calendar {
  func daysBetween(_ from: Date, and to: Date, includeStartDay: Bool = false) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        return numberOfDays.day!
    }
  
  func daysOf24HoursBetween(_ from: Date, and to: Date) -> Int {
      let numberOfDays = dateComponents([.day], from: from, to: to)
      return numberOfDays.day!
  }
  
}
