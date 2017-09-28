//
//  MyViewController.swift
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copyright © 2017 FlyingPuPu. All rights reserved.
//

import UIKit

class HSGHSettingsFixesChNameVC: HSGHHomeBaseViewController {
    
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var contentViewHeightCons: NSLayoutConstraint!
    //Eng
    
    @IBOutlet weak var wholeScrollView: UIScrollView!

    
    //Ch
    @IBOutlet weak var chFirstNameTf: LimitedTextField!
    @IBOutlet weak var chLastNameTF: LimitedTextField!
    
    @IBOutlet weak var nextButton: HSGHCustomButton!
    @IBOutlet weak var chTitleLabel: UILabel!
    
    
    let limitedChCount = 2
    
    
    //编辑模式
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        setupDefault()
        self.automaticallyAdjustsScrollViewInsets = false
        
        setToEditModel()
        self.setNavigationBarIsHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func setToEditModel() {
        chFirstNameTf.text = HSGHUserInf.shareManager().lastName
        chLastNameTF.text = HSGHUserInf.shareManager().firstName
        checkStatus()
    }

    func setupDefault() {
        nextButton.isNext = true
        nextButton.isEnabled = false


        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        
        
        chFirstNameTf.delegate = self
        chFirstNameTf.limitedNumber = limitedChCount
        chFirstNameTf.returnKeyType = .done
        chFirstNameTf.limitedRegEx = "^[\\u4e00-\\u9fa5]{0,}$";
        chLastNameTF.delegate = self
        chLastNameTF.limitedNumber = limitedChCount
        chLastNameTF.returnKeyType = .done
        chLastNameTF.limitedRegEx = "^[\\u4e00-\\u9fa5]{0,}$";
        
        chFirstNameTf.addTarget(self, action: #selector(textFieldDidEnd), for: UIControlEvents.editingDidEnd)
        chFirstNameTf.addTarget(self, action: #selector(textFieldDidEnd), for: UIControlEvents.editingDidEndOnExit)
        chLastNameTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        chFirstNameTf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange() {
        checkStatus()
    }
    
    func textFieldDidEnd() {
    }

    
    deinit {
        chFirstNameTf.removeTarget(self, action: #selector(textFieldDidEnd), for: UIControlEvents.editingDidEnd)
        chFirstNameTf.removeTarget(self, action: #selector(textFieldDidEnd), for: UIControlEvents.editingDidEndOnExit)
        chLastNameTF.removeTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        chFirstNameTf.removeTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        chFirstNameTf?.delegate = nil
        chLastNameTF?.delegate = nil
    }
    

    func checkStatus() {
        if !chFirstNameTf.text!.isEmpty && !chLastNameTF.text!.isEmpty {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    

    @IBAction func clickNext(_ sender: Any) {
        
        if let first = chFirstNameTf.text, let second = chLastNameTF.text {
            if first.isEmpty || second.isEmpty {
                let toast = Toast(text: "姓或名中为空，请输入", duration: Delay.short)
                toast.show()
                return
            }
            
            if (!validateCH(first) || !validateCH(second)) {
                let toast = Toast(text: "姓或名中包含非中文字符，请重新输入", duration: Delay.short)
                toast.show()
                return
            }
        }
        
        if !HSGHNameMatch.isMatchName(chFirstNameTf.text!) {
            let toast = Toast(text: "请输入正确的姓氏", duration: Delay.short)
            toast.show()
            return
        }
        
        requestModifyInfo()
    }
    
    
    func saveInfo() {
        HSGHRegisterNetModel.singleInstance().firstName = chLastNameTF.text!
        HSGHRegisterNetModel.singleInstance().lastName = chFirstNameTf.text!
    }
    
    
    func requestModifyInfo() {
        saveInfo()
        SVProgressHUD.show()
        HSGHSettingsModel.modifyUserCHName() {[weak self] (ret, msg) in
            SVProgressHUD.dismiss()
            if ret {
                let toast = Toast(text: "修改中文名成功", duration: Delay.short)
                toast.show()
                self?.navigationController?.popViewController(animated: true)
            }
            else {
                if let msg : String = msg, (msg as NSString).length > 0 {
                    let toast = Toast(text: msg, duration: Delay.short)
                    toast.show()
                }
                else {
                    let toast = Toast(text: "服务器错误，请稍后再试", duration: Delay.short)
                    toast.show()
                }
            }
        }
    }
    
}

//Control input
extension  HSGHSettingsFixesChNameVC: UITextFieldDelegate {
    var kMaxLength : Int {
        return 20
    }
    
    var kMinLength : Int {
        return 8
    }
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    

    func inputValidate(_ string: String) -> Bool {
        //@"[ a-zA-Z0-9\u4e00-\u9fa5]"  汉字加英文和数字
        // -/:;()$&@\".,?!'  字符
        //"^[0-9a-zA-Z-/:;()$&@\".,?!]*$" 全部数字和字符 但不包括空格
        //^(.*[a-z])(?=.*[0-9]).*$  数字或小写英文，不能纯数字
        if let regex = try? NSRegularExpression(pattern: "^[A-Za-z]*$", options: .caseInsensitive) {
            return regex.matches(in: string, options: .withoutAnchoringBounds, range: NSMakeRange(0, string.characters.count)).count > 0
        }
        
        return false
    }
    
    
    func validate(_ string: String) -> Bool {
        return HSGHTools.isValidateNickName(_:string)
    }
    
    func validateCH(_ string: String) -> Bool {
        if string.isEmpty {
            return false
        }
        
        if let regex = try? NSRegularExpression(pattern: "^[\\u4e00-\\u9fa5]*$", options: .caseInsensitive) {
            return regex.matches(in: string, options: .withoutAnchoringBounds, range: NSMakeRange(0, string.characters.count)).count > 0
        }
        
        return false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        restoreKeyboard()
        return true
    }
}
