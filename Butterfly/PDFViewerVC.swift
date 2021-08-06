//
//  PDFViewerVC.swift
//  Butterfly
//
//  Created by AbdulWahab Fanar on 8/6/21.
//  Copyright © 2021 AbdulWahab Fanar. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
import Photos


class PDFViewerVC: UIViewController {
    var docPDFView: PDFView!
    let photoAssets: [PHAsset]
    
    init(assets: [PHAsset]) {
        self.photoAssets = assets
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        setupPDFView()
        let shareBarButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(sharePDF))
        navigationItem.setRightBarButton(shareBarButton, animated: false)
    }
    fileprivate func setupPDFView() {
        docPDFView = PDFView(frame: view.bounds)
        docPDFView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(docPDFView)
        docPDFView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        docPDFView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        docPDFView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        docPDFView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        docPDFView.autoScales = true
        docPDFView.minScaleFactor = 0
        docPDFView.displayBox = .trimBox
        docPDFView.displayDirection = .vertical
        docPDFView.displayMode = .singlePageContinuous
        
        
        docPDFView.document = getPDFDocument()
        refreshScale()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perform(#selector(refreshScale), with: nil, afterDelay: 0.4)
        docPDFView.zoomIn(self)
    }
    @objc
    func refreshScale(){
         docPDFView.scaleFactor = docPDFView.scaleFactorForSizeToFit
    }
    
    fileprivate func getPDFDocument() -> PDFDocument{
        let doc = PDFDocument()
        
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.deliveryMode = .highQualityFormat
        imageRequestOptions.isSynchronous = true
        
        for i in 0..<photoAssets.count{
            let asset = photoAssets[i]
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: imageRequestOptions) { (image, info) in
                let page = PDFPage(image: image!)!
                doc.insert(page, at: i)
            }
        }
        return doc
    }
    @objc
    func sharePDF(){
        let PDFData = docPDFView.document?.dataRepresentation()
        let activity = UIActivityViewController(activityItems: [PDFData!], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }

}
