//
//  QRServices.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import Firebase
import UIKit
import ARKit

class QRServices {
    
    static let instance = QRServices()
    var userQRCodes = [QR]()
    var errorMessage = " "
    
    private func reference(to collectionReference: CollectionReferences) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func configure() {
        FirebaseApp.configure()
    }
    
    func getUserQRCodes(uid: String, completion: @escaping CompletionHandler) {
        reference(to: .Users).document(uid).collection("QRCodes")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    completion(false)
                    return
                }
                if documents.count == 0 {
                    self.userQRCodes = []
                    completion(true)
                } else {
                    for document in documents {
                        let QRObject = QR(qrId: document.documentID,
                                          date: document.data()["date"] as! String,
                                          qrType: document.data()["qrType"] as! String,
                                          downloadURL: document.data()["downloadURL"] as! String)
                        if self.userQRCodes.contains(QRObject) == false {
                           self.userQRCodes.append(QRObject)
                        }
                    }
                    completion(true)
                }
            }
    }
    
    func removeRealtimeQRCode(qrId: String, selectedType: String) {
        let ref = Database.database().reference().child("QR").child("\(qrId)_\(selectedType)")
        ref.removeValue()
    }
    
    func removeQRCode(uid: String, qrId: String, completion: @escaping CompletionHandler) {
        reference(to: .Users).document(uid).collection("QRCodes").document(qrId)
            .delete() { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                print(err.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
}
