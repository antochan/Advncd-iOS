//
//  ConfirmPageCollectionViewCell.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/2.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Lottie

class ConfirmPageCollectionViewCell: UICollectionViewCell {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //title
    let titleLabel = UILabel()
    
    //animation
    let animationView = LOTAnimationView()
    
    //Extra text
    let textLabel = UILabel()
    
    //confirm Button
    let confirmButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        drawConfirmPage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawConfirmPage() {
        self.addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: screenHeight * 0.055, left: screenWidth * 0.2, bottom: 0, right: screenWidth * 0.2), size: .init(width: screenWidth * 0.6, height: screenWidth * 0.2))
        titleLabel.text = "Almost There!"
        titleLabel.font = UIFont.MontserratSemiBold(size: 35)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        self.addSubview(animationView)
        animationView.anchor(top: titleLabel.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: screenHeight * 0.025, left: screenWidth * 0.1, bottom: 0, right: screenWidth * 0.1), size: .init(width: screenWidth * 0.8, height: screenWidth * 0.8))
        animationView.setAnimation(named: "confirm")
        animationView.play()
        animationView.loopAnimation = true
        
        self.addSubview(textLabel)
        textLabel.anchor(top: animationView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: screenWidth * 0.05, bottom: 0, right: screenWidth * 0.05), size: .init(width: screenWidth * 0.9, height: screenHeight * 0.1))
        textLabel.text = "Please make sure you’ve populated every field to maximize your AR experience! When you are ready, click confirm to generate your QR code! Congratulations!"
        textLabel.font = UIFont.MontserratRegular(size: 15)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.numberOfLines = 0
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        
        self.addSubview(confirmButton)
        confirmButton.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: screenWidth * 0.15, bottom: screenHeight * 0.075, right: screenWidth * 0.15), size: .init(width: screenWidth * 0.7, height: screenHeight * 0.05))
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.masksToBounds = true
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.MontserratMedium(size: 15)
        confirmButton.backgroundColor = UIColor.FlatColor.Green.LogoGreen
    }
}
