//
//  Document.swift
//  MarkdownParser
//
//  Created by Naif Alrashed on 21/04/2019.
//  Copyright © 2019 Naif Alrashed. All rights reserved.
//

enum Document: Equatable {
    case paragraph(String)
    case h1(String)
    case h2(String)
}
