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
        XCTAssertEqual(Lexer(input: "").tokenize().map { $0.token }, [])
    }
    
    func test_bold_withDoubleStars() {
        XCTAssertEqual(Lexer(input: "**Hello world**").tokenize().map { $0.token }, [
            .star, .star, .text("Hello"), .whiteSpace, .text("world"), .star, .star
        ])
    }
    
    func test_bold_withDoubleUnderScores() {
        XCTAssertEqual(Lexer(input: "__Hello world__").tokenize().map { $0.token }, [
            .underScore, .underScore, .text("Hello"), .whiteSpace, .text("world"), .underScore, .underScore
        ])
    }
    
    func test_italics_withSingleUnderScore() {
        XCTAssertEqual(Lexer(input: "_Hello world_").tokenize().map { $0.token }, [
            .underScore, .text("Hello"), .whiteSpace, .text("world"), .underScore
        ])
    }
    
    func test_italics_withSingleStar() {
        XCTAssertEqual(Lexer(input: "*Hello world*").tokenize().map { $0.token }, [
            .star, .text("Hello"), .whiteSpace, .text("world"), .star
        ])
    }
    
    func test_h1() {
        XCTAssertEqual(Lexer(input: "# Hello World").tokenize().map { $0.token }, [
            .hashtag, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h2() {
        XCTAssertEqual(Lexer(input: "## Hello World").tokenize().map { $0.token }, [
            .hashtag, .hashtag,.whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h3() {
        XCTAssertEqual(Lexer(input: "### Hello World").tokenize().map { $0.token }, [
            .hashtag, .hashtag, .hashtag, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h4() {
        XCTAssertEqual(Lexer(input: "#### Hello World").tokenize().map { $0.token }, [
            .hashtag, .hashtag, .hashtag, .hashtag, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h5() {
        XCTAssertEqual(Lexer(input: "##### Hello World").tokenize().map { $0.token }, [
            .hashtag, .hashtag, .hashtag, .hashtag, .hashtag, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_h6() {
        XCTAssertEqual(Lexer(input: "###### Hello World").tokenize().map { $0.token }, [
            .hashtag, .hashtag, .hashtag, .hashtag, .hashtag, .hashtag, .whiteSpace, .text("Hello"), .whiteSpace, .text("World")])
    }
    
    func test_newLine() {
        let input = """
                    # Hello
                    How Are You
                    """
        XCTAssertEqual(Lexer(input: input).tokenize().map { $0.token },
                       [
                        .hashtag, .whiteSpace, .text("Hello"), .newLine,
                        .text("How"), .whiteSpace, .text("Are"), .whiteSpace, .text("You")
                       ])
    }
    
    func test_link() {
        XCTAssertEqual(Lexer(input: "[link](google.com)").tokenize().map { $0.token }, [
            .openBracket, .text("link"), .closeBracket,
            .openParenthesis, .text("google"), .dot, .text("com"), .closeParenthesis
        ])
    }
    
    func test_image() {
        XCTAssertEqual(Lexer(input: "![Image](https://url/a.png)").tokenize().map { $0.token }, [
            .bang, .openBracket, .text("Image"), .closeBracket,
            .openParenthesis, .text("https://url/a"), .dot, .text("png"), .closeParenthesis
        ])
    }
    
    func test_block() {
        XCTAssertEqual(Lexer(input: "> Hello").tokenize().map { $0.token },
                       [.block, .whiteSpace, .text("Hello")])
    }
    
    func test_unorderedList_star() {
        let input = """
                    * first element
                    * second element
                    * third element
                    """
        XCTAssertEqual(Lexer(input: input).tokenize().map { $0.token },
                       [.star, .whiteSpace, .text("first"), .whiteSpace, .text("element"), .newLine,
                        .star, .whiteSpace, .text("second"), .whiteSpace, .text("element"), .newLine,
                        .star, .whiteSpace, .text("third"), .whiteSpace, .text("element")])
    }
    
    func test_unorderedList_dash() {
        let input = """
                    - first element
                    - second element
                    - third element
                    """
        XCTAssertEqual(Lexer(input: input).tokenize().map { $0.token },
                       [.dash, .whiteSpace, .text("first"), .whiteSpace, .text("element"), .newLine,
                        .dash, .whiteSpace, .text("second"), .whiteSpace, .text("element"), .newLine,
                        .dash, .whiteSpace, .text("third"), .whiteSpace, .text("element")])
    }
    
    func test_inlineCode() {
        XCTAssertEqual(Lexer(input: "`Hello`").tokenize().map { $0.token },
                       [.graveAccent, .text("Hello"), .graveAccent])
    }
    
    func test_codeBlock() {
        let input = """
                    Hello
                    ```
                    Code Here
                    ```
                    """
        XCTAssertEqual(Lexer(input: input).tokenize().map { $0.token },
                       [.text("Hello"), .newLine,
                        .graveAccent, .graveAccent, .graveAccent, .newLine,
                        .text("Code"), .whiteSpace, .text("Here"), .newLine,
                        .graveAccent, .graveAccent, .graveAccent])
    }
    
    func test_orderedList_withParenthesis() {
        let input = """
                    1) first
                    2) second
                    """
        XCTAssertEqual(Lexer(input: input).tokenize().map { $0.token },
                       [.int(1), .closeParenthesis, .whiteSpace, .text("first"), .newLine,
                        .int(2), .closeParenthesis, .whiteSpace, .text("second"),])
    }
    
    func test_orderedList_withDot() {
        let input = """
                    1. first
                    2. second
                    """
        XCTAssertEqual(Lexer(input: input).tokenize().map { $0.token },
                       [.int(1), .dot, .whiteSpace, .text("first"), .newLine,
                        .int(2), .dot, .whiteSpace, .text("second"),])
    }
    
    func test_horizontalLine_usingStars() {
        XCTAssertEqual(Lexer(input: "***").tokenize().map { $0.token }, [.star, .star, .star])
    }
    
    func test_horizontalLine_usingUnderscors() {
        XCTAssertEqual(Lexer(input: "___").tokenize().map { $0.token }, [.underScore, .underScore, .underScore])
    }
    
    func test_horizontalLine_usingDash() {
        XCTAssertEqual(Lexer(input: "---").tokenize().map { $0.token }, [.dash, .dash, .dash])
    }
    
    func test_stringRepresntation() {
        let input = """
                    .`->!()[]_#*123
                    
                    """
        XCTAssertEqual(
            Lexer(input: input).tokenize().map { $0.stringRepresentation },
            [".", "`", "-", ">", "!", "(", ")", "[", "]", "_", "#", "*", "123", "\n"]
        )
    }
}
