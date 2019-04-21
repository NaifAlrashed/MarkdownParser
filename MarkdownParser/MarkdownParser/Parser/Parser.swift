//
//  Parser.swift
//  MarkdownParser
//
//  Created by Naif Alrashed on 21/04/2019.
//  Copyright © 2019 Naif Alrashed. All rights reserved.
//

struct Parser {
    
    private let input: String
    
    init(input: String) {
        self.input = input
    }
    
    func parse() -> [Document] {
        let tokens = Lexer(input: input).tokenize()
        return tokens.compactMap { token in
            if case let .text(content) = token {
                return .paragraph(content)
            }
            return nil
        }
    }
}
