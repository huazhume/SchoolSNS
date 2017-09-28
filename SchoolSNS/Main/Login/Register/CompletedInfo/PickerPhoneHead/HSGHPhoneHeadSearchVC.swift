//
//  ViewController.swift
//  CustomSearchBar
//
//  Created by Gabriel Theodoropoulos on 8/9/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

public class PhoneHeadInfo {
    var name: String = ""
    var phone: String = ""
    
    //drop + prefix
    public func dropFirst() -> String {
        return String(phone.substring(from: phone.index(phone.startIndex, offsetBy: 1)))
    }
}


public class HSGHPhoneHeadSearchVC: HSGHHomeBaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate {
    
    @IBOutlet weak var tblSearchResults: UITableView!
    
    
    var dataArray : [PhoneHeadInfo]? = []
    var dataDic : [String : [PhoneHeadInfo]] = [:]
    
    var filteredArray : [PhoneHeadInfo]? = nil
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    public var returnBlock: ((_ selected: PhoneHeadInfo?)->Void)? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        loadLists()
        
        self.title = "选择"
        
        self.addLeftNavigationBarBtn(with: "取消")
        
        // Uncomment the following line to enable the default search controller.
        configureSearchController()
        
        // Comment out the next line to disable the customized search controller and search bar and use the default ones. Also, uncomment the above line.
        //        configureCustomSearchController()
    }
    
    deinit {
        tblSearchResults?.delegate = nil
        tblSearchResults?.dataSource = nil
    }
    
    public override func leftBarItemBtnClicked(_ btn: UIButton!) {
        if let returnBlock = returnBlock {
            returnBlock(nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowSearchResults {
            if let filteredArray = filteredArray, let returnBlock = returnBlock {
                returnBlock(filteredArray[indexPath.row])
            }
            self.dismiss(animated: true, completion: nil)
        }
        else {
            if let dataArray = dataArray, let returnBlock = returnBlock {
                returnBlock(dataArray[indexPath.row])
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            if let filteredArray = filteredArray {
                return filteredArray.count
            }
            else {
                return 0
            }
        }
        else {
            if let dataArray = dataArray {
                return dataArray.count
            }
            else {
                return 0
            }
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        if shouldShowSearchResults {
            if let filteredArray = filteredArray {
                cell.textLabel?.text = filteredArray[indexPath.row].name + "(" + filteredArray[indexPath.row].phone + ")"
            }
        }
        else {
            if let dataArray = dataArray {
                cell.textLabel?.text = dataArray[indexPath.row].name + "(" + dataArray[indexPath.row].phone + ")"
            }
        }
        
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    // MARK: Custom functions
    
    func loadLists() {
        let filePath = Bundle.main.path(forResource: "PhoneHead.plist", ofType: nil)
        let wholeArray = NSArray(contentsOfFile: filePath ?? "") as? [[[String]]]
        
        if let wholeArray = wholeArray {
            for subArray in wholeArray {
                //Add into search dic
                if let first = subArray.first {
                    let pinyin = first[0].chineseToPinyin()
                    let firstChar = String(pinyin[pinyin.startIndex]).uppercased()
                    dataDic[firstChar] = []
                    
                    for data in subArray {
                        let info = PhoneHeadInfo()
                        info.name = data[0]
                        info.phone = data[1]
                        dataArray?.append(info)
                        dataDic[firstChar]?.append(info)
                    }
                }
            }
        }
        
        tblSearchResults.reloadData()
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        for subView in searchController.searchBar.subviews {
            for view in subView.subviews {
                if view.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                    let imageView = view as! UIImageView
                    imageView.removeFromSuperview()
                }
            }
        }
        
        // Place the search bar view to the tableview headerview.
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: tblSearchResults.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orange, searchBarTintColor: UIColor.black)
        
        customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
    }
    
    
    // MARK: UISearchBarDelegate functions
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        filteredArray?.removeAll()
        getSearchResultArray(searchBarText:searchString)
        tblSearchResults.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func didChangeSearchText(_ searchText: String) {
        filteredArray?.removeAll()
        getSearchResultArray(searchBarText:searchText)
        tblSearchResults.reloadData()
    }
}

//For pinyin search
extension HSGHPhoneHeadSearchVC {
    fileprivate func getSearchResultArray(searchBarText: String) {
        if searchBarText == "" {
            self.filteredArray = self.dataArray
            self.tblSearchResults.reloadData()
            return
        }
        
        // 中文搜索
        if searchBarText.isIncludeChineseIn() {
            // 转拼音
            let pinyin = searchBarText.chineseToPinyin()
            // 获取大写首字母
            let first = String(pinyin[pinyin.startIndex]).uppercased()
            
            guard let dic = self.dataDic[first] else {
                return
            }
            
            for data in dic {
                if data.name.hasPrefix(searchBarText) {
                    self.filteredArray?.append(data)
                }
            }
        }else {
            // 拼音搜索
            // 若字符个数为1
            if searchBarText.characters.count == 1 {
                guard let dic = self.dataDic[searchBarText.uppercased()] else {
                    return
                }
                self.filteredArray = dic
            }else {
                guard let dic = self.dataDic[searchBarText.first().uppercased()] else {
                    return
                }
                for data in dic {
                    // 去空格
                    let py = String(data.name.chineseToPinyin().characters.filter({ $0 != " "}))
                    let range = py.range(of: searchBarText)
                    if range != nil {
                        self.filteredArray?.append(data)
                    }
                }
                // 加入首字母判断 如 cq => 重庆 bj => 北京
                if self.filteredArray?.count == 0 {
                    for data in dic {
                        // 北京 => bei jing
                        let pinyin = data.name.chineseToPinyin()
                        // 获取空格的index
                        let a = pinyin.characters.index(of: " ")
                        let index = pinyin.index(a!, offsetBy: 2)
                        // offsetBy: 2 截取 bei j
                        // offsetBy: 1 截取 bei+空格
                        // substring(to: index) 不包含 index最后那个下标
                        let py = pinyin.substring(to: index)
                        /// 获取第二个首字母
                        ///
                        ///     py = "bei j"
                        ///     last = "j"
                        ///
                        let last = py.substring(from: py.index(py.endIndex, offsetBy: -1))
                        /// 两个首字母
                        let pyIndex = String(pinyin[pinyin.startIndex]) + last
                        
                        if searchBarText.lowercased() == pyIndex {
                            self.filteredArray?.append(data)
                        }
                    }
                }
            }
        }
    }
}

extension String {
    // MARK: 汉字 -> 拼音
    func chineseToPinyin() -> String {
        
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        
        return pinyin
    }
    
    // MARK: 判断是否含有中文
    func isIncludeChineseIn() -> Bool {
        
        for (_, value) in self.characters.enumerated() {
            
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        
        return false
    }
    
    // MARK: 获取第一个字符
    func first() -> String {
        let index = self.index(self.startIndex, offsetBy: 1)
        return self.substring(to: index)
    }
    
}

