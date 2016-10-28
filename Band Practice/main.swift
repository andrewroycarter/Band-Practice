//
//  main.swift
//  Band Practice
//
//  Created by Andrew Carter on 10/23/16.
//  Copyright © 2016 Andrew Carter. All rights reserved.
//

import Foundation

let arguments = CommandLine.arguments
guard arguments.count == 3 else {
    print("Missing parameters. Example usage: bandpractice ~/books/my_book.json ~/Desktop")
    exit(1)
}

let sourcePath = (arguments[1] as NSString).expandingTildeInPath
let destinationPath = (arguments[2] as NSString).expandingTildeInPath

let sourceURL = URL(fileURLWithPath: sourcePath)
let destinationURL = URL(fileURLWithPath: destinationPath)

print("Creating book...")
let book = try Book(url: sourceURL)

print("Rendering book...")
let renderer = PDFRenderer()
renderer.render(book: book, to: destinationURL)

print("Rendered to \(destinationURL.absoluteString).")
