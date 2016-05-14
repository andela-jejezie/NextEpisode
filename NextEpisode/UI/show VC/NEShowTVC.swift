//
//  NEShowTVC.swift
//  NextEpisode
//
//  Created by Andela on 5/11/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit

class NEShowTVC: CDTableViewController {
    // MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // CDTableViewController subclass customization
        self.entity = "Show"
        self.sort = [NSSortDescriptor(key: "name", ascending: true)]
        self.sectionNameKeyPath = nil
        self.fetchBatchSize = 20
        self.isEpisode = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let appDomain = NSBundle.mainBundle().bundleIdentifier!
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.configureSearch()
        self.definesPresentationContext = true
//        NETodayEpisodesAPI.getAllShow(context) 

    }
    
    // MARK: - VIEW
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performFetch()
    }
    override func viewWillAppear(animated: Bool) {
    }
    // MARK: - CELL CONFIGURATION
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let show = frc.objectAtIndexPath(indexPath) as? Show {
            (cell as! NEShowTableViewCell).readMoreButton.tag = indexPath.row
            (cell as! NEShowTableViewCell).favoriteButton.tag = indexPath.row
            (cell as! NEShowTableViewCell).readMoreButton.addTarget(self, action: #selector(NEShowTVC.readMoreButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            (cell as! NEShowTableViewCell).favoriteButton.addTarget(self, action: #selector(NEShowTVC.addFavorite(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            (cell as! NEShowTableViewCell).configureCellForShow(show)
        }else {print("ERROR getting item in \(#function)")}
    }
    
    func addFavorite(sender:UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let show = frc.objectAtIndexPath(indexPath) as? Show
        
        let item = CDHelper.shared.arrayOfFavoriteID.indexOf(show!.showID!)
        if (item != nil) {
            CDHelper.shared.arrayOfFavoriteID.removeAtIndex(CDHelper.shared.arrayOfFavoriteID.indexOf((show?.showID!)!)!)
            CDHelper.shared.favoriteShows.removeAtIndex(CDHelper.shared.favoriteShows.indexOf(show!)!)
        }else {
            CDHelper.shared.arrayOfFavoriteID.append((show?.showID!)!)
            CDHelper.shared.favoriteShows.append(show!)
        }
        NSUserDefaults.standardUserDefaults().setObject(CDHelper.shared.arrayOfFavoriteID, forKey: "NEFavoriteShows")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.tableView.reloadData()
    }
    
    func readMoreButtonClicked(sender:UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let show = frc.objectAtIndexPath(indexPath) as? Show
        let showStoryboard = UIStoryboard(name: "Show", bundle: nil)
        let targetVC = showStoryboard.instantiateViewControllerWithIdentifier("NEShowDetailsVC") as? NEShowDetailsVC
        targetVC?.show = show
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }

}
