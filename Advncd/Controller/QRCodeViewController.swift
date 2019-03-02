//
//  QRCodeViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Firebase

class QRCodeViewController: UIViewController {
    
    let qrView = QRCodeView()
    
    var uuid = ""
    var selectedType = ""
    let currentUser = Auth.auth().currentUser
    
    override func loadView() {
        self.view = qrView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        setupQRUpload()
        qrView.confirmButton.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupQRUpload() {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let QRString = "\(uuid)_\(selectedType)"
        qrView.QRCodeImage.image = QRString.qrCode
        uploadQRImage(data: (QRString.qrCode?.pngData())!, uuid: uuid)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        let dateString = formatter.string(from: date)
        qrView.detailsLabel.text = "Type: \(selectedType)\nCreated at: \(dateString)"
        AuthServices.instance.addQRData(uid: currentUser!.uid, qrId: uuid, qrType: selectedType, date: dateString)
        UIViewController.removeSpinner(spinner: sv)
    }
    
    func uploadQRImage(data: Data, uuid: String) {
        let storageRef = Storage.storage().reference().child("QR").child(uuid)
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            if error != nil {
                self.displayAlert(title: "Error uploading", message: "error uploading picture, please try again later or contact support")
                return
            } else {
                print("upload complete")
            }
        }
    }
    
    @objc func confirmPressed() {
        transitionToBaseVC()
    }
    
}
