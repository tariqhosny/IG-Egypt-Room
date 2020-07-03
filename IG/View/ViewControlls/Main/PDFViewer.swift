//
//  PDFViewer.swift
//  IG
//
//  Created by Tariq on 2/24/20.
//  Copyright © 2020 Tariq. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewer: UIViewController{

    var pdfView = PDFView()
    var pdfURL: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pdfView)
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "PDF Viewer"
    }
    
    override func viewDidLayoutSubviews() {
        pdfView.frame = view.frame
    }
    
}
