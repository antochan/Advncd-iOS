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
import FacebookCore
import FacebookLogin

class AuthViewController: UIViewController {
    
    let authView = AuthView()
    
    override func loadView() {
        self.view = authView
    }
    
    override func viewWillLayoutSubviews() {
        if Auth.auth().currentUser != nil {
            transitionToBaseVC()
        } else {
            featuresIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.hideKeyboardWhenTappedAround()
        authView.emailTextfield.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        authView.passwordTextfield.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        authView.confirmButton.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
        authView.facebookButton.addTarget(self, action: #selector(facebookPressed), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
    
    @objc func facebookPressed() {
        let loginManager = LoginManager()
        authView.facebookButton.isUserInteractionEnabled = false
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.signIntoFirebase()
            case .failed(let error):
                self.authView.displayError(message: error.localizedDescription)
            case .cancelled:
                self.authView.facebookButton.isUserInteractionEnabled = true
                return
            }
        }
    }
    
    fileprivate func signIntoFirebase() {
        guard let authenticationToken = AccessToken.current?.authenticationToken else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        let sv = UIViewController.displaySpinner(onView: self.view)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let err = error {
                self.authView.displayError(message: err.localizedDescription)
            } else {
                if let uid = user?.user.uid, let email = user?.user.email {
                    let docRef = Firestore.firestore().collection("Users").document(uid)
                    docRef.getDocument { (document, error) in
                        if let document = document, !document.exists {
                            self.writeToDB(email: email, uid: uid)
                        }
                    }
                    UIViewController.removeSpinner(spinner: sv)
                    self.transitionToBaseVC()
                }
            }
            return
        }
    }
    
    @objc func confirmPressed() {
        let sv = UIViewController.displaySpinner(onView: self.view)
        formChecker(sv: sv)
        if let email = authView.emailTextfield.text , let password = authView.passwordTextfield.text {
            AuthServices.instance.loginUser(email: email, password: password) { (success) in
                if success {
                    self.transitionToBaseVC()
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
                self.transitionToBaseVC()
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
