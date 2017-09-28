//
//  MyViewController.swift
//  FPPKit
//
//  Created by FlyingPuPu on 09/05/2017.
//  Copy t © 2017 FlyingPuPu. All rights reserved.
//

import UIKit

class HSGHRegSexInfoVC: HSGHBaseViewController {

    @IBOutlet weak var imageBGButton: AnimatableButton!
    @IBOutlet weak var imageButton: AnimatableButton!
    
    @IBOutlet weak var womanButton: HSGHCustomButton!
    @IBOutlet weak var manButton: HSGHCustomButton!
    
    @IBOutlet weak var nextButton: HSGHCustomButton!
    
    var hasSelectedSex : Bool = false
    var hasSelectedImage: Bool = false
    
    @IBOutlet weak var regButtonToBottomCons: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        adjustUIConstraints()
        navigationController?.navigationBar.isHidden = true
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setDefault() {
        imageButton.clipsToBounds = true
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.layer.cornerRadius = imageButton.frame.width / 2
        nextButton.isNext = true
        nextButton.isEnabled = false
    }
    
    func adjustUIConstraints() {
        if (UIScreen.main.bounds.height < 568) {
            regButtonToBottomCons.constant = 10
        }
    }

    @IBAction func pickerImage(_ sender: Any) {
        let imagePickerVC: HSGHPhotoPickerController = HSGHPhotoPickerController()
        imagePickerVC.isPersonalMode = true
        imagePickerVC.cropBlock = { [weak self] (image: UIImage?) -> () in
            self!.imageBGButton.isHidden = true
            self!.imageButton.setImage(image, for: .normal)
            self!.imageButton.setImage(image, for: .selected)
            self!.hasSelectedImage = true
            if self!.hasSelectedSex {
                self!.nextButton.isEnabled = true
            }
            if let image = image {
                HSGHRegisterNetModel.singleInstance()!.image = HSGHTools.fixOrientation(image)
                let data = HSGHUploadPicNetRequest.convert(toNSData: image)
                HSGHUploadPicNetRequest.upload(data) {success, key, name in
                    if let key = key {
                        HSGHRegisterNetModel.singleInstance()!.imageKey = key
                    }
                }
            }
        }

        let nav = UINavigationController(rootViewController: imagePickerVC)
        self.present(nav, animated: true)
    }

    @IBAction func clickWomen(_ sender: Any) {
        hasSelectedSex = true
        if (hasSelectedImage) {
            nextButton.isEnabled = true
        }
        HSGHRegisterNetModel.singleInstance()!.sex = 2
        womanButton.isSelected = true
        manButton.isSelected = false
    }

    @IBAction func clickMan(_ sender: Any) {
        hasSelectedSex = true
        if (hasSelectedImage) {
            nextButton.isEnabled = true
        }
        HSGHRegisterNetModel.singleInstance()!.sex = 1
        manButton.isSelected = true
        womanButton.isSelected = false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.

    }
}
