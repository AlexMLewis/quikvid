//
//  AddMembersCell.swift
//  quikvid
//
//  Created by Gordon Moore on 12/24/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

protocol AddMembersCellDelegate: class {
    func didTapAddMemberButton(_ followButton: UIButton, on cell: AddMembersCell)
}

class AddMembersCell: UITableViewCell {
    
    weak var delegate: AddMembersCellDelegate?

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
        delegate?.didTapAddMemberButton(sender, on: self)
    }
}
