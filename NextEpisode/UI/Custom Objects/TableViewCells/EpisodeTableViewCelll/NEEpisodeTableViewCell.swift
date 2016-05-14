//
//  NEEpisodeTableViewCell.swift
//  NextEpisode
//
//  Created by Andela on 5/6/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import Kingfisher


class NEEpisodeTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var imageCoverView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var airtimeLabel: UILabel!
    
    @IBOutlet weak var seasonLabel: UILabel!
    
    @IBOutlet weak var showTitleLabel: UILabel!
    internal func configureCellForEpisode(episode:Episode) {
       
        self.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        coverImageView.image = UIImage(named: "images")
//        if let name = episode.show?.name {
//            showTitleLabel.text = name
//        }
        guard let episodeNumber = episode.episode where episode.episode != nil else {
           episodeNumberLabel.text = "Episode: not available"
            return
        }
        episodeNumberLabel.text = "Episode: \(episodeNumber)"
        
        guard let airtime = episode.airtime where episode.airtime != nil else {
          airtimeLabel.text = "Time: Not available"
            return
        }
        airtimeLabel.text = "Time: \(airtime)"
        
//
        summaryLabel.text = episode.summary!.isEmpty ? "No summary": episode.summary
        seasonLabel.text = "Season: \(episode.season!)"
//        if let path = episode.show?.image {
//            coverImageView.kf_setImageWithURL(NSURL(string: path)!)
//        }
        
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
        showTitleLabel.text = ""
        episodeNumberLabel.text = ""
        airtimeLabel.text = ""
        summaryLabel.text = ""
        seasonLabel.text = ""
        coverImageView.image = nil
    }
    
}
