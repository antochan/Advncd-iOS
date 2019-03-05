//
//  QRDetailsViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/5.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit

class QRDetailsViewController: UIViewController {
    
    let qrView = QRCodeView()
    
    override func loadView() {
        self.view = qrView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        qrView.confirmButton.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
        qrView.saveImageButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func confirmPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(profileVC, animated: false, completion: nil)
    }
    
    @objc func saveImage() {
        UIImageWriteToSavedPhotosAlbum(qrView.QRCodeImage.image!, nil, nil, nil)
        displayAlert(title: "Saved Image!", message: "Your QR code is saved to your phone! Get creative and enjoy! :)")
    }

}
