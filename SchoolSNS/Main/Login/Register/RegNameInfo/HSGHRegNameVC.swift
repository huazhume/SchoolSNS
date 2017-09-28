//
//  MyViewController.swift
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copyright © 2017 FlyingPuPu. All rights reserved.
//

import UIKit

class HSGHRegNameVC: HSGHBaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var contentViewHeightCons: NSLayoutConstraint!
    //Eng
    
    @IBOutlet weak var wholeScrollView: UIScrollView!
    @IBOutlet weak var enFirstNameTf: LimitedTextField!
    @IBOutlet weak var enSecondNameTF: LimitedTextField!
    @IBOutlet weak var enThirdNameTF: LimitedTextField!
    
    //Ch
    @IBOutlet weak var chFirstNameTf: LimitedTextField!
    @IBOutlet weak var chLastNameTF: LimitedTextField!
    
    @IBOutlet weak var nextButton: HSGHCustomButton!
    @IBOutlet weak var chTitleLabel: UILabel!
    
    
    @IBOutlet weak var wholePositionView: UIView!
    @IBOutlet weak var positionShowTF: UITextField!
    var pickerView: UIView!
    var realPickerView: UIPickerView!

    var positionDic: [String: [CitySingleData]]? = nil
    var positionKeys: [String]? = nil
    var selectRow = 0
    var secondSelectRow = 0
    var zipCode = ""
    
    var isFixesCNName = false
    
    let limitedCount = 10
    let limitedChCount = 2
    
    
    //编辑模式
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        setupDefault()
        setupPickerView()
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if !isFixesCNName {
            let delay = DispatchTime.now() + DispatchTimeInterval.milliseconds(800)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.chFirstNameTf.becomeFirstResponder()
            }
        }

        updateTitleLabel()
        
        
        setToEditModel()
    }
    
    //setTitle
    func updateTitleLabel() {
        let attributeString = NSMutableAttributedString(string:"真实中文姓名(可以设置为不显示)")
        attributeString.addAttribute(NSFontAttributeName,
                                     value: UIFont.boldSystemFont(ofSize: 15),
                                     range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black,
                                     range: NSMakeRange(0, attributeString.length))
        chTitleLabel.attributedText = attributeString
    }
    
    
    //编辑模式
    func setToEditModel() {
        if isFixesCNName {
            titleLabel.text = "您的姓氏不合规范，请重新输入"
            progressLabel.isHidden = true
            backButton.isHidden = true
            
            chFirstNameTf.text = HSGHUserInf.shareManager().lastName
            chLastNameTF.text = HSGHUserInf.shareManager().firstName
            HSGHRegisterNetModel.singleInstance().homeCityId = HSGHUserInf.shareManager().homeCityId
            positionShowTF.text = HSGHUserInf.shareManager().homeCity
            
            if let firstEn = HSGHUserInf.shareManager().firstNameEn {
                enFirstNameTf.text = firstEn
            }
            
            if let middleEn = HSGHUserInf.shareManager().middleNameEn {
                enSecondNameTF.text = middleEn
            }
            
            if let lastEn = HSGHUserInf.shareManager().lastNameEn {
                enThirdNameTF.text = lastEn
            }
            
            checkStatus()
        }
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
    
    
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupDefault() {
        nextButton.isNext = true
        nextButton.isEnabled = false

        fetchCityData { [weak self] dictionary in
            if let dic = dictionary {
                self?.positionDic = dic
                self?.positionKeys = Array(dic.keys)
                self?.realPickerView.reloadAllComponents()
            }
        }

        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        
        enFirstNameTf.delegate = self
        enFirstNameTf.limitedNumber = limitedCount
        enSecondNameTF.delegate = self
        enSecondNameTF.limitedNumber = limitedCount
        enThirdNameTF.delegate = self
        enThirdNameTF.limitedNumber = limitedCount
        enFirstNameTf.limitedType = .custom
        enSecondNameTF.limitedType = .custom
        enThirdNameTF.limitedType = .custom
        enFirstNameTf.limitedRegEx = "^[A-Za-z]+$"
        enSecondNameTF.limitedRegEx = "^[A-Za-z]+$"
        enThirdNameTF.limitedRegEx = "^[A-Za-z]+$"
        enFirstNameTf.isFirstNameBig = true
        enSecondNameTF.isFirstNameBig = true
        enThirdNameTF.isFirstNameBig = true
        
        
        
        chFirstNameTf.delegate = self
        chFirstNameTf.limitedNumber = limitedChCount
        chFirstNameTf.returnKeyType = .done
        chFirstNameTf.limitedRegEx = "^[\\u4e00-\\u9fa5]{0,}$";
        chLastNameTF.delegate = self
        chLastNameTF.limitedNumber = limitedChCount
        chLastNameTF.returnKeyType = .done
        chLastNameTF.limitedRegEx = "^[\\u4e00-\\u9fa5]{0,}$";
        updateCons()
        
        enThirdNameTF.isEnabled = false
        enThirdNameTF.textColor = UIColor.lightGray
        chFirstNameTf.addTarget(self, action: #selector(textFieldDidEnd), for: UIControlEvents.editingDidEnd)
        chFirstNameTf.addTarget(self, action: #selector(textFieldDidEnd), for: UIControlEvents.editingDidEndOnExit)
        chLastNameTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        chFirstNameTf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        enFirstNameTf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange() {
        checkStatus()
    }
    
    func textFieldDidEnd() {
        if let text = chFirstNameTf.text {
            if (text as NSString).length > 0 {
                enThirdNameTF.text = HSGHNameMatch.pinyinMulti(of: text).capitalized
            }
        }
    }

    func updateCons(){
        if (nextButton.bottom + wholeScrollView.top + 10 > self.view.height) {
            wholeScrollView.contentSize = CGSize(width: self.view.width ,height: nextButton.bottom + 10)
        }
        else {
            wholeScrollView.contentSize = CGSize(width: self.view.width ,height: self.view.height - wholeScrollView.top)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        enFirstNameTf?.delegate = nil
        enSecondNameTF?.delegate = nil
        enThirdNameTF?.delegate = nil
        
        chFirstNameTf?.delegate = nil
        chLastNameTF?.delegate = nil
    }
    
    
    func setupPickerView() {
        pickerView = UIView(frame: CGRect(x: 0, y: view.height / 2.0, width: view.width, height: view.height - view.height / 2.0))
        pickerView.backgroundColor = .white
        view.addSubview(pickerView)

        realPickerView = UIPickerView.init(frame: CGRect(x: 0, y: 20, width: view.width, height: pickerView.height - 30))
        realPickerView.showsSelectionIndicator = true
        realPickerView.dataSource = self
        realPickerView.delegate = self
        pickerView.addSubview(realPickerView)

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 40)
        button.backgroundColor = .init(hexString: "000000")
        button.setTitle("完成", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(clickPickerView), for: .touchUpInside)
        pickerView.addSubview(button)

        pickerView.isHidden = true
    }

    func clickPickerView() {
        if let keys = positionKeys, let array = positionDic?[keys[selectRow]] {
            if (array.count > secondSelectRow) {
                positionShowTF.text = array[secondSelectRow].city
                zipCode = String(array[secondSelectRow].zipCode)!
            }
        }
        checkStatus()
        wholeScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        pickerView.isHidden = true
    }

    func checkStatus() {
        if !chFirstNameTf.text!.isEmpty && !chLastNameTF.text!.isEmpty && !positionShowTF.text!.isEmpty {
            if let _: String = chFirstNameTf.text, let _: String = chLastNameTF.text,
               let _ = positionShowTF.text {
                nextButton.isEnabled = true
            } else {
                let toast = Toast(text: "中文名和常住地不能为空哦！", duration: Delay.short)
                toast.show()
                nextButton.isEnabled = false
                return
            }
        } else {
            nextButton.isEnabled = false
        }
    }
    
    @IBAction func selectionPosition(_ sender: Any) {
        pickerView.isHidden = false
        wholeScrollView.setContentOffset(CGPoint(x:0, y:wholePositionView.top - 60), animated: true)
        restoreKeyboard()
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let keys = positionKeys else {
            return 0
        }
        if component == 0 {
            return keys.count
        } else {
            if let array = positionDic?[keys[selectRow]] {
                return array.count
            }
        }
        return 0
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let keys = positionKeys else {
            return
        }

        if component == 1 {
            if let array = positionDic?[keys[selectRow]] {
                secondSelectRow = row
                positionShowTF.text = array[row].city
                zipCode = String(array[row].zipCode)!
            } else {
                positionShowTF.text = ""
            }
        } else {
            selectRow = row
            self.realPickerView.reloadComponent(1)
        }
        checkStatus()
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let keys = positionKeys else {
            return ""
        }
        if component == 0 {
            return keys[row]
        }
        else {
            if let array = positionDic?[keys[selectRow]] {
                return array[row].city
            }
        }

        return ""
    }

    
    func checkLoginStatus() -> Bool {
        guard let first = chFirstNameTf.text, let second = chLastNameTF.text, validateCH(first), validateCH(second) else{
            let toast = Toast(text: "姓或名中包含非中文字符，请重新输入", duration: Delay.short)
            toast.show()
            return false
        }
        
        HSGHRegisterNetModel.singleInstance().firstName = second
        HSGHRegisterNetModel.singleInstance().lastName = first
        
        HSGHRegisterNetModel.singleInstance().homeCityId = zipCode
        return true
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
        
//        if let firstEn = enFirstNameTf.text, let lastEn = enThirdNameTF.text {
//            if firstEn.isEmpty, !lastEn.isEmpty {
//                let toast = Toast(text: "FirstName 不能为空哦", duration: Delay.short)
//                toast.show()
//                return
//            }
//            if !firstEn.isEmpty, lastEn.isEmpty {
//                let toast = Toast(text: "LastName 不能为空哦", duration: Delay.short)
//                toast.show()
//                return
//            }
//        }
        
        showDialog()
    }
    
    
    func showDialog() {
        guard let firstCH = chFirstNameTf.text, let secondCH = chLastNameTF.text, let firstName = enFirstNameTf.text,
            let middleName = enSecondNameTF.text, var lastName = enThirdNameTF.text else {
                return
        }
        
        if !lastName.isEmpty {
            lastName = HSGHNameMatch.pinyinMulti(of: firstCH).capitalized
        }
        
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        /* attributed string for alertController message */
        let string: String
        var firstlength: Int = 0
        var secondLength: Int = 0
        var thirdLength: Int = 0
        var fourLength: Int = 0
        var fiveLength: Int = 0
        var wholeLength: Int = 0

        let hasEngName = (firstName as NSString).length > 0  //(lastName as NSString).length > 0
        
        if hasEngName {
            if (middleName as NSString).length == 0 {
                string = "中文名: \(firstCH)\(secondCH)(将不可修改)\n英文名: \(firstName) \(lastName)\nLastName: \(lastName)(将不可修改)"
                fourLength = ("\(firstName) \(lastName)" as NSString).length
            }
            else {
                string = "中文名: \(firstCH)\(secondCH)(将不可修改)\n英文名: \(firstName) \(middleName) \(lastName)\nLastName: \(lastName)(将不可修改)"
                fourLength = ("\(firstName) \(middleName) \(lastName)" as NSString).length
            }
            thirdLength = ("\n英文名: " as NSString).length
            fiveLength = ("\nLastName: " as NSString).length
        }
        else {
            string = "中文名: \(firstCH)\(secondCH)(将不可修改)"
        }
        
        firstlength = ("中文名: " as NSString).length
        secondLength = ("\(firstCH)\(secondCH)(将不可修改)" as NSString).length
        wholeLength = (string as NSString).length

        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: NSRange(location:0,length: firstlength))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location:firstlength,length:secondLength))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: NSRange(location:firstlength + secondLength,length: thirdLength))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location:firstlength + secondLength + thirdLength,length:fourLength))
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: NSRange(location:firstlength + secondLength + thirdLength + fourLength
            ,length: fiveLength))
        let lastLength = firstlength + secondLength + thirdLength + fourLength + fiveLength
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location:lastLength,length:wholeLength - lastLength))
        
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
            self?.requestModifyInfo()
        })
        
        self.navigationController?.present(alertController, animated: true, completion: nil);
    }
    
    func saveInfo() {
        HSGHRegisterNetModel.singleInstance().firstName = chLastNameTF.text!
        HSGHRegisterNetModel.singleInstance().lastName = chFirstNameTf.text!
        
        if let enFirstName = enFirstNameTf.text, !enFirstName.isEmpty{
            HSGHRegisterNetModel.singleInstance().firstNameEn = enFirstName
        }
        else {
            HSGHRegisterNetModel.singleInstance().firstNameEn = HSGHNameMatch.pinyinMulti(of: chLastNameTF.text!).capitalized
        }
        
        if let enmiddleName = enSecondNameTF.text, !enmiddleName.isEmpty {
            HSGHRegisterNetModel.singleInstance().middleNameEn = enmiddleName
        }
        
//        if let enThirdName = enThirdNameTF.text, !enThirdName.isEmpty {
//            HSGHRegisterNetModel.singleInstance().lastNameEn = enThirdName
//        }
//        else
//        {
            HSGHRegisterNetModel.singleInstance().lastNameEn = HSGHNameMatch.pinyinMulti(of: chFirstNameTf.text!).capitalized
//        }
        
        if ((zipCode as NSString).length == 5) {
            zipCode = "0" + zipCode
        }
        HSGHRegisterNetModel.singleInstance().homeCityId = zipCode
    }
    
    
    func requestModifyInfo() {
        saveInfo()
        SVProgressHUD.show()
        
        if isFixesCNName {
            HSGHSettingsModel.modifyUserName() {(ret, msg) in
                SVProgressHUD.dismiss()
                if ret {
                    self.navigationController?.dismiss(animated: true, completion: nil)
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
        }
        else {
            HSGHSettingsModel.modifyUser(true) {(ret, msg) in
                SVProgressHUD.dismiss()
                if ret {
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate?.enterMainUI()
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
        }

    }
    
}

//Control input
extension  HSGHRegNameVC: UITextFieldDelegate {
    var kMaxLength : Int {
        return 20
    }
    
    var kMinLength : Int {
        return 8
    }
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    
  
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let replacedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//
//        checkStatus()
//        if ((textField == enFirstNameTf) || (textField == enSecondNameTF) || (textField == enThirdNameTF)) {
//            if !inputValidate(string) {
//                return false
//            } else {
//                if (textField.text! as NSString).length == 0 {
//                    let str =  replacedString.capitalized
//                    textField.text = str
//                    return false
//                }
//            }
//        }
//        
//        return (replacedString as NSString).length <= kMaxLength
//    }
    
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
        
        //@"[ a-zA-Z0-9\u4e00-\u9fa5]"  汉字加英文和数字
        // -/:;()$&@\".,?!'  字符
        //"^[0-9a-zA-Z-/:;()$&@\".,?!]*$" 全部数字和字符 但不包括空格
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
