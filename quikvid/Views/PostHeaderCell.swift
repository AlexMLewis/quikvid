//
//  PostHeaderCell.swift
//  quikvid
//
//  Created by Gordon Moore on 12/26/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {

    static let height: CGFloat = 54
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        print("options button tapped")
    }
    
}
