//
//  Persist.swift
//  MyClock
//
//  Created by ghui on 2022/4/17.
//

import Foundation

struct Persist {
    private static let userDefault = UserDefaults.standard

    static func save(value: Any, forkey key: String) {
        userDefault.set(value, forKey: key)
    }

    static func read(key: String, default: String = .empty) -> String {
        if userDefault.object(forKey: key) == nil {
            save(value: `default`, forkey: key)
            return `default`
        }
        return userDefault.string(forKey: key) ?? `default`
    }

    static func read(key: String, default: Int = 0) -> Int {
        if userDefault.object(forKey: key) == nil {
            save(value: `default`, forkey: key)
            return `default`
        }
        return userDefault.integer(forKey: key)
    }

    static func read(key: String, default: Bool = false) -> Bool {
        if userDefault.object(forKey: key) == nil {
            save(value: `default`, forkey: key)
            return `default`
        }
        return userDefault.bool(forKey: key)
    }

    static func read(key: String) -> Data? {
        return userDefault.data(forKey: key)
    }
}
