//
//  NEShowDetailsVC.swift
//  NextEpisode
//
//  Created by Andela on 5/7/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import Kingfisher

class NEShowDetailsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var showSummaryTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var seasonsButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showNameLabel: UILabel!
    var show:Show!
    var casts:[Cast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let showIDString = String(show.showID!)
        showSummaryTextView.layer.borderWidth = 1
        showSummaryTextView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3).CGColor
        showSummaryTextView.layer.cornerRadius = 4
        collectionView.dataSource = self
        collectionView.delegate = self
        showNameLabel.text = show.name!
        showImageView.kf_setImageWithURL(NSURL(string: show.image!)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        showSummaryTextView.text = show.summary!
        ratingLabel.text = "Rating \(show.rating!.average!)/10"
        if show.casts?.count > 0 {
            casts = show.casts!.map({ ($0 as! Cast) })
        }
        if show.casts?.count == 0 {
            NETodayEpisodesAPI.getCastForShow(showIDString, onCompletion: { (res, error) in
                dispatch_async(dispatch_get_main_queue(), { 
                    if self.show.casts?.count > 0 {
                        self.casts = self.show.casts!.map({ ($0 as! Cast) })
                    }
                    self.collectionView.reloadData()
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
        cell?.moreButton.tag = indexPath.row
        cell?.moreButton.addTarget(self, action: #selector(NEShowDetailsVC.readMoreButtonClicked(_:)), forControlEvents: .TouchUpInside)
        cell?.configureCellForData(cast)
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowDetailsToCastDetailsSegue", sender: nil)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height)
    }
    
    @IBAction func onSeasonButtonTapped(sender: UIButton) {
        CDHelper.shared.selectedShow = self.show
       let targetVC = self.storyboard?.instantiateViewControllerWithIdentifier("NESeasonEpisodeTVC") as? NESeasonEpisodeTVC
        self.navigationController?.pushViewController(targetVC!, animated: true)

    }
    func readMoreButtonClicked(sender:UIButton) {
        let cast = casts[sender.tag]
        UIApplication.sharedApplication().openURL(NSURL(string: (cast.person?.url!)!)!)
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
