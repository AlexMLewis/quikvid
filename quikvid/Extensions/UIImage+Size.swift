//
//  UIImage+Size.swift
//  quikvid
//
//  Created by Alexander Lewis on 12/17/17.
//  Copyright © 2017 Alexander Lewis. All rights reserved.
//

import UIKit

extension UIImage {
    var aspectHeight: CGFloat {
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        return size.height / aspectRatio
    }
}
