//
//  HSGHSettingsNotificationVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 14/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHSettingsNotificationVC: HSGHBaseTableViewController {
    
    @IBOutlet weak var firstOneSwitch: UISwitch!
    @IBOutlet weak var firstTwoSwitch: UISwitch!
    @IBOutlet weak var firstThirdSwitch: UISwitch!
    
    @IBOutlet weak var secondOneSwitch: UISwitch!
    @IBOutlet weak var secondTwoSwitch: UISwitch!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault(allClosed: false )
        checkStatus()
    }
    
    func setDefault(allClosed close: Bool) {
        firstOneSwitch.onTintColor = UIColor(hexString: "3987d0")
        firstTwoSwitch.onTintColor = UIColor(hexString: "3987d0")
        firstThirdSwitch.onTintColor = UIColor(hexString: "3987d0")
        secondOneSwitch.onTintColor = UIColor(hexString: "3987d0")
        secondTwoSwitch.onTintColor = UIColor(hexString: "3987d0")
        
        firstOneSwitch.isOn = !close
        firstTwoSwitch.isOn = !close
        firstThirdSwitch.isOn = !close
        secondOneSwitch.isOn = !close
        secondTwoSwitch.isOn = !close
        
        firstOneSwitch.addTarget(self, action: #selector(changeStatus(sender:)), for: .valueChanged)
        firstTwoSwitch.addTarget(self, action: #selector(changeStatus(sender:)), for: .valueChanged)
        firstThirdSwitch.addTarget(self, action: #selector(changeStatus(sender:)), for: .valueChanged)
        secondOneSwitch.addTarget(self, action: #selector(changeStatus(sender:)), for: .valueChanged)
        secondTwoSwitch.addTarget(self, action: #selector(changeStatus(sender:)), for: .valueChanged)
    }
    
    func changeStatus(sender : UISwitch) {
        if sender.isOn {
            if !checkStatus() {
                sender.isOn = false
            }
        }
    }
    
    @discardableResult
    func checkStatus() -> Bool {
        if !UIApplication.shared.remoteNotificationsEnabled() {
            setDefault(allClosed: true )
            let alertVC = UIAlertController(title: "push访问被拒绝", message: "请在设置中允许骞骞推送通知", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }))
            self.navigationController?.present(alertVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}

//extension UIApplication {
//    func remoteNotificationsEnabled() -> Bool {
//        var notificationsEnabled = false
//        if let userNotificationSettings = currentUserNotificationSettings {
//            notificationsEnabled = userNotificationSettings.types.contains(.alert)
//        }
//        return notificationsEnabled
//    }
//}

