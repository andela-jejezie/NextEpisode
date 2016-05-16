//
//  NEShowTableViewCell.swift
//  NextEpisode
//
//  Created by Andela on 5/12/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import Kingfisher


class NEShowTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }
    
    internal func configureCellForShow(show:Show) {
        
        self.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        coverImageView.image = UIImage(named: "images")
        
            nameLabel.text = show.name
        guard let rating = show.rating?.average where show.rating?.average != nil else {
            ratingLabel.text = "Rating: not available"
            return
        }
        ratingLabel.text = "Rating: \(rating)/10"
        
        summaryLabel.text = show.summary!.isEmpty ? "No summary": show.summary
        if let path = show.image {
            let imageView = UIImageView()
            imageView.kf_setImageWithURL(NSURL(string: path)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                self.coverImageView.image = CDHelper.resizeImage(image!, newWidth: self.coverImageView.frame.size.width)
            })
        }
        
        let item = CDHelper.shared.arrayOfFavoriteID.indexOf(show.showID!)
        if (item != nil) {
            favoriteImageView.image = UIImage(named: "HeartsFilled")
        }else {
           favoriteImageView.image = UIImage(named: "Hearts") 
        }
        
    }
    
    override func layoutSubviews() {
        //        self.cardView.backgroundColor = UIColor.whiteColor()
        self.cardView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3).CGColor
        self.cardView.layer.borderWidth = 1
        self.cardView.layer.cornerRadius = self.frame.size.width * 0.015
        self.cardView.layer.shadowRadius = 3;
        self.cardView.layer.shadowOpacity = 0;
        self.cardView.layer.shadowOffset = CGSizeMake(1, 1)
        let blurEffect = UIBlurEffect(style: .Light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.coverImageView.frame
        visualEffectView.alpha = 0
        self.coverImageView.addSubview(visualEffectView)
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        summaryLabel.text = ""
        ratingLabel.text = ""
        coverImageView.image = nil
    }

}
