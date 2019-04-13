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
    
    func test_empty() {
        XCTAssertEqual(Lexer(input: "").tokenize(), [])
    }
    
    func test_bold_withDoubleStars() {
        XCTAssertEqual(Lexer(input: "**Hello world**").tokenize(), [
            .doubleStars, .text("Hello world"), .doubleStars
        ])
    }
    
    func test_bold_withDoubleUnderScores() {
        XCTAssertEqual(Lexer(input: "__Hello world__").tokenize(), [
            .doubleUnderScore, .text("Hello world"), .doubleUnderScore
        ])
    }
    
    func test_italics_withSingleUnderScore() {
        XCTAssertEqual(Lexer(input: "_Hello world_").tokenize(), [
            .singleUnderScore, .text("Hello world"), .singleUnderScore
        ])
    }
    
    func test_italics_withSingleStar() {
        XCTAssertEqual(Lexer(input: "*Hello world*").tokenize(), [
            .singleStar, .text("Hello world"), .singleStar
        ])
    }
    
    func test_h1() {
        XCTAssertEqual(Lexer(input: "# Hello World").tokenize(), [.h1, .text(" Hello World")])
    }
    
    func test_h2() {
        XCTAssertEqual(Lexer(input: "## Hello World").tokenize(), [.h2, .text(" Hello World")])
    }
    
    func test_h3() {
        XCTAssertEqual(Lexer(input: "### Hello World").tokenize(), [.h3, .text(" Hello World")])
    }
    
    func test_h4() {
        XCTAssertEqual(Lexer(input: "#### Hello World").tokenize(), [.h4, .text(" Hello World")])
    }
    
    func test_h5() {
        XCTAssertEqual(Lexer(input: "##### Hello World").tokenize(), [.h5, .text(" Hello World")])
    }
    
    func test_h6() {
        XCTAssertEqual(Lexer(input: "###### Hello World").tokenize(), [.h6, .text(" Hello World")])
    }
}
