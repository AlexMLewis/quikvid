//
//  PostService.swift
//  quikvid
//
//  Created by Alexander Lewis on 12/17/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
        }
    }
    
    // Write a new Post object to database
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        
        // Create a reference to the current user
        let currentUser = User.current
        
        // Initialize a new Post using the data passed in by the parameters
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        
        // Convert the new post object into a dictionary so that it can be written as JSON in our database
        let dict = post.dictValue
        
        // Construct the relative path to the location where we want to store the new post data
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        
        // Write the data to the specified 
        postRef.updateChildValues(dict)
    }
}
