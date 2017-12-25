//
//  AddMembersCell.swift
//  quikvid
//
//  Created by Gordon Moore on 12/24/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

class AddMembersCell: UITableViewCell {

    @IBOutlet weak var addMemberButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // style customizations
        addMemberButton.layer.borderColor = UIColor.lightGray.cgColor
        addMemberButton.layer.borderWidth = 1
        addMemberButton.layer.cornerRadius = 6
        addMemberButton.clipsToBounds = true
        
        addMemberButton.setTitle("Add", for: .normal)
        addMemberButton.setTitle("Added", for: .selected)
    }
    
    @IBAction func addMemberButtonTapped(_ sender: UIButton) {
        print("add member button tapped")
    }
}
