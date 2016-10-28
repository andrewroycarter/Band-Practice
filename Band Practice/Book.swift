//
//  Book.swift
//  Band Practice
//
//  Created by Andrew Carter on 10/23/16.
//  Copyright © 2016 Andrew Carter. All rights reserved.
//

import Foundation

struct Book {
    
    let songs: [Song]
    let name: String
    
    init(url: URL) throws {
        let jsonData = try Data(contentsOf: url)
        guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            throw DecodeError.expectedDictionary
        }
        songs = try (try jsonObject.decode("songs") as [[String: Any]]).map { try Song(dictionary: $0, baseURL: url.deletingLastPathComponent()) }
        name = try jsonObject.decode("name")
    }
}
