//
//  TodayEpisodesVC.swift
//  NextEpisode
//
//  Created by Andela on 5/6/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit

class TodayEpisodesVC: CDTableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    // MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // CDTableViewController subclass customization
        self.entity = "Episode"
        self.sort = [NSSortDescriptor(key: "airtime", ascending: true)]
        self.sectionNameKeyPath = nil
        self.fetchBatchSize = 20
        
    }
    var searchController : UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
    }
    
    // MARK: - VIEW
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performFetch()
    }
    
    // MARK: - CELL CONFIGURATION
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let episode = frc.objectAtIndexPath(indexPath) as? Episode {
            (cell as! NEEpisodeTableViewCell).readMoreButton.tag = indexPath.row
            (cell as! NEEpisodeTableViewCell).readMoreButton.addTarget(self, action: #selector(TodayEpisodesVC.readMoreButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)

            (cell as! NEEpisodeTableViewCell).configureCellForEpisode(episode)
        }else {print("ERROR getting item in \(#function)")}
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
    func readMoreButtonClicked(sender:UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let episode = frc.objectAtIndexPath(indexPath) as? Episode
        let episodeStoryboard = UIStoryboard(name: "Episode", bundle: nil)
        let targetVC = episodeStoryboard.instantiateViewControllerWithIdentifier("NEEpisodeDetailVC") as? NEEpisodeDetailVC
        targetVC?.episode = episode
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }
}
