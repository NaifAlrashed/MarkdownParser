//
//  ParserTests.swift
//  MarkdownParserTests
//
//  Created by Naif Alrashed on 21/04/2019.
//  Copyright © 2019 Naif Alrashed. All rights reserved.
//

import XCTest
@testable import MarkdownParser

class ParserTests: XCTestCase {

    func test_parse_noContent() {
        XCTAssertEqual(Parser(input: "").parse(), [])
    }
    
    func test_parse_normalText() {
        XCTAssertEqual(Parser(input: "hello").parse(), [.paragraph("hello")])
    }
    
    func test_parse_normalText_withSpace() {
        XCTAssertEqual(Parser(input: "hello world").parse(), [
            .paragraph("hello world")])
    }
    
    func test_h1() {
        XCTAssertEqual(Parser(input: "# Hello").parse(), [.h1("Hello")])
        XCTAssertEqual(Parser(input: "#Hello").parse(), [.paragraph("#Hello")])
    }
    
    func test_h2() {
        XCTAssertEqual(Parser(input: "## Hello").parse(), [.h2("Hello")])
        XCTAssertEqual(Parser(input: "##Hello").parse(), [.paragraph("##Hello")])
    }
    
    func test_h3() {
        XCTAssertEqual(Parser(input: "### Hello").parse(), [.h3("Hello")])
        XCTAssertEqual(Parser(input: "###Hello").parse(), [.paragraph("###Hello")])
    }
    
    func test_h4() {
        XCTAssertEqual(Parser(input: "#### Hello").parse(), [.h4("Hello")])
        XCTAssertEqual(Parser(input: "####Hello").parse(), [.paragraph("####Hello")])
    }
    
    func test_h5() {
        XCTAssertEqual(Parser(input: "##### Hello").parse(), [.h5("Hello")])
        XCTAssertEqual(Parser(input: "#####Hello").parse(), [.paragraph("#####Hello")])
    }
    
    func test_h6() {
        XCTAssertEqual(Parser(input: "###### Hello").parse(), [.h6("Hello")])
        XCTAssertEqual(Parser(input: "######Hello").parse(), [.paragraph("######Hello")])
    }
    
    func test_inlineCode() {
        XCTAssertEqual(Parser(input: #"`print("Hello, world")`"#).parse(),
                       [.inlineCode(#"print("Hello, world")"#)])
        let input = #"""
                    `print("Hello
                    ,world")`
                    """#
        XCTAssertEqual(Parser(input: input).parse(), [.paragraph(input)])
    }
    
    func test_bold() {
        XCTAssertEqual(Parser(input: "__Hello, World__").parse(), [.bold("Hello, World")])
        let multiLineUnderscoreInput = #"""
                    __Hello
                    , World")__
                    """#
        XCTAssertEqual(Parser(input: multiLineUnderscoreInput).parse(),
                       [.paragraph(multiLineUnderscoreInput)])
        
        XCTAssertEqual(Parser(input: "**Hello, World**").parse(), [.bold("Hello, World")])
        let multiLineStarInput = #"""
                    **Hello
                    , World")**
                    """#
        XCTAssertEqual(Parser(input: multiLineStarInput).parse(), [.paragraph(multiLineStarInput)])
    }
}
