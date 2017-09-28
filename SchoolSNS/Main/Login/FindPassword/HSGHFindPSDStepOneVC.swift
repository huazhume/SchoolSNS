//
//  HSGHFindPSDStepOneVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 20/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHFindPSDStepOneVC: HSGHHomeBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var wholeEmailView: AnimatableView!
    @IBOutlet weak var wholePhoneView: AnimatableView!
    @IBOutlet weak var phoneHeadLabel: UILabel!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var emailEditTextFiled: UITextField!
    
    @IBOutlet weak var selectStatusButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    var selectedPhoneInfo:PhoneHeadInfo = PhoneHeadInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPhoneInfo.name = "中国"
        selectedPhoneInfo.phone = "+86"
        wholeEmailView.isHidden = true
        wholePhoneView.isHidden = false
        
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        emailEditTextFiled.delegate = self
        phoneTF.delegate = self
        
        updateInfo()
        
        selectStatusButton.isHidden = true
        infoLabel.isHidden = true
        title = "邮箱绑定"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "邮箱绑定"
    }
    
    deinit {
        emailEditTextFiled?.delegate = nil
        phoneTF?.delegate = nil
    }
    
    func adjustInput() -> Bool {
        if wholePhoneView.isHidden { //Email
            guard let emailText = emailEditTextFiled.text else {
                let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
            
            if emailText.isEmpty {
                let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
            
            if !HSGHTools.isValidateEmail(emailText) {
                let toast = Toast(text: "邮箱格式不正确，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
        } else {
            guard let phoneText = phoneTF.text else {
                let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
            
            if phoneText.isEmpty {
                let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
            
            
            if (phoneText as NSString).length < 6 {
                let toast = Toast(text: "号码太短，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
            
        }
        
        return true
    }
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    
    func updateInfo() {
        phoneHeadLabel.text = selectedPhoneInfo.name + selectedPhoneInfo.phone
    }
    
    //MARK: -- UI Actions
    
    @IBAction func selectPhoneHead(_ sender: Any) {
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
    
    @IBAction func selection(_ sender: Any) {
        showPopView(view: sender as! UIView)
    }
    
    @IBAction func clickNext(_ sender: Any) {
        if adjustInput() {
            //send code
            restoreKeyboard()
            if let inputText = phoneTF.text {
                let userModel = HSGHLoginUserModel()
                userModel.isEmail = wholePhoneView.isHidden
                userModel.email = emailEditTextFiled.text
                userModel.phoneCode = selectedPhoneInfo.dropFirst()
                userModel.phoneNumber = inputText
                userModel.category = 2
                AppDelegate.instanceApplication().indicatorShow()
                HSGHLoginNetRequest.sendVerityCode(userModel) {[weak self] (ret, isExisted, errDes) in
                    AppDelegate.instanceApplication().indicatorDismiss()
                    if !ret {
                        let toast = Toast(text: errDes, duration: Delay.short)
                        toast.show()
                    } else {
                        self?.jumpNext()
                    }
                }
            }
        }
    }
    //MARK: --- delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        restoreKeyboard()
        return true
    }
    
    func jumpNext() {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let vc : RegCompletedPhoneCode = storyboard.instantiateViewController(withIdentifier: "inputCode") as! RegCompletedPhoneCode
        vc.isFindPSD = true
        let sendModel = HSGHLoginUserModel()
        
        if wholePhoneView.isHidden {
            sendModel.isEmail = true
            sendModel.email = emailEditTextFiled.text!
        } else {
            sendModel.isEmail = false
            sendModel.phoneCode = selectedPhoneInfo.dropFirst()
            sendModel.phoneNumber = phoneTF.text!
        }
        vc.forgetPSDModel = sendModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HSGHFindPSDStepOneVC {
    func showPopView(view: UIView, _ isYear: Bool = true) {
        let popView = PopoverView()
        var retArray: Array<PopoverAction> = Array<PopoverAction>()
        let action : PopoverAction = PopoverAction(title: "手机", handler: {[weak self] (action) in
            self?.wholeEmailView.isHidden = true
            self?.wholePhoneView.isHidden = false
        })
        retArray.append(action)
        
        let action2 : PopoverAction = PopoverAction(title: "邮箱", handler: {[weak self] (action) in
            self?.wholeEmailView.isHidden = false
            self?.wholePhoneView.isHidden = true
        })
        retArray.append(action2)
        popView.show(to: view, with: retArray)
    }
}

