//
//  RegCompletedPhoneCode.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 13/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit

class RegCompletedPhoneCode: HSGHBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nextButton: AnimatableButton!
    @IBOutlet weak var codeTF: AnimatableTextField!
    @IBOutlet weak var infoLabel: ActiveLabel!
    public var isFindPSD = false
    public var forgetPSDModel : HSGHLoginUserModel = HSGHLoginUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        codeTF.delegate = self
    }
    deinit {
        codeTF?.delegate = nil
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
    
    func setDefault()  {
        
        let customType = ActiveType.custom(pattern: "(请求新验证码\\([0-9]+\\)。)")
        infoLabel.enabledTypes.append(customType)
        
        infoLabel.customize { label in
            //请求新验证码(60)。
            if (isFindPSD) {
                let phoneNumber = forgetPSDModel.isEmail ? forgetPSDModel.email : forgetPSDModel.phoneNumber
                label.text = "请输入我们发送到 \(phoneNumber!) 的6位数字验证码。"
            }
            else {
                if let phone = HSGHRegisterNetModel.singleInstance().phoneNumber {
                    label.text = "请输入我们发送到 \(phone) 的6位数字验证码。"
                }
            }
            label.numberOfLines = 2
            label.textColor = UIColor(hexString: "272727")
            label.customColor[customType] = UIColor(hexString: "3897f0")
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                switch type {
                case customType:
                    atts[NSFontAttributeName] = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.boldSystemFont(ofSize: 14)
                default: ()
                }
                return atts
            }
            infoLabel.handleCustomTap(for: customType) {print($0)}
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let inputText = codeTF.text else {
            nextButton.isEnabled = false
            return false
        }
        
        if inputText.lengthOfBytes(using: .utf8) != 6 {
            let toast = Toast(text: "请输入6位验证码", duration: Delay.short)
            toast.show()
            return false
        }
        
        if isFindPSD {
            forgetPSDModel.verifyCode = inputText
        }
        else {
            HSGHRegisterNetModel.singleInstance().verifyCode = inputText
        }
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc: RegCompletedLogin = segue.destination as! RegCompletedLogin
        vc.isFindPSD = isFindPSD
        vc.forgetPSDModel = forgetPSDModel
    }
}

