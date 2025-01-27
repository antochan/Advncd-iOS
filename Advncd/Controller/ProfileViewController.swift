//
//  ProfileViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseUI

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    let currentUser = Auth.auth().currentUser!
    
    override func loadView() {
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        profileView.backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        profileView.logoutButton.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        let nib = UINib(nibName: "QRCodeTableViewCell", bundle: nil)
        profileView.tableView.register(nib, forCellReuseIdentifier: "QRCell")
        profileView.tableView.backgroundColor = .clear
        profileView.tableView.separatorStyle = .none
        profileView.tableView.tableFooterView = UIView()
        
        getUserQRCodes(uid: currentUser.uid)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let baseVC = storyboard.instantiateViewController(withIdentifier: "PagerTabVC") as! PagerTabViewController
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(baseVC, animated: false, completion: nil)
    }
    
    @objc func logoutPressed() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler:{ (UIAlertAction)in
            do {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthVC") as! AuthViewController
                self.present(authViewController, animated: true, completion: nil)
            } catch let err {
                print(err)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getUserQRCodes(uid: String) {
        profileView.animationView.isHidden = false
        profileView.loaderbackground.isHidden = false
        QRServices.instance.userQRCodes.removeAll()
        QRServices.instance.getUserQRCodes(uid: uid) { (success) in
            if success {
                self.profileView.animationView.isHidden = true
                self.profileView.loaderbackground.isHidden = true
                self.profileView.tableView.reloadData()
                self.profileView.remainingLabel.text = "\(QRServices.instance.userQRCodes.count) / 3"
            } else {
                self.profileView.animationView.isHidden = true
                self.profileView.loaderbackground.isHidden = true
                self.displayAlert(title: "Error", message: "There was an error getting your QR codes! Try again later!")
            }
        }
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = QRServices.instance.userQRCodes.count
        if count == 0 {
            profileView.noDataLabel.isHidden = false
            return 0
        } else {
            profileView.noDataLabel.isHidden = true
            return QRServices.instance.userQRCodes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QRCell", for: indexPath as IndexPath) as! QRCodeTableViewCell
        cell.selectionStyle = .none
        let userQRCodes = QRServices.instance.userQRCodes
        let date = userQRCodes[indexPath.row].date
        let qrType = userQRCodes[indexPath.row].qrType
        let downloadURL = userQRCodes[indexPath.row].downloadURL
        cell.QRImageView.sd_setImage(with: URL(string: downloadURL), placeholderImage: #imageLiteral(resourceName: "QRcode"), completed: { image, error, cacheType, imageURL in
            self.profileView.loaderbackground.isHidden = true
            self.profileView.animationView.isHidden = true
        })
        cell.detailsLabel.text = "Type: \(qrType)\nCreated at: \(date)"
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(removeQRCodeTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transitionToQRDetailsVC(indexPath: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height * 0.175
    }
    
    func transitionToQRDetailsVC(indexPath: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let QRDetailsVC = storyboard.instantiateViewController(withIdentifier: "QRDetailsVC") as! QRDetailsViewController
        let indexPath = IndexPath(row: indexPath, section: 0)
        let cell = profileView.tableView.cellForRow(at: indexPath) as! QRCodeTableViewCell
        QRDetailsVC.qrView.QRCodeImage.image = cell.QRImageView.image
        QRDetailsVC.qrView.detailsLabel.text = cell.detailsLabel.text
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(QRDetailsVC, animated: false, completion: nil)
    }
    
    @objc func removeQRCodeTapped(sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        QRServices.instance.removeRealtimeQRCode(qrId: QRServices.instance.userQRCodes[sender.tag].qrId, selectedType: QRServices.instance.userQRCodes[sender.tag].qrType)
        if let uid = Auth.auth().currentUser?.uid {
            QRServices.instance.removeQRCode(uid: uid, qrId: QRServices.instance.userQRCodes[sender.tag].qrId) { (success) in
                if success {
                    print(sender.tag)
                    self.getUserQRCodes(uid: uid)
                    self.profileView.tableView.reloadData()
                    UIViewController.removeSpinner(spinner: sv)
                } else {
                    UIViewController.removeSpinner(spinner: sv)
                    self.displayAlert(title: "Error", message: "Something unexpected happened when trying to delete your QR code, try again later")
                }
            }
        }
    }
    
}
