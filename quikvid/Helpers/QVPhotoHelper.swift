//
//  QVPhotoHelper.swift
//  quikvid
//
//  Created by Alexander Lewis on 12/16/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

class QVPhotoHelper: NSObject {
    
    // MARK: - Properties
    
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    
    func presentActionSheet(from viewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                // do nothing yet
            })
            
            alertController.addAction(capturePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
                // do nothing yet
            })
            
            alertController.addAction(uploadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
}
