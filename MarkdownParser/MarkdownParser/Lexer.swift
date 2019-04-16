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
        return readWhiteSpaceAndNewLine() ??
            readCharacterTokens() ??
            readText()
    }
    
    private mutating func readWhiteSpaceAndNewLine() -> Token? {
        let start = self
        guard let char = popFirst() else {
            self = start
            return nil
        }
        if CharacterSet.whitespaces.contains(char) {
            return .whiteSpace
        } else if CharacterSet.newlines.contains(char) {
            return .newLine
        } else {
            self = start
            return nil
        }
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
            return readStar(afterFirstChar: afterFirstCharPop)
        case "_":
            return readUnderScore(afterFirstChar: afterFirstCharPop)
        case "#":
            return readTitle(start: start)
        case "(":
            return .openParenthesis
        case ")":
            return .closeParenthesis
        case "[":
            return .openBracket
        case "]":
            return .closeBracket
        case "!":
            return .bang
        case ">":
            return .block
        case "-":
            return .dash
        case "`":
            return readCodeBlock()
        default:
            self = start
            return nil
        }
    }
    
    private mutating func readStar(afterFirstChar: Substring.UnicodeScalarView) -> Token? {
        if let secondChar = popFirst(), secondChar == "*" {
            return .doubleStars
        } else {
            self = afterFirstChar
            return .singleStar
        }
    }
    
    private mutating func readUnderScore(afterFirstChar: Substring.UnicodeScalarView) -> Token? {
        if let secondChar = popFirst(), secondChar == "_" {
            return .doubleUnderScore
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
            let stateBeforeCurrentChar = self
            if let nextChar = popFirst() {
                if nextChar == "#" {
                    continue
                } else {
                    self = stateBeforeCurrentChar
                    return generateTitle(numberOfHashtags: numberOfHashtags)
                }
            } else {
                self = start
                return nil
            }
        }
        self = start
        return nil
    }
    
    private mutating func readCodeBlock() -> Token {
        let start = self
        guard let secondChar = popFirst(),
            secondChar == "`",
            let thirdChar = popFirst(), thirdChar == "`"
        else {
            self = start
            return .inlineCode
        }
        return .codeBlock
    }
    
    private mutating func readText() -> Token? {
        var text = ""
        var start = self
        while let char = popFirst() {
            if CharacterSet.markDownKeyWords.inverted.contains(char) {
                text.append(String(char))
            } else {
                self = start
                return text.isEmpty ? nil: .text(text)
            }
            start = self
        }
        return text.isEmpty ? nil: .text(text)
    }
}

extension CharacterSet {
    static let markDownKeyWords = CharacterSet(charactersIn: "`->!()[]_#*")
        .union(.whitespacesAndNewlines)
}
