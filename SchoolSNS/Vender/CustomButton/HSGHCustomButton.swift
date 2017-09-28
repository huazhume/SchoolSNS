//
//  HSGHCustomButton.swift
//  SchoolSNS
//
//  Created by FlyingPuPu on 27/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit

class HSGHCustomButton: AnimatableButton {
    @IBInspectable var isNext: Bool = false {
        didSet {
            configureSettings()
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        configureSettings()
    }
    
    func configureSettings() {
        self.setTitleColor(UIColor(hexString: "7e8390"), for: .normal)
        self.setTitleColor(UIColor.white, for: .selected)
        let inset = UIEdgeInsetsMake(0, 60, 0, 60)
        let isSmall = self.height >= 50 ? false : true
        self.setBackgroundImage(UIImage(named: isSmall ? "customButtonWhiteS" : "customButtonWhite")?.resizableImage(withCapInsets: inset, resizingMode: .stretch), for: .normal)
        if !isNext {
            self.setBackgroundImage(UIImage(named: isSmall ? "customButtonDeepS" : "customButtonDeep")?.resizableImage(withCapInsets: inset, resizingMode: .stretch), for: .selected)
            self.setBackgroundImage(UIImage(named: isSmall ? "customButtonDeepS" : "customButtonDeep")?.resizableImage(withCapInsets: inset, resizingMode: .stretch), for: .highlighted)
        }
        else {
            self.setTitleColor(UIColor.white, for: .normal)
            self.setBackgroundImage(UIImage(named: isSmall ? "customButtonNextS" : "customButtonNext")?.resizableImage(withCapInsets: inset, resizingMode: .stretch), for: .normal)
            self.setBackgroundImage(UIImage(named: isSmall ? "customButtonNextS" : "customButtonNext")?.resizableImage(withCapInsets: inset, resizingMode: .stretch), for: .selected)
            self.setBackgroundImage(UIImage(named: isSmall ? "customButtonNextS" : "customButtonNext")?.resizableImage(withCapInsets: inset, resizingMode: .stretch), for: .highlighted)
        }
    }
}
