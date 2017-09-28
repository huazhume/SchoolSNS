//
//  MyViewController.swift
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copyright © 2017 FlyingPuPu. All rights reserved.
//

import UIKit

public class HSGHRegSchoolInfosVC: HSGHBaseViewController {
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wholeScrollView: UIScrollView!
    @IBOutlet weak var regularWholeView: UIView!
    @IBOutlet weak var regularEndYearWholeView: UIView!
    
    @IBOutlet weak var addWholeView: UIView!
    @IBOutlet weak var masterWholeView: UIView!
    @IBOutlet weak var masterEndYearWholeView: UIView!
    
    @IBOutlet weak var highSchoolWholeView: UIView!
    
    @IBOutlet weak var highSchoolSelectedView: UIView!
    
    
    
    @IBOutlet weak var nextButton: HSGHCustomButton!
    @IBOutlet weak var highClickWholeButton: UIButton!
    @IBOutlet weak var nextButtonToTopCons: NSLayoutConstraint! //390
    @IBOutlet weak var highClickToTopCons: NSLayoutConstraint! //500
    
    @IBOutlet weak var contentViewCons: NSLayoutConstraint! //700
    
    
    @IBOutlet weak var engTextFiled: UITextField!
    @IBOutlet weak var engSelectButton: UIButton!
    @IBOutlet weak var regularStartYearLabel: UILabel!
    
    @IBOutlet weak var regularEndButton: UIButton!
    @IBOutlet weak var regularStartButton: UIButton!
    @IBOutlet weak var regularEndYearLabel: UILabel!
    
    @IBOutlet weak var nowcheck: HSGHCustomButton!
    
    @IBOutlet weak var hadCheck: HSGHCustomButton!
    //Master
    
    @IBOutlet weak var addMasterButton: HSGHCustomButton!
    
    @IBOutlet weak var masterEndYearLabel: UILabel!
    @IBOutlet weak var masterEndYearButton: UIButton!
    
    @IBOutlet weak var masterStartYearLabel: UILabel!
    @IBOutlet weak var masterEngTF: UITextField!

    @IBOutlet weak var masterEndButton: UIButton!
    @IBOutlet weak var masterStartButton: UIButton!
    @IBOutlet weak var masterSelectButton: UIButton!
    @IBOutlet weak var nowMasterCheck: HSGHCustomButton!
    
    @IBOutlet weak var hadMasterCheck: HSGHCustomButton!
    
    //High school
    
    @IBOutlet weak var highSchoolName: UITextField!
    @IBOutlet weak var highSchoolNameButton: UIButton!
    @IBOutlet weak var highSchoolStartYear: UILabel!
    
    var isHighSchoolMode = false
    
    var currentYearLabel: UILabel? = nil
    var currentTF: UITextField? = nil

    let yearMin = 2000
    let yearMax = 2017
    
    let nextDefaultHeight = 390.0
    let clickDefaultHeight = 500.0
    
    let univStatusOnline = 2
    let univStatusGraduation = 3
    
    public var isEditingModel = false
    public var isFixesSchoolModel = false
    
    var isFirstLoading = true //用于设置默认值的时候做静默操作，不会主动触发一些UI操作，比如自动弹出选择年份的选择框
    
    var hasRegularSelectedBoardSchool = false  //本科是否已选择了国外大学
    var hasMasterSelectedBoardSchool = false  //研究生是否已选择了国外大学

    @IBOutlet weak var backButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        setupDefault()
        adjustUIConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func updateCons() {
        if !highSchoolWholeView.isHidden {
            nextButtonToTopCons.constant =  CGFloat(nextDefaultHeight)
            highClickToTopCons.constant = CGFloat(clickDefaultHeight)
        }
        else {
            nextButtonToTopCons.constant = CGFloat(masterWholeView.isHidden ? nextDefaultHeight : (nextDefaultHeight + 130))
            highClickToTopCons.constant = CGFloat(masterWholeView.isHidden ? clickDefaultHeight : (clickDefaultHeight + 130))
        }
        
        if (wholeScrollView.top + highClickToTopCons.constant + 30) > UIScreen.main.bounds.size.height {
            wholeScrollView.contentSize = CGSize(width: wholeScrollView.width, height: highClickToTopCons.constant + 30)
        }
        else {
            wholeScrollView.contentSize = CGSize(width: wholeScrollView.width, height: UIScreen.main.bounds.size.height - wholeScrollView.top + 30)
        }
    }
    
    
    func adjustUIConstraints() {
        if (UIScreen.main.bounds.height < 568) {
            nextButtonToTopCons.constant =  250
            highClickToTopCons.constant = 350
        }
    }

