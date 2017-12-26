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

struct UserService {
    // Class method for reading a user from the database
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            // handle newly created user here
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
        var groupNames = [String]()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        UserService.groupsOfCurrentUser { (groups) in
            groupNames = groups
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            var counter = 1
        
            for group in groupNames {
                let ref = Database.database().reference().child("groups").child(group).child("posts")
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                        return completion([])
                    }
                    
                    let posts = snapshot.reversed().flatMap(Post.init)
                    allPosts += posts
                    if counter == groupNames.count {
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

        // reference to read all users from the database
        let ref = Database.database().reference().child("users")

        // read users node from database
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }

            // take snapshot and:
            // 1. convert all of the child DataSnapshot into User
            // 2. filter out the current user object from the User array
            let users =
                snapshot
                    .flatMap(User.init)
                    .filter { $0.uid != currentUser.uid }

            // Create new DispatchGroup so that we can be notified when all asynchronous tasks are finished executing
            // use the notify(queue:) method on DispatchGroup as completion handler for when all follow data has been read
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()

                // make a request for each individual user to determine if the user is being followed by the current user
                FollowService.isUserFollowed(user) { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }

            // run the completion block after all follow relationship data has returned
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    // fetch all users current user is following
    static func friendsOfCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        
        // reference to all users
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
}
















