//
//  UserDefaultsManager.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 22/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import Foundation

class UserDefaultsManager {

    enum Keys {
        static let history = "History"
    }

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard

    // MARK: - Public Properties

    var history: [History] {
        get {
            return getHistory()
        } set {
            setHistory(newValue)
        }
    }

    // MARK: - Lifecycle

    static let shared = UserDefaultsManager()

    // MARK: - Private Methods

    private func getHistory() -> [History] {
        guard let data = userDefaults.value(forKey: Keys.history) as? Data else { return [History]() }
        let decoder = JSONDecoder()

        guard let decoded = try? decoder.decode([History].self, from: data) else { return [History]() }
        return decoded
    }

    private func setHistory(_ newValue: [History]) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(newValue) else { return }
        userDefaults.set(encoded, forKey: Keys.history)
    }
}
