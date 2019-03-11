//
//  CustomViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/11.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MessageUI

class CustomViewController: UIViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Custom")
    }

    @IBAction func emailTapped(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
}

extension CustomViewController: MFMailComposeViewControllerDelegate {
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["anto.chan101@gmail.com"])
        mailComposerVC.setSubject("Custom AR Request")
        
        return mailComposerVC
    }
    
    func showMailError() {
        displayAlert(title: "Could not send email", message: "Your device could not send email")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
