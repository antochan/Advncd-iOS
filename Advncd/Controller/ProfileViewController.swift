//
//  ProfileViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    
    override func loadView() {
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        profileView.backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        profileView.logoutButton.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let baseVC = storyboard.instantiateViewController(withIdentifier: "BaseVC") as! BaseViewController
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

}
