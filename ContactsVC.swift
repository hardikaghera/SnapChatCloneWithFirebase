//
//  ContactsVC.swift
//  SnapChatCloneWithFirebase
//
//  Created by hardik aghera on 25/03/18.
//  Copyright © 2018 hardikaghera2306. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MobileCoreServices
import FirebaseAuth


class ContactsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private var users = [User]()

    @IBOutlet weak var contactsTableView: UITableView!
    private var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        checkForMessages()
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
             let imgData = UIImageJPEGRepresentation(pickedImage, 0.5)! as Data
            let imgName = "\(NSUUID().uuidString).jpg"
            DBProvider.instance.saveImage(data: imgData, name: imgName)
            dismiss(animated: true, completion: nil)
            
        } else if let pickedVideoURL = info[UIImagePickerControllerMediaURL] as? URL {
            
            let videoName = "\(NSUUID().uuidString)\(pickedVideoURL)"
            DBProvider.instance.saveVideo(url: pickedVideoURL, name: videoName)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func checkForMessages() {
        
        DBProvider.instance.messageRef.observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            
            if let receiveMessage = snapshot.value as? Dictionary<String,AnyObject> {
                
                for(_,value) in receiveMessage {
                    
                    if let message = value as? Dictionary<String,String>{
                        let mediaURL = message[DBProvider.instance.MEDIA_URL]
                        let msg = message[DBProvider.instance.MESSAGE]
                        let receiverID = message[DBProvider.instance.RECEIVER]
                        let senderID = message[DBProvider.instance.SENDER_ID]
                        
                        if receiverID == FIRAuth.auth()!.currentUser!.uid {
                            self.messageReceived(title: "You Received a Message From User\(senderID!)", message: msg!, mediaURL: mediaURL!)
                        }
                    }
                }
            }
            
        }
    }
    
    private func getUsers() {
        DBProvider.instance.usersRef.observeSingleEvent(of: FIRDataEventType.value){ (snapshot: FIRDataSnapshot) in
         
            if let myUsers = snapshot.value as? Dictionary<String,AnyObject> {
                
                for (key,value) in myUsers {
                 
                    if let userData = value as? Dictionary<String,AnyObject> {
                        
                        if let data = userData["data"] as? Dictionary<String,AnyObject> {
                            
                            if let email = data["email"] as? String {
                                
                                let id = key
                                let newUser = User(email: email, id: id)
                                self.users.append(newUser)
                            }
                            
                        }
                    }
                }
            }
            self.contactsTableView.reloadData()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
    }

   
    @IBAction func logOutButtonTapped(_ sender: AnyObject) {
        if AuthProvider.instance.logOut() {
            dismiss(animated: true, completion: nil)
        } else {
            showAlertMessage(title: "Could Not LogOut", message: "Problem Conneting to server please try Again!")
        }
        
    }

    @IBAction func GalleryButtonTapped(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)

            
        }
    }

    @IBAction func cameraButtonTapped(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }

    @IBAction func sendButtonTapped(_ sender: AnyObject) {
        
        if index != -1 {
            if DBProvider.instance.imageURL != nil {
                DBProvider.instance.setMessageandMedia(senderID: FIRAuth.auth()!.currentUser!.uid, sendingTo: users[index].id, mediaURL: DBProvider.instance.imageURL!.absoluteString, message: "Hey this is my cool image")
                index = -1
                
            } else if DBProvider.instance.videoURL != nil {
                DBProvider.instance.setMessageandMedia(senderID: FIRAuth.auth()!.currentUser!.uid, sendingTo: users[index].id, mediaURL: DBProvider.instance.videoURL!.absoluteString, message: "Hey this is my cool video")
                index = -1
                
            } else {
                showAlertMessage(title: "No data Selected", message: "Please select either Video or An Image to send")
            }
        } else {
            showAlertMessage(title: "Select a User", message: "Please Select a user to send a message to!")
        }
    }
   
    @IBAction func VideoButtonTapped(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    private func showAlertMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func messageReceived(title: String, message: String, mediaURL: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: "YES", style: .default) { (alertAction: UIAlertAction) in
            self.performSegue(withIdentifier: "ShowMessageVC", sender: mediaURL)
        }
        
        let no = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        alert.addAction(no)
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ShowMessageVC {
            
            if let mediaURL = sender as? String {
                destination.mediaURL = mediaURL
            }
        }
    }

} // class
