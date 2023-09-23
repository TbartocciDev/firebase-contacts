//
//  Encodable.swift
//  FirebaseCRUD
//
//  Created by Tommy Bartocci on 9/17/23.
//

import Foundation

enum error: Error {
    case encoding
}

extension Encodable {
    func toJson(excluding keys: [String] = [String]()) throws -> [String : Any]{
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        
        guard var json = jsonObject as? [String : Any] else { throw error.encoding }
        
        for key in keys {
            json[key] = nil
        }
        
        return json
    }
}
