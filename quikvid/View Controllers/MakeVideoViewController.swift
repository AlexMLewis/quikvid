//
//  MakeVideoViewController.swift
//  quikvid
//
//  Created by Gordon Moore on 12/26/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

class MakeVideoViewController: UIViewController {

    // MARK: - Properties
    
    var groups = [String]()
    var isSelected = false
    
    //MARK: - Subviews
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
    }
    
    // fetch all groups we're in and set them to our datasource
    // refresh UI on main thread because all UI updates must be on the main thread
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserService.groupsOfCurrentUser { [unowned self] (groups) in
            self.groups = groups
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension MakeVideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MakeVideoCell") as! MakeVideoCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: MakeVideoCell, atIndexPath indexPath: IndexPath) {
        cell.groupNameLabel.text = groups[indexPath.row]
         cell.makeVideoButton.isSelected = isSelected
    }
}

extension MakeVideoViewController: MakeVideoCellDelegate {
    func didTapMakeVideoButton(_ makeVideoButton: UIButton, on cell: MakeVideoCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        makeVideoButton.isUserInteractionEnabled = false
        defer {
            makeVideoButton.isUserInteractionEnabled = true
        }
        
        UserService.postsInGroup(groupName: cell.groupNameLabel.text!) { (images) in
            let settings = RenderSettings()
            let imageAnimator = ImageAnimator(renderSettings: settings, imageArray: images)
            imageAnimator.render() {
                self.isSelected = true
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}




