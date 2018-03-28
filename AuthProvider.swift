//
//  AuthProvider.swift
//  SnapChatCloneWithFirebase
//
//  Created by hardik aghera on 25/03/18.
//  Copyright © 2018 hardikaghera2306. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ errMSG: String?) -> Void

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid email Address, Please enter valid email Address!!"
    static let WRONG_PASSWORD = "Invalid Password, Please enter valid Password"
    static let PROBLEM_CONNECTING = "Problem Connecting to Database"
    static let USER_NOT_FOUND = "User not found, Please Register!!"
    static let EMAIL_ALREADY_IN_USE = "Email Already in use, Please use another email address"
    static let WEAK_PASSWORD = "Password should be atleast 6 character long!"
}

class AuthProvider {
    private static let _instance = AuthProvider()
    
    static var instance: AuthProvider {
        return _instance
    }
    
    func isLoggedIn() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            return true
        }
        
        return false
    }
    
    func logOut() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            do{
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                return false
            }
        }
        return true
        
    }
    
    func login(withEmail: String,password: String,loginHandler: LoginHandler?) {
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                // User not Signed in we have Problem
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            } else {
               // User is signed In
                loginHandler?(nil)
            }
        })
    }
    
    func signUp(withEmail: String, password: String, loginHandler: LoginHandler?) {
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            } else {
                // uid = userid (unique for every User)
                if user?.uid != nil {
                    
                    // Save to database
                    DBProvider.instance.saveUser(withID: user!.uid, email: withEmail, password: password)
                    
                    // sign in user
                    FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
                        
                        if error != nil {
                           self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
                        } else {
                            loginHandler?(nil)
                        }
                    })
                    
                }
            }
        })
        
    }
    
    private func handleErrors(err: NSError,loginHandler: LoginHandler?) {
        
        if let errCode = FIRAuthErrorCode(rawValue: err.code) {
            
            switch errCode {
            case .errorCodeWrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
            case .errorCodeInvalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
            case .errorCodeUserNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
            case .errorCodeWeakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                break
            }
        }
    }
}
