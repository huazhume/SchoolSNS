//
//  HSGHSettingsFixesEngNameVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 26/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHSettingsFixesEngNameVC: HSGHBaseViewController, UITextFieldDelegate {
    @IBOutlet weak var firstTF: LimitedTextField!
    @IBOutlet weak var middleTF: LimitedTextField!
    @IBOutlet weak var thirdTF: LimitedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDefault()
    }
    
    func configDefault() {
        if let first = HSGHUserInf.shareManager().firstNameEn {
            firstTF.text = first
        }
        
        if let second = HSGHUserInf.shareManager().middleNameEn {
            middleTF.text = second
        }
        
        if let last = HSGHUserInf.shareManager().lastNameEn {
            thirdTF.text = last
            thirdTF.isEnabled = false
        }
        
        firstTF.limitedNumber = 10
        firstTF.isFirstNameBig = true
        middleTF.limitedNumber = 10
        middleTF.isFirstNameBig = true
        thirdTF.limitedNumber = 10
        thirdTF.isFirstNameBig = true
        firstTF.limitedType = .custom
        middleTF.limitedType = .custom
        firstTF.limitedRegEx = "^[A-Za-z]+$"
        middleTF.limitedRegEx = "^[A-Za-z]+$"
        thirdTF.limitedRegEx = "^[A-Za-z]+$"
        firstTF.delegate = self
        middleTF.delegate = self
        thirdTF.delegate = self
        firstTF.keyboardType = .asciiCapable
        middleTF.keyboardType = .asciiCapable
        thirdTF.keyboardType = .asciiCapable
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, (text as NSString).length == 0 {
            let str =  string.capitalized
            textField.text = str
            return false
        }
        return true
    }
    
    @IBAction func clickFinished(_ sender: Any) {
        guard let firstName = firstTF.text, let middleName = middleTF.text, let lastName = thirdTF.text else {
            let toast = Toast(text: "firstName 和 lastName 不能为空哦！", duration: Delay.short)
            toast.show()
            return
        }
        
        if lastName.lengthOfBytes(using: .ascii) == 0 {
            let toast = Toast(text: "LastName 不能为空哦！", duration: Delay.short)
            toast.show()
            return
        }
        
        if firstName.lengthOfBytes(using: .ascii) == 0 {
            let toast = Toast(text: "FirstName 不能为空哦！", duration: Delay.short)
            toast.show()
            return
        }
        
        
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        
        /* attributed string for alertController message */
        let string: String
        let secondLength: Int
        if (middleName as NSString).length == 0 {
            string = "英文名: \(firstName) \(lastName)\nLastName: \(lastName)(将不可修改)"
            secondLength = ("\(firstName) \(lastName)" as NSString).length

        }
        else {
            string = "英文名: \(firstName) \(middleName) \(lastName)\nLastName: \(lastName)(将不可修改)"
            secondLength = ("\(firstName) \(middleName) \(lastName)" as NSString).length
        }
        let firstlength = ("英文名: " as NSString).length
        let thirdLength = ("\nLastName: " as NSString).length
        let wholeLength = (string as NSString).length
        
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: NSRange(location:0,length: firstlength))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location:firstlength,length:secondLength))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: NSRange(location:firstlength + secondLength,length: thirdLength))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location:firstlength + secondLength + thirdLength,length:wholeLength - (firstlength + secondLength + thirdLength)))

        //line space 
        let paragraphStye = NSMutableParagraphStyle()
        paragraphStye.lineSpacing = 8
        let rang = NSMakeRange(0, CFStringGetLength(string as CFString!))
        attributedString .addAttribute(NSParagraphStyleAttributeName, value: paragraphStye, range: rang)
        paragraphStye.alignment = .center
        
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        /* action: OK */
        alertController.addAction(UIAlertAction(title: "取消", style: .default,  handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: .default ) {[weak self] _ in
            self?.requestFixName(firstName, middleName, lastName)
        })
        
        self.navigationController?.present(alertController, animated: true, completion: nil);
    }
    

    func requestFixName(_ firstName: String, _ middleName: String, _ lastName: String) {
        HSGHSettingsModel.modifyUserEngName(firstName, middleName: middleName, lastName: lastName) { (ret , errorDes) in
            if ret {
                let toast = Toast(text: "更新英文名成功!", duration: Delay.short)
                toast.show()
                HSGHUserInf.updateDisplayMode(false)
                self.navigationController?.popViewController(animated: true)
                return
                
            }
            else {
                let toast = Toast(text: "出了一点小问题，请稍后再试!", duration: Delay.short)
                toast.show()
                return
            }
        }
    }
    
}
