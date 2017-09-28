//
//  RegCompletedPhone.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 13/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//
import UIKit

class RegCompletedPhone: HSGHBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nextButton: AnimatableButton!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var phoneHeadLabel: UILabel!
    var selectedPhoneInfo:PhoneHeadInfo = PhoneHeadInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPhoneInfo.name = "中国"
        selectedPhoneInfo.phone = "+86"
        self.updateInfo()
        
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        phoneTF.delegate = self
    }
    
    deinit {
        phoneTF?.delegate = nil
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        super.viewWillDisappear(animated);
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    func updateInfo() {
        phoneHeadLabel.text = selectedPhoneInfo.name + selectedPhoneInfo.phone
    }
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    
    
    //MARK: --- delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        restoreKeyboard()
        return true
    }
    
    
    @IBAction func selectedPhoneHead(_ sender: Any) {
        let storyboard = UIStoryboard(name: "PhoneHead", bundle: nil)
        let vc : HSGHPhoneHeadSearchVC = storyboard.instantiateViewController(withIdentifier: "headInfoVC") as! HSGHPhoneHeadSearchVC
        let nav = HSGHBaseNavigationViewController.init(rootViewController: vc)
        vc.returnBlock = {[weak self] data in
            if let data = data {
                self?.selectedPhoneInfo.name = data.name
                self?.selectedPhoneInfo.phone = data.phone
                self?.updateInfo()
            }
        }
        self.present(nav, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let inputText = phoneTF.text {
            HSGHRegisterNetModel.singleInstance().phoneNumber = inputText
            HSGHRegisterNetModel.singleInstance().phoneCode = selectedPhoneInfo.dropFirst()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let inputText = phoneTF.text else {
            nextButton.isEnabled = false
            return false
        }
        
        if selectedPhoneInfo.phone == "+86" {
            if !HSGHTools.isValidateCNPhoneNumber(inputText) {
                let toast = Toast(text: "格式错误，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
        }
        else
        {
            if inputText.lengthOfBytes(using: .utf8) < 6 {
                let toast = Toast(text: "长度太短，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
        }
        
        return true
    }
    
    func checkStatus() -> Bool {
        guard let inputText = phoneTF.text else {
            nextButton.isEnabled = false
            return false
        }
        
        if selectedPhoneInfo.phone == "+86" {
            if !HSGHTools.isValidateCNPhoneNumber(inputText) {
                let toast = Toast(text: "格式错误，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
        }
        else
        {
            if inputText.lengthOfBytes(using: .utf8) < 6 {
                let toast = Toast(text: "长度太短，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
        }
        
        return true
    }
    
    
    
    
    @IBAction func clickNext(_ sender: Any) {
        if checkStatus() {
            //send code
            restoreKeyboard()
            if let inputText = phoneTF.text {
            let userModel = HSGHLoginUserModel()
            userModel.isEmail = false
            userModel.phoneCode = selectedPhoneInfo.dropFirst()
            userModel.phoneNumber = inputText
            userModel.category = 1
            AppDelegate.instanceApplication().indicatorShow()
            HSGHLoginNetRequest.sendVerityCode(userModel) {[weak self] (ret, isExisted, errDes) in
                AppDelegate.instanceApplication().indicatorDismiss()
                if isExisted {
                    let toast = Toast(text: "用户已存在，请重新输入", duration: Delay.short)
                    toast.show()
                } else {
                    if !ret {
                        let toast = Toast(text: errDes, duration: Delay.short)
                        toast.show()
                    } else {
                        HSGHRegisterNetModel.singleInstance().phoneNumber = inputText
                        HSGHRegisterNetModel.singleInstance().phoneCode = self?.selectedPhoneInfo.dropFirst()
                        self?.jumpNext()
                    }
                }
            }
        }
        }
    }
    
    
    
    func jumpNext() {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let vc : RegCompletedPhoneCode = storyboard.instantiateViewController(withIdentifier: "inputCode") as! RegCompletedPhoneCode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
