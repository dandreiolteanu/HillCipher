//
//  Alphabet.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 21/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import Foundation

enum Alphabet: Int {
    case space = 0, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z

    init?(withInt int: Int) {
        if int > 26 {
            let mod = int % 27
            self.init(rawValue: mod)
        } else {
            self.init(rawValue: int)
        }
    }

    init(withChar char: Character) {
        switch char {
        case " ": self = .space
        case "a": self = .a
        case "b": self = .b
        case "c": self = .c
        case "d": self = .d
        case "e": self = .e
        case "f": self = .f
        case "g": self = .g
        case "h": self = .h
        case "i": self = .i
        case "j": self = .j
        case "k": self = .k
        case "l": self = .l
        case "m": self = .m
        case "n": self = .n
        case "o": self = .o
        case "p": self = .p
        case "q": self = .q
        case "r": self = .r
        case "s": self = .s
        case "t": self = .t
        case "u": self = .u
        case "v": self = .v
        case "w": self = .w
        case "x": self = .x
        case "y": self = .y
        case "z": self = .z
        default: fatalError()
        }
    }

    var stringValue: String {
        switch self {
        case .space: return " "
        case .a: return "a"
        case .b: return  "b"
        case .c: return "c"
        case .d: return "d"
        case .e: return "e"
        case .f: return "f"
        case .g: return "g"
        case .h: return "h"
        case .i: return "i"
        case .j: return "j"
        case .k: return "k"
        case .l: return "l"
        case .m: return "m"
        case .n: return "n"
        case .o: return "o"
        case .p: return "p"
        case .q: return "q"
        case .r: return "r"
        case .s: return "s"
        case .t: return "t"
        case .u: return "u"
        case .v: return "v"
        case .w: return "w"
        case .x: return "x"
        case .y: return "y"
        case .z: return "z"
        }
    }
}
