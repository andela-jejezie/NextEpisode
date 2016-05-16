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
        // add check for empty image
        if let imageString = cast.person?.image {
            UIImageView().kf_setImageWithURL(NSURL(string: imageString)!, placeholderImage: UIImage(named: "user"), optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                if let personImage = image {
                    self.imageView.image = CDHelper.resizeImage(personImage, newWidth: self.imageView.frame.size.width)
                }else {
                    self.imageView.image = UIImage(named: "user")
                }
            })
            nameLabel.text = cast.person?.name!
        }else {
            imageView.image = UIImage(named: "user")
        }
        
    }
}
