//
//  DocumentSnapshot.swift
//  FirebaseCRUD
//
//  Created by Tommy Bartocci on 9/17/23.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot {
    func decode<T: Codable>(as objectType: T.Type, includesId: Bool = true) throws -> T {
        var documentJson = data()
        if includesId {
            documentJson!["id"] = documentID
        }
        
        let documentData = try JSONSerialization.data(withJSONObject: documentJson)
        
        let decodedData = try JSONDecoder().decode(objectType, from: documentData)
        
        return decodedData
    }
}
