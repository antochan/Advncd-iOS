//
//  QRCodeTableViewCell.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/3.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import Lottie

class QRCodeTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var QRImageView: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.backgroundColor = UIColor.FlatColor.Blue.MatDarkBlue
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        detailsLabel.font = UIFont.MontserratRegular(size: 11)
        detailsLabel.textColor = UIColor.FlatColor.Gray.IdleGray
        
        self.backgroundColor = .clear
    }
    
}
