//
//  Song.swift
//  Band Practice
//
//  Created by Andrew Carter on 10/23/16.
//  Copyright © 2016 Andrew Carter. All rights reserved.
//

import Foundation

struct Song {
    let title: String
    let artist: String
    let body: String
    
    init(dictionary: [String: Any], baseURL: URL) throws {
        let source: String = try dictionary.decode("source")
        body = try String(contentsOf: baseURL.appendingPathComponent(source))
        title = try dictionary.decode("title")
        artist = try dictionary.decode("artist")
        
    }
}

extension Song: Equatable {
    public static func ==(lhs: Song, rhs: Song) -> Bool {
        return lhs.title == rhs.title
    }
}

extension Song: Comparable {

    public static func <(lhs: Song, rhs: Song) -> Bool {
        return lhs.title < rhs.title 
    }

    
}
