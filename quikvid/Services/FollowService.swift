//
//  FollowService.swift
//  quikvid
//
//  Created by Gordon Moore on 12/23/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//
// Service for all follow-related network requests

import Foundation
import FirebaseDatabase

struct FollowService {
    // service method for following another user
    private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        
        // dictionary to update multiple locations at the same time
        // set appropriate key/value for followers and following
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : true,
                          "following/\(currentUID)/\(user.uid)" : true]
        
        // write relationship to Firebase
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            // return whether update was successful based on error
            success(error == nil)
        }
    }
    
    // service method for unfollowing another user
    private static func unfollowUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        // Use NSNull() object instead of nil because updateChildValues expects type [Hashable : Any]
        let followData = ["followers/\(user.uid)/\(currentUID)" : NSNull(),
                         "following/\(currentUID)/\(user.uid)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            // return whether update was successful based on error
            success(error == nil)
        }
    }
    
    // service method to directly set the follow relationship to the current user
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
        if isFollowing {
            followUser(followee, forCurrentUserWithSuccess: success)
        } else {
            unfollowUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    // service method to determine whether a user is already followed by the current user
    static func isUserFollowed(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("followers").child(user.uid)
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}
