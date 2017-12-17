//
//  StorageService.swift
//  quikvid
//
//  Created by Alexander Lewis on 12/17/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit
import FirebaseStorage

struct StorageService {
    // provide method for uploading images
    
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        
        // Change the image from an UIImage to Data
        // Reduce the quality of the image
        // Return nil if we can't
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        // We upload our media data to the path provided as a parameter to the method
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            
            // Check if there was an error after the upload completes
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // Return the downloaded URL for the image
            completion(metadata?.downloadURL())
        })
    }
}
