//
//  PostActionCell.swift
//  quikvid
//
//  Created by Gordon Moore on 12/26/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

class PostActionCell: UITableViewCell {

    static let height: CGFloat = 46
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
