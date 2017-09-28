//
//  HSGHSettingsEndCell.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 26/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation


class HSGHSettingsEndCell: UITableViewHeaderFooterView {
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate : SettingsTableViewHeadProtocol?
    private var cellSection: Int = 0
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier : reuseIdentifier)
        self.backgroundColor = UIColor.white
        addGes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
        addGes()
    }
    
    func addGes() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tapGes)
    }
    
    func tapClick() {
        delegate?.clickHead(cellSection)
    }
    
    func updateInfo(_ name: String, _ section: Int) {
        cellSection = section
        nameLabel.text = name
    }
    
}
