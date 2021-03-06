//
//  NEShowDetailsVC.swift
//  NextEpisode
//
//  Created by Andela on 5/7/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import Kingfisher

class NEShowDetailsVC: NEGenericVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var showSummaryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var seasonsButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    var show:Show!
    var casts:[Cast] = []
    
    @IBOutlet weak var seeMoreButtonHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.seeMoreButtonHeight.constant = 54
        showSummaryLabel.numberOfLines = 0
        collectionView.dataSource = self
        collectionView.delegate = self
        title = show.name!
        if let imageString = show.image {
            UIImageView().kf_setImageWithURL(NSURL(string: imageString)!, placeholderImage: UIImage(named: "user"), optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                if let personImage = image {
                    self.showImageView.image = CDHelper.resizeImage(personImage, newWidth: self.showImageView.frame.size.width)
                }else {
                    self.showImageView.image = UIImage(named: "user")
                }
            })
        }else {
            showImageView.image = UIImage(named: "user")
        }
        showImageView.kf_setImageWithURL(NSURL(string: show.image!)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        if let summary = show.summary {
            showSummaryLabel.text = CDHelper.formatString(summary)
        }else {
            showSummaryLabel.text = "Synopsis not available"
        }
        
        ratingLabel.text = "Rating \(show.averageRating!)/10"
        if show.casts?.count > 0 {
            casts = show.casts!.map({ ($0 as! Cast) })
        }
        if show.casts?.count == 0 {
            let showIDString = String(show.showID!)
            NERequest.getCastsForShow(showIDString, completionHandler: { (casts, errorMessage) in
                dispatch_async(dispatch_get_main_queue(), {
                    if let _ = casts {
                        print(casts)
                        for object in casts! {
                            if let dict = object as? [String:AnyObject] {
                                Cast.newInstance(dict, context: CDHelper.shared.context, forShow: self.show)
                            }
                        }
                        CDHelper.saveSharedContext()
                        if self.show.casts?.count > 0 {
                            self.casts = self.show.casts!.map({ ($0 as! Cast) })
                        }
                        self.collectionView.reloadData()
                    }
                })
            })
            
            
            
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NECastCollectionViewCell", forIndexPath: indexPath) as? NECastCollectionViewCell
        let cast = casts[indexPath.row]
        cell?.configureCellForData(cast)
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowDetailsToCastDetailsSegue", sender: nil)
    }
    
    
    @IBAction func onSeeMoreTapped(sender: AnyObject) {
        if seeMoreButtonHeight.constant == 54 {
            self.seeMoreButton.setTitle("See less", forState: .Normal)
            let maximumLabelSize = CGSizeMake(showSummaryLabel.frame.size.width, 800);
            let expectedSize = showSummaryLabel.sizeThatFits(maximumLabelSize)
            UIView.animateWithDuration(0.5, animations: {
                self.seeMoreButtonHeight.constant = expectedSize.height
                self.view.layoutIfNeeded()
            })
        }else {
            self.seeMoreButton.setTitle("See more", forState: .Normal)
            UIView.animateWithDuration(0.5, animations: {
                self.seeMoreButtonHeight.constant = 54
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func onSeasonButtonTapped(sender: UIButton) {
        CDHelper.shared.selectedShow = self.show
        let targetVC = self.storyboard?.instantiateViewControllerWithIdentifier("NESeasonEpisodeTVC") as? NESeasonEpisodeTVC
        self.navigationController?.pushViewController(targetVC!, animated: true)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetailsToCastDetailsSegue" {
            let targetVC = segue.destinationViewController as? NECastDetailVC
            let indexPaths = self.collectionView.indexPathsForSelectedItems()
            let indexPath = indexPaths![0]
            let cast = casts[indexPath.row]
            targetVC?.cast = cast
        }
    }
    
}
