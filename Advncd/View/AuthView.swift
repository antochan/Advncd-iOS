//
//  AuthView.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/2/28.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

class AuthView: UIView {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //Background Component
    let backgroundImage = UIImageView()
    let backgroundOverlay = UIView()
    let logoImage = UIImageView()
    
    //Login fields
    let emailTextfield = UITextField()
    let emailImage = UIImageView()
    let emailDivider = UIView()
    
    let passwordTextfield = UITextField()
    let passwordImage = UIImageView()
    let passwordDivider = UIView()
    
    //Login or Register button
    let confirmButton = UIButton()
    
    //forgot password
    let forgotPassButton = UIButton()
    
    //facebook Button
    let facebookButton = UIButton()
    
    //error label
    let errorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        drawAuthForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawAuthForm()
    }
    
    func drawAuthForm() {
        //Background Component
        self.addSubview(backgroundImage)
        backgroundImage.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = #imageLiteral(resourceName: "background")
        
        self.addSubview(backgroundOverlay)
        backgroundOverlay.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundOverlay.backgroundColor = UIColor.FlatColor.Blue.DarkBlue.withAlphaComponent(0.95)
        
        backgroundOverlay.addSubview(logoImage)
        logoImage.frame = CGRect(x: screenWidth * 0.15, y: 0, width: screenWidth * 0.7, height: screenWidth * 0.7)
        logoImage.image = #imageLiteral(resourceName: "Logo")
        
        //Email Textfield Component
        backgroundOverlay.addSubview(emailImage)
        emailImage.anchor(top: logoImage.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: screenHeight * 0.03, left: screenWidth * 0.15 + 8, bottom: 0, right: 0), size: .init(width: 18, height: 18))
        emailImage.image = #imageLiteral(resourceName: "avatar")
        
        backgroundOverlay.addSubview(emailTextfield)
        emailTextfield.anchor(top: emailImage.topAnchor, leading: emailImage.trailingAnchor, bottom: emailImage.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 3, left: 15, bottom: -3, right: screenWidth * 0.15))
        textFieldUI(textfield: emailTextfield, placeholder: "Email / Username")
        
        backgroundOverlay.addSubview(emailDivider)
        emailDivider.anchor(top: emailTextfield.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: emailTextfield.trailingAnchor, padding: .init(top: 10, left: screenWidth * 0.15, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        emailDivider.backgroundColor = UIColor.FlatColor.Gray.IdleGray
        
        //Password Textfield Component
        backgroundOverlay.addSubview(passwordImage)
        passwordImage.anchor(top: emailDivider.bottomAnchor, leading: emailImage.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: screenHeight * 0.05, left: 0, bottom: 0, right: 0), size: .init(width: 18, height: 18))
        passwordImage.image = #imageLiteral(resourceName: "lock")
        
        backgroundOverlay.addSubview(passwordTextfield)
        passwordTextfield.anchor(top: passwordImage.topAnchor, leading: passwordImage.trailingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 3, left: 15, bottom: -3, right: screenWidth * 0.15))
        textFieldUI(textfield: passwordTextfield, placeholder: "Password")
        passwordTextfield.isSecureTextEntry = true
        
        backgroundOverlay.addSubview(passwordDivider)
        passwordDivider.anchor(top: passwordTextfield.bottomAnchor, leading: emailDivider.leadingAnchor, bottom: nil, trailing: emailDivider.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 1))
        passwordDivider.backgroundColor = UIColor.FlatColor.Gray.IdleGray
        
        //confirm Button
        backgroundOverlay.addSubview(confirmButton)
        confirmButton.anchor(top: passwordDivider.bottomAnchor, leading: passwordDivider.leadingAnchor, bottom: nil, trailing: passwordDivider.trailingAnchor, padding: .init(top: screenHeight * 0.1, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: screenHeight * 0.06))
        confirmButton.backgroundColor = UIColor.FlatColor.Green.LogoGreen
        confirmButton.setTitle("LOGIN", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 15
        confirmButton.layer.masksToBounds = true
        confirmButton.titleLabel?.font = UIFont.MontserratMedium(size: 15)
        
        //forgot password Button
        backgroundOverlay.addSubview(forgotPassButton)
        forgotPassButton.anchor(top: confirmButton.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: screenHeight * 0.025, left: screenWidth * 0.3, bottom: 0, right: screenWidth * 0.3), size: .init(width: 0, height: screenHeight * 0.01))
        forgotPassButton.setTitleColor(UIColor.FlatColor.Gray.IdleGray, for: .normal)
        forgotPassButton.setTitle("Forgot your password?", for: .normal)
        forgotPassButton.titleLabel?.font = UIFont.MontserratRegular(size: 12)
        forgotPassButton.sizeToFit()
        
        //facebook Button
        backgroundOverlay.addSubview(facebookButton)
        facebookButton.anchor(top: forgotPassButton.bottomAnchor, leading: confirmButton.leadingAnchor, bottom: nil, trailing: confirmButton.trailingAnchor, padding: .init(top: screenHeight * 0.05, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: screenHeight * 0.06))
        facebookButton.backgroundColor = UIColor.FlatColor.Blue.FacebookBlue
        facebookButton.setTitle("FACEBOOK LOGIN", for: .normal)
        facebookButton.setTitleColor(.white, for: .normal)
        facebookButton.layer.cornerRadius = 15
        facebookButton.layer.masksToBounds = true
        facebookButton.titleLabel?.font = UIFont.MontserratMedium(size: 15)
        
        //error label
        backgroundOverlay.addSubview(errorLabel)
        errorLabel.isHidden = true
        errorLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: screenWidth * 0.1, bottom: screenHeight * 0.025, right: screenWidth * 0.1), size: .init(width: screenWidth * 0.8, height: screenHeight * 0.05))
        errorLabel.font = UIFont.MontserratRegular(size: 12)
        errorLabel.text = "Error has occured. Please try again later."
        errorLabel.textColor = UIColor.FlatColor.Red.GoogleRed
        errorLabel.numberOfLines = 0
    }
    
    func textFieldUI(textfield: UITextField, placeholder: String) {
        textfield.textColor = .white
        textfield.font = UIFont.MontserratMedium(size: 13)
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.FlatColor.Gray.IdleGray, NSAttributedString.Key.font: UIFont.MontserratMedium(size: 13)])
    }
}
