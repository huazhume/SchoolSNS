//
//  HSGHSettingsPrivacyVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 14/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHSettingsPrivacyVC: HSGHBaseTableViewController {
    
    @IBOutlet weak var firstSwitch: UISwitch!
    @IBOutlet weak var secondSwitch: UISwitch!
    @IBOutlet weak var thirdSwitch: UISwitch!
    @IBOutlet weak var fourthSwitch: UISwitch!
    
    @IBOutlet weak var realNameSwitch: UISwitch!
    var alertVC : UIAlertController? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultStatus()
    }
    
    func setupDefaultStatus() {
        firstSwitch.onTintColor = UIColor(hexString: "3987d0")
        secondSwitch.onTintColor = UIColor(hexString: "3987d0")
        thirdSwitch.onTintColor = UIColor(hexString: "3987d0")
        fourthSwitch.onTintColor = UIColor(hexString: "3987d0")
        
        firstSwitch.isOn = false
        secondSwitch.isOn = true
        thirdSwitch.isOn = false
        fourthSwitch.isOn = false
        realNameSwitch.isOn = false
        
        fourthSwitch.addTarget(self, action: #selector(changeStatus), for: .valueChanged)
    }
    
    func changeStatus() {
        if !fourthSwitch.isOn {
            let popup = PopupDialog(title: "提示", message: "关闭显示您的学校信息，您将无法查看他人学校信息", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
            }
            self.navigationController?.present(popup, animated: true, completion: nil)
        }
    }
}
