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
}