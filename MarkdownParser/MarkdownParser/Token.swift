//
//  Token.swift
//  MarkdownParser
//
//  Created by Naif Alrashed on 05/04/2019.
//  Copyright © 2019 Naif Alrashed. All rights reserved.
//

enum Token: Equatable {
    
    case h1
    
    case doubleStars
    case singleStar
    
    case doubleUnderScore
    case singleUnderScore
    
    case text(String)
}
