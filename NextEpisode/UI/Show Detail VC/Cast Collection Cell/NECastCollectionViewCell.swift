//
//  NECastCollectionViewCell.swift
//  NextEpisode
//
//  Created by Andela on 5/7/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import Kingfisher
class NECastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func layoutSubviews() {
         imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
    }
    internal func configureCellForData (cast:Cast) {
        imageView.kf_setImageWithURL(NSURL(string: (cast.person?.image)!)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        nameLabel.text = cast.person?.name!
    }
}
