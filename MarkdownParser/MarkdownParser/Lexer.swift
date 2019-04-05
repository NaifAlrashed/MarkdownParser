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
        return readDoubleCharacterTokens() ?? readText()
    }
    
    private mutating func readDoubleCharacterTokens() -> Token? {
        let start = self
        guard let firstChar = popFirst(), let secondChar = popFirst() else {
            self = start
            return nil
        }
        switch (firstChar, secondChar) {
        case ("*", "*"):
            return .doubleStars
        case ("_", "_"):
            return .doubleUnderScore
        default:
            self = start
            return nil
        }
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
