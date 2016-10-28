//
//  Renderer.swift
//  Band Practice
//
//  Created by Andrew Carter on 10/23/16.
//  Copyright © 2016 Andrew Carter. All rights reserved.
//

import Foundation

protocol Renderer {
    func render(book: Book, to url: URL)
}
