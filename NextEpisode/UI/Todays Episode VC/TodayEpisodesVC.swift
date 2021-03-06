//
//  TodayEpisodesVC.swift
//  NextEpisode
//
//  Created by Andela on 5/6/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit

class TodayEpisodesVC: CDTableViewController {
    
    
    // MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // CDTableViewController subclass customization
        self.entity = "Episode"
        self.sort = [NSSortDescriptor(key: "airtime", ascending: true)]
        self.sectionNameKeyPath = nil
        self.fetchBatchSize = 20
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController = UISearchController(searchResultsController:  nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
//      self.configureSearch()
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
//        NETodayEpisodesAPI.getTVSeriesScheduledTodayForCountryCode("", context: context)
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

    func readMoreButtonClicked(sender:UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let episode = frc.objectAtIndexPath(indexPath) as? Episode
        let episodeStoryboard = UIStoryboard(name: "Episode", bundle: nil)
        let targetVC = episodeStoryboard.instantiateViewControllerWithIdentifier("NEEpisodeDetailVC") as? NEEpisodeDetailVC
        targetVC?.episode = episode
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }
}
