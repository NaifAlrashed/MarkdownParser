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
    
    func tokenize() -> [TokenContainer] {
        var tokens = [TokenContainer]()
        var parsableInput = Substring(input).unicodeScalars
        while let token = parsableInput.nextToken() {
            tokens.append(token)
        }
        return tokens
    }
}

extension Substring.UnicodeScalarView {
    
    mutating func nextToken() -> TokenContainer? {
        return readWhiteSpaceAndNewLine() ??
            readCharacterTokens() ??
            readInteger() ??
            readText()
    }
    
    private mutating func readWhiteSpaceAndNewLine() -> TokenContainer? {
        let start = self
        guard let char = popFirst() else {
            self = start
            return nil
        }
        if CharacterSet.whitespaces.contains(char) {
            return TokenContainer(token: .whiteSpace)
        } else if CharacterSet.newlines.contains(char) {
            return TokenContainer(token: .newLine)
        } else {
            self = start
            return nil
        }
    }
    
    private mutating func readCharacterTokens() -> TokenContainer? {
        let start = self
        guard let firstChar = popFirst() else {
            self = start
            return nil
        }
        switch firstChar {
        case "*":
            return TokenContainer(token: .star)
        case "_":
            return TokenContainer(token: .underScore)
        case "#":
            return TokenContainer(token: .hashtag)
        case "(":
            return TokenContainer(token: .openParenthesis)
        case ")":
            return TokenContainer(token: .closeParenthesis)
        case "[":
            return TokenContainer(token: .openBracket)
        case "]":
            return TokenContainer(token: .closeBracket)
        case "!":
            return TokenContainer(token: .bang)
        case ">":
            return TokenContainer(token: .block)
        case "-":
            return TokenContainer(token: .dash)
        case "`":
            return TokenContainer(token: .graveAccent)
        case ".":
            return TokenContainer(token: .dot)
        default:
            self = start
            return nil
        }
    }
    
    private mutating func readInteger() -> TokenContainer? {
        var start = self
        var allIntegers = Substring.UnicodeScalarView()
        while let maybeInteger = popFirst(), CharacterSet.integers.contains(maybeInteger) {
            allIntegers.append(maybeInteger)
            start = self
        }
        self = start
        return allIntegers.isEmpty ? nil: TokenContainer(token: .int(Int(String(allIntegers))!))
    }
    
    private mutating func readText() -> TokenContainer? {
        var text = ""
        var start = self
        while let char = popFirst() {
            if CharacterSet.markDownKeyWords.inverted.contains(char) {
                text.append(String(char))
            } else {
                self = start
                return text.isEmpty ? nil: TokenContainer(token: .text(text))
            }
            start = self
        }
        return text.isEmpty ? nil: TokenContainer(token: .text(text))
    }
}

extension CharacterSet {
    static let markDownKeyWords = CharacterSet(charactersIn: ".`->!()[]_#*")
        .union(.whitespacesAndNewlines)
        .union(.integers)
    static let integers = CharacterSet(charactersIn: "0987654321")
}
