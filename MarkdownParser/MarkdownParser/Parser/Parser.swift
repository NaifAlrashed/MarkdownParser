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

extension ArraySlice where Element == TokenContainer {
    mutating func nextDocument() -> Document? {
        return parseLargeTitle() ??
            parseParagraph()
    }
    
    private mutating func parseLargeTitle() -> Document? {
        let start = self
        guard let firstToken = popFirst(),
            firstToken.token == .hashtag,
            let secondToken = popFirst(),
            let thirdToken = popFirst()
        else {
            self = start
            return nil
        }
        
        if secondToken.token == .whiteSpace, case let .text(content) = thirdToken.token {
            return .h1(content)
        } else if secondToken.token == .hashtag,
            thirdToken.token == .whiteSpace,
            let fourthToken = popFirst(),
            case let .text(content) = fourthToken.token
        {
            return .h2(content)
        } else {
            self = start
            return nil
        }
    }
    
    private mutating func parseParagraph() -> Document? {
        var start = self
        var content: String?
        while let token = popFirst(), !markdownTokenSet.contains(token.token) {
            start = self
            content = "\(content ?? "")\(token.stringRepresentation)"
        }
        self = start
        if let content = content {
            return .paragraph(content)
        } else {
            return nil
        }
    }
}

let markdownTokenSet: Set<Token> = Set<Token>([.hashtag])
