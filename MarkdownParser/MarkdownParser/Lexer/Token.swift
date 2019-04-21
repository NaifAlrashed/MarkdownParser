//
//  Token.swift
//  MarkdownParser
//
//  Created by Naif Alrashed on 05/04/2019.
//  Copyright © 2019 Naif Alrashed. All rights reserved.
//

enum Token: Equatable {
    
    case hashtag
    
    case star
    
    case underScore
    
    case text(String)
    
    case bang
    
    case openBracket
    case closeBracket
    
    case openParenthesis
    case closeParenthesis
    
    case block
    
    case graveAccent
    
    case dash
    
    case int(Int)
    
    case dot
    
    case whiteSpace
    case newLine
}