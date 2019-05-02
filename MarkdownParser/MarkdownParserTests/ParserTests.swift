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
    
    func test_Italics() {
        XCTAssertEqual(Parser(input: "_Hello, World_").parse(), [.italics("Hello, World")])
        let multiLineUnderscoreInput = #"""
                                        _Hello
                                        , World")
                                        """#
        XCTAssertEqual(Parser(input: multiLineUnderscoreInput).parse(),
                       [.paragraph(multiLineUnderscoreInput)])
        XCTAssertEqual(Parser(input: "_Hello, World__").parse(), [.italics("Hello, World"), .paragraph("_")])
        
        XCTAssertEqual(Parser(input: "*Hello, World*").parse(), [.italics("Hello, World")])
        let multiLineStarInput = #"""
                                  *Hello
                                  , World")*
                                  """#
        XCTAssertEqual(Parser(input: multiLineStarInput).parse(), [.paragraph(multiLineStarInput)])
    }
    
    func test_unorderedList() {
        let starUnorderedList = """
                                * first element
                                * second element
                                * third element
                                """
        XCTAssertEqual(Parser(input: starUnorderedList).parse(),
                       [.unorderedList(["first element\n",
                                        "second element\n",
                                        "third element"])])
        let dashUnorderedList = """
                                - first element
                                - second element
                                - third element
                                """
        XCTAssertEqual(Parser(input: dashUnorderedList).parse(),
                       [.unorderedList(["first element\n",
                                        "second element\n",
                                        "third element"])])
    }
    
    func test_orderedList() {
        let bracesOrderedList = """
                                1) first element
                                2) second element
                                """
        XCTAssertEqual(Parser(input: bracesOrderedList).parse(),
                       [.orderedList(["first element\n", "second element"])])
        let dotOrderedList = """
                             1. first element
                             2. second element
                             """
        XCTAssertEqual(Parser(input: dotOrderedList).parse(),
                       [.orderedList(["first element\n", "second element"])])
    }
    
    func test_block() {
        let content =
        """
        The music video for Rihanna’s song American Oxygen depicts various
        moments from American history, including the inauguration of Barack Obama
        """
        let block =
        """
        > \(content)
        """
        XCTAssertEqual(Parser(input: block).parse(), [.block(content)])
    }
}
