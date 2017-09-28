//
//  RegCompletedPhoneCode.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 13/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit

class HSGHSettingsUnbindingCode: HSGHBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nextButton: HSGHCustomButton!
    @IBOutlet weak var codeTF: AnimatableTextField!
    @IBOutlet weak var infoLabel: VerticallyAlignedLabel!
    
    public var isPhone = false
    public var isBoard = false
    public var content = ""
    public var isBinding = false
    public var phoneCode = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        codeTF.delegate = self
        
        updateTitle()
        nextButton.isNext = true
    }
    
    deinit {
        codeTF?.delegate = nil
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated);
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setDefault()  {
        infoLabel.text = "请输入我们发送到 \(content) 的6位数字验证码。"
    }

    func updateTitle() {
        title = isBinding ? "输入验证码" : (isPhone ? "解绑手机" : "解绑邮箱")
    }
    
    @IBAction func clickNext(_ sender: Any) {
        guard let inputText = codeTF.text else {
            let toast = Toast(text: "验证码不能为空哦!", duration: Delay.short)
            toast.show()
            return
        }
        
        if inputText.isEmpty {
            let toast = Toast(text: "验证码不能为空哦!", duration: Delay.short)
            toast.show()
            return
        }
        
        if inputText.lengthOfBytes(using: .utf8) != 6 {
            let toast = Toast(text: "请输入6位验证码哦！", duration: Delay.short)
            toast.show()
            return
        }
        
        let userModel = HSGHLoginUserModel()
        userModel.isEmail = !isPhone
        userModel.email = content
        userModel.phoneCode = phoneCode
        userModel.phoneNumber = content
        userModel.verifyCode = inputText
        AppDelegate.instanceApplication().indicatorShow()
        if isBinding {
            HSGHSettingsModel.binding(userModel) {[weak self] (ret, errorDes) in
                AppDelegate.instanceApplication().indicatorDismiss()
                if ret {
                    //Refresh local
                    self?.refreshLocalDB()

                    let popup = PopupDialog(title: "提示", message: "绑定成功", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
                    }
                    
                    let buttonTwo = DefaultButton(title: "确定") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                    popup.addButtons([buttonTwo])
                    self?.navigationController?.present(popup, animated: true, completion: nil)
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
        else {
            HSGHSettingsModel.unbinding(userModel) {[weak self] (ret, errorDes) in
                AppDelegate.instanceApplication().indicatorDismiss()
                if ret {
                    //Refresh local
                    self?.refreshLocalDB()
                    
                    let popup = PopupDialog(title: "提示", message: "解绑成功", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
                    }
                    
                    let buttonTwo = DefaultButton(title: "确定") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                    popup.addButtons([buttonTwo])
                    self?.navigationController?.present(popup, animated: true, completion: nil)
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
        
    }
    
    
    func refreshLocalDB() {
        let updateContent = isBinding ? content : ""
        
        if isPhone {
            if isBoard {
                HSGHUserInf.shareManager().phoneAbroad = updateContent
            }
            else {
                HSGHUserInf.shareManager().phoneCn = updateContent
            }
        }
        else {
            HSGHUserInf.shareManager().email = updateContent
        }
        
        HSGHUserInf.shareManager().saveUserDefault()
    }

    
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: --- delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        restoreKeyboard()
        return true
    }
}

