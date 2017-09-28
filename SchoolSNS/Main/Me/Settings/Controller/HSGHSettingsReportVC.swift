//
//  HSGHSettingsReportVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 14/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation


class HSGHSettingsReportVC: HSGHHomeBaseViewController {
    
    @IBOutlet weak var spaceCons1: NSLayoutConstraint!
    
    @IBOutlet weak var spaceCons2: NSLayoutConstraint!
    
    @IBOutlet weak var spaceCons3: NSLayoutConstraint!
    @IBOutlet weak var spaceCons4: NSLayoutConstraint!
    
    @IBOutlet weak var firstButton: AnimatableButton!
    
    @IBOutlet weak var secondButton: AnimatableButton!
    
    @IBOutlet weak var fourButton: AnimatableButton!
    @IBOutlet weak var thirdButton: AnimatableButton!
    @IBOutlet weak var contentTextView: AnimatableTextView!
    @IBOutlet weak var pushButton: UIButton!
    
    @IBOutlet var collectionsButton: [AnimatableButton]!
    var type = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我要反馈"
        setDefault()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addTapHiddenKeyboard()
        contentTextView.delegate = self
        contentTextView.returnKeyType = .done
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        contentTextView?.delegate = nil
    }
    
    
    func setDefault()  {
        let cons = (view.width - 37.5 * 4) / 5
        spaceCons1.constant = cons
        spaceCons2.constant = cons
        spaceCons3.constant = cons
        spaceCons4.constant = cons
        
        firstButton.tag = 1
        secondButton.tag = 2
        thirdButton.tag = 3
        fourButton.tag = 1000
        type = 1
        
        for button in collectionsButton {
            button.setTitleColor(UIColor(hexString: "A7A7A7"), for: .normal)
            button.setTitleColor(UIColor(hexString: "272727"), for: .selected)
        }
        
        pushButton.backgroundColor = UIColor(hexString: "2d2f3a")
    }
    
    
    @IBAction func clickTypeSelect(_ sender: Any) {
        type = (sender as! AnimatableButton).tag
        updateSelectedStatus(type)
    }
    
    
    func updateSelectedStatus(_ tag: Int) {
        for button in collectionsButton {
            button.isSelected = (button.tag == tag)
            updateButtonSelectedStyle(button)
        }
    }
    
    
    func updateButtonSelectedStyle(_ button: AnimatableButton) {
        button.borderColor = button.isSelected ? UIColor(hexString: "272727") : UIColor(hexString: "A7A7A7")
    }
    
    
    @IBAction func sendReport(_ sender: Any) {
        if contentTextView.text.isEmpty {
            let toast = Toast(text: "再输入一点内容吧", duration: Delay.short)
            toast.show()
            return
        }
        
        HSGHSettingsModel.suggest(contentTextView.text, type: UInt(type)) { ret in
            if ret {
                let popup = PopupDialog(title: nil, message: "感谢您的宝贵建议，谢谢！", buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true) {
                }
                
                let buttonTwo = DefaultButton(title: "确定") {
                    self.navigationController?.popViewController(animated: true)
                }
                popup.addButtons([buttonTwo])
                self.navigationController?.present(popup, animated: true, completion: nil)
            }
            else {
                let toast = Toast(text: "出了一点小问题，请稍后再试吧！", duration: Delay.short)
                toast.show()
            }
        }
        
    }
}


extension HSGHSettingsReportVC : UITextViewDelegate {
    //MARK: -- keyboard
    //键盘的出现
    func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        //        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
        //        let changeY = kbRect.origin.y - UIScreen.main.bounds.size.height
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.view.top = -100;
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            restoreKeyboard()
            return false
        }
        return true
    }
    
    
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        let kbInfo = notification.userInfo
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            self.view.top = 0
        }
    }
    
    func restoreKeyboard() {
        self.view.endEditing(true)
    }
    
    func addTapHiddenKeyboard() {
        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restoreKeyboard))
        self.view.addGestureRecognizer(tapGes)
    }
}
