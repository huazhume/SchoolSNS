//
//  MyViewController.swift
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copyright © 2017 FlyingPuPu. All rights reserved.
//

import UIKit

class HSGHReginFinishedVC: HSGHBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var okButton: AnimatableButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        passwordTF.delegate = self
        emailTF.delegate = self
    }
    
    deinit {
        passwordTF?.delegate = nil
        emailTF?.delegate = nil
    }

    @IBAction func clickOK(_ sender: Any) {
        restoreKeyboard()
        if adjustInput() {
            SVProgressHUD.show()
            HSGHRegisterNetRequest.request({ (ret, _) in
                SVProgressHUD.dismiss()
                if ret {
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate?.enterMainUI()
                }
                else {
                    let toast = Toast(text: "用户名已存在或注册失败，请稍后再试", duration: Delay.short)
                    toast.show()
                }
            })

        }
    }
    func adjustInput() -> Bool {
        guard let emailText = emailTF.text, let password = passwordTF.text  else {
            let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }

        if emailText.isEmpty || password.isEmpty {
            let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }

        if !HSGHTools.isValidateEmail(emailText) {
            let toast = Toast(text: "邮箱格式不正确", duration: Delay.short)
            toast.show()
            return false
        }

        if !HSGHTools.isValidatePassword(password) {
            let toast = Toast(text: "请输入6~32位字母或数字密码", duration: Delay.short)
            toast.show()
            return false
        }

        HSGHRegisterNetModel.singleInstance().phoneNumber = emailText
        HSGHRegisterNetModel.singleInstance().password = password
        return true
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
