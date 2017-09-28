//
//  HSGHSettingsHeadCell.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 26/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit

protocol SettingsTableViewHeadProtocol : class {
    func clickHead(_ section: Int)
}



class HSGHSettingsHeadCell: UITableViewHeaderFooterView {

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var settingArrow: UIImageView!
    
    weak var delegate : SettingsTableViewHeadProtocol?
    private var cellSection: Int = 0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
    
    func updateInfo(_ imageName: String, _ name: String, _ section: Int, _ isNext: Bool) {
        headImageView.image = UIImage(named: imageName)
        headLabel.text = name
        cellSection = section
        
        settingArrow.transform = isNext ? settingArrow.transform.rotated(by: CGFloat(-Double.pi / 2)) : settingArrow.transform.rotated(by: 0)
        
    }
    
}
