//
//  UploadPhotoCell.swift
//  quikvid
//
//  Created by Gordon Moore on 12/25/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

protocol UploadPhotoCellDelegate: class {
    func didTapUploadButton(_ uploadButton: UIButton, on cell: UploadPhotoCell)
}

class UploadPhotoCell: UITableViewCell {
    
    weak var delegate: UploadPhotoCellDelegate?

    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var groupnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // style customizations
        uploadButton.layer.borderColor = UIColor.lightGray.cgColor
        uploadButton.layer.borderWidth = 1
        uploadButton.layer.cornerRadius = 6
        uploadButton.clipsToBounds = true
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        delegate?.didTapUploadButton(sender, on: self)
    }
}
