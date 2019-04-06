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
    
    func test_canTokenizeBoldWithDoubleStars() {
        XCTAssertEqual(Lexer(input: "**Hello world**").tokenize(), [
            .doubleStars, .text("Hello world"), .doubleStars
        ])
    }
    
    func test_canTokenizeBoldWithDoubleUnderScores() {
        XCTAssertEqual(Lexer(input: "__Hello world__").tokenize(), [
            .doubleUnderScore, .text("Hello world"), .doubleUnderScore
        ])
    }
    
    func test_canTokenize_italics_withSingleUnderScore() {
        XCTAssertEqual(Lexer(input: "_Hello world_").tokenize(), [
            .singleUnderScore, .text("Hello world"), .singleUnderScore
        ])
    }
    
    func test_canTokenize_italics_withSingleStar() {
        XCTAssertEqual(Lexer(input: "*Hello world*").tokenize(), [
            .singleStar, .text("Hello world"), .singleStar
        ])
    }
}
