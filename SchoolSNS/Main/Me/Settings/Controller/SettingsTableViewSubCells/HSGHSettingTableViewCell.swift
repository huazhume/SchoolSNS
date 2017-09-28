//
//  HSGHSettingTableViewCell.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 26/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit

protocol SettingsTableViewChangeStatus : class {
    func changToStaus(_ status: Bool, _ indexPath: IndexPath)
    func clickCell(_ indexPath: IndexPath)
}



class HSGHSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    weak var delegate : SettingsTableViewChangeStatus?
    var cellIndexPath : IndexPath? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        setupDefaultStatus()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.backgroundColor = UIColor.white
        setupDefaultStatus()
    }
    
    
    func setupDefaultStatus() {
        statusSwitch.onTintColor = UIColor(hexString: "3987d0")
        
        statusSwitch.addTarget(self, action: #selector(changeStatus), for: .valueChanged)
    }
    
    func changeStatus() {
        if let cellIndexPath = cellIndexPath {
            delegate?.changToStaus(statusSwitch.isOn, cellIndexPath)
        }
    }
    
    
    func addGes() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tapGes)
    }
    
    func tapClick() {
        if let cellIndexPath = cellIndexPath, statusSwitch.isHidden {
            delegate?.clickCell(cellIndexPath)
        }
    }
    
    //MARK: update info
    func updateInfo(_ name: String, _ status: Bool, _ indexPath: IndexPath, _ showSwitch: Bool) {
        headLabel.text = name
        statusSwitch.isOn = status
        cellIndexPath = indexPath
        statusSwitch.isHidden = !showSwitch
        if !showSwitch {
            addGes()
        }
    }
    
}
