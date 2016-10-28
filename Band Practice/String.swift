//
//  String.swift
//  Band Practice
//
//  Created by Andrew Carter on 10/28/16.
//  Copyright © 2016 Andrew Carter. All rights reserved.
//

import Foundation

extension String {
    
    var chords: [Chord] {
        var chords = [Chord]()
        
        let expression: NSRegularExpression
        
        do {
            expression = try NSRegularExpression(pattern: "\\[([^]]*)]", options: [])
        } catch {
            fatalError("Failed to create regular expression for finding chords")
        }
        
        expression.enumerateMatches(in: self, options: [], range: NSMakeRange(0, characters.count)) { (result, flags, stop) in
            guard let result = result else {
                return
            }
            
            let chordString = (self as NSString).substring(with: result.range)
            if let chord = Chord(string: chordString, range: result.range) {
                chords.append(chord)
            }
        }
        
        return chords
    }
    
}
