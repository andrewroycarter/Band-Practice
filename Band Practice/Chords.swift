//
//  Chords.swift
//  Band Practice
//
//  Created by Andrew Carter on 10/28/16.
//  Copyright © 2016 Andrew Carter. All rights reserved.
//

import Foundation

struct Chord {
    
    enum RootNote: Int {
        
        enum RootNoteError: Error {
            case unknownString(String)
        }
        
        case c
        case cSharp
        case d
        case dSharp
        case e
        case f
        case fSharp
        case g
        case gSharp
        case a
        case aSharp
        case b
        
        init(string: String) throws {
            let compareString = string.lowercased()
            
            if compareString.contains("c#") || compareString.contains("db") {
                self = .cSharp
            } else if compareString.contains("c") {
                self = .c
            } else if compareString.contains("d#") || compareString.contains("eb") {
                self = .dSharp
            } else if compareString.contains("d") {
                self = .d
            } else if compareString.contains("e") {
                self = .e
            } else if compareString.contains("f#") || compareString.contains("gb") {
                self = .fSharp
            } else if compareString.contains("f") {
                self = .f
            } else if compareString.contains("g#") || compareString.contains("ab") {
                self = .gSharp
            } else if compareString.contains("g") {
                self = .g
            } else if compareString.contains("a#") || compareString.contains("bb") {
                self = .aSharp
            } else if compareString.contains("a") {
                self = .a
            } else if compareString.contains("b") {
                self = .b
            } else {
                throw RootNoteError.unknownString(string)
            }
        }
    }
    
    let range: NSRange
    let rootNote: RootNote
    let string: String
    
    init?(string: String, range: NSRange) {
        guard let rootNote = try? RootNote(string: string) else {
            return nil
        }
        
        self.rootNote = rootNote
        self.string = string
        self.range = range
    }
}
