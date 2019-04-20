//
//  Token.swift
//  MarkdownParser
//
//  Created by Naif Alrashed on 05/04/2019.
//  Copyright © 2019 Naif Alrashed. All rights reserved.
//

enum Token: Equatable {
    
    case hashtag
    
    case doubleStars
    case singleStar
    
    case doubleUnderScore
    case singleUnderScore
    
    case text(String)
    
    case bang
    
    case openBracket
    case closeBracket
    
    case openParenthesis
    case closeParenthesis
    
    case block
    case codeBlock
    
    case dash
    
    case inlineCode
    
    case int(Int)
    
    case dot
    
    case whiteSpace
    case newLine
}
