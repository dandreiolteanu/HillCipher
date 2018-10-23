//
//  History.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 22/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import UIKit

enum HistoryType: Codable {
    case encryption
    case decryption

    enum CodingKeys: String, CodingKey {
        case encryption = "Encryption"
        case decryption = "Decryption"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let _ = try? values.decode(String.self, forKey: .encryption) {
            self = .encryption
            return
        }

        if let _ = try? values.decode(String.self, forKey: .decryption) {
            self = .decryption
            return
        }
        self = .encryption
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .encryption:
            try container.encode(self.stringValue, forKey: .encryption)
        case .decryption:
            try container.encode(self.stringValue, forKey: .decryption)
        }
    }

    var stringValue: String {
        return self == .encryption ? "Encryption" : "Decryption"
    }

    var image: UIImage? {
        return self == .encryption ? UIImage(named: "icn_encryption") : UIImage(named: "icn_decryption")
    }

    var color: UIColor {
        return self == .encryption ? #colorLiteral(red: 0.003921568627, green: 0.5450980392, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 0.05490196078, blue: 0.05490196078, alpha: 1)
    }
}

struct History: Codable {
    let type: HistoryType
    let plaintext: String
    let encryptionKey: String
    let encryptionMatrix: String

    init(type: HistoryType, plaintext: String, encryptionKey: String, encryptionMatrix: String) {
        self.type = type
        self.plaintext = plaintext
        self.encryptionKey = encryptionKey
        self.encryptionMatrix = encryptionMatrix
    }
}
