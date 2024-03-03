//
//  File.swift
//
//
//  Created by Gray on 2024/2/24.
//

import Foundation

public extension Date {
  
  static var currentYear: Int {
    return Calendar.current.component(.year, from: Date())
  }
  
  static func calculateDate(of year: Int = Self.currentYear, month: Int, week: Int, weekday: Int) -> Date? {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.weekday = weekday // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
    // Set to first day of the month to start searching from.
    components.day = 1
    
    let calendar = Calendar.current
    guard let startOfMonth = calendar.date(from: components) else { return nil }
    
    var occurrence = 0
    var date = startOfMonth
    
    while true {
      if calendar.component(.weekday, from: date) == components.weekday {
        occurrence += 1
      }
      if occurrence == week {
        return date
      }
      guard let nextDay = calendar.date(byAdding: .day, value: 1, to: date) else { break }
      date = nextDay
    }
    
    return nil
  }
  
  static var motherDay: Date {
    // Mother's Day: May's second Sunday
    return calculateDate(of: 2024, month: 5, week: 2, weekday: 1)!
  }
  
  static var fatherDay: Date {
    // Father's Day: June's third Sunday
    return calculateDate(of: 2024, month: 6, week: 3, weekday: 1)!
  }
  
  static var thanksgivingDay: Date {
    // Father's Day: June's third Sunday
    return calculateDate(of: 2024, month: 11, week: 4, weekday: 5)! // // 5 = Thursday
  }
  
}
