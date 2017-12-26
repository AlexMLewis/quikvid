//
//  UploadPhotoViewController.swift
//  quikvid
//
//  Created by Gordon Moore on 12/25/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

class UploadPhotoViewController: UIViewController {
    
    //MARK: - Properties
    
    var groups = [String]()
    let photoHelper = QVPhotoHelper()
    var group = ""
    
    // MARK: - Subviews

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
        
        // set the completionHandler property of QVPhotoHelper
        photoHelper.completionHandler = { image in
            PostService.create(for: image, group: self.group)
        }
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

extension UploadPhotoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadPhotoCell") as! UploadPhotoCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configure(cell: UploadPhotoCell, atIndexPath indexPath: IndexPath) {
        cell.groupnameLabel.text = groups[indexPath.row]
    }
}

extension UploadPhotoViewController: UploadPhotoCellDelegate {
    func didTapUploadButton(_ uploadButton: UIButton, on cell: UploadPhotoCell) {
        group = cell.groupnameLabel.text!
        photoHelper.presentActionSheet(from: self)
    }
}
















