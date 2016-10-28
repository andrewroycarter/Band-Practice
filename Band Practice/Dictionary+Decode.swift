//
//  Dictionary+Decode.swift
//  Band Practice
//
//  Created by Andrew Carter on 10/28/16.
//  Copyright © 2016 Andrew Carter. All rights reserved.
//

import Foundation

enum DecodeError: Error {
    case missingKey(String)
    case valueTypeMismatch(String)
    case expectedDictionary
    case expectedArray
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    func decode<T>(_ key: Key) throws -> T {
        return try decodeNonOptionalValue(for: key)
    }
    
    func decode<T: ExpressibleByNilLiteral>(_ key: Key) throws -> T {
        let value = self[key]
        
        if value == nil {
            return nil
        } else {
            return try decodeNonOptionalValue(for: key)
        }
    }
    
    func decodeNonOptionalValue<T>(for key: Key) throws -> T {
        switch self[key] {
        case let value as T:
            return value
            
        case nil:
            throw DecodeError.missingKey(String(describing: key))
            
        case .some:
            throw DecodeError.valueTypeMismatch(String(describing: key))
        }
    }
}
