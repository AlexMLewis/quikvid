//
//  PostHeaderCell.swift
//  quikvid
//
//  Created by Alexander Lewis on 12/17/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    
    static let height: CGFloat = 54
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
        print("options button tapped")
    }
}
