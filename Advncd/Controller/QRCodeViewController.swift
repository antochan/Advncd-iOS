//
//  QRCodeViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class QRCodeViewController: UIViewController {
    
    let qrView = QRCodeView()
    
    var uuid = ""
    var selectedType = ""
    let currentUser = Auth.auth().currentUser
    var dateString = ""
    
    override func loadView() {
        self.view = qrView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        setupQRUpload()
        qrView.confirmButton.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
        qrView.saveImageButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupQRUpload() {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let QRString = "https://advncd-ar.com/\(uuid)_\(selectedType)"
        qrView.QRCodeImage.image = QRString.qrCode
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        dateString = formatter.string(from: date)
        qrView.detailsLabel.text = "Type: \(selectedType)\nCreated at: \(dateString)"
        uploadQRImage(data: (QRString.qrCode?.pngData())!, uuid: uuid)
        UIViewController.removeSpinner(spinner: sv)
    }
    
    func uploadQRImage(data: Data, uuid: String) {
        let storageRef = Storage.storage().reference().child("QR").child(uuid)
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    self.displayAlert(title: "Error uploading", message: "An error has occured uploading your image. Try again later")
                    return
                }
                AuthServices.instance.addQRData(uid: (self.currentUser?.uid)!, qrId: uuid, qrType: self.selectedType, date: self.dateString, downloadURL: downloadURL.absoluteString)
                self.writeQRURL(uuid: uuid, downloadURL: downloadURL.absoluteString, selectedType: self.selectedType)
            }
        }
    }
    
    func writeQRURL(uuid: String, downloadURL: String, selectedType: String) {
        let databaseRef = Database.database().reference().child("QR").child("\(uuid)_\(selectedType)")
        databaseRef.setValue(downloadURL)
    }
    
    @objc func confirmPressed() {
        transitionToBaseVC()
    }
    
    @objc func saveImage() {
        UIImageWriteToSavedPhotosAlbum(qrView.QRCodeImage.image!, nil, nil, nil)
        displayAlert(title: "Saved Image!", message: "Your QR code is saved to your phone! Get creative and enjoy! :)")
    }
    
}
