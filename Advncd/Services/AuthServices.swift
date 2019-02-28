//
//  AuthServices.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import FirebaseAuth
import Firebase
import UIKit

class AuthServices {
    
    static let instance = AuthServices()
    
    var errorMessage = String()
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
}
