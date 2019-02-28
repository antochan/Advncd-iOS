//
//  AuthViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/2/28.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Lottie
import WhatsNewKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class AuthViewController: UIViewController {
    
    let authView = AuthView()
    
    var activeTextField = UITextField()
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewWillLayoutSubviews() {
//        if Auth.auth().currentUser != nil {
//            transitionToBaseVC()
//        } else {
//            featuresIfNeeded()
//        }
        featuresIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        authView.emailTextfield.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        authView.passwordTextfield.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        authView.confirmButton.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func emailDidChange(_ textField: UITextField) {
        authView.emailDivider.backgroundColor = .white
        authView.emailImage.image = #imageLiteral(resourceName: "avatar-white")
    }
    
    @objc func passwordDidChange(_ textfield: UITextField) {
        authView.passwordDivider.backgroundColor = .white
        authView.passwordImage.image = #imageLiteral(resourceName: "lock-white")
    }
    
    @objc func confirmPressed() {
        let sv = UIViewController.displaySpinner(onView: self.view)
        formChecker(sv: sv)
        if let email = authView.emailTextfield.text , let password = authView.passwordTextfield.text {
            AuthServices.instance.loginUser(email: email, password: password) { (success) in
                if success {
                    print("Logged In transition to base VC")
                } else {
                    self.registerUser(email: email, password: password, sv: sv)
                }
            }
        }
    }
    
    func registerUser(email: String, password: String, sv: UIView) {
        AuthServices.instance.registerUser(email: email, password: password) { (success) in
            if success {
                if let user = Auth.auth().currentUser {
                    let docRef = Firestore.firestore().collection("Users").document(user.uid)
                    docRef.getDocument { (document, error) in
                        if let document = document, !document.exists {
                            self.writeToDB(email: email, uid: user.uid)
                        }
                    }
                }
            } else {
                self.authView.displayError(message: AuthServices.instance.errorMessage)
                UIViewController.removeSpinner(spinner: sv)
            }
        }
    }
    
    func writeToDB(email: String, uid: String) {
        AuthServices.instance.writeUserToDB(uid: uid, email: email) { (success) in
            if success {
                print("transition now!")
            } else {
                self.authView.displayError(message: AuthServices.instance.errorMessage)
            }
        }
    }
    
    func formChecker(sv: UIView) {
        if authView.emailTextfield.text == "" || authView.passwordTextfield.text == "" {
            authView.displayError(message: "Please make sure to fill in both email and password.")
            UIViewController.removeSpinner(spinner: sv)
        }
    }
    
    func featuresIfNeeded() {
        let items = [
            WhatsNew.Item(title: "Authentication", subtitle: "Logging in is simple. If the current login details you put in already exists you will get logged in automatically otherwise we will register for you", image: #imageLiteral(resourceName: "Auth")),
            WhatsNew.Item(title: "Create your own", subtitle: "Advncd allows you to create your own augmented reality experience by creating your own custom QR code", image: #imageLiteral(resourceName: "Create")),
            WhatsNew.Item(title: "Get Creative", subtitle: "Get creative with what you'd like to do with your own custom AR experience", image: #imageLiteral(resourceName: "Creative"))
        ]
        
        let theme = WhatsNewViewController.Theme { configuration in
            configuration.apply(animation: .fade)
            configuration.backgroundColor = UIColor.FlatColor.Blue.DarkBlue
            configuration.titleView.titleFont = UIFont.MontserratSemiBold(size: 35)
            configuration.titleView.titleColor = UIColor.FlatColor.Green.LogoGreen
            configuration.completionButton.backgroundColor = UIColor.FlatColor.Green.LogoGreen
            configuration.itemsView.titleFont = UIFont.MontserratSemiBold(size: 17)
            configuration.itemsView.titleColor = UIColor.FlatColor.Green.LogoGreen
            configuration.itemsView.subtitleFont = UIFont.MontserratRegular(size: 15)
            configuration.itemsView.subtitleColor = .white
            configuration.itemsView.imageSize = .preferred
        }
        
        let config = WhatsNewViewController.Configuration(theme: theme)
        
        let guidance = WhatsNew(title: "How it Works", items: items)
        
        let keyValueVersionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard)
        
        let guidanceVC = WhatsNewViewController(whatsNew: guidance, configuration: config, versionStore: keyValueVersionStore)
        
        if let vc = guidanceVC {
            self.present(vc, animated: true)
        }
    }

}
