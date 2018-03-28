//
//  DBProvider.swift
//  SnapChatCloneWithFirebase
//
//  Created by hardik aghera on 27/03/18.
//  Copyright © 2018 hardikaghera2306. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider()
    private let USERS = "users"
    private let EMAIL = "email"
    private let PASSWORD = "password"
    private let DATA = "data"
    
    static var instance: DBProvider {
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return dbRef.child(USERS)
    }
    
    func saveUser (withID: String, email: String, password: String) {
        let data : Dictionary<String,String> = [EMAIL: email,PASSWORD: password]
        usersRef.child(withID).child(DATA).setValue(data)
        
    }
}
