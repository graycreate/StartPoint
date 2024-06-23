//
//  Date.swift
//
//
//  Created by Gray on 2023/3/13.
//

import Foundation
import SwiftUI

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
  
  func dateByAddingDays(date: Date, days: Int) -> Date {
    return self.date(byAdding: .day, value: days, to: date)!
  }
  
}

public extension Date {
  func set(hour: Int, minute: Int = 0, second: Int = 0, calendar: Calendar = .current) -> Date? {
    calendar.date(bySettingHour: hour,
                  minute: minute,
                  second: second,
                  of: self)
  }
  
    @available(macOS 12, *)
    var expired: Bool {
    Date.now > self
  }
  
  var timeStamp: Int {
    Int(self.timeIntervalSince1970 * 1000)
  }
  
  static var currentTimeStamp: Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
  }
  
    @available(macOS 12, *)
    static var printTime: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.string(from: Date.now)
  }
  
}

public struct DateKit {
  
  public static var startOfNextDay: Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let now = Date()
    let startOfNextDay = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: now)!)
    return startOfNextDay;
  }
  
}

public struct DateComponentsMultiplier {
  let value: Int
  let component: Calendar.Component
}

public func *(lhs: Int, rhs: Calendar.Component) -> DateComponentsMultiplier {
  return DateComponentsMultiplier(value: lhs, component: rhs)
}

public extension Date {
  static func +(lhs: Date, rhs: DateComponentsMultiplier) -> Date {
    return Calendar.current.date(byAdding: rhs.component, value: rhs.value, to: lhs) ?? lhs
  }
  
  static func -(lhs: Date, rhs: DateComponentsMultiplier) -> Date {
    return Calendar.current.date(byAdding: rhs.component, value: -rhs.value, to: lhs) ?? lhs
  }
  
  // formatter to show 年月日 时分秒
  var fullFormatted: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: self)
  }
  
}

public extension TimeInterval {
  var timeStampMilliSecond: Int64 {
    return Int64(self * 1000)
  }
  
  var localFormatted: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium 
    formatter.locale = .current
    return formatter.string(from: Date(timeIntervalSince1970: self))
  }
  
}

