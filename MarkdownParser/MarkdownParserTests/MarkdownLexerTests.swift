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
            .doubleStars, .text("Hello"), .whiteSpace, .text("world"), .doubleStars
        ])
    }
    
    func test_bold_withDoubleUnderScores() {
        XCTAssertEqual(Lexer(input: "__Hello world__").tokenize(), [
            .doubleUnderScore, .text("Hello"), .whiteSpace, .text("world"), .doubleUnderScore
        ])
    }
    
    func test_italics_withSingleUnderScore() {
        XCTAssertEqual(Lexer(input: "_Hello world_").tokenize(), [
            .singleUnderScore, .text("Hello"), .whiteSpace, .text("world"), .singleUnderScore
        ])
    }
    
    func test_italics_withSingleStar() {
        XCTAssertEqual(Lexer(input: "*Hello world*").tokenize(), [
            .singleStar, .text("Hello"), .whiteSpace, .text("world"), .singleStar
        ])
    }
    
    func test_h1() {
        XCTAssertEqual(Lexer(input: "# Hello World").tokenize(), [
            .h1, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h2() {
        XCTAssertEqual(Lexer(input: "## Hello World").tokenize(), [
            .h2,.whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h3() {
        XCTAssertEqual(Lexer(input: "### Hello World").tokenize(), [
            .h3, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h4() {
        XCTAssertEqual(Lexer(input: "#### Hello World").tokenize(), [
            .h4, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h5() {
        XCTAssertEqual(Lexer(input: "##### Hello World").tokenize(), [
            .h5, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h6() {
        XCTAssertEqual(Lexer(input: "###### Hello World").tokenize(), [
            .h6, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_newLine() {
        let input = """
                    # Hello
                    How Are You
                    """
        XCTAssertEqual(Lexer(input: input).tokenize(),
                       [
                        .h1, .whiteSpace, .text("Hello"), .newLine,
                        .text("How"), .whiteSpace, .text("Are"), .whiteSpace, .text("You")
                       ])
    }
    
    func test_link() {
        XCTAssertEqual(Lexer(input: "[link](google.com)").tokenize(), [
            .openBracket, .text("link"), .closeBracket,
            .openParenthesis, .text("google.com"), .closeParenthesis
        ])
    }
    
    func test_image() {
        XCTAssertEqual(Lexer(input: "![Image](https://url/a.png)").tokenize(), [
            .bang, .openBracket, .text("Image"), .closeBracket,
            .openParenthesis, .text("https://url/a.png"), .closeParenthesis
        ])
    }
    
    func test_block() {
        XCTAssertEqual(Lexer(input: "> Hello").tokenize(),
                       [.block, .whiteSpace, .text("Hello")])
    }
}
