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

private extension ArraySlice where Element == TokenContainer {
    
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
        guard var content = popFirst()?.stringRepresentation else { return nil }
        var start = self
        while let token = popFirst(), !markdownTokenSet.contains(token.token) {
            start = self
            content = "\(content)\(token.stringRepresentation)"
        }
        self = start
        if let nextDocument = nextDocument(), case let .paragraph(nextContent) = nextDocument {
            return .paragraph("\(content)\(nextContent)")
        } else {
            self = start
            return .paragraph(content)
        }
    }
}

let markdownTokenSet: Set<Token> = Set<Token>([.hashtag])
