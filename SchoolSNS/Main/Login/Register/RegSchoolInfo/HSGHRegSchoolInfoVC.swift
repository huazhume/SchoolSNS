//
//  MyViewController.swift
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copyright © 2017 FlyingPuPu. All rights reserved.
//

import UIKit

public class HSGHRegSchoolInfoVC: HSGHBaseViewController {
    @IBOutlet weak var rightBar: UIBarButtonItem!
    @IBOutlet weak var engTextFiled: UITextField!
    @IBOutlet weak var regularStartYearLabel: UILabel!
    @IBOutlet weak var regularEndYearLabel: UILabel!
    @IBOutlet weak var regularEndYearLine: UIView!
    @IBOutlet weak var regularEndYearTitle: UILabel!
    @IBOutlet weak var regularEndYearButton: AnimatableButton!

    @IBOutlet weak var masterTitle: UILabel!
    @IBOutlet weak var masterWholeView: UIView!
    @IBOutlet weak var nowcheck: AnimatableButton!
    
    @IBOutlet weak var hadCheck: AnimatableButton!
    //Master
    @IBOutlet weak var masterSwitchLine: UIView!

    @IBOutlet weak var switchMaster: UISwitch!

    @IBOutlet weak var masterEndYearLabel: UILabel!
    @IBOutlet weak var masterEndYearTitle: UILabel!
    @IBOutlet weak var masterEndYearButton: AnimatableButton!
    @IBOutlet weak var masterEndYearLine: UIView!
    
    @IBOutlet weak var masterStartYearLabel: UILabel!
    @IBOutlet weak var masterEngTF: UITextField!

    @IBOutlet weak var nowMasterCheck: AnimatableButton!
    
    @IBOutlet weak var hadMasterCheck: AnimatableButton!
    
    //High school
    
    @IBOutlet weak var highSchoolWholeView: UIView!
    @IBOutlet weak var highSchoolName: UITextField!
    @IBOutlet weak var highSchoolNameButton: UIButton!
    
    @IBOutlet weak var highSchoolStartYear: UILabel!
    var isHighSchoolMode = false
    
    var currentYearLabel: UILabel? = nil
    var currentTF: UITextField? = nil

    let yearMin = 2000
    let yearMax = 2017
    
    let univStatusOnline = 2
    let univStatusGraduation = 3
    
