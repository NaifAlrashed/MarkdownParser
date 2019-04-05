//
//  MarkdownLexerTests.swift
//  MarkdownParserTests
//
//  Created by Naif Alrashed on 05/04/2019.
//  Copyright © 2019 Naif Alrashed. All rights reserved.
//

import XCTest
@testable import MarkdownParser

class MarkdownLexerTests: XCTestCase {
    
    func test_canTokenizeEmptyString() {
        var lexer = Lexer(input: "")
        XCTAssertEqual(lexer.tokenize(), [])
    }
    
    func test_canTokenizeBold() {
        var lexer = Lexer(input: "**Hello world**")
        XCTAssertEqual(lexer.tokenize(), [
            .doubleStars, .text("Hello world"), .doubleStars
        ])
    }
}
