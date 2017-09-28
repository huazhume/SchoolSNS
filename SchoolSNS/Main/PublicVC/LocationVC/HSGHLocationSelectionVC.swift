//
//  HSGHLocationSelectionVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 17/05/2017.
//  Copyright (c) 2017 Facebook. All rights reserved.
//

import Foundation
import UIKit

public class HSGHLocationSelectionVC: HSGHHomeBaseViewController, UITableViewDataSource, UITableViewDelegate {
    var _tableView: UITableView? = nil
    var _dataArray: NSMutableArray = []
    var _currentData: HSGHPOIInfo?
    var _isAllowed: Bool = false
    var _isChina: Bool = true
    var _selectedRow: Int = 0
    public var setPosition: String = ""
    
    //小菊花
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    //选择一行数据后
    public var selectedData: ((_ position: HSGHPOIInfo?, _ isAllowed: Bool) -> Void)?

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName: String?, bundle: Bundle?) {
        selectedData = nil
        _currentData = nil
        super.init(nibName: nibName, bundle: bundle)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "所在位置"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定",
//                                                            style: .done,
//                                                            target: self,
//                                                            action:#selector(HSGHLocationSelectionVC.rightBarClicked))
//        self.navigationItem.rightBarButtonItem!.tintColor = UIColor(hexString: "3897f0")
        //self.addRightNavigationBarBtn(with: "确定")
        //self.addRightNavigationBarBtn(with: "跳过")
        self.addRightNavigationBarBtn(with: "发布")
        
        view.backgroundColor = .white
        _tableView = UITableView(frame:CGRect(x:0, y:HSGH_NAVGATION_HEIGHT, width:view.bounds.width, height: view.bounds.height - HSGH_NAVGATION_HEIGHT), style: .plain)
        _tableView?.delegate = self
        _tableView?.dataSource = self
        _tableView?.rowHeight = 50.0
        _tableView?.separatorStyle = .none
        view.addSubview(_tableView!)
        _tableView!.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.getPOISuccess),name: NSNotification.Name(rawValue: kAMapSearchAPIPOISuccess), object: nil)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        //数据
        if (_dataArray.count == 0){
            appendFirstData()
            _tableView!.reloadData()
            self.playActivityIndicator()
            if _isChina {//外国
                GMSPlacesClient.shared().currentPlace(callback: { (placeLikelihoodList, error) -> Void in
                    if let error = error {
                        print("Pick Place error: \(error.localizedDescription)")
                        return
                    }
                    
                    var rstMarr : [HSGHPOIInfo] = []
//                    let fstData: HSGHPOIInfo = HSGHPOIInfo()
//                    fstData.name = "不显示位置"
//                    fstData.subName = ""
//                    rstMarr.append(fstData)
                    
                    if let placeLikelihoodList = placeLikelihoodList {
                        for likelihood in placeLikelihoodList.likelihoods {
                            let place = likelihood.place
                            let poi = HSGHPOIInfo()
                            
                            poi.name = place.name
                            poi.subName = place.formattedAddress! //中国湖北省武汉市洪山区沿湖路121号 邮政编码: 430071
                            poi.subName = poi.subName.components(separatedBy: " ").first!
                            poi.latitude = place.coordinate.latitude;
                            poi.longitude = place.coordinate.longitude;
                            rstMarr.append(poi)
                        }
                    }
                    
                    self.stopActivityIndicator()
                    
                    self._dataArray.addObjects(from: rstMarr)
                    self._tableView!.reloadData()
                })
                
            } else {
             //   appendFirstData() //不显示位置 下面这回掉一辈子也不会执行
                HSGHLocationManager.shared().fetchPOIInfo { [weak self] data in
                    if let data = data {
                        self!._dataArray.addObjects(from: data)
                        self!._tableView!.reloadData()
                    }
                }
            }
        } else {
            appendFirstData()
            _tableView!.reloadData()
        }
        
    }
    
    //MARK: notification 这个才是高德地图的回掉
    func getPOISuccess(notification: NSNotification) {
        self.stopActivityIndicator()
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        _dataArray.addObjects(from: (userInfo["poiArr"] as! NSArray) as! [Any])
        self._tableView!.reloadData()
    }
    
    public override func rightBarItemBtnClicked(_ btn: UIButton!) {
        print("---rightBarItemBtnClicked---发布---")
        //rightBarClicked()
        
        self.dismiss(animated: true)
        NotificationCenter.default.post(name:NSNotification.Name(rawValue:"PUBLISH_MSG_NOTIFI"), object: nil, userInfo: nil)
    }
    

    override open func leftBarItemBtnClicked(_ btn: UIButton!) {
        self.dismiss(animated: true)
    }
  
    func rightBarClicked() {//点击跳过
        if let selected = selectedData {
            //selected(_currentData, true)
            selected(nil, true)
        }
        self.dismiss(animated: true)
    }

    func appendFirstData() {
        let data: HSGHPOIInfo = HSGHPOIInfo()
        data.name = "不显示位置"
        data.subName = ""
        _dataArray.insert(data, at: 0)

        if !setPosition.isEmpty {
            let data: HSGHPOIInfo = HSGHPOIInfo()
            data.name = setPosition
            data.subName = ""
            _dataArray.add(data)
            _selectedRow = 1;
        }
    }
    
    //菊花转动开始
    func playActivityIndicator() {
        self.view.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //菊花转动结束
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    //MARK: delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let data = _dataArray[indexPath.row] as! HSGHPOIInfo
        cell.updateInfo(data.name, subName: data.subName)
        if (indexPath.row == 0) {
            cell.firstLocationName.textColor = UIColor(hexString: "7898D5")
        }
        else {
            cell.firstLocationName.textColor = UIColor(hexString: "272829")
        }

        cell.setSelected(indexPath.row == _selectedRow, animated: false)

        return cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _isAllowed = indexPath.row != 0
        _selectedRow = indexPath.row
        _currentData = _dataArray[indexPath.row] as? HSGHPOIInfo
        
        if let selected = selectedData {
            selected(_currentData, true)
        }
        
        //self.dismiss(animated: true)
    }
}
