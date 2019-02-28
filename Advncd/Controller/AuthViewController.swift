//
//  AuthViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/2/28.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    let authView = AuthView()
    
    var activeTextField = UITextField()
    
    override func loadView() {
        self.view = authView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        authView.emailTextfield.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        authView.passwordTextfield.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
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

}
