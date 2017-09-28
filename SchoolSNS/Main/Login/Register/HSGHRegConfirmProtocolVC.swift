//
//  HSGHRegConfirmProtocolVC.swift
//  SchoolSNS
//
//  Created by Murloc on 12/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class HSGHRegConfirmProtocolVC: HSGHBaseViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    func setupViews() {
        
        view.backgroundColor = UIColor.white
        
        title = "骞骞用户协议"
        
        let textView: UITextView = UITextView(frame: CGRect(x: 0, y: HSGH_NAVGATION_HEIGHT, width: view.width, height: view.height - HSGH_NAVGATION_HEIGHT))
        
        let path = Bundle.main.url(forResource: "Protocol", withExtension: "rtf")

        if let path = path {
            let attributedString = try? NSAttributedString(fileURL:path, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
            if let attributedString = attributedString  {
                textView.attributedText = attributedString
            }
        }
        
        view.addSubview(textView)
    }

}
