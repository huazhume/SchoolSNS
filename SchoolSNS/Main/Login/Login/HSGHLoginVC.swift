//
//  MyViewController.swift
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copyright © 2017 FlyingPuPu. All rights reserved.
//

import UIKit

public class HSGHLoginVC: HSGHBaseViewController {
    
    @IBOutlet weak var emailWholeView: AnimatableView!
    @IBOutlet weak var phoneWholeView: AnimatableView!
    
    
    @IBOutlet weak var emailEditTextFiled: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    
    @IBOutlet weak var phoneHeadLabel: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var phoneTFTailCons: NSLayoutConstraint!
    
    @IBOutlet weak var newRegToBottomCons: NSLayoutConstraint!
    @IBOutlet weak var emailToTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var emailToLeft: NSLayoutConstraint!
    @IBOutlet weak var emailToRight: NSLayoutConstraint!
    
    @IBOutlet weak var selectStatusButton: UIButton!
    
    var selectedPhoneInfo:PhoneHeadInfo = PhoneHeadInfo()
    var isEnterForget : Bool = false
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        adjustUIConstraints()
        addTapHiddenKeyboard()
        selectedPhoneInfo.name = "中国"
        selectedPhoneInfo.phone = "+86"
        passwordTextFiled.delegate = self
        emailEditTextFiled.delegate = self
        phoneTF.delegate = self
        updateInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        selectStatusButton.isHidden = true
        
//        let delay = DispatchTime.now() + DispatchTimeInterval.milliseconds(500)
//        DispatchQueue.main.asyncAfter(deadline: delay) {
//            self.phoneTF.becomeFirstResponder()
//        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        passwordTextFiled?.delegate = nil
        emailEditTextFiled?.delegate = nil
        phoneTF?.delegate = nil
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        navigationController?.isNavigationBarHidden = true
        UIApplication.shared.isStatusBarHidden = true
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isStatusBarHidden = false
    }

    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: -- keyboard
    //键盘的出现
    func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
//        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
//        let changeY = kbRect.origin.y - UIScreen.main.bounds.size.height
        //键盘弹出的时间t
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.view.top = -100;
        }
    }
    
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        let kbInfo = notification.userInfo
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            self.view.top = 0
        }
    }
    
    
    //MARK: --- adjust UI
    func adjustUIConstraints() {
        if (UIScreen.main.bounds.height <= 568) {
            newRegToBottomCons.constant = 5.0
            phoneTFTailCons.constant = 0
//            phoneTF.font = UIFont.systemFont(ofSize: 11)
            emailToLeft.constant = 22
            emailToRight.constant = 22
        }
    }
    
    func addTapHiddenKeyboard() {
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
    }
    
    //MARK: --- internal actions
    func adjustInput() -> Bool {
        if phoneWholeView.isHidden { //Email
            guard let emailText = emailEditTextFiled.text, let password = passwordTextFiled.text  else {
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
                let toast = Toast(text: "账号格式不正确，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
        } else {
            guard let phoneText = phoneTF.text, let password = passwordTextFiled.text  else {
                let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
            
            if phoneText.isEmpty || password.isEmpty {
                let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
            
            
            if (phoneText as NSString).length < kMinLength {
                let toast = Toast(text: "号码太短，请重新输入", duration: Delay.short)
                toast.show()
                return false
            }
            
        }

        if let password = passwordTextFiled.text, password.lengthOfBytes(using: .utf8) < kMinLength {
            let toast = Toast(text: "密码长度至少6位，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        return true
    }

    func setInputStatus(_ isError: Bool, _ filed: UITextField) {
        filed.textColor = isError ? UIColor.red : UIColor.init(hexString: "272727")
    }
    
    func updateInfo() {
        phoneHeadLabel.text = selectedPhoneInfo.name + selectedPhoneInfo.phone
    }
    ///Action
    
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
    
    
    @IBAction func selection(_ sender: Any) {
        showPopView(view: sender as! UIView)
    }
    
    @IBAction func loginIn(_ sender: Any) {
        restoreKeyboard()
        if adjustInput() {
            if let password = passwordTextFiled.text {
                SVProgressHUD.show();
                let userModel = HSGHLoginUserModel()
                if phoneWholeView.isHidden {
                    userModel.isEmail = true
                    userModel.email = emailEditTextFiled.text
                } else {
                    userModel.isEmail = false
                    userModel.phoneCode = selectedPhoneInfo.dropFirst()
                    userModel.phoneNumber = phoneTF.text;
                }
                
                HSGHLoginNetRequest.login(userModel, password: password, block: { (ret) in
                    SVProgressHUD.dismiss()
                    if ret {
                        
                        HSGHUserInf.shareManager().hasSendQianQian = true
                        HSGHUserInf.shareManager().saveUserDefault()
                        
                        let delegate = UIApplication.shared.delegate as? AppDelegate
                        if HSGHUserInf.hasCompletedInfo() {
                            delegate?.enterMainUI()
                        } else {
                            delegate?.enterCompleteInfo()
                        }
                    }
                    else {
                        let toast = Toast(text: "用户名或者密码错误，请稍后再试", duration: Delay.short)
                        toast.show()
                    }
                })

            }

        }
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! HSGHRegWholeVC
        vc.isFromForgetPSD = ((sender as! UIView).tag == 1)
    }
}

extension HSGHLoginVC {
    func showPopView(view: UIView, _ isYear: Bool = true) {
        let popView = PopoverView()
        var retArray: Array<PopoverAction> = Array<PopoverAction>()
        let action : PopoverAction = PopoverAction(title: "手机", handler: {[weak self] (action) in
            self?.emailWholeView.isHidden = true
            self?.phoneWholeView.isHidden = false
        })
        retArray.append(action)
        
        let action2 : PopoverAction = PopoverAction(title: "邮箱", handler: {[weak self] (action) in
            self?.emailWholeView.isHidden = false
            self?.phoneWholeView.isHidden = true
        })
        retArray.append(action2)
        popView.show(to: view, with: retArray)
    }
}


//Control input
extension  HSGHLoginVC: UITextFieldDelegate {
    var kMaxLength : Int {
        return 32
    }
    
    var kMinLength : Int {
        return 6
    }
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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


