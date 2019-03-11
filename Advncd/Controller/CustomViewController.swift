//
//  CustomViewController.swift
//  Advncd
//
//  Created by Antonio Chan on 2019/3/11.
//  Copyright © 2019 Antonio Chan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CustomViewController: UIViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Custom")
    }

}