    public var isEditingModel = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        setupDefault()
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupDefault() {
        switchMaster.onTintColor = UIColor(hexString: "3987d0")
        nowcheck.setImage(UIImage(named: "reg_check_normal"), for: .normal)
        nowcheck.setImage(UIImage(named: "reg_checked"), for: .selected)
        hadCheck.setImage(UIImage(named: "reg_check_normal"), for: .normal)
        hadCheck.setImage(UIImage(named: "reg_checked"), for: .selected)

        nowMasterCheck.setImage(UIImage(named: "reg_check_normal"), for: .normal)
        nowMasterCheck.setImage(UIImage(named: "reg_checked"), for: .selected)
        hadMasterCheck.setImage(UIImage(named: "reg_check_normal"), for: .normal)
        hadMasterCheck.setImage(UIImage(named: "reg_checked"), for: .selected)

        nowcheck.isSelected = true

        nowMasterCheck.isSelected = true

        rightBar.isEnabled = false
        
        showOrHiddenEndYear(true)
        showOrHiddenMasterTitle(true)
        showOrHiddenMasterEndYear(true)
        highSchoolWholeView.isHidden = true

        //Keyboard
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
        engTextFiled.delegate = self
        masterEngTF.delegate = self

        switchMaster.addTarget(self, action: #selector(switchOnOff), for: .valueChanged)


        //show univ
        
        engTextFiled.isEnabled = false
        masterEngTF.isEnabled = false
        
        //High school
        highSchoolName.delegate = self
        highSchoolNameButton.isHidden = false
        
        if isEditingModel {
            title = "编辑"
            rightBar.title = "确定"
            updateEditInfo()
        }
    }
    
    func updateEditInfo() {
        //Restore info
        engTextFiled.text = HSGHUserInf.shareManager().bachelorUniv.name
        regularStartYearLabel.text = HSGHUserInf.shareManager().bachelorUniv.convertToStartYear()
        if HSGHUserInf.shareManager().bachelorUniv.univStatus == univStatusOnline {
            clickNowRegularButton(UIButton())
        } else {
            clickHadRegularButton(UIButton())
            regularEndYearLabel.text = HSGHUserInf.shareManager().bachelorUniv.convertToEndYear()
            
            if !HSGHUserInf.shareManager().masterUniv.name.isEmpty {
                switchMaster.setOn(true, animated: false)
                masterEngTF.text = HSGHUserInf.shareManager().masterUniv.name
                masterStartYearLabel.text = HSGHUserInf.shareManager().masterUniv.convertToStartYear()
                if HSGHUserInf.shareManager().masterUniv.univStatus == univStatusOnline {
                    clickNowMasterButton(UIButton())
                } else {
                    clickHadMasterButton(UIButton())
                    masterEndYearLabel.text = HSGHUserInf.shareManager().masterUniv.convertToEndYear()
                }
            }
            else {
                switchMaster.isOn = false
            }
        }
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

    func switchOnOff() {
        masterWholeView.isHidden = !switchMaster.isOn
        checkStatus()
    }
    
    @IBAction func clickNowRegularButton(_ sender: Any) {
        nowcheck.isSelected = true
        hadCheck.isSelected = false
        HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus = 0
        
        showOrHiddenEndYear(true)
        showOrHiddenMasterTitle(true)
    
        checkStatus()
    }
    
    @IBAction func clickHadRegularButton(_ sender: Any) {
        nowcheck.isSelected = false
        hadCheck.isSelected = true
        HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus = 2
        
        showOrHiddenEndYear(false)
        showOrHiddenMasterTitle(false)
        
        checkStatus()
    }

    @IBAction func clickStartYear(_ sender: Any) {
        currentYearLabel = regularStartYearLabel
        self.showPopView(view: sender as! UIView)
    }

    @IBAction func clickEndYear(_ sender: Any) {
        currentYearLabel = regularEndYearLabel
        self.showPopView(view: sender as! UIView)
 
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
        HSGHRegisterNetModel.singleInstance().masterUniv.univStatus = 0
        
        showOrHiddenMasterEndYear(true)
        
        checkStatus()
    }
    
    @IBAction func clickHadMasterButton(_ sender: Any) {
        nowMasterCheck.isSelected = false
        hadMasterCheck.isSelected = true
        HSGHRegisterNetModel.singleInstance().masterUniv.univStatus = 2
        
        showOrHiddenMasterEndYear(false)
        
        checkStatus()
    }
    
    // MARK: - High School
    
    @IBAction func switchToHighSchool(_ sender: Any) {
        isHighSchoolMode = !isHighSchoolMode
        highSchoolWholeView.isHidden = !isHighSchoolMode
        view.bringSubview(toFront: highSchoolWholeView)
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
        }
        else {
            HSGHRegisterNetModel.singleInstance().bachelorUniv.univIn = regularStartYearLabel.text! + "-09-01T05:47:54.726Z"
            if (regularEndYearLabel.text?.lengthOfBytes(using: .utf8) != 0) {
                HSGHRegisterNetModel.singleInstance().bachelorUniv.univOut = regularEndYearLabel.text! + "-07-01T05:47:54.726Z"
            }
            
            if HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus == 2 {
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
        if isEditingModel {
            self.navigationController?.popViewController(animated: true)
            return false
        }
        
        if isHighSchoolMode , let text : String = highSchoolName.text, text.isEmpty {
            let toast = Toast(text: "内容为空，请重新输入", duration: Delay.short)
            toast.show()
            rightBar.isEnabled = false
            return false
        }
        
        return true
    }
}


extension HSGHRegSchoolInfoVC: UITextFieldDelegate {
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
extension HSGHRegSchoolInfoVC {
    func showOrHiddenEndYear(_ hidden: Bool) {
        regularEndYearLabel.isHidden = hidden
        regularEndYearLine.isHidden = hidden
        regularEndYearTitle.isHidden = hidden
        regularEndYearButton.isHidden = hidden
    }
    
    func showOrHiddenMasterEndYear(_ hidden: Bool) {
        masterEndYearLabel.isHidden = hidden
        masterEndYearLine.isHidden = hidden
        masterEndYearTitle.isHidden = hidden
        masterEndYearButton.isHidden = hidden
    }
    
    func showOrHiddenMasterTitle(_ hidden: Bool) {
        masterTitle.isHidden = hidden
        masterSwitchLine.isHidden = hidden
        switchMaster.isHidden = hidden
        masterWholeView.isHidden = hidden
    }
    
    
    func checkStatus() {
        if !isHighSchoolMode {
            if engTextFiled.text!.isEmpty || regularStartYearLabel.text!.isEmpty {
                rightBar.isEnabled = false
                return
            }
            
            switch HSGHRegisterNetModel.singleInstance().bachelorUniv.univStatus {
            case 0,1:
                rightBar.isEnabled = true
                return
                
            case 2:
                if !switchMaster.isOn {
                    rightBar.isEnabled = true
                    return
                }
                
                if masterEngTF.text!.isEmpty || masterStartYearLabel.text!.isEmpty {
                    rightBar.isEnabled = false
                    return
                }
                
                if (HSGHRegisterNetModel.singleInstance().masterUniv.univStatus == 0 ||
                    HSGHRegisterNetModel.singleInstance().masterUniv.univStatus == 1) {
                    rightBar.isEnabled = true
                }
                else {
                    rightBar.isEnabled = !regularEndYearLabel.text!.isEmpty
                }
                break
                
            default:
                break;
            }
        }
        else {
            if highSchoolName.text!.isEmpty || highSchoolStartYear.text!.isEmpty {
                rightBar.isEnabled = false
                return
            }
            rightBar.isEnabled = true
        }
    }
    
}

//Show popover view
extension HSGHRegSchoolInfoVC {
    
    func pickDate() -> Array<PopoverAction> {
        return pickRangeDate(yearMin, yearMax)
    }
    
    func pickRangeDate(_ start: Int, _ end: Int) -> Array<PopoverAction> {
        var retArray: Array<PopoverAction> = Array<PopoverAction>()
        for v in start ... end {
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
                
            case regularEndYearLabel:
                if let text = self.regularStartYearLabel.text, !text.isEmpty {
                    startYear = Int(text)!
                }
                
            case masterStartYearLabel:
                if let text = self.masterEndYearLabel.text, !text.isEmpty {
                    endYear = Int(text)!
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