    func setupDefault() {
        nextButton.isNext = true
        addMasterButton.isNext = true
        
        nowcheck.isSelected = true
        nowMasterCheck.isSelected = true

        nextButton.isEnabled = false
        
        showOrHiddenEndYear(true)
        showOrHiddenMasterTitle(true)
        showOrHiddenMasterEndYear(true)
        highSchoolWholeView.isHidden = true
        masterWholeView.isHidden = true
        addWholeView.isHidden = true
        
        //Keyboard
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        engTextFiled.delegate = self
        masterEngTF.delegate = self
        
        //show univ
        
        engTextFiled.isEnabled = false
        masterEngTF.isEnabled = false
        
        //High school
        highSchoolName.delegate = self
        highSchoolNameButton.isHidden = false
        
        if isEditingModel {
            if isFixesSchoolModel {
                titleLabel.text = "编辑学校信息"
                nextButton.setTitle("确定", for: .normal)
                backButton.isHidden = true
            }
            else {
                titleLabel.text = "编辑"
                nextButton.setTitle("确定", for: .normal)
            }
            updateEditInfo(true)
        }
        else {
            HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus = univStatusOnline
        }
        
        updateCons()
    }
    
    func updateEditInfo(_ enableOperation: Bool) {
        highSchoolSelectedView.isHidden = true
        progressLabel.isHidden = true
        
        //Restore info
        if let name = HSGHUserInf.shareManager().bachelorUniv.name {
            engTextFiled.text = name
            engSelectButton.isEnabled = enableOperation
            
            HSGHRegisterNetModel.singleInstance().bachelorUniv.univId = HSGHUserInf.shareManager().bachelorUniv.univId
            HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus = HSGHUserInf.shareManager().bachelorUniv.univStatus
            hasRegularSelectedBoardSchool = !(HSGHUserInf.shareManager().bachelorUniv.city == 1)
        }
        
        if let text = HSGHUserInf.shareManager().bachelorUniv.convertToStartYear() {
            regularStartYearLabel.text = text
            
            regularStartButton.isEnabled = enableOperation
        }
        
        if HSGHUserInf.shareManager().bachelorUniv.univStatus == univStatusOnline {
            clickNowRegularButton(UIButton())
        } else {
            clickHadRegularButton(UIButton())
            nowcheck.isEnabled = enableOperation
            
            if let text = HSGHUserInf.shareManager().bachelorUniv.convertToEndYear() {
                regularEndYearLabel.text = text
                regularEndButton.isEnabled = enableOperation
            }
            
            if let name = HSGHUserInf.shareManager().masterUniv.name, !name.isEmpty{
                addMasterSchool(UIButton())
                addMasterButton.isEnabled = enableOperation
                if let name = HSGHUserInf.shareManager().masterUniv.name {
                    masterEngTF.text = name
                    masterSelectButton.isEnabled = enableOperation
                    
                    HSGHRegisterNetModel.singleInstance().masterUniv.univId = HSGHUserInf.shareManager().masterUniv.univId
                    HSGHRegisterNetModel.singleInstance().masterUniv.univStatus = HSGHUserInf.shareManager().masterUniv.univStatus
                    hasMasterSelectedBoardSchool = !(HSGHUserInf.shareManager().masterUniv.city == 1)
                }
                
                if let text = HSGHUserInf.shareManager().masterUniv.convertToStartYear() {
                    if let masterStart = text.toInt(), let regularEndText = regularEndYearLabel.text, let regularEnd = regularEndText.toInt(), masterStart < regularEnd {
                        masterStartButton.isEnabled = enableOperation;
                        masterStartYearLabel.text = ""
                        return
                    }
                    
                    masterStartButton.isEnabled = enableOperation;
                    masterStartYearLabel.text = text
                }
                
                if HSGHUserInf.shareManager().masterUniv.univStatus == univStatusOnline || HSGHUserInf.shareManager().masterUniv.univStatus == 0{
                    clickNowMasterButton(UIButton())
                } else {
                    clickHadMasterButton(UIButton())
                    nowMasterCheck.isEnabled = enableOperation
                    if let name =  HSGHUserInf.shareManager().masterUniv.convertToEndYear() {
                        masterEndButton.isEnabled = enableOperation;
                        masterEndYearLabel.text = name
                    }
                }
            }
        }
        
        if let highSchool = HSGHUserInf.shareManager().highSchool, let name = highSchool.name, !name.isEmpty {
            highSchoolName.text = name
            if let text = HSGHUserInf.shareManager().highSchool.convertToStartYear() {
                highSchoolStartYear.text = text
            }
            HSGHRegisterNetModel.singleInstance().highSchool.univId = HSGHUserInf.shareManager().highSchool.univId
        }
        
        
        if !enableOperation {
            let popup = PopupDialog(title: nil, message: "已添加的信息将不能被修改哦！", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
            }
            
            let buttonTwo = DefaultButton(title: "确定") {
            }
            popup.addButtons([buttonTwo])
            self.navigationController?.present(popup, animated: true, completion: nil)
        }
        
        isFirstLoading = false
    }
    
    deinit {
        highSchoolName?.delegate = nil
        engTextFiled?.delegate = nil
        masterEngTF?.delegate = nil
    }

    @IBAction func clickSelectedSchool(_ sender: Any) {
        currentTF = engTextFiled
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc : SearchViewController = storyboard.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        let nav = HSGHBaseNavigationViewController.init(rootViewController: vc)
        vc.returnBlock = {[weak self] data in
            if let data = data {
                self?.currentTF?.text = data.name
                
                self?.hasRegularSelectedBoardSchool = !(data.city == 1)
            
                if self?.currentTF == self?.engTextFiled {
                    HSGHRegisterNetModel.singleInstance().bachelorUniv.univId = data.univId
                } else {
                    HSGHRegisterNetModel.singleInstance().masterUniv.univId = data.univId
                }
                
                self?.checkStatus()
            }
        }
        self.present(nav, animated: true, completion: nil)
        
    }

    @IBAction func clickSelectedMasterSchool(_ sender: Any) {
        currentTF = masterEngTF
        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc: SearchViewController = storyboard.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.returnBlock = {[weak self] data in
            if let data = data {
                self?.currentTF?.text = data.name
                
                self?.hasMasterSelectedBoardSchool = !(data.city == 1)

                if self?.currentTF == self?.engTextFiled {
                    HSGHRegisterNetModel.singleInstance().bachelorUniv.univId = data.univId
                } else {
                    HSGHRegisterNetModel.singleInstance().masterUniv.univId = data.univId
                }
                
                self?.checkStatus()
            }
        }
        let nav = HSGHBaseNavigationViewController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
    }

    
    @IBAction func clickNowRegularButton(_ sender: Any) {
        nowcheck.isSelected = true
        hadCheck.isSelected = false
        HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus = univStatusOnline
        hasMasterSelectedBoardSchool = false;
        
        showOrHiddenEndYear(true)
        showOrHiddenMasterTitle(true)
        masterWholeView.isHidden = true
        
        updateCons()
        checkStatus()
        
        clearSchoolInfo(true)

    }
    
    @IBAction func clickHadRegularButton(_ sender: Any) {
        nowcheck.isSelected = false
        hadCheck.isSelected = true
        HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus = univStatusGraduation
        
        showOrHiddenEndYear(false)
        showOrHiddenMasterTitle(false)
        
        updateCons()
        checkStatus()
        
        if !isFirstLoading {
            clickEndYear(regularEndButton)  //自动显示选择结束年
        }
    }

    @IBAction func clickStartYear(_ sender: Any) {
        currentYearLabel = regularStartYearLabel
        self.showPopView(view: sender as! UIView)
    }

    @IBAction func clickEndYear(_ sender: Any) {
        currentYearLabel = regularEndYearLabel
        self.showPopView(view: sender as! UIView)
    }
    
    
    @IBAction func addMasterSchool(_ sender: Any) {
        masterWholeView.isHidden = !masterWholeView.isHidden
        
        if !masterWholeView.isHidden {
            if (HSGHRegisterNetModel.singleInstance().masterUniv.univStatus != univStatusOnline && HSGHRegisterNetModel.singleInstance().masterUniv.univStatus != univStatusGraduation) {
                HSGHRegisterNetModel.singleInstance().masterUniv.univStatus = univStatusOnline
            }
            
            hasMasterSelectedBoardSchool = !(HSGHUserInf.shareManager().masterUniv.city == 1)
        }

        updateCons()
    }
    
    
    //master
    @IBAction func clickMasterEndYear(_ sender: Any) {
        currentYearLabel = masterEndYearLabel
        self.showPopView(view: sender as! UIView)
    }

