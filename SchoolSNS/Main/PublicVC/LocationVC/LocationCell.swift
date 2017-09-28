//
//  LocationCell.swift
//  SchoolSNSs
//
//  Created by FlyingPuPu on 17/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var checkedButton: AnimatableButton!
    @IBOutlet weak var firstLocationName: UILabel!
    @IBOutlet weak public var secondLocationName: UILabel!

    /// 上面那栏的高度，默认20，如果下面不存在则改成
    @IBOutlet weak var firstLicationHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkedButton.isHidden = !selected
        if (selected) {
            checkedButton.setImage(UIImage(named: "checked"), for: .normal)
            checkedButton.setImage(UIImage(named: "checked"), for: .selected)
            checkedButton.setImage(UIImage(named: "checked"), for: .highlighted)
        }
    }

    public func updateInfo(_ name: String, subName: String) {
        firstLocationName.text = name
        secondLocationName.text = subName
        if (subName.characters.count == 0) {
            self.secondLocationName.isHidden = true;
            self.firstLicationHeight.constant = 34;
//            var frame = firstLocationName.frame
//            frame.origin.y = (self.frame.height - firstLocationName.frame.height) / 2.0
//            firstLocationName.frame = frame
        }else{
            self.secondLocationName.isHidden = false;
            self.firstLicationHeight.constant = 20;
        }
    }
}
