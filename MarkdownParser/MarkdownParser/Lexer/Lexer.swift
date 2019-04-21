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
            readInteger() ??
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
        switch firstChar {
        case "*":
            return .star
        case "_":
            return .underScore
        case "#":
            return .hashtag
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
            return .graveAccent
        case ".":
            return .dot
        default:
            self = start
            return nil
        }
    }
    
    private mutating func readInteger() -> Token? {
        var start = self
        var allIntegers = Substring.UnicodeScalarView()
        while let maybeInteger = popFirst(), CharacterSet.integers.contains(maybeInteger) {
            allIntegers.append(maybeInteger)
            start = self
        }
        self = start
        return allIntegers.isEmpty ? nil: .int(Int(String(allIntegers))!)
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
    static let markDownKeyWords = CharacterSet(charactersIn: ".`->!()[]_#*")
        .union(.whitespacesAndNewlines)
        .union(.integers)
    static let integers = CharacterSet(charactersIn: "0987654321")
}