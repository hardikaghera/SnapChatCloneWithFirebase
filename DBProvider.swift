//
//  DBProvider.swift
//  SnapChatCloneWithFirebase
//
//  Created by hardik aghera on 27/03/18.
//  Copyright © 2018 hardikaghera2306. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DBProvider {
    
    private static let _instance = DBProvider()
    
    private let USERS = "users"
    private let CHILD_MESSAGE = "message"
    private let EMAIL = "email"
    private let PASSWORD = "password"
    private let DATA = "data"
    private let IMAGE_STORAGE = "images"
    private let VIDEO_STORAGE = "videos"
    let SENDER_ID = "senderID"
    let RECEIVER = "receiver"
    let MEDIA_URL = "mediaURL"
    let MESSAGE = "message"
    
    var imageURL: URL?
    var videoURL: URL?
    
    static var instance: DBProvider {
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return dbRef.child(USERS)
    }
    
    var messageRef : FIRDatabaseReference {
        return dbRef.child(CHILD_MESSAGE)
    }
    
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://snapchatapp-65cd3.appspot.com")
    }
    
    var imageStorage: FIRStorageReference {
        return storageRef.child(IMAGE_STORAGE)
    }
    
    var videoStorage: FIRStorageReference {
        return storageRef.child(VIDEO_STORAGE)
    }
    
    func saveImage(data:Data,name: String) {
        let ref = imageStorage.child(name)
        ref.put(data, metadata: nil) { (metadata:FIRStorageMetadata?, err:Error?) in
            if err != nil {
                print("Problem uploading image")
            } else {
                self.imageURL = metadata!.downloadURL()
            }
            
        }
    }
    
    func saveVideo(url: URL,name: String) {
        let ref = videoStorage.child(name)
        ref.putFile(url, metadata: nil) { (metadata:FIRStorageMetadata?, error:Error?) in
            if error != nil {
                print("Problem uploading video")
            } else {
                self.videoURL = metadata!.downloadURL()
            }
            
        }
    }

    func setMessageandMedia(senderID: String, sendingTo: String,mediaURL: String,message: String) {
        let msg: Dictionary<String,String> = [self.SENDER_ID: senderID,self.RECEIVER: sendingTo,self.MEDIA_URL: mediaURL,self.MESSAGE: message]
        dbRef.child(CHILD_MESSAGE).childByAutoId().setValue(msg)
        
    }
    
    
    func saveUser (withID: String, email: String, password: String) {
        let data : Dictionary<String,String> = [EMAIL: email,PASSWORD: password]
        usersRef.child(withID).child(DATA).setValue(data)
        
    }
}
