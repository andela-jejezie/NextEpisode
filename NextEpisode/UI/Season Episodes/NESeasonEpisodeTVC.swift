//
//  NESeasonEpisodeTVC.swift
//  NextEpisode
//
//  Created by Andela on 5/13/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit

class NESeasonEpisodeTVC: CDTableViewController {
    var showID:NSNumber!
    // MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // CDTableViewController subclass customization
        self.entity = "Episode"
        self.sort = [NSSortDescriptor(key: "season", ascending: true),   NSSortDescriptor(key: "episode", ascending: true)]
        self.sectionNameKeyPath = "season"
        self.fetchBatchSize = 20
        self.filter = NSPredicate(format: "showID == %@", CDHelper.shared.selectedShow.showID!)
        self.isEpisode = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.tableView.rowHeight = 44;
        if CDHelper.shared.selectedShow?.episodes?.count == 0 {
            let showString = String(CDHelper.shared.selectedShow.showID!)
            print(showString)
            NETodayEpisodesAPI.getEpisodesForShowWithID(showString, onCompletion: { (success) in
                print("fetched \(success) ")
            })
        }
        
    }
    
    // MARK: - VIEW
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performFetch()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let episode = frc.objectAtIndexPath(indexPath) as? Episode
        let episodeStoryboard = UIStoryboard(name: "Episode", bundle: nil)
        let targetVC = episodeStoryboard.instantiateViewControllerWithIdentifier("NEEpisodeDetailVC") as? NEEpisodeDetailVC
        targetVC?.episode = episode
        targetVC?.show = CDHelper.shared.selectedShow
        self.navigationController?.pushViewController(targetVC!, animated: true)        
    }
    
    // MARK: - CELL CONFIGURATION
    override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        if let episode = frc.objectAtIndexPath(indexPath) as? Episode {
          cell.textLabel?.text = "Episode \(episode.episode!)"
            cell.detailTextLabel?.text = episode.name
        }else {print("ERROR getting item in \(#function)")}
    }
    
    
}
