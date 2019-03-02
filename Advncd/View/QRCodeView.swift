//
//  QRCodeView.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

class QRCodeView: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    //background content
    let backgroundImage = UIImageView()
    let backgroundOverlay = UIView()
    let logo = UIImageView()
    
    //QR Code component
    let QRCodeView = UIView()
    let QRCodeImage = UIImageView()
    let detailsLabel = UILabel()
    
    //confirm Button
    let confirmButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.FlatColor.Blue.DarkBlue
        drawQRCode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawQRCode()
    }
    
    func drawQRCode() {
        //Background Component
        self.addSubview(backgroundImage)
        backgroundImage.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = #imageLiteral(resourceName: "background")
        
        self.addSubview(backgroundOverlay)
        backgroundOverlay.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundOverlay.backgroundColor = UIColor.FlatColor.Blue.DarkBlue.withAlphaComponent(0.95)
        
        backgroundOverlay.addSubview(logo)
        logo.frame = CGRect(x: screenWidth * 0.325, y: 0, width: screenWidth * 0.35, height: screenWidth * 0.35)
        logo.image = #imageLiteral(resourceName: "Logo")
        
        //QR Code component
        backgroundOverlay.addSubview(QRCodeView)
        QRCodeView.anchor(top: logo.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 8, left: screenWidth * 0.2, bottom: 0, right: screenWidth * 0.2), size: .init(width: screenWidth * 0.6, height: screenHeight * 0.35))
        QRCodeView.backgroundColor = UIColor.FlatColor.Blue.MatDarkBlue
        QRCodeView.layer.cornerRadius = 10
        QRCodeView.layer.masksToBounds = true
        
        QRCodeView.addSubview(QRCodeImage)
        QRCodeImage.anchor(top: QRCodeView.topAnchor, leading: QRCodeView.leadingAnchor, bottom: nil, trailing: QRCodeView.trailingAnchor, padding: .init(top: screenHeight * 0.025, left: screenWidth * 0.1, bottom: 0, right:  screenWidth * 0.1), size: .init(width: screenWidth * 0.4, height: screenWidth * 0.4))
        QRCodeImage.contentMode = .scaleAspectFill
        
        QRCodeView.addSubview(detailsLabel)
        detailsLabel.anchor(top: QRCodeImage.bottomAnchor, leading: QRCodeImage.leadingAnchor, bottom: QRCodeView.bottomAnchor, trailing: QRCodeImage.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 0))
        detailsLabel.textColor = UIColor.FlatColor.Gray.IdleGray
        detailsLabel.numberOfLines = 0
        detailsLabel.text = "Type: Standard AR\nCreated at: 2/23/2019"
        detailsLabel.font = UIFont.MontserratRegular(size: 11)
        detailsLabel.textAlignment = .center
        
        //confirm button
        backgroundOverlay.addSubview(confirmButton)
        confirmButton.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: screenWidth * 0.15, bottom: screenHeight * 0.075, right: screenWidth * 0.15), size: .init(width: screenWidth * 0.7, height: screenHeight * 0.05))
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.masksToBounds = true
        confirmButton.setTitle("Done", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.MontserratMedium(size: 15)
        confirmButton.backgroundColor = UIColor.FlatColor.Green.LogoGreen
    }
    
}
