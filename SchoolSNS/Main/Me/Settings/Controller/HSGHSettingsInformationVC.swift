//
//  HSGHSettingsInformationVC.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 14/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation


class HSGHSettingsInformationVC: HSGHBaseTableViewController {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
   override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1) {
            //edit school
        }
    }
    
    
    
}
