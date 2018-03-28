//
//  ContactsVC.swift
//  SnapChatCloneWithFirebase
//
//  Created by hardik aghera on 25/03/18.
//  Copyright © 2018 hardikaghera2306. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ContactsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    private var users = [User]()

    @IBOutlet weak var contactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        // Do any additional setup after loading the view.
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

   
    @IBAction func logOutButtonTapped(_ sender: AnyObject) {
        if AuthProvider.instance.logOut() {
            dismiss(animated: true, completion: nil)
        } else {
            showAlertMessage(title: "Could Not LogOut", message: "Problem Conneting to server please try Again!")
        }
        
    }

    @IBAction func GalleryButtonTapped(_ sender: AnyObject) {
    }

    @IBAction func cameraButtonTapped(_ sender: AnyObject) {
    }

    @IBAction func sendButtonTapped(_ sender: AnyObject) {
    }
   
    @IBAction func VideoButtonTapped(_ sender: AnyObject) {
    }
    
    private func showAlertMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }

} // class
