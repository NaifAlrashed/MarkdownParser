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
        let text = tokens.reduce("") { totalString, token in
            switch token {
            case let .text(content):
                return "\(totalString)\(content)"
            case .whiteSpace:
                return "\(totalString) "
            default: return totalString
            }
        }
        return text.isEmpty ? []: [.paragraph(text)]
    }
}
