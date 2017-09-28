//
//  HSGHSettingsPhoneBindingVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 14/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHSettingsPhoneBindingVC: HSGHHomeBaseViewController {
    
    @IBOutlet weak var nextButton: HSGHCustomButton!
    @IBOutlet weak var headButton: UIButton!
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    var selectedPhoneInfo:PhoneHeadInfo = PhoneHeadInfo()

    
    public var isBoard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfo()
        nextButton.isNext = true
        title = "绑定国外手机"
    }
    
    @IBAction func clickHeadButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PhoneHead", bundle: nil)
        let vc : HSGHPhoneHeadSearchVC = storyboard.instantiateViewController(withIdentifier: "headInfoVC") as! HSGHPhoneHeadSearchVC
        let nav = HSGHBaseNavigationViewController.init(rootViewController: vc)
        vc.returnBlock = {[weak self] data in
            if let data = data {
                self?.selectedPhoneInfo.name = data.name
                self?.selectedPhoneInfo.phone = data.phone
                self?.updateHeadInfo()
            }
        }
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func clickNext(_ sender: Any) {
        guard let phone = phoneTF.text else {
            let toast = Toast(text: "号码不能为空哦！", duration: Delay.short)
            toast.show()
            return
        }
        
        if phone.isEmpty {
            let toast = Toast(text: "号码不能为空哦！", duration: Delay.short)
            toast.show()
            return
        }
        else {
            if isBoard {
                if (phone as NSString).length < 6 {
                    let toast = Toast(text: "号码太短了，再多输入几位吧！", duration: Delay.short)
                    toast.show()
                    return
                }
            }
            else {
                if !HSGHTools.isValidateCNPhoneNumber(phone) {
                    let toast = Toast(text: "不是可用的电话号码哦，请重新输入吧！", duration: Delay.short)
                    toast.show()
                    return
                }
            }
        }
        
        let userModel = HSGHLoginUserModel()
        userModel.isEmail = false
        userModel.phoneCode = selectedPhoneInfo.dropFirst()
        userModel.phoneNumber = phone
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
    

    func updateInfo() {
        title = isBoard ? "绑定国外手机" : "绑定国内手机"
        headButton.isEnabled = isBoard
        if (isBoard) {
            selectedPhoneInfo.name = "澳大利亚"
            selectedPhoneInfo.phone = "+61"
        } else {
            selectedPhoneInfo.name = "中国"
            selectedPhoneInfo.phone = "+86"
        }
        updateHeadInfo()
    }
    
    func updateHeadInfo() {
        headLabel.text = selectedPhoneInfo.name + selectedPhoneInfo.phone
    }
    
    func jumpCodeVC(){
        let storyboard = UIStoryboard(name: "HSGHSettings", bundle: nil)
        let vc : HSGHSettingsUnbindingCode = storyboard.instantiateViewController(withIdentifier: "inputCode") as! HSGHSettingsUnbindingCode
        vc.isBinding = true
        vc.isPhone = true
        vc.phoneCode = selectedPhoneInfo.dropFirst()
        vc.content = phoneTF.text!
        vc.isBoard = isBoard
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
