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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        if let imageString = cast.person?.image {
            UIImageView().kf_setImageWithURL(NSURL(string: imageString)!, placeholderImage: UIImage(named: "user"), optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                if let personImage = image {
                    self.personImageView.image = CDHelper.resizeImage(personImage, newWidth: self.personImageView.frame.size.width)
                }else {
                    self.personImageView.image = UIImage(named: "user")
                }
            })
        }else {
            personImageView.image = UIImage(named: "user")
        }
        if let PersonName = cast.person?.name {
            title = "\(PersonName) "
            personNameLabel.text = PersonName
            personURLButton.setTitle("More about \(PersonName)", forState: .Normal)
        }else {
           personImageView.image = UIImage(named: "user")
        }
        if let imageString = cast.character?.image {
            UIImageView().kf_setImageWithURL(NSURL(string: imageString)!, placeholderImage: UIImage(named: "user"), optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                if let personImage = image {
                    self.characterImageView.image = CDHelper.resizeImage(personImage, newWidth: self.characterImageView.frame.size.width)
                }else {
                    self.characterImageView.image = UIImage(named: "user")
                }
            })
        }else {
            characterImageView.image = UIImage(named: "user")
        }
        if let castName = cast.character?.name {
            characterNameLabel.text = castName
            characterURLButton.setTitle("More about \(castName) ", forState: .Normal)
  
        }

    }
    
    override func viewDidLayoutSubviews() {
        personImageView.layer.cornerRadius = personImageView.frame.size.height/2
        personImageView.clipsToBounds = true
        characterImageView.layer.cornerRadius = personImageView.frame.size.height/2
        characterImageView.clipsToBounds = true
    }

    @IBAction func onAboutCharacterTapped(sender: AnyObject) {
        let webStoryboard = UIStoryboard(name: "WebViewStoryboard", bundle: nil)
        let targetVC = webStoryboard.instantiateViewControllerWithIdentifier("NEWebViewVC") as? NEWebViewVC
        targetVC?.urlString = cast.character?.url!
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }
    @IBAction func onMoreAboutPersonTapped(sender: AnyObject) {
        let webStoryboard = UIStoryboard(name: "WebViewStoryboard", bundle: nil)
        let targetVC = webStoryboard.instantiateViewControllerWithIdentifier("NEWebViewVC") as? NEWebViewVC
        targetVC?.urlString = cast.person?.url!
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }
}
