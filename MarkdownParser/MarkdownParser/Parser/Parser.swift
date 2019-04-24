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
        var tokens = ArraySlice(Lexer(input: input).tokenize())
        var documents = [Document]()
        while let document = tokens.nextDocument() {
            documents.append(document)
        }
        return documents
    }
}

extension ArraySlice where Element == Token {
    mutating func nextDocument() -> Document? {
        return parseLargeTitle() ??
            parseParagraph()
    }
    
    private mutating func parseLargeTitle() -> Document? {
        let start = self
        guard let firstToken = popFirst(),
            firstToken == .hashtag,
            let secondToken = popFirst(),
            let thirdToken = popFirst()
        else {
            self = start
            return nil
        }
        
        if secondToken == .whiteSpace, case let .text(content) = thirdToken {
            return .h1(content)
        } else if secondToken == .hashtag,
            thirdToken == .whiteSpace,
            let fourthToken = popFirst(),
            case let .text(content) = fourthToken
        {
            return .h2(content)
        } else {
            self = start
            return nil
        }
    }
    
    private mutating func parseParagraph() -> Document? {
        guard let token = popFirst() else { return nil }
        switch token {
        case let .text(conent):
            return .paragraph(conent)
        case .whiteSpace:
            return .paragraph(" ")
        default:
            return nil
        }
    }
}
