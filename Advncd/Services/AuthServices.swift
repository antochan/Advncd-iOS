//
//  AuthServices.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Firebase
import UIKit

class AuthServices {
    
    static let instance = AuthServices()
    
    var errorMessage = String()
    
    private func reference(to collectionReference: CollectionReferences) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func configure() {
        FirebaseApp.configure()
    }
    
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
    
    func writeUserToDB(uid: String, email: String, completion: @escaping CompletionHandler) {
        reference(to: .Users).document(uid).setData([
            "uid": uid,
            "email": email
        ]) { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func addQRData(uid: String, qrId: String, qrType: String, date: String) {
        reference(to: .Users).document(uid).collection("QRCodes").document(qrId).setData([
            "qrType": qrType,
            "date": date
        ]) { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
            } else {
                print("successfully added qr to user")
            }
        }
    }
    
}
