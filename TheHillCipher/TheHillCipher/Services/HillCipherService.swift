//
//  HillCipherService.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 21/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import Foundation

protocol HillCipherServiceProtocol {
    /// The plainText
    var plainText: String { get set }

    /// The encryptionMatrix which we will use to encrypt the plainText
    /// or decrypt the encryptionKey
    var encryptionMatrix: Matrix { get set }

    /// The encryptionKey
    var encryptionKey: String { get set }

    /// Encrypts a plainText and returns an encryptionKey
    ///
    /// - Parameters:
    ///   - plainText: the plainText in this protocol
    ///   - encryptionMatrix: the encryptionMatrix in this protocol
    /// - Returns: The encryptionKey as a string
    /// - Throws: `MatrixError.NoInverseAvailable` or `MatrixError.MatrixShouldBe2x2
    ///            when the matrix has no inverse or the matrix is not 2x2
    func encrypt(completion: @escaping (String) -> Void) throws

    /// Decrypts an encryptionKey and returns a plainText
    ///
    /// - Parameters:
    ///   - encryptionKey: the encryptionKey in this protocol
    ///   - encryptionMatrix: the encryptionMatrix in this protocol
    /// - Returns: The plainText as a string
    /// - Throws: `MatrixError.NoInverseAvailable` or `MatrixError.MatrixShouldBe2x2
    ///            when the matrix has no inverse or the matrix is not 2x2
    func decrypt(completion: @escaping (String) -> Void) throws
}

class HillCipherServiceImpl: HillCipherServiceProtocol {

    // MARK: - Public Properties

    var plainText: String = ""
    var encryptionMatrix = Matrix(n: 2, m: 2)
    var encryptionKey = ""

    // MARK: - Public Methods

    func encrypt(completion: @escaping (String) -> Void) throws {
        let listRepr = mapToListRepresentation(string: plainText)
        let splitedArray = listRepr.completedChunk(into: 4, completeWithElement: 0)

        if encryptionMatrix.isInversable {
            if gcd(Int(encryptionMatrix.determinant()), 27) == 1 {
                let matrixSplittedArray = getMatrixArray(from: splitedArray)
                let matrixArray = matrixSplittedArray.map { Matrix(matrix: [$0]) }
                encryptionKey = getKeys(from: matrixArray)
                completion(encryptionKey)
            } else {
                throw MatrixError.GreatestCommonDivisor
            }
        } else {
            throw MatrixError.NoInverseAvailable
        }
    }

    func decrypt(completion: @escaping (String) -> Void) throws {
        let listRepr = mapToListRepresentation(string: encryptionKey.lowercased())
        let splittedArray = listRepr.completedChunk(into: 4, completeWithElement: 0)

        if encryptionMatrix.isInversable {
            if gcd(Int(encryptionMatrix.determinant()), 27) == 1 {
                let inversedMatrix = try! encryptionMatrix.decryptionInverse(with: 27)
                let matrixSplittedArray = getMatrixArray(from: splittedArray)
                let matrixArray = matrixSplittedArray.map { Matrix(matrix: [$0]) }
                plainText = getDecryptionKeys(from: matrixArray, inversed: inversedMatrix)
                completion(plainText)
            } else {
                throw MatrixError.GreatestCommonDivisor
            }
        } else {
            throw MatrixError.NoInverseAvailable
        }
    }

    // MARK: - Private Methods

    private func getMatrixArray(from array: [[Double]]) -> [[Double]] {
        var matrixArary = [[Double]]()

        for elements in array {
            let chuncked = elements.chunked(into: 2)
            chuncked.forEach { matrixArary.append($0) }
        }

        return matrixArary
    }

    private func getKeys(from letterCodesMatrix: [Matrix]) -> String {
        var encryptionKey = ""
        letterCodesMatrix.forEach {
            let matrix = try! $0 * encryptionMatrix
            let line = matrix.getUnsafeLine(1)
            let letters = line.map { Alphabet(withInt: Int($0)) }
            letters.forEach { encryptionKey += $0!.stringValue }
        }

        return encryptionKey.uppercased()
    }

    private func getDecryptionKeys(from letterCodesMatrix: [Matrix], inversed: Matrix) -> String {
        var decryptionKey = ""
        letterCodesMatrix.forEach {
            let matrix = try! $0 * inversed
            let line = matrix.getUnsafeLine(1)
            let letters = line.map { Alphabet(withInt: Int($0)) }
            letters.forEach { decryptionKey += $0!.stringValue }
        }

        return decryptionKey.lowercased()
    }

    private func mapToListRepresentation(string: String) -> [Double] {
        var list = [Double]()
        string.forEach {
            let char = Alphabet.init(withChar: $0)
            list.append(Double(char.rawValue))
        }

        return list
    }

    func gcd(_ a: Int, _ b: Int) -> Int {
        let r = a % b
        if r != 0 {
            return gcd(b, r)
        } else {
            return b
        }
    }
}
