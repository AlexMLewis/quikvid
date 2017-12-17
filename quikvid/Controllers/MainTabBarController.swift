//
//  MainTabBarController.swift
//  quikvid
//
//  Created by Alexander Lewis on 12/16/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//
//  MainTabBarController helps to implement the photo tab bar item as a button feature
//  1. Subclasses UITabBarController with our own custom class
//  2. Implements the UITabBarController Delegate
//  3. Asks its delegate whether or not it should present the view controller
//     that belongs to the tab bar item that the user just tapped

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    let photoHelper = QVPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            print("handle image")
        }
        
        // Set MainTabBarController as the delegate of its tab bar
        delegate = self
        // Set the tab bar's unselectedItemTintColor from the default of gray to black
        tabBar.unselectedItemTintColor = .black
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    // Returns a Bool that determines if the tab bar will present the corresponding
    // UIViewController that the use has selected. True --> behave as usual.
    // False --> view controller will not be displayed
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) ->
    Bool {
        // Photo taking tab is tagged 1
        // If the view controllers tag is the photo taking tag, return false
        if viewController.tabBarItem.tag == 1 {
            // present photo taking action sheet
            photoHelper.presentActionSheet(from: self)
            return false
        }
        
        return true
    }
}
