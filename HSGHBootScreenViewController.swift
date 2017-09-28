//
//  HSGHBootScreenViewController.swift
//  SchoolSNS
//
//  Created by Huaral on 2017/7/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

import UIKit

class HSGHBootScreenViewController: UIViewController ,UIScrollViewDelegate  {

    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self;
        // Do any additional setup after loading the view.
    
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let index = scrollView.contentOffset.x / scrollView.bounds.size.width;
        self.pageControl.currentPage = Int(index);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
