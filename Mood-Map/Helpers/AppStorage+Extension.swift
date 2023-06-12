//
//  AppStorage+Extension.swift
//  AppWrite-CURD
//
//  Created by Ranga Reddy Nukala on 09/06/23.
//

import Foundation
import SwiftUI

enum UserDefaultsKey: String {
    case userId
    case sessionId
    case token
    case name
    case isFirstUser
    case deviceToken
    case isSuperUser
    case expireTime
}

extension UserDefaults {
    func set(_ value: Any, for key: UserDefaultsKey) {
        self.set(value, forKey: key.rawValue)
    }
    func bool(for key: UserDefaultsKey) -> Bool {
        return self.bool(forKey: key.rawValue)
    }
    func data(for key: UserDefaultsKey) -> Data? {
        return self.data(forKey: key.rawValue)
    }
    func string(for key: UserDefaultsKey) -> String? {

        return self.string(forKey: key.rawValue)
    }
    func integer(for key: UserDefaultsKey) -> Int? {
        return self.integer(forKey: key.rawValue)
    }
    func float(for key: UserDefaultsKey) -> Float? {

        return self.float(forKey: key.rawValue)
    }
    func url(for key: UserDefaultsKey) -> URL? {
        return self.url(forKey: key.rawValue)
    }
    func value(for key: UserDefaultsKey) -> Any? {
        return self.value(forKey: key.rawValue)
    }

    func removeObject(forKey key: UserDefaultsKey) {
        self.removeObject(forKey: key.rawValue)
    }
}

extension AppStorage {
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == Bool {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == Int {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == Double {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == URL {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == String {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
    init(wrappedValue: Value, _ key: UserDefaultsKey, store: UserDefaults? = nil) where Value == Data {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
}

extension String {
    func humanReadableDateTimeWithSeconds() -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withFractionalSeconds]

        guard let date = isoDateFormatter.date(from: self) else {
            return ""
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter.string(from: date)
    }
}
