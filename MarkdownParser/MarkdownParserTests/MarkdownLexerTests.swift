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
        XCTAssertEqual(Lexer(input: "").tokenize(), [])
    }
    
    func test_canTokenizeBold() {
        XCTAssertEqual(Lexer(input: "**Hello world**").tokenize(), [
            .doubleStars, .text("Hello world"), .doubleStars
        ])
    }
}
