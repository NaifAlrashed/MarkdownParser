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
            parseBold() ??
            parseItalics() ??
            parseInlineCode() ??
            parseUnorderedList() ??
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
    
    private mutating func parseBold() -> Document? {
        let start = self
        let boldTokenType: Token
        switch (popFirst()?.token, popFirst()?.token) {
        case (.underScore?, .underScore?): boldTokenType = .underScore
        case (.star?, .star?): boldTokenType = .star
        default:
            self = start
            return nil
        }
        
        var didParseBoldTokenEnd = false
        var content = ""
        
        while let nextTokenContainer = popFirst() {
            switch nextTokenContainer.token {
            case boldTokenType:
                didParseBoldTokenEnd = true
                break
            case .newLine:
                self = start
                return nil
            default:
                content = "\(content)\(nextTokenContainer.stringRepresentation)"
            }
        }
        if didParseBoldTokenEnd {
            return .bold(content)
        } else {
            self = start
            return nil
        }
    }
    
    private mutating func parseItalics() -> Document? {
        let start = self
        let boldTokenType: Token
        switch popFirst()?.token {
        case .underScore?: boldTokenType = .underScore
        case .star?: boldTokenType = .star
        default:
            self = start
            return nil
        }
        var content = ""
        
        while let nextTokenContainer = popFirst() {
            switch nextTokenContainer.token {
            case boldTokenType:
                if let firstChar = first?.stringRepresentation.unicodeScalars.first, CharacterSet.alphanumerics.contains(firstChar) {
                    self = start
                    return nil
                } else {
                    return .italics(content)
                }
            case .newLine:
                self = start
                return nil
            default:
                content = "\(content)\(nextTokenContainer.stringRepresentation)"
            }
        }
        self = start
        return nil
    }
    
    private mutating func parseInlineCode() -> Document? {
        let start = self
        var content = ""
        guard case .graveAccent? = popFirst()?.token else {
            self = start
            return nil
        }
        var didParseEndGraveAccent = false
        
        while let nextTokenContainer = popFirst() {
            switch nextTokenContainer.token {
            case .graveAccent:
                didParseEndGraveAccent = true
                break
            case .newLine:
                self = start
                return nil
            default:
                content = "\(content)\(nextTokenContainer.stringRepresentation)"
            }
        }
        if didParseEndGraveAccent {
            return .inlineCode(content)
        } else {
            self = start
            return nil
        }
    }
    
    private mutating func parseUnorderedList() -> Document? {
        guard let firstToken = first?.token else { return nil }
        let listToken: Token
        if case .star = firstToken {
            listToken = .star
        } else if case .dash = firstToken {
            listToken = .dash
        } else {
            return nil
        }
        var unorderedListContent = [String]()
        let start = self
        while let firstTokenContainer = popFirst(),
            firstTokenContainer.token == listToken,
        case .whiteSpace? = popFirst()?.token {
            if let listItemContent = readStringUntilNewLine(), !listItemContent.isEmpty {
                unorderedListContent.append(listItemContent)
            }
        }
        if unorderedListContent.isEmpty {
            self = start
            return nil
        } else {
            return .unorderedList(unorderedListContent)
        }
    }
    
    private mutating func readStringUntilNewLine() -> String? {
        var listItemContent = ""
        let start = self
        while let tokenContainer = popFirst() {
            switch tokenContainer.token {
            case .newLine:
                return listItemContent
            default:
                listItemContent = "\(listItemContent)\(tokenContainer.stringRepresentation)"
            }
        }
        if listItemContent.isEmpty {
            self = start
            return nil
        } else {
            return listItemContent
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
