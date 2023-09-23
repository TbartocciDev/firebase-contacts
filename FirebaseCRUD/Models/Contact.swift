//
//  Contact.swift
//  FirebaseCRUD
//
//  Created by Tommy Bartocci on 9/17/23.
//

import Foundation


struct Contact: Codable, FirebaseObject {
    var id: String? = nil
    var firstName: String
    var lastName: String
    var phoneNum: String
    var email: String
    
    var imgData: Data?
    
    init(firstName: String, lastName: String, phoneNum: String, email: String){
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNum = phoneNum
        self.email = email
    }
    
}
