//
//  Extensions.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 18/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import UIKit

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    func completedChunk(into size: Int, completeWithElement element: Element) -> [[Element]] {
        var chunked = self.chunked(into: size)
        for (i, elements) in chunked.enumerated() {
            if elements.count < size {
                chunked[i].append(contentsOf: repeatElement(element, count: size - elements.count))
            }
        }
        return chunked
    }
}

extension Collection where Iterator.Element == Int {
    var doubleArray: [Double] {
        return compactMap { Double($0) }
    }
}

// (1 / 9) % 26 <--> (9 * x) % 26 == 1
extension Double {
    func inverseModulus(_ mod: Int) -> Double {
        for i in 1...mod {
            if (Int(self) * i) % mod == 1 {
                return Double(i)
            }
        }

        return 0
    }
}

extension String {
    func formatForMatrix() -> Matrix {
        return Matrix(matrix: self.split(separator: ",")
                                .map { "\($0)" }
                                .compactMap { Double($0) }
                                .chunked(into: 2))
    }

    var isValidForMatrixEntry: Bool {
        return self.split(separator: ",").count == 4
    }

    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }
}

extension UIButton {
    func setEnabled(_ isEnabled: Bool) {
        self.alpha = isEnabled ? 1.0 : 0.5
        self.isEnabled = isEnabled
    }
}

extension UIViewController {
    func showAlert(with title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
