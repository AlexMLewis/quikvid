//
//  UserService.swift
//  quikvid
//
//  Created by Alexander Lewis on 12/16/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase
import FirebaseStorage

struct UserService {
    // Class method for reading a user from the database
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(user)
        })
    }
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        
        // create a dictionary to store the username the user has provided inside our database
        let userAttrs = ["username": username]
        
        // specify a relative path for the location of where we want to store our data
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        // write the data at the location we provided above
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // read the user we just wrote to the database and create a user from the snapshot
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                
                // handle newly created user here
                completion(user)
            })
        }
    }
    
    // Retrieve all the posts in the groups associated with the current user
    static func allGroupPosts(for user: User, completion: @escaping ([Post]) -> Void) {
        
        // all the posts to be returned
        var allPosts = [Post]()
        var groups = [String: String]()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        UserService.groupsOfCurrentUserComplete { (groupInfo) in
            groups = groupInfo
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            var counter = 1
        
            for (group, owner) in groups {
                let ref = Database.database().reference().child("groups").child(owner).child(group).child("posts")
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                        return completion([])
                    }
                    
                    let posts = snapshot.reversed().flatMap(Post.init)
                    allPosts += posts
                    if counter == groups.count {
                        completion(allPosts)
                    } else {
                        counter += 1
                    }
                })
            }
        })
    }
    
    // fetch all users on the app and display them
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            let users =
                snapshot
                    .flatMap(User.init)
                    .filter { $0.uid != currentUser.uid }
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()

                FollowService.isUserFollowed(user) { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    // fetch all users current user is following
    static func friendsOfCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            var following =
                snapshot
                    .flatMap(User.init)
                    .filter { $0.uid != currentUser.uid }
            
            let dispatchGroup = DispatchGroup()
            following.forEach { (user) in
                dispatchGroup.enter()
                
                // filter out users we don't follow
                FollowService.isUserFollowed(user) { (isFollowed) in
                    if !isFollowed {
                        following = following.filter { $0.uid != user.uid}
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(following)
            })
        })
    }
    
    // fetch all groups current user is part of
    static func groupsOfCurrentUser(completion: @escaping ([String]) -> Void) {
        let currentUser = User.current
        let ref = Database.database().reference().child("users").child(currentUser.uid).child("groups")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary
                else {return completion([])}
            let groups = value.allKeys as! [String]
            completion(groups)
        })
    }
    
    // fetch all groups and information current user is part of
    static func groupsOfCurrentUserComplete(completion: @escaping ([String: String]) -> Void) {
        let currentUser = User.current
        
        let ref = Database.database().reference().child("users").child(currentUser.uid).child("groups")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary
                else {return completion([:])}
            completion(value as! [String : String])
        })
    }
    
    // all posts in this group
    static func postsInGroup(groupName: String, completion: @escaping ([UIImage]) -> Void) {
        
        UserService.groupOwner(groupName: groupName) { (owner) in
            
            let ref = Database.database().reference().child("groups").child(owner).child(groupName).child("posts")
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                    return completion([])
                }
                
                let posts = snapshot.reversed().flatMap(Post.init)
                
                let dispatchGroup = DispatchGroup()
                
                var images = [UIImage]()
                
                for post in posts {
                    dispatchGroup.enter()
                    let storageRef = Storage.storage().reference(forURL: post.imageURL)
                    storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        let pic = UIImage(data: data!)
                        images.append(pic!)
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main, execute: {
                    completion(images)
                })
            })
        }
    }
    
    // return owner of this group
    static func groupOwner(groupName: String, completion: @escaping (String) -> Void) {
        let ref = Database.database().reference().child("users").child(User.current.uid).child("groups")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let owner = value?[groupName] as? String ?? ""
            completion(owner)
        })
    }
    
    static func groupInfo(groupName: String, completion: @escaping (Int, [Post]) -> Void) {
        UserService.groupOwner(groupName: groupName) { (owner) in
            
            let postRef = Database.database().reference().child("groups").child(owner).child(groupName).child("posts")
            let memberRef = Database.database().reference().child("groups").child(owner).child(groupName).child("members")
            
            postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                    return completion(0, [])
                }
                
                let posts = snapshot.reversed().flatMap(Post.init)
                
                memberRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    completion(value!.count, posts)
                })
            })
        }
    }
}
















