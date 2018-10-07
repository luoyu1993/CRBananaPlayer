//
//  CRAboutViewController.swift
//  CRBananerPlayer
//
//  Created by CRMO on 2018/9/24.
//  Copyright © 2018年 CRMO. All rights reserved.
//

import UIKit

class CRAboutViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoDictionary = Bundle.main.infoDictionary
        if let infoDictionary = infoDictionary {
            let appVersion = infoDictionary["CFBundleShortVersionString"] as! String
            versionLabel.text = "版本 \(appVersion)"
        }
    }
}
