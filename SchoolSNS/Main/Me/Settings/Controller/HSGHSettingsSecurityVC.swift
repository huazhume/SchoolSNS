//
//  HSGHSettingsSecurityVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 14/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation


class HSGHSettingsSecurityVC: HSGHBaseTableViewController {
    
    @IBOutlet weak var psdLabel: UILabel!
    
    @IBOutlet weak var noChinaHeadLabel: UILabel!
    @IBOutlet weak var noChinaPhoneLabel: UILabel!
    
    @IBOutlet weak var chinaHeadLabel: UILabel!
    @IBOutlet weak var chinaPhoneLabel: UILabel!
    
    @IBOutlet weak var emailHeadLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshInfo()
        super.viewWillAppear(animated)
        title = "安全设置"
    }
    
    func refreshInfo() {
        psdLabel.text = ""
        if let phone = HSGHUserInf.shareManager().phoneAbroad {
            noChinaPhoneLabel.text = phone
            noChinaHeadLabel.text = "国外手机号解绑"
        } else {
            noChinaPhoneLabel.text = ""
            noChinaHeadLabel.text = "国外手机号绑定"
        }
        
        if let phone = HSGHUserInf.shareManager().phoneCn {
            chinaPhoneLabel.text = phone
            chinaHeadLabel.text = "国内手机号解绑"
        } else {
            chinaPhoneLabel.text = ""
            chinaHeadLabel.text = "国内手机号绑定"
        }
        
        if let email = HSGHUserInf.shareManager().email {
            emailLabel.text = email
            emailHeadLabel.text = "邮箱解绑"
        } else {
            emailLabel.text = ""
            emailHeadLabel.text = "邮箱绑定"
        }
    }
    
    
    func hasOnlyBindingWay() -> Bool {
        var count = 0
        if let phoneAbroad = HSGHUserInf.shareManager().phoneAbroad, !phoneAbroad.isEmpty {
            count += 1
        }
        
        if let phoneCn = HSGHUserInf.shareManager().phoneCn, !phoneCn.isEmpty {
            count += 1
        }
        
        if let email = HSGHUserInf.shareManager().email, !email.isEmpty {
            count += 1
        }
        
        return count == 1
    }
    
    
    func currentTextContent(_ row: Int) -> String {
        switch row {
        case 1:
            return noChinaPhoneLabel.text!
            
        case 2:
            return chinaPhoneLabel.text!
            
        case 3:
            return emailLabel.text!
            
        default:
            return ""
        }
    }
    
    
    func jumpByIndex(_ row: Int) {
        let storyboard = UIStoryboard(name: "HSGHSettings", bundle: nil)
        if currentTextContent(row).isEmpty { //Enter binding
            switch row {
            case 1, 2:
                let vc : HSGHSettingsPhoneBindingVC = storyboard.instantiateViewController(withIdentifier: "bindingPhone") as! HSGHSettingsPhoneBindingVC
                vc.isBoard = (row == 1)
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc : HSGHSettingsBindingEmailVC = storyboard.instantiateViewController(withIdentifier: "bindingEmail") as! HSGHSettingsBindingEmailVC
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                return
            }
        }
        else { //Enter unbinding
            let vc : HSGHSettingsUnbindingCode = storyboard.instantiateViewController(withIdentifier: "inputCode") as! HSGHSettingsUnbindingCode
            vc.isBoard = (row == 1)
            vc.isPhone = (row != 3)
            vc.content = currentTextContent(row)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != 0) { //only 1,2,3
            if hasOnlyBindingWay(), !currentTextContent(indexPath.row).isEmpty {
                let popup = PopupDialog(title: "提示", message: "唯一的绑定方式将不能再被解绑！", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
                }
                
                let buttonTwo = DefaultButton(title: "确定") {
                }
                popup.addButtons([buttonTwo])
                self.navigationController?.present(popup, animated: true, completion: nil)
            }
            else {
                jumpByIndex(indexPath.row)
            }
        }
    }
    
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
}


