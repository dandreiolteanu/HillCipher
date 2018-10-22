//
//  HistoryCell.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 22/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var plaintextLabel: UILabel!
    @IBOutlet weak var encryptionKeyLabel: UILabel!
    @IBOutlet weak var matrixLabel: UILabel!

    // MARK: - Public Methods

    public func configureCell(with history: History) {
        self.typeLabel.text = history.type.stringValue
        self.plaintextLabel.text = "Plaintext: \(history.plaintext.lowercased())"
        self.encryptionKeyLabel.text = "EncryptionKey: \(history.encryptionKey.uppercased())"
        self.matrixLabel.text = "Matrix: \(history.encryptionMatrix)"
    }
}
