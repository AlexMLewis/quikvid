//
//  AddMembersViewController.swift
//  quikvid
//
//  Created by Gordon Moore on 12/24/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

class AddMembersViewController: UIViewController {
    
    // receives group name from create group view controller
    var group:String = ""
    
    // MARK: - Properties
    
    var users = [User]()
    
    // MARK: - Subviews

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fetch all users we're following ("friends with") and set them to our datasource
        // refresh UI on main thread because all UI updates must be on the main thread
        UserService.friendsOfCurrentUser { [unowned self] (users) in
            self.users = users
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension AddMembersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMembersCell") as! AddMembersCell
        
        configure(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: AddMembersCell, atIndexPath indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        cell.usernameLabel.text = user.username
        cell.addMemberButton.isSelected = false
    }
}
