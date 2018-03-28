//
//  Users.swift
//  SnapChatCloneWithFirebase
//
//  Created by hardik aghera on 25/03/18.
//  Copyright © 2018 hardikaghera2306. All rights reserved.
//

import Foundation

struct User {
    
    private var _email = String()
    private var _id = String()
    
    init(email: String,id: String) {
       
        _email = email
        _id = id
    }
    
    var email: String {
        return _email
    }
    
    var id: String {
        return _id
    }
}
