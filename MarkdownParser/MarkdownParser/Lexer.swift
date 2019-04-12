//
//  Lexer.swift
//  MarkdownParser
//
//  Created by Naif Alrashed on 05/04/2019.
//  Copyright © 2019 Naif Alrashed. All rights reserved.
//

struct Lexer {
    
    private let input: String
    
    init(input: String) {
        self.input = input
    }
    
    func tokenize() -> [Token] {
        var tokens = [Token]()
        var parsableInput = Substring(input).unicodeScalars
        while let token = parsableInput.nextToken() {
            tokens.append(token)
        }
        return tokens
    }
}

extension Substring.UnicodeScalarView {
    
    mutating func nextToken() -> Token? {
        return readCharacterTokens() ?? readText()
    }
    
    private mutating func readCharacterTokens() -> Token? {
        let start = self
        guard let firstChar = popFirst() else {
            self = start
            return nil
        }
        let afterFirstCharPop = self
        switch firstChar {
        case "*":
            return readStar(start: start, afterFirstChar: afterFirstCharPop)
        case "_":
            return readUnderScore(start: start, afterFirstChar: afterFirstCharPop)
        case "#":
            return readTitle(start: start)
        default:
            self = start
            return nil
        }
    }
    
    private mutating func readStar(start: Substring.UnicodeScalarView,
                                   afterFirstChar: Substring.UnicodeScalarView) -> Token? {
        if let secondChar = popFirst() {
            let beforeThirdChar = self
            if CharacterSet.whitespaces.contains(secondChar) {
                self = start
                return nil
            } else if secondChar == "*" {
                if let thirdChar = popFirst(), CharacterSet.whitespaces.contains(thirdChar) {
                    self = start
                    return nil
                } else {
                    self = beforeThirdChar
                    return .doubleStars
                }
            }
            self = afterFirstChar
            return .singleStar
        } else {
            self = afterFirstChar
            return .singleStar
        }
    }
    
    private mutating func readUnderScore(start: Substring.UnicodeScalarView,
                                         afterFirstChar: Substring.UnicodeScalarView) -> Token? {
        if let secondChar = popFirst() {
            let beforeThirdChar = self
            if secondChar == "_" {
                if let thirdChar = popFirst(), CharacterSet.whitespaces.contains(thirdChar) {
                    self = start
                    return nil
                } else {
                    self = beforeThirdChar
                    return .doubleUnderScore
                }
            } else if CharacterSet.whitespaces.contains(secondChar) {
                self = start
                return nil
            } else {
                self = afterFirstChar
                return .singleUnderScore
            }
            
        } else {
            self = afterFirstChar
            return .singleUnderScore
        }
    }
    
    private mutating func readTitle(start: Substring.UnicodeScalarView) -> Token? {
        
        func generateTitle(numberOfHashtags: Int) -> Token? {
            switch numberOfHashtags {
            case 1:
                return .h1
            case 2:
                return .h2
            case 3:
                return .h3
            case 4:
                return .h4
            case 5:
                return .h5
            case 6:
                return .h6
            default:
                return nil
            }
        }
        
        for numberOfHashtags in 1...6 {
            if let nextChar = popFirst() {
                if nextChar == "#" {
                    continue
                } else if NSCharacterSet.whitespaces.contains(nextChar) {
                    return generateTitle(numberOfHashtags: numberOfHashtags)
                } else {
                    self = start
                    return nil
                }
            } else {
                self = start
                return nil
            }
        }
        self = start
        return nil
    }
    
    private mutating func readText() -> Token? {
        if let char = popFirst() {
            let start = self
            if case let .text(output)? = nextToken() {
                return .text("\(char)\(output)")
            } else {
                self = start
                return .text(String(char))
            }
        }
        return nil
    }
}
