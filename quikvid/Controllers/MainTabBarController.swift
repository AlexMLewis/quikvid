//
//  MainTabBarController.swift
//  quikvid
//
//  Created by Alexander Lewis on 12/16/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    let photoHelper = QVPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            print("handle image")
        }
        
        delegate = self
        tabBar.unselectedItemTintColor = .black
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) ->
    Bool {
        if viewController.tabBarItem.tag == 1 {
            // present photo taking action sheet
            photoHelper.presentActionSheet(from: self)
            return false
        }
        
        return true
    }
}
