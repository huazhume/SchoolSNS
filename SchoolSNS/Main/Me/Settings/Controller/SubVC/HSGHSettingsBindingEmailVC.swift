//
//  HSGHSettingsInputPhoneVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 14/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHSettingsBindingEmailVC: HSGHHomeBaseViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var nextButton: HSGHCustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isNext = true
        title = "邮箱绑定"
    }
    
    @IBAction func clickNext(_ sender: Any) {
        guard let email = emailTF.text else{
            let toast = Toast(text: "邮箱不能为空哦！", duration: Delay.short)
            toast.show()
            return
        }
        
        if email.isEmpty {
            let toast = Toast(text: "邮箱不能为空哦！", duration: Delay.short)
            toast.show()
            return
        }
        
        if !HSGHTools.isValidateEmail(email) {
            let toast = Toast(text: "邮箱格式不正确哦！", duration: Delay.short)
            toast.show()
            return
        }
        
        
        let userModel = HSGHLoginUserModel()
        userModel.isEmail = true
        userModel.email = email
        userModel.category = 1
        AppDelegate.instanceApplication().indicatorShow()
        HSGHSettingsModel.sendVerityCode(userModel) {[weak self] (ret, errorDes) in
            AppDelegate.instanceApplication().indicatorDismiss()
            if ret {
                self?.jumpCodeVC()
            }
            else {
                if let errorDes = errorDes {
                    let toast = Toast(text: errorDes, duration: Delay.short)
                    toast.show()
                }
                else {
                    let toast = Toast(text: "出了点小问题，请稍后再试吧!", duration: Delay.short)
                    toast.show()
                }
            }
        }
    }
    
    
    func jumpCodeVC(){
        let storyboard = UIStoryboard(name: "HSGHSettings", bundle: nil)
        let vc : HSGHSettingsUnbindingCode = storyboard.instantiateViewController(withIdentifier: "inputCode") as! HSGHSettingsUnbindingCode
        vc.isBinding = true
        vc.isPhone = false
        vc.content = emailTF.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
