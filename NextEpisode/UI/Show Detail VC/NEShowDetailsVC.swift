//
//  NEShowDetailsVC.swift
//  NextEpisode
//
//  Created by Andela on 5/7/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import Kingfisher

class NEShowDetailsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var seasonsButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var showSummary: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showNameLabel: UILabel!
    var show:Show!
    var casts:[Cast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        showNameLabel.text = show.name!
        showImageView.kf_setImageWithURL(NSURL(string: show.image!)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        showSummary.text = show.summary!
        ratingLabel.text = "Rating \(show.rating!.average!)/10"
        if show.casts?.count > 0 {
            casts = show.casts!.map({ ($0 as! Cast) })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        print(casts.count)
        print(show.casts?.count)
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
