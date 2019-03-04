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
    var allARImageReferenceImage = Set<ARReferenceImage>()
    var downloadURLs = Set<String>()
    
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
    
    func getAllQRCodes(completion: @escaping CompletionHandler) {
        let reference = Database.database().reference().child("QR")
        reference.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : String] ?? [:]
            for (key, value) in postDict {
                if self.downloadURLs.contains(value) == false {
                    self.downloadURLs.insert(value)
                    let qrImage = UIImage(url: URL(string: value))
                    let qrCiImage = CIImage(image: qrImage!)
                    let qrCGImage = self.convertCIImageToCGImage(inputImage: qrCiImage!)
                    let qrARImage = ARReferenceImage(qrCGImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
                    qrARImage.name = key
                    self.allARImageReferenceImage.insert(qrARImage)
                }
            }
            completion(true)
        })
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
    
}