    @IBAction func clickMasterStartYear(_ sender: Any) {
        currentYearLabel = masterStartYearLabel
        restoreKeyboard()
        self.showPopView(view: sender as! UIView)

    }

    @IBAction func clickNowMasterButton(_ sender: Any) {
        nowMasterCheck.isSelected = true
        hadMasterCheck.isSelected = false
        HSGHRegisterNetModel.singleInstance().masterUniv.univStatus = univStatusOnline
        
        showOrHiddenMasterEndYear(true)
        
        checkStatus()
        
        clearSchoolInfo(false)
    }
    
    @IBAction func clickHadMasterButton(_ sender: Any) {
        nowMasterCheck.isSelected = false
        hadMasterCheck.isSelected = true
        HSGHRegisterNetModel.singleInstance().masterUniv.univStatus = univStatusGraduation
        
        showOrHiddenMasterEndYear(false)
        
        checkStatus()
        
        if !isFirstLoading {
            clickMasterEndYear(masterEndButton) //自动弹出结束年
        }
    }
    
    
    //还原状态，比如从已毕业切换到在读，需要清理掉之前的信息
    func clearSchoolInfo(_ isRegular: Bool) {
        if isRegular {
            regularEndYearLabel.text = ""
        }
        else {
            masterEndYearLabel.text = ""
        }
        
        HSGHUserInf.emptyEndYear(isRegular)
    }
    
    // MARK: - High School
    @IBAction func switchToHighSchool(_ sender: Any) {
        isHighSchoolMode = !isHighSchoolMode
        highSchoolWholeView.isHidden = !isHighSchoolMode
        view.bringSubview(toFront: highSchoolWholeView)
        if !highSchoolWholeView.isHidden {
            view.bringSubview(toFront: nextButton)
            view.bringSubview(toFront: highSchoolSelectedView)
        }
        regularWholeView.isHidden = !highSchoolWholeView.isHidden
        if !regularWholeView.isHidden {
            if (HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus == univStatusGraduation) {
                addWholeView.isHidden = false
                masterWholeView.isHidden = false
            }
            else {
                addWholeView.isHidden = true
                masterWholeView.isHidden = true
            }
        }
        else {
            addWholeView.isHidden = !highSchoolWholeView.isHidden
            masterWholeView.isHidden = !highSchoolWholeView.isHidden
        }
//        addWholeView.isHidden = !highSchoolWholeView.isHidden
//        masterWholeView.isHidden = !highSchoolWholeView.isHidden
        updateCons()
        checkStatus()
    }
    
