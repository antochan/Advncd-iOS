//
//  PageCollectionViewCell.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/1.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //background component
    let backgroundImage = UIImageView()
    let backgroundOverlay = UIView()
    
    //header
    let cancelButton = UIButton()
    let titleLabel = UILabel()
    let logoImage = UIImageView()
    let stepLabel = UILabel()
    
    //instruction step
    let instructionImage = UIImageView()
    let instructionLabel = UILabel()
    
    //Picture
    let addImage = UIImageView()
    
    //resume picture
    let resumeImage = UIImageView()
    
    //text view
    let textBox = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        drawPageCell()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.frame.origin.y == 0 {
                self.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.frame.origin.y != 0 {
            self.frame.origin.y = 0
        }
    }
    
    func drawPageCell() {
        
        //background component
        
        self.addSubview(backgroundOverlay)
        backgroundOverlay.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundOverlay.backgroundColor = UIColor.FlatColor.Blue.DarkBlue.withAlphaComponent(0.95)
        
        //header component
        backgroundOverlay.addSubview(cancelButton)
        cancelButton.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 42, left: 25, bottom: 0, right: 0), size: .init(width: screenWidth * 0.06, height: screenWidth * 0.06))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        
        backgroundOverlay.addSubview(titleLabel)
        titleLabel.anchor(top: cancelButton.topAnchor, leading: self.leadingAnchor, bottom: cancelButton.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 8, left: screenWidth * 0.25, bottom: -8, right: screenWidth * 0.25))
        titleLabel.font = UIFont.MontserratSemiBold(size: 30)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .white
        
        backgroundOverlay.addSubview(logoImage)
        logoImage.anchor(top: cancelButton.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding:.init(top: screenHeight * 0.02, left: 25, bottom: 0, right: 0), size: .init(width: screenWidth * 0.23, height: screenWidth * 0.23))
        logoImage.image = #imageLiteral(resourceName: "Logo")
        
        backgroundOverlay.addSubview(stepLabel)
        stepLabel.frame = CGRect(x: screenWidth * 0.23 + 30, y: 42 + screenWidth * 0.125 + screenHeight * 0.02, width: screenWidth * 0.6, height: screenWidth * 0.115)
        stepLabel.font = UIFont.MontserratSemiBold(size: 22)
        stepLabel.textColor = .white
        
        //instruction component
        backgroundOverlay.addSubview(instructionImage)
        instructionImage.anchor(top: logoImage.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 8, left: screenWidth * 0.3, bottom: 0, right: screenWidth * 0.3), size: .init(width: screenWidth * 0.4, height: screenHeight * 0.27))
        instructionImage.image = #imageLiteral(resourceName: "Regular-1")
        
        backgroundOverlay.addSubview(instructionLabel)
        instructionLabel.anchor(top: instructionImage.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 30, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: screenHeight * 0.075))
        instructionLabel.numberOfLines = 0
        instructionLabel.font = UIFont.MontserratMedium(size: 16)
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        
        backgroundOverlay.addSubview(addImage)
        addImage.isHidden = true
        addImage.contentMode = .scaleAspectFill
        addImage.anchor(top: instructionLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: screenHeight * 0.025, left: screenWidth * 0.15, bottom: 0, right: screenWidth * 0.15), size: .init(width: screenWidth * 0.7, height: (screenWidth * 0.7) * 0.75))
        addImage.layer.cornerRadius = 10
        addImage.layer.masksToBounds = true
        addImage.image = #imageLiteral(resourceName: "Picture")
        
        backgroundOverlay.addSubview(textBox)
        textBox.backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        textBox.isHidden = true
        textBox.layer.borderColor = UIColor.white.cgColor
        textBox.layer.borderWidth = 1.5
        textBox.layer.cornerRadius = 10
        textBox.layer.masksToBounds = true
        textBox.anchor(top: instructionLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: screenHeight * 0.025, left: screenWidth * 0.15, bottom: 0, right: screenWidth * 0.15), size: .init(width: screenWidth * 0.7, height: (screenWidth * 0.7) * 0.667))
        textBox.font = UIFont.MontserratMedium(size: 15)
        textBox.textColor = .white
        
        backgroundOverlay.addSubview(resumeImage)
        resumeImage.isHidden = true
        resumeImage.anchor(top: instructionLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: screenHeight * 0.025, left: screenWidth * 0.3, bottom: 0, right: screenWidth * 0.3), size: .init(width: screenWidth * 0.4, height: screenWidth * 0.4))
        resumeImage.layer.cornerRadius = (screenWidth * 0.4) / 2
        resumeImage.layer.masksToBounds = true
        resumeImage.image = #imageLiteral(resourceName: "Resume-Picture")
    }
}
