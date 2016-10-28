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
        name = try jsonObject.decode("name")
        
        let songsObject: [[String: Any]] = try jsonObject.decode("songs")
        let songs = try songsObject.map { try Song(dictionary: $0, baseURL: url.deletingLastPathComponent()) }
        
        let artists = Set(songs.map { $0.artist.lowercased() })
        let sortedArtists = artists.sorted()
        
        self.songs = sortedArtists.reduce([Song]()) { (result, artist) -> [Song] in
            return result + songs.filter { $0.artist.lowercased() == artist.lowercased() }
        }
    }
}
