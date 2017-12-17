//
//  QVPhotoHelper.swift
//  quikvid
//
//  Created by Alexander Lewis on 12/16/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//
//  QVPhotoHelper has three main responsibilities
//  1. Presenting the popover to allow the user to choose between taking a new photo
//     or selecting on from the photo library
//  2. Depending on the user's selection, presenting the camera or photo library
//  3. Returning the image that the user has taken or selected

import UIKit

class QVPhotoHelper: NSObject {
    
    // MARK: - Properties
    // completionHandler that will be called when the user has selected a photo from UIImagePickerController
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    // presentActionSheet(from:) takes a reference to a view controller
    // this reference is necessary because the QVPhotoHelper needs a UIViewController on which
    // it can present other view controllers
    // we call this method from MainTabBarController
    func presentActionSheet(from viewController: UIViewController) {
        
        // UIAlertController can be used to present different types of alerts
        // An action sheet is a popup that will be displayed at the bottom edge of the screen
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        // Check if the current device has a camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // Create a new UIAlertAction
            // Each UIAlertAction represents an action on the UIAlertController
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                // do nothing yet
            })
            
            // Add the action to the alertController instance
            alertController.addAction(capturePhotoAction)
        }
        
        // Add photo library option to alertController
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
                // do nothing yet
            })
            
            alertController.addAction(uploadAction)
        }
        
        // Add cancel option to alertController
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present UIAlertController from our UIViewController
        viewController.present(alertController, animated: true)
    }
}
