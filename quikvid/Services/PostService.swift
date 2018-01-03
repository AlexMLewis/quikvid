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
    static func create(for image: UIImage, group: String) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight, group: group)
        }
    }
    
    // Write a new Post object to database
    private static func create(forURLString urlString: String, aspectHeight: CGFloat, group: String) {
        
        UserService.groupOwner(groupName: group) { (owner) in
            let post = Post(imageURL: urlString, imageHeight: aspectHeight, group: group)
            let dict = post.dictValue
            let postRef = Database.database().reference().child("groups").child(owner).child(group).child("posts").childByAutoId()
            postRef.updateChildValues(dict)
        }
    }
}
