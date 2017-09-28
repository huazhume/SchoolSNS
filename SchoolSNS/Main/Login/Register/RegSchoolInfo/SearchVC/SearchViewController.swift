//
//  ViewController.swift
//  CustomSearchBar
//
//  Created by Gabriel Theodoropoulos on 8/9/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

public class SearchViewController: HSGHHomeBaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate {

    @IBOutlet weak var tblSearchResults: UITableView!
    
    public var isHighSchool: Bool = false
    
    var dataArray : [UnivSingle]? = nil
    
    var filteredArray : [UnivSingle]? = nil
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    public var returnBlock: ((_ selected: UnivSingle?)->Void)? = nil
    
    
    deinit {
        tblSearchResults?.delegate = nil
        tblSearchResults?.dataSource = nil
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        loadListOfCountries()
        
        self.title = (isHighSchool ? "搜索高中" : "选择院校")
        
        self.addLeftNavigationBarBtn(with: "取消")
        
        // Uncomment the following line to enable the default search controller.
        configureSearchController()
        
        // Comment out the next line to disable the customized search controller and search bar and use the default ones. Also, uncomment the above line.
//        configureCustomSearchController()
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
//                cell.textLabel?.text = filteredArray[indexPath.row].name
//                if let url = filteredArray[indexPath.row].iconUrl {
//                    cell.imageView?.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: UIImage(named: "defaultSchoolIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
//                }
                
                for view in cell.contentView.subviews {
                    if view is UIImageView {
                        if let url = filteredArray[indexPath.row].iconUrl {
                            let imageView = view as! UIImageView
                            imageView.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: UIImage(named: "defaultSchoolIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
                        }
                        else {
                            let imageView = view as! UIImageView
                            imageView.sd_setImage(with: NSURL(string: "")! as URL, placeholderImage: UIImage(named: "defaultSchoolIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
                        }
                    }
                    
                    if view is UILabel {
                        let label = view as! UILabel
                        label.text = filteredArray[indexPath.row].name
                    }
                }
            }
        }
        else {
            if let dataArray = dataArray {
                for view in cell.contentView.subviews {
                    if view is UIImageView {
                        if let url = dataArray[indexPath.row].iconUrl {
                            let imageView = view as! UIImageView
                            imageView.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: UIImage(named: "defaultSchoolIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
                        }
                        else {
                            let imageView = view as! UIImageView
                            imageView.sd_setImage(with: NSURL(string: "")! as URL, placeholderImage: UIImage(named: "defaultSchoolIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates)
                        }
                    }
                    
                    if view is UILabel {
                        let label = view as! UILabel
                        label.text = dataArray[indexPath.row].name
                    }
                }
                
//                cell.textLabel?.text = dataArray[indexPath.row].name
//                if let url = dataArray[indexPath.row].iconUrl {
//                    cell.imageView?.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: UIImage(named: "defaultSchoolIcon"), options: SDWebImageOptions.allowInvalidSSLCertificates)

//                }
            }
        }
        
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    // MARK: Custom functions
    
    func loadListOfCountries() {
        HSGHFetchUniv.fetch("", isAll: true, isHighSchool: isHighSchool) { [weak self] success, array in
            if success, let array = array, array.count > 0 {
                self?.dataArray = array as? [UnivSingle]
                self?.tblSearchResults.reloadData()
            }
        }
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundColor = UIColor.init(red: 222.0/255, green: 222.0/255, blue: 222.0/255, alpha: 1.0);
        
        //去除searchBar的UISearchBarBackground
        for view in searchController.searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                    subview.removeFromSuperview()
                    break;
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
        HSGHFetchUniv.fetch(searchString, isAll: false, isHighSchool: isHighSchool) { [weak self] success, array in
            if success, let array = array, array.count > 0 {
                self?.filteredArray = array as? [UnivSingle]
                self?.tblSearchResults.reloadData()
            }
        }
        
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
        HSGHFetchUniv.fetch(searchText, isAll: false, isHighSchool: isHighSchool) { [weak self] success, array in
            if success, let array = array, array.count > 0 {
                self?.filteredArray = array as? [UnivSingle]
                self?.tblSearchResults.reloadData()
            }
        }
    }
}

