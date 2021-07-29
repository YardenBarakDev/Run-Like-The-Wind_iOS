//
//  UserAccount.swift
//  Run Like The Wind
//
//  Created by Yarden Barak on 30/06/2021.
//

import Foundation

class UserAccount : Codable{
   
    let idToken : String // Safe to send to the server
    let givenName : String
    let familyName : String
    let email : String
    
    init(idToken : String, givenName : String, familyName : String, email : String) {
        self.idToken = idToken
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
    }
    
}
