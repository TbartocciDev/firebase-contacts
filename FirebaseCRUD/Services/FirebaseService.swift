//
//  FireService.swift
//  FirebaseCRUD
//
//  Created by Tommy Bartocci on 9/17/23.
//

import UIKit
import FirebaseFirestore

enum FirestoreCollectionReference: String {
    case contacts
}

class FirebaseService {
    private init() {}
    
    static let shared = FirebaseService()
    
    private func reference(to collectionReference: FirestoreCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func create<T: Codable>(for encodableObject: T, in collectionReference: FirestoreCollectionReference) {
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            
            reference(to: collectionReference).addDocument(data: json) { error in
                
            }
        } catch {
            print(error)
        }
    }
    
    func read<T: Codable>(from collectionReference: FirestoreCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        reference(to: collectionReference).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            do {
                var objects: [T] = []
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                
                completion(objects)
            } catch {
                print(error)
            }
//            print(snapshot.documents.count)
        }
    }
    
    func update<T: Codable & FirebaseObject>(for encodableObject: T, in collectionReference: FirestoreCollectionReference) {
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            guard let id = encodableObject.id else { throw error.encoding }
            reference(to: collectionReference).document(id).setData(json)
        } catch {
            print(error)
        }
    }
    
    func delete<T: FirebaseObject>(_ object: T, in collectionReference: FirestoreCollectionReference) {
        do {
            guard let id = object.id else { throw error.encoding}
            reference(to: collectionReference).document(id).delete()
        } catch {
            print(error)
        }
        
    }
}
