//
//  HSGHSettingsSwiftVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 26/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

struct StatusInfo {
    var name : String
    var status : Bool
    var showSwitch: Bool
}

struct SectionHeadInfo {
    var isExtended: Bool
    var name : String
    var imagePath : String
    var cellCount: Int
    var footHeight: CGFloat
    var headHeight: CGFloat
}

class HSGHSettingsSwiftVC : HSGHHomeBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var showAllFunc : Bool = false    //temp to hidden
    var privacyStatusArray = [StatusInfo]()
    var notifiStatusArray = [StatusInfo]()
    var headInfoArray = [SectionHeadInfo]()
    
    var tableView : UITableView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = true
        refreshNameStatus()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateConfig()
    }
    
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        title = "设置"

        tableView = UITableView(frame: CGRect(x: 0, y: HSGH_NAVGATION_HEIGHT, width: view.width, height: view.height - HSGH_NAVGATION_HEIGHT), style: .grouped)
        if let tableView = tableView {
            view.addSubview(tableView)
        }
        
        view.backgroundColor = UIColor.white
        tableView?.backgroundColor = UIColor(hexString: "efefef")//UIColor.white
        setupModel()
        
        tableView?.register(UINib(nibName: "SettingsHeadCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SettingsHeadCell")
        tableView?.register(UINib(nibName: "HSGHSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "HSGHSettingTableViewCell")
        tableView?.register(UINib(nibName: "HSGHSettingsEndCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "HSGHSettingsEndCell")
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func refreshNameStatus() {
        if HSGHUserInf.hasEngName() {
            privacyStatusArray[showAllFunc ? 1 : 0] = StatusInfo(name: "显示英文名", status: (HSGHUserInf.shareManager().displayNameMode == 2), showSwitch: true)
        }
        else {
            privacyStatusArray[showAllFunc ? 1 : 0] = StatusInfo(name: "添加英文名", status: HSGHUserInf.shareManager().searchByName, showSwitch: false)
        }
        tableView?.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    
    deinit {
//        updateConfig()
    }
    
    func isChangePrivate() -> Bool {
        if showAllFunc {
            if HSGHUserInf.shareManager().showQQianStranger != privacyStatusArray[0].status {
                return true
            }
            
            if HSGHUserInf.shareManager().searchByName != privacyStatusArray[2].status {
                return true
            }
            
            if HSGHUserInf.shareManager().showQQianAlumni != privacyStatusArray[3].status {
                return true
            }
            
            if HSGHUserInf.shareManager().showUniv != privacyStatusArray[4].status {
                return true
            }
            
            if HSGHUserInf.hasEngName() {
                let status = privacyStatusArray[1].status ? 2 : 1
                if HSGHUserInf.shareManager().displayNameMode != status {
                    return true
                }
            }
        }
        else {
            if HSGHUserInf.shareManager().searchByName != privacyStatusArray[1].status {
                return true
            }
            
//            if HSGHUserInf.shareManager().showUniv != privacyStatusArray[2].status {
//                return true
//            }
            
            if HSGHUserInf.hasEngName() {
                let status = privacyStatusArray[0].status ? 2 : 1
                if HSGHUserInf.shareManager().displayNameMode != status {
                    return true
                }
            }
        }

        
        return false
    }
    
    func isChangeNotification() -> Bool {
        if HSGHUserInf.shareManager().notifyReply != notifiStatusArray[0].status {
            return true
        }
        
        if HSGHUserInf.shareManager().notifyAt != notifiStatusArray[1].status {
            return true
        }
        
        if HSGHUserInf.shareManager().notifyUp != notifiStatusArray[2].status {
            return true
        }
        
        if HSGHUserInf.shareManager().notifyApply != notifiStatusArray[3].status {
            return true
        }
        
        if HSGHUserInf.shareManager().notifyAgree != notifiStatusArray[4].status {
            return true
        }
        return false
    }
    
    
    //UpdateInfo
    func updateConfig() {
        if isChangeNotification() {
            HSGHSettingsModel.modifyNotification(notifiStatusArray[4].status, apply: notifiStatusArray[3].status, at: notifiStatusArray[1].status, reply: notifiStatusArray[0].status, up: notifiStatusArray[2].status) { (ret, errDes) in
                if (ret) {
                    let toast = Toast(text: "更新通知设置成功!", duration: Delay.short)
                    toast.show()
                }
                else {
                    let toast = Toast(text: "更新设置失败，请稍后再重试!", duration: Delay.short)
                    toast.show()
                }
            }
        }
        
        if isChangePrivate() {
            if showAllFunc {
                let status: UInt = privacyStatusArray[1].status ? 2 : 1
                HSGHUserInf.updateDisplayMode(!privacyStatusArray[1].status)
                HSGHSettingsModel.modifyPrivacy(privacyStatusArray[3].status, showQQianStranger: privacyStatusArray[0].status, searchByName: privacyStatusArray[2].status,showUniv: privacyStatusArray[4].status, displayMode: status) { (ret, errDes) in
                                                    if (ret) {
    //                                                    let toast = Toast(text: "更新隐私设置成功!", duration: Delay.short)
    //                                                    toast.show()
                                                        }
                                                    else {
                                                        let toast = Toast(text: "更新设置失败，请稍后再重试!", duration: Delay.short)
                                                        toast.show()
                                                    }
                }
            }
            else {
                let status: UInt = privacyStatusArray[0].status ? 2 : 1
                HSGHUserInf.updateDisplayMode(!privacyStatusArray[0].status)
                HSGHSettingsModel.modifyPrivacy(false, showQQianStranger: false, searchByName: privacyStatusArray[1].status,showUniv: true, displayMode: status) { (ret, errDes) in
                    if (ret) {

                    }
                    else {
                        let toast = Toast(text: "更新设置失败，请稍后再重试!", duration: Delay.short)
                        toast.show()
                    }
                }
            }
        }
    }
    
    //MARK: dataModel
    func setupModel() {
        //Privacy
        if showAllFunc {
            privacyStatusArray.append(StatusInfo(name: "对陌生人开放主页新鲜事", status: HSGHUserInf.shareManager().showQQianStranger, showSwitch: true))
        }
        
        if HSGHUserInf.hasEngName() {
            privacyStatusArray.append(StatusInfo(name: "显示英文名", status: (HSGHUserInf.shareManager().displayNameMode == 2), showSwitch: true))
        }
        else {
            privacyStatusArray.append(StatusInfo(name: "添加英文名", status: HSGHUserInf.shareManager().searchByName, showSwitch: false))
        }
        
        privacyStatusArray.append(StatusInfo(name: "允许被实名搜索到", status: HSGHUserInf.shareManager().searchByName, showSwitch: true))
        privacyStatusArray.append(StatusInfo(name: "修改中文名", status: HSGHUserInf.shareManager().showUniv, showSwitch: false))

        if showAllFunc {
            privacyStatusArray.append(StatusInfo(name: "对校友隐身", status: HSGHUserInf.shareManager().showQQianAlumni, showSwitch: true))
            privacyStatusArray.append(StatusInfo(name: "显示第一海外学历信息于新鲜事", status: HSGHUserInf.shareManager().showUniv, showSwitch: true))
        }
        
        //Notification
        notifiStatusArray.append(StatusInfo(name: "评论提醒", status: HSGHUserInf.shareManager().notifyReply, showSwitch: true))
        notifiStatusArray.append(StatusInfo(name: "被@提醒", status: HSGHUserInf.shareManager().notifyAt, showSwitch: true))
        notifiStatusArray.append(StatusInfo(name: "点赞提醒", status: HSGHUserInf.shareManager().notifyUp, showSwitch: true))
        notifiStatusArray.append(StatusInfo(name: "被申请加好友", status: HSGHUserInf.shareManager().notifyApply, showSwitch: true))
        notifiStatusArray.append(StatusInfo(name: "申请好友被通过", status: HSGHUserInf.shareManager().notifyAgree, showSwitch: true))
        
        //section head info
        headInfoArray.append(SectionHeadInfo(isExtended: false, name: "隐私",  imagePath: "settings_privaty", cellCount: 3, footHeight: 5, headHeight: 50))
        headInfoArray.append(SectionHeadInfo(isExtended: false, name: "通知",  imagePath: "settings_notification", cellCount: notifiStatusArray.count,footHeight: 5, headHeight: 50))
        headInfoArray.append(SectionHeadInfo(isExtended: false, name: "安全",  imagePath: "settings_security", cellCount: 0, footHeight: 5, headHeight: 50))
        headInfoArray.append(SectionHeadInfo(isExtended: false, name: "反馈",  imagePath: "settings_report", cellCount: 0, footHeight: 5, headHeight: 50))
        headInfoArray.append(SectionHeadInfo(isExtended: false, name: "关于我们",  imagePath: "settings_about", cellCount: 0, footHeight: 80, headHeight: 50))
        headInfoArray.append(SectionHeadInfo(isExtended: false, name: "退出当前账号",  imagePath: "", cellCount: 0, footHeight: 100, headHeight: 50))
    }
    
    
    //MARK: ^_^ tableViewDelegate
    //Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headInfo: SectionHeadInfo = headInfoArray[section]
        return headInfo.headHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let headInfo: SectionHeadInfo = headInfoArray[section]
        return headInfo.footHeight
    }
    
    //Cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == headInfoArray.count - 1 {
            let view: HSGHSettingsEndCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HSGHSettingsEndCell") as! HSGHSettingsEndCell
            let headInfo = headInfoArray[section]
            view.delegate = self
            view.updateInfo(headInfo.name, section)
            view.contentView.backgroundColor = UIColor.white
            return view
        }
        else {
            let view: HSGHSettingsHeadCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeadCell") as! HSGHSettingsHeadCell
            let headInfo = headInfoArray[section]
            view.delegate = self
            view.updateInfo(headInfo.imagePath, headInfo.name, section, section > 1)
            view.contentView.backgroundColor = UIColor.white
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "efefef")
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view: HSGHSettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HSGHSettingTableViewCell") as! HSGHSettingTableViewCell
        if indexPath.section == 0 {
            let cellInfo : StatusInfo = privacyStatusArray[indexPath.row]
            view.updateInfo(cellInfo.name, cellInfo.status, indexPath, cellInfo.showSwitch)
        }
        
        if indexPath.section == 1 {
            let cellInfo : StatusInfo = notifiStatusArray[indexPath.row]
            view.updateInfo(cellInfo.name, cellInfo.status, indexPath, cellInfo.showSwitch)
        }
        
        view.delegate = self
        return view
    }
    
    
    //Count
    func numberOfSections(in tableView: UITableView) -> Int {
        return headInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let headInfo = headInfoArray[section]
        return headInfo.isExtended ? headInfo.cellCount : 0
    }
}

extension HSGHSettingsSwiftVC: SettingsTableViewHeadProtocol, SettingsTableViewChangeStatus {
    func clickHead(_ section: Int) {
        switch section {
        case 0:
            var headInfo = headInfoArray[section]
            headInfo.isExtended = !headInfo.isExtended
            headInfoArray[section] = headInfo
            tableView?.reloadSections(IndexSet(integer: section), with: .automatic)
        case 1:
            if checkStatus() {
                var headInfo = headInfoArray[section]
                headInfo.isExtended = !headInfo.isExtended
                headInfoArray[section] = headInfo
                tableView?.reloadSections(IndexSet(integer: section), with: .automatic)
            }
        case 2: //safe
            let storyboard = UIStoryboard(name: "HSGHSettings", bundle: nil)
            let vc : HSGHSettingsSecurityVC = storyboard.instantiateViewController(withIdentifier: "safe") as! HSGHSettingsSecurityVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 3: //safe
            let storyboard = UIStoryboard(name: "HSGHSettings", bundle: nil)
            let vc : HSGHSettingsReportVC = storyboard.instantiateViewController(withIdentifier: "report") as! HSGHSettingsReportVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 4: //about
            let storyboard = UIStoryboard(name: "HSGHSettings", bundle: nil)
            let vc : HSGHSettingsAboutUSVC = storyboard.instantiateViewController(withIdentifier: "about") as! HSGHSettingsAboutUSVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 5: //exit
            let delegate = AppDelegate.instanceApplication()
            delegate?.enterLogin()
            HSGHUserInf.emptyUserDefault()
        default:
            break
        }
    }
    
    func changToStaus(_ status: Bool, _ indexPath: IndexPath) {
        if indexPath.section == 0 {
            var info = privacyStatusArray[indexPath.row]
            info.status = status
            privacyStatusArray[indexPath.row] = info
        }
        
        if indexPath.section == 1 {
            var info = notifiStatusArray[indexPath.row]
            info.status = status
            notifiStatusArray[indexPath.row] = info
        }  
    }
    
    func clickCell(_ indexPath: IndexPath) {
        if (indexPath.row == 2) {
            let storyboard = UIStoryboard(name: "HSGHSettings", bundle: nil)
            let vc : HSGHSettingsFixesChNameVC = storyboard.instantiateViewController(withIdentifier: "CompletedCHName") as! HSGHSettingsFixesChNameVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "HSGHSettings", bundle: nil)
            let vc : HSGHSettingsFixesEngNameVC = storyboard.instantiateViewController(withIdentifier: "fixedEng") as! HSGHSettingsFixesEngNameVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @discardableResult
    func checkStatus() -> Bool {
        if !UIApplication.shared.remoteNotificationsEnabled() {
            let alertVC = UIAlertController(title: "push访问被拒绝", message: "请在设置中允许骞骞推送通知", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }))
            self.navigationController?.present(alertVC, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}

extension UIApplication {
    func remoteNotificationsEnabled() -> Bool {
        var notificationsEnabled = false
        if let userNotificationSettings = currentUserNotificationSettings {
            notificationsEnabled = userNotificationSettings.types.contains(.alert)
        }
        return notificationsEnabled
    }
}


