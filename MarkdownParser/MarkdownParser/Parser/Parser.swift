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
        func generateTitle(numberOfHashtags: Int, content: String) -> Document? {
            switch numberOfHashtags {
            case 1: return .h1(content)
            case 2: return .h2(content)
            case 3: return .h3(content)
            case 4: return .h4(content)
            case 5: return .h5(content)
            case 6: return .h6(content)
            default: return nil
            }
        }
        let start = self
        var didParseWhiteSpace = false
        for numberOfHashtags in 0...6 {
            if let nextToken = popFirst() {
                switch nextToken.token {
                case .hashtag: continue
                case .whiteSpace:
                    didParseWhiteSpace = true
                    break
                default:
                    self = start
                    return nil
                }
            }
            if !didParseWhiteSpace {
                self = start
                return nil
            } else {
                if case let .text(content)? = popFirst()?.token {
                    return generateTitle(numberOfHashtags: numberOfHashtags, content: content)
                } else {
                    self = start
                    return nil
                }
            }
        }
        return nil
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
