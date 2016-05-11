//
//  NECastDetailVC.swift
//  NextEpisode
//
//  Created by Andela on 5/9/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import Kingfisher

class NECastDetailVC: NEGenericVC {

    @IBOutlet weak var characterURLButton: UIButton!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var personURLButton: UIButton!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    
    var cast:Cast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageString = cast.person?.image {
            personImageView.kf_setImageWithURL(NSURL(string: imageString)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        personNameLabel.text = cast.person?.name
        personURLButton.setTitle("More about \(cast.person?.name!)", forState: .Normal)
        if let imageString = cast.character?.image {
          characterImageView.kf_setImageWithURL(NSURL(string: imageString)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        characterNameLabel.text = cast.character?.name!
        characterURLButton.setTitle("More about \(cast.character?.name!) ", forState: .Normal)

    }

}
