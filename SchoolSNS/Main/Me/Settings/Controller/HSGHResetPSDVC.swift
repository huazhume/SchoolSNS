//
//  HSGHResetPSDVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 26/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHResetPSDVC: HSGHBaseTableViewController {

    @IBOutlet weak var originTF: UITextField!

    @IBOutlet weak var newTF: UITextField!

    @IBOutlet weak var renewTF: UITextField!

    @IBOutlet weak var clickOK: HSGHCustomButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        self.view.backgroundColor = UIColor(hexString: "efefef")
        originTF.delegate = self
        newTF.delegate = self
        renewTF.delegate = self
        
        clickOK.isNext = true
        title = "修改密码"
    }
    
    deinit {
    }
    
    func adjustInput() -> Bool {
        guard let originText: String = originTF.text, let newText: String = newTF.text,
              let renewText: String = renewTF.text else {
            let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }

        if newText.isEmpty || originText.isEmpty || renewText.isEmpty {
            let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        if newText.lengthOfBytes(using: .utf8) < kMinLength || originText.lengthOfBytes(using: .utf8) < kMinLength || renewText.lengthOfBytes(using: .utf8) < kMinLength {
            let toast = Toast(text: "密码长度至少6位，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        if newText.lengthOfBytes(using: .utf8) > 16 || originText.lengthOfBytes(using: .utf8) > 16 || renewText.lengthOfBytes(using: .utf8) > 16 {
            let toast = Toast(text: "密码长度最长16位，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        if originText != HSGHUserInf.shareManager().password {
            let toast = Toast(text: "原密码不正确，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        if originText == newText {
            let toast = Toast(text: "新密码和旧密码一样，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }

        if newText != renewText {
            let toast = Toast(text: "新密码前后输入不相同，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        return true
    }
    
    @IBAction func clickOK(_ sender: Any) {
        if adjustInput() {
            SVProgressHUD.show()
            HSGHSettingsModel.resetPassword(originTF.text!, newPSD: renewTF.text!,block: { (ret) in
                SVProgressHUD.dismiss()
                if ret {
                    let alertController = UIAlertController(title: nil,
                                                            message: "设置密码成功，请重新登入",
                                                            preferredStyle: .alert)
                    let okAction: UIAlertAction = UIAlertAction(title: "知道了", style: .default) { _ in
                        let delegate = UIApplication.shared.delegate as? AppDelegate
                        delegate?.enterLogin()
                    }
                    alertController.addAction(okAction)
                    let systemAttributes: [String: AnyObject] = [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                        NSForegroundColorAttributeName: UIColor(hexString: "272727")
                    ]
                    let attributedString = NSMutableAttributedString(string: "设置密码成功，请重新登入。", attributes: systemAttributes)
                    alertController.setValue(attributedString, forKey: "attributedMessage")
                    self.present(alertController, animated: true)
                }
                else {
                    let toast = Toast(text: "服务器错误，请稍后再试", duration: Delay.short)
                    toast.show()
                }
            })
        }
    }
}

//Control input
extension  HSGHResetPSDVC: UITextFieldDelegate {
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





