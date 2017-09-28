//
//  HSGHRegWholeVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 23/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHRegWholeVC: HSGHHomeBaseViewController  {
    
    @IBOutlet weak var phoneHeadLabel: UILabel!
    //tag: 0 ~ 3
    @IBOutlet var tfCollectionsArray: [UITextField]!
    @IBOutlet weak var resendButton: AnimatableButton!
    @IBOutlet weak var resendLabel: UILabel!
    
    @IBOutlet weak var nextButton: AnimatableButton!
    
    @IBOutlet weak var confirmWholeView: UIView!
    var isFromForgetPSD : Bool = false
    
    fileprivate var selectedPhoneInfo:PhoneHeadInfo = PhoneHeadInfo()
    fileprivate var countTimer : DispatchSourceTimer?
    fileprivate var currentTime : Int = 0

    //For iPad cons
    @IBOutlet weak var WholeToTailsCons: NSLayoutConstraint!
    @IBOutlet weak var WholeToLeftCons: NSLayoutConstraint!
    @IBOutlet weak var wholeToTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var regButtonToBottomCons: NSLayoutConstraint!
    
    
    
//MARK: ^_^ LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        setupTF()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        adjustUIConstraints()
        
        let delay = DispatchTime.now() + DispatchTimeInterval.milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            let phoneTF = self.findTF(0)
            phoneTF?.becomeFirstResponder()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.clearTF()
    }
    
    func adjustUIConstraints() {
        if (UIScreen.main.bounds.height <= 568) {
            WholeToTailsCons.constant = -5
            WholeToLeftCons.constant = -5
            wholeToTopCons.constant = (UIScreen.main.bounds.height == 480) ? -5 : 5
            regButtonToBottomCons.constant = (UIScreen.main.bounds.height == 480) ? 0 : 10
        }
    }
    
