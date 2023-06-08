//
//  main.swift
//  swift-cli
//
//  Created by Ousmane Bathily le 06/06/2023.

import Foundation

class Parser {
    let s: String
    var index: String.Index
    init(_ s: String) {
        self.s = s
        self.index = s.startIndex
    }
    
    func head() -> Character? {
        return index < s.endIndex ? s[index] : nil
    }
    
    func pop(_ char: Character) {
        assert(head() == char)
        index = s.index(after: index)
    }
    
    func parse() -> Int {
        let result = sum()
        assert(head() == nil)
        return result
    }
    
    func sum() -> Int {
        var result = product()
        while let char = head(), char == "+" || char == "-" {
            if char == "+" {
                pop("+")
                result += product()
            } else {
                pop("-")
                result -= product()
            }
        }
        return result
    }
    
    func product() -> Int {
        var result = self.getFactor()
        while let char = head(), char == "*" {
            pop("*")
            result *= getFactor()
        }
        return result
    }
    
    func getFactor() -> Int {
        if let char = head(), char.isNumber {
            return number()
        } else if head() == "(" {
            pop("(")
            let result = sum()
            pop(")")
            return result
        } else {
            fatalError("Erreur de syntaxe: Vérifier l'expression")
        }
    }
    
    func number() -> Int {
        var numStr = ""
        while let char = head(), char.isNumber {
            numStr.append(char)
            index = s.index(after: index)
        }
        return Int(numStr)!
    }
}

func eval(_ s: String) -> Int {
    let parser = Parser(s)
    return parser.parse()
}
