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
}