//MARK: ^_^ Confirm
    @IBAction func enterConfirm(_ sender: Any) {
        let vc = HSGHRegConfirmProtocolVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//MARK: ^_^ Public Actions
    
//MARK: ^_^ Notification
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
        if findTF(3)!.isFirstResponder || findTF(2)!.isFirstResponder {
            UIView.animate(withDuration: duration) {
                self.view.top = -180
            }
        }
        else {
            UIView.animate(withDuration: duration) {
                if (UIScreen.main.bounds.height < 568) {
                    self.view.top = -30;
                }
                else {
                    self.view.top = -50;
                }
            }
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
    
//MARK: ^_^ Inner Actions ^_^ Start
//MARK: ^_^ UI Actions
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
    
    @IBAction func clickResendCode(_ sender: Any) {
        
        let codeTF = findTF(3)
        codeTF?.becomeFirstResponder()
        
        
        let phoneTF = findTF(0)
        if let inputTextTF = phoneTF, let inputText = inputTextTF.text {
            if inputText.isEmpty {
                let toast = Toast(text: "手机为空，请输入", duration: Delay.short)
                toast.show()
                return
            }
            
            if !HSGHTools.isValidatedPhone(inputText, phoneCode: selectedPhoneInfo.phone) {
                let toast = Toast(text: "手机格式不正确，请重新输入", duration: Delay.short)
                toast.show()
                return
            }
            
            let userModel = HSGHLoginUserModel()
            userModel.isEmail = false
            userModel.phoneCode = selectedPhoneInfo.dropFirst()
            userModel.phoneNumber = inputText
            userModel.category = isFromForgetPSD ? 2 : 1
            SVProgressHUD.show()
            HSGHLoginNetRequest.sendVerityCode(userModel) {[weak self] (ret, isExisted, errDes) in
                SVProgressHUD.dismiss()
                if isExisted {
                    let toast = Toast(text: "用户已存在，请重新输入！", duration: Delay.short)
                    toast.show()
                } else {
                    if !ret {
                        if let errDes = errDes, !errDes.isEmpty {
                            let toast = Toast(text: errDes, duration: Delay.short)
                            toast.show()
                        }
                        else {
                            let toast = Toast(text: "出了点小问题，请稍后再试", duration: Delay.short)
                            toast.show()
                        }
                    }
                    else {
                        self?.setTheTimer()
                    }
                }
            }
        }
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        if isValidateInput() {
            SVProgressHUD.show()
            if isFromForgetPSD {
                let forgetPSDModel : HSGHLoginUserModel = HSGHLoginUserModel()
                forgetPSDModel.verifyCode = findTF(3)?.text!
                forgetPSDModel.secondPSD = findTF(1)?.text!
                forgetPSDModel.phoneCode = selectedPhoneInfo.dropFirst()
                forgetPSDModel.phoneNumber = findTF(0)?.text!
                HSGHLoginNetRequest.forgetPassword(forgetPSDModel, block: { (ret, msg) in
                    if ret {
                        #if false
                            let popup = PopupDialog(title: nil, message: "密码重置成功，请重新登入", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
                            }
                            
                            let buttonTwo = DefaultButton(title: "确定") {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            popup.addButtons([buttonTwo])
                            self.navigationController?.present(popup, animated: true, completion: nil)
                        #else
                            let userModel = HSGHLoginUserModel()
                            userModel.isEmail = false
                            userModel.phoneCode = forgetPSDModel.phoneCode
                            userModel.phoneNumber = forgetPSDModel.phoneNumber
                            HSGHLoginNetRequest.login(userModel, password: forgetPSDModel.secondPSD, block: { (ret) in
                                SVProgressHUD.dismiss()
                                if (ret) {
                                    let toast = Toast(text: "密码重置成功", duration: Delay.short)
                                    toast.show()
                                    HSGHUserInf.shareManager().hasSendQianQian = true
                                    HSGHUserInf.shareManager().saveUserDefault()
                                    let delegate = UIApplication.shared.delegate as? AppDelegate
                                    delegate?.enterMainUI()
                                }
                                else {
                                    let toast = Toast(text: "除了一点小问题，请稍后再试", duration: Delay.short)
                                    toast.show()
                                }
                            })
                        #endif
                    }
                    else {
                        SVProgressHUD.dismiss()
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
                saveInfo()
                HSGHRegisterNetRequest.requestFirstStep({ (ret, isNext, msg) in
                    SVProgressHUD.dismiss()
                    if ret {
                        
                        HSGHUserInf.shareManager().hasSendQianQian = false
                        HSGHUserInf.shareManager().saveUserDefault()
                        
                        let appdelegate = AppDelegate.instanceApplication()
                        appdelegate?.enterCompleteInfo()
                    }
                    else {
                        if (isNext) {
                            let toast = Toast(text: "用户已被注册，请重新输入", duration: Delay.short)
                            toast.show()
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
                    }
                })
            }
        }
    }
    
    
    //MARK: ^_^ Refresh UI Info
    func setupDefault() {
        nextButton.isEnabled = true
        selectedPhoneInfo.name = "中国"
        selectedPhoneInfo.phone = "+86"
        self.updateInfo()
        
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        
        nextButton.setTitle(isFromForgetPSD ? "重置密码" : "下一步", for: .normal)
        title = isFromForgetPSD ? "找回账号" : "新用户注册"
        resendLabel.text = "获取验证码"
        confirmWholeView.isHidden = isFromForgetPSD
    }
    
    func saveInfo(){
        HSGHRegisterNetModel.singleInstance().phoneNumber = findTF(0)?.text!
        HSGHRegisterNetModel.singleInstance().phoneCode = selectedPhoneInfo.dropFirst()
        HSGHRegisterNetModel.singleInstance().password = findTF(1)?.text!
        HSGHRegisterNetModel.singleInstance().verifyCode = findTF(3)?.text!
    }
    
    
    func updateInfo() {
        phoneHeadLabel.text = selectedPhoneInfo.name + selectedPhoneInfo.phone
    }
    
    func updateSendButtonText(_ time: Int) {
        if time > 0 {
            resendLabel.text = String(time)
        }
        else {
            resendLabel.text = "重新获取"
        }
    }
    
    func findTF(_ tag: Int) -> UITextField? {
        for textFiled in tfCollectionsArray {
            if textFiled.tag == tag {
                return textFiled
            }
        }
        return nil
    }
}

//MARK: ^_^ Resend verity code
extension HSGHRegWholeVC {
    
    var beginTime : Int {
        return 60
    }
    
    var endTime : Int {
        return 0
    }
    
    func setTheTimer() {
        deinitTimer()
        self.resendButton.isEnabled = false
        countTimer = DispatchSource.makeTimerSource(queue: .main)
        countTimer?.scheduleRepeating(deadline: .now() + 1, interval: 1)
        countTimer?.setEventHandler {
            self.updateSendButtonText(self.currentTime)
            self.currentTime -= 1
            if (self.currentTime <= 0) {
                self.resendButton.isEnabled = true
            }
        }
        // 启动定时器
        countTimer?.resume()
        self.currentTime = beginTime
    }
    
    func deinitTimer() {
        if let timer = self.countTimer {
            timer.cancel()
            self.countTimer = nil
        }
    }
    
}


//MARK: ^_^ Keyboard & Input
extension HSGHRegWholeVC : UITextFieldDelegate {
    var phoneInputRange : Range<Int> {
        return 6..<19
    }
    
    var psdInputRange : Range<Int> {
        return 6..<33
    }
    
    var verityCodeLimited : Int {
        return 6
    }
    
    func setupTF() {
        for textFiled in tfCollectionsArray {
            textFiled.delegate = self
        }
    }
    
    func clearTF() {
        for textFiled in tfCollectionsArray {
            textFiled.delegate = nil
        }
    }
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    
//MARK: ^-^ delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        restoreKeyboard()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        nextButton.isEnabled = isValidateInput()
        return true
    }
    
    
//MARK: ^_^ CheckInput
    ///@Return => All input not empty ==> false, one is empty ==> ture
    
    func emptyContentCheck() -> Bool {
        for textFiled in tfCollectionsArray {
            guard let text = textFiled.text, !text.isEmpty else{
                return true
            }
        }
        
        return false
    }
    
    func isValidateInput() -> Bool {
        if emptyContentCheck() {
            return false
        }
        
        var firstTF : UITextField? = nil
        var secondTF : UITextField? = nil
        for textFiled in tfCollectionsArray {
            if textFiled.tag == 1 {
                firstTF = textFiled
            }
            
            if textFiled.tag == 2 {
                secondTF = textFiled
            }
            
            switch textFiled.tag {
                case 0: //Phone
                    if !HSGHTools.isValidatedPhone(textFiled.text!, phoneCode: selectedPhoneInfo.phone) {
                        let toast = Toast(text: "手机格式不正确，请重新输入", duration: Delay.short)
                        toast.show()
                        return false
                    }
            
                case 1,2: //PSD
                    if !HSGHTools.isValidatePassword(textFiled.text!) {
                        let toast = Toast(text: "密码格式不正确，请重新输入", duration: Delay.short)
                        toast.show()
                        return false
                    }
                
                case 3: //VerityCode
                    if !HSGHTools.isValidateVerityCode(textFiled.text!) {
                        let toast = Toast(text: "请输入6位验证码", duration: Delay.short)
                        toast.show()
                        return false
                    }
                
                default:
                    break
            }
        }
        
        
        if let firstText = firstTF!.text, let secondText = secondTF!.text, firstText != secondText {
            let toast = Toast(text: "前后密码不一致，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        return true
    }
    
    
}

