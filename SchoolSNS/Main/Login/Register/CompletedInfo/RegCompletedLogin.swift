//
//  RegCompletedLogin.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 13/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit

class RegCompletedLogin: HSGHBaseViewController {
    
    @IBOutlet weak var nextButton: AnimatableButton!
    @IBOutlet weak var repeatedPSDTF: AnimatableTextField!
    @IBOutlet weak var psdTF: AnimatableTextField!
    
    public var isFindPSD = false
    public var forgetPSDModel : HSGHLoginUserModel = HSGHLoginUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        psdTF.delegate = self
        repeatedPSDTF.delegate = self
        if isFindPSD {
            title = "重置密码"
        }
    }
    
    deinit {
        psdTF?.delegate = nil
        repeatedPSDTF?.delegate = nil
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if !isFindPSD {
            navigationController?.navigationBar.isHidden = true
        }
        super.viewWillDisappear(animated);
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        if !isFindPSD {
            navigationController?.navigationBar.isHidden = false
        }
        super.viewWillDisappear(animated)
    }
    
    //MARK: --- Login
    func adjustInput() -> Bool {
        guard let emailText = psdTF.text, let repeatedText = repeatedPSDTF.text  else {
            let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        if emailText != repeatedText {
            let toast = Toast(text: "前后密码不一致，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        if emailText.lengthOfBytes(using: .utf8) < kMinLength {
            let toast = Toast(text: "密码长度至少6位，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        if isFindPSD {
            forgetPSDModel.secondPSD = emailText
        }
        else {
            HSGHRegisterNetModel.singleInstance().password = emailText
        }
        return true
    }
    
    @IBAction func enterLogin(_ sender: Any) {
        restoreKeyboard()
        if adjustInput() {
            if isFindPSD {
                SVProgressHUD.show()
                HSGHLoginNetRequest.forgetPassword(forgetPSDModel, block: { (ret, msg) in
                    SVProgressHUD.dismiss()
                    if ret {
                        let popup = PopupDialog(title: nil, message: "密码重置成功，请重新登入", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
                        }
                        
                        let buttonTwo = DefaultButton(title: "确定") {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        popup.addButtons([buttonTwo])
                        self.navigationController?.present(popup, animated: true, completion: nil)
                    }
                    else {
                        if let msg = msg {
                            let toast = Toast(text: msg, duration: Delay.short)
                            toast.show()
                        }
                        else {
                            let toast = Toast(text: "服务器错误，请稍后再试", duration: Delay.short)
                            toast.show()
                        }
                    }
                })
            }
            else {
                //Enter completeInfo
                let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                let vc : HSGHRegSexInfoVC = storyboard.instantiateViewController(withIdentifier: "completeInfo") as! HSGHRegSexInfoVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

//Control input
extension  RegCompletedLogin: UITextFieldDelegate {
    var kMaxLength : Int {
        return 32
    }
    
    var kMinLength : Int {
        return 6
    }
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replacedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !self.validate(string: replacedString) {
            return false
        }
        
        return replacedString.lengthOfBytes(using: .utf8) <= kMaxLength
    }
    
    func validate(string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        //@"[ a-zA-Z0-9\u4e00-\u9fa5]"  汉字加英文和数字
        // -/:;()$&@\".,?!'  字符
        //"^[0-9a-zA-Z-/:;()$&@\".,?!]*$" 全部数字和字符 但不包括空格
        if let regex = try? NSRegularExpression(pattern: "^[0-9a-zA-Z-/:;()$&@\".,?!]*$", options: .caseInsensitive) {
            return regex.matches(in: string, options: .withoutAnchoringBounds, range: NSMakeRange(0, string.characters.count)).count > 0
        }
        
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        restoreKeyboard()
        return true
    }
}

