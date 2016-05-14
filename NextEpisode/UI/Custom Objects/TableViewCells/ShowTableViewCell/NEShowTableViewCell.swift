//
//  NEShowTableViewCell.swift
//  NextEpisode
//
//  Created by Andela on 5/12/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit


class NEShowTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    var isFavorite = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }
    
    internal func configureCellForEpisode(show:Show) {
        
        self.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        coverImageView.image = UIImage(named: "images")
        if let name = show.name {
            nameLabel.text = name
        }
        guard let rating = show.rating?.average where show.rating?.average != nil else {
            ratingLabel.text = "Rating: not available"
            return
        }
        ratingLabel.text = "Rating: \(rating)/10"
        
        summaryLabel.text = show.summary!.isEmpty ? "No summary": show.summary
        if let path = show.image {
            coverImageView.kf_setImageWithURL(NSURL(string: path)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        
        print(CDHelper.shared.arrayOfFavoriteID)
        print(show.showID!)
        
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
