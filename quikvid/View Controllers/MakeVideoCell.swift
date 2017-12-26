//
//  MakeVideoCell.swift
//  quikvid
//
//  Created by Gordon Moore on 12/26/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

protocol MakeVideoCellDelegate: class {
    func didTapMakeVideoButton(_ makeVideoButton: UIButton, on cell: MakeVideoCell)
}

class MakeVideoCell: UITableViewCell {

    weak var delegate: MakeVideoCellDelegate?
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var makeVideoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // style customizations
        makeVideoButton.layer.borderColor = UIColor.lightGray.cgColor
        makeVideoButton.layer.borderWidth = 1
        makeVideoButton.layer.cornerRadius = 6
        makeVideoButton.clipsToBounds = true
    }
    
    @IBAction func makeVideoButtonTapped(_ sender: UIButton) {
        delegate?.didTapMakeVideoButton(sender, on: self)
    }
}
