//
//  Extension.swift
//  Gambit challenge
//
//  Created by Hassan on 1.10.2020.
//

import Foundation

extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}