    @IBAction func selectedHighSchool(_ sender: Any) {
        currentTF = highSchoolName
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc : SearchViewController = storyboard.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
            vc.isHighSchool = true
        let nav = HSGHBaseNavigationViewController.init(rootViewController: vc)
        vc.returnBlock = {[weak self] data in
            if let data = data {
                self?.currentTF?.text = data.name
                HSGHRegisterNetModel.singleInstance().highSchool.univId = data.univId
                self?.checkStatus()
            }
        }
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func clickHighSchoolStartYear(_ sender: Any) {
        currentYearLabel = highSchoolStartYear
        self.showPopView(view: sender as! UIView, true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (isHighSchoolMode) {
            HSGHRegisterNetModel.singleInstance().highSchool.univIn = highSchoolStartYear.text! + "-09-01T05:47:54.726Z"
            HSGHRegisterNetModel.singleInstance().highSchool.univStatus = univStatusOnline
        }
        else {
            HSGHRegisterNetModel.singleInstance().bachelorUniv.univIn = regularStartYearLabel.text! + "-09-01T05:47:54.726Z"
            if (regularEndYearLabel.text?.lengthOfBytes(using: .utf8) != 0) {
                HSGHRegisterNetModel.singleInstance().bachelorUniv.univOut = regularEndYearLabel.text! + "-07-01T05:47:54.726Z"
            }
            
            if HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus == univStatusGraduation {
                if masterStartYearLabel.text?.lengthOfBytes(using: .utf8) != 0 {
                    HSGHRegisterNetModel.singleInstance().masterUniv.univIn = masterStartYearLabel.text! + "-09-01T05:47:54.726Z"
                }
                
                if (masterEndYearLabel.text?.lengthOfBytes(using: .utf8) != 0) {
                    HSGHRegisterNetModel.singleInstance().masterUniv.univOut = masterEndYearLabel.text! + "-07-01T05:47:54.726Z"
                }
            }
        }
    }
    
    public override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isHighSchoolMode , let text : String = highSchoolName.text, text.isEmpty {
            let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
            toast.show()
            nextButton.isEnabled = false
            return false
        }
        
        if isEditingModel {
            self.navigationController?.popViewController(animated: true)
            return false
        }
        
        return true
    }
    
    func saveInfo() {
        if (isHighSchoolMode) {
            HSGHRegisterNetModel.singleInstance().highSchool.univIn = highSchoolStartYear.text! + "-09-01T05:47:54.726Z"
            HSGHRegisterNetModel.singleInstance().highSchool.univStatus = univStatusOnline
        }
        else {
            HSGHRegisterNetModel.singleInstance().bachelorUniv.univIn = regularStartYearLabel.text! + "-09-01T05:47:54.726Z"
            if (regularEndYearLabel.text?.lengthOfBytes(using: .utf8) != 0) {
                HSGHRegisterNetModel.singleInstance().bachelorUniv.univOut = regularEndYearLabel.text! + "-07-01T05:47:54.726Z"
            }
            
            if HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus == univStatusGraduation {
                if masterStartYearLabel.text?.lengthOfBytes(using: .utf8) != 0 {
                    HSGHRegisterNetModel.singleInstance().masterUniv.univIn = masterStartYearLabel.text! + "-09-01T05:47:54.726Z"
                }
                
                if (masterEndYearLabel.text?.lengthOfBytes(using: .utf8) != 0) {
                    HSGHRegisterNetModel.singleInstance().masterUniv.univOut = masterEndYearLabel.text! + "-07-01T05:47:54.726Z"
                }
            }
        }
    }
    
    @IBAction func clickNext(_ sender: Any) {
        if isHighSchoolMode , let text : String = highSchoolName.text, text.isEmpty {
            let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
            toast.show()
            nextButton.isEnabled = false
            return
        }
        
        saveInfo()
        
        if !hasRegularSelectedBoardSchool && !hasMasterSelectedBoardSchool {
            let popup = PopupDialog(title: nil, message: "请至少选择一所国外大学哦！", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
            }
            
            let buttonTwo = DefaultButton(title: "确定") {
            }
            popup.addButtons([buttonTwo])
            self.navigationController?.present(popup, animated: true, completion: nil)
            return
        }
        
        if isEditingModel {
            AppDelegate.instanceApplication().indicatorShow()
            HSGHSettingsModel.modifyAndDeleteSchoolInfo(HSGHRegisterNetModel.singleInstance(), block: {[weak self] (ret, errDes) in
                AppDelegate.instanceApplication().indicatorDismiss()
                if (ret) {
                    let toast = Toast(text: "更新学校信息成功!", duration: Delay.short)
                    toast.show()
                    
                    if (self?.isFixesSchoolModel)! {
                        self?.dismiss(animated: true, completion: nil)
                    }
                    else {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                else {
                    let toast = Toast(text: "出了一点小问题，请稍后再试!", duration: Delay.short)
                    toast.show()
                }
            })
        }
        else {
            let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            let vc : HSGHRegNameVC = storyboard.instantiateViewController(withIdentifier: "CompletedLast") as! HSGHRegNameVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension HSGHRegSchoolInfosVC: UITextFieldDelegate {
    var kMaxLength: Int {
        return 40
    }
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        restoreKeyboard()
        checkStatus()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        checkStatus()
        return newString.lengthOfBytes(using: .utf8) <= kMaxLength
    }
    
}

//For check and change status
extension HSGHRegSchoolInfosVC {
    func showOrHiddenEndYear(_ hidden: Bool) {
        regularEndYearWholeView.isHidden = hidden
    }
    
    func showOrHiddenMasterEndYear(_ hidden: Bool) {
        masterEndYearWholeView.isHidden = hidden
    }
    
    func showOrHiddenMasterTitle(_ hidden: Bool) {
        addWholeView.isHidden = hidden
    }
    
    
    func checkStatus() {
        if !isHighSchoolMode {
            if  let text =  engTextFiled.text, text.isEmpty {
                nextButton.isEnabled = false
                return
            }
            
            if let text =  regularStartYearLabel.text, text.isEmpty {
                nextButton.isEnabled = false
                return
            }
            
            switch HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus {
            case univStatusOnline:
                nextButton.isEnabled = true
                return
                
            case univStatusGraduation:
                if !masterWholeView.isHidden {
                    if regularEndYearLabel.text!.isEmpty {
                        nextButton.isEnabled = false
                        return
                    }
                    
                    if masterEngTF.text!.isEmpty || masterStartYearLabel.text!.isEmpty {
                        nextButton.isEnabled = false
                        return
                    }
                    
                    if HSGHRegisterNetModel.singleInstance().masterUniv.univStatus == univStatusOnline {
                        nextButton.isEnabled = true
                    }
                    else {
                        nextButton.isEnabled = !masterEndYearLabel.text!.isEmpty
                    }
                }
                else {
                    nextButton.isEnabled = !regularEndYearLabel.text!.isEmpty
                }
                break
                
            default:
                break;
            }
        }
        else {
            if highSchoolName.text!.isEmpty || highSchoolStartYear.text!.isEmpty {
                nextButton.isEnabled = false
                return
            }
            nextButton.isEnabled = true
        }
    }
    
}

//Show popover view
extension HSGHRegSchoolInfosVC {
    
    func pickDate() -> Array<PopoverAction> {
        return pickRangeDate(yearMin, yearMax)
    }
    
    func pickRangeDate(_ start: Int, _ end: Int) -> Array<PopoverAction> {
        var retArray: Array<PopoverAction> = Array<PopoverAction>()
        let fixStart = start > 2017 ? 2017 : start
        var fixEnd = end > 2017 ? 2017 : end
        
        if fixEnd < fixStart {
            fixEnd = fixStart
        }
        
        for v in fixStart ... fixEnd {
            let action : PopoverAction = PopoverAction(title: String(v), handler: {[weak self] (action) in
                self?.currentYearLabel?.text = action?.title
                self?.checkStatus()
            })
            retArray.append(action)
        }
        return retArray
    }
    
    func showPopView(view: UIView, _ isHighSchool: Bool = false) {
        let popView = PopoverView()
        var startYear = isHighSchool ? 2013 : self.yearMin
        var endYear = isHighSchool ? 2017 :self.yearMax
        if (!isHighSchoolMode) {
            switch currentYearLabel! {
            case regularStartYearLabel:
                if let text = self.regularEndYearLabel.text, !text.isEmpty {
                    endYear = Int(text)!
                }
                
                if let text2 = self.masterStartYearLabel.text, !text2.isEmpty {
                    if Int(text2)! < endYear {
                        endYear = Int(text2)!
                    }
                }
                
            case regularEndYearLabel:
                if let text = self.regularStartYearLabel.text, !text.isEmpty {
                    startYear = Int(text)!
                }
                
                if let text2 = self.masterStartYearLabel.text, !text2.isEmpty {
                    if Int(text2)! < endYear {
                        endYear = Int(text2)!
                    }
                }
                
            case masterStartYearLabel:
                if let text = self.masterEndYearLabel.text, !text.isEmpty {
                    endYear = Int(text)!
                }
                
                if let text2 = self.regularEndYearLabel.text, !text2.isEmpty {
                    if Int(text2)! > startYear {
                        startYear = Int(text2)!
                    }
                }
                else {
                    if let text2 = self.regularStartYearLabel.text, !text2.isEmpty {
                        if Int(text2)! > startYear {
                            startYear = Int(text2)!
                        }
                    }
                }
                
            case masterEndYearLabel:
                if let text = self.masterStartYearLabel.text, !text.isEmpty {
                    startYear = Int(text)!
                }
                
            default:
                break
                
            }
        }
        
        popView.show(to: view, with: pickRangeDate(startYear, endYear))
    }
    
    
}
