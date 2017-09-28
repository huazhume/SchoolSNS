//
//  HSGHSettingsAboutUSVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 14/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHSettingsAboutUSVC: HSGHHomeBaseViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "关于我们"
        versionLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
}
