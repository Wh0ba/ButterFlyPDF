//
//  ViewController.swift
//  Butterfly
//
//  Created by AbdulWahab Fanar on 8/6/21.
//  Copyright © 2021 AbdulWahab Fanar. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import QuickLook

class ViewController: UIViewController {
    
    @IBOutlet weak var browseButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        browseButton.layer.cornerRadius = 15
        browseButton.clipsToBounds = true
    }
    
    @IBAction func handleButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/wh0ba/")!)
    }
    @IBAction func browseButtonTapped(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if (status == .authorized){
                self.showPicker()
            }
        }
    }
    func showPicker(){
        let picker = ImagePickerController()
        
        presentImagePicker(picker, select: nil, deselect: nil, cancel: nil, finish: { (assets) in
                self.showPDFView(selectedAssets: assets)
        })
    }
    func showPDFView(selectedAssets: [PHAsset]) {
        let pdfVC = PDFViewerVC(assets: selectedAssets)
        navigationController?.pushViewController(pdfVC, animated: true)
    }
    
}

