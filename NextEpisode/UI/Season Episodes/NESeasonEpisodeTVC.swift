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
        self.filter = NSPredicate(format: "show == %@", CDHelper.shared.selectedShow)
        self.isEpisode = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.definesPresentationContext = true
        self.tableView.rowHeight = 44;
            let showString = String(CDHelper.shared.selectedShow.showID!)
            
            NERequest.getEpisodes(showString, completionHandler: { (episodes, errorMessage) in
                dispatch_async(dispatch_get_main_queue(), { 
                    if let _ = episodes {
                        for episodeDict in episodes! {
                            if let dict = episodeDict as? [String:AnyObject] {
                                Episode.newInstance(dict, context: CDHelper.shared.context, show: CDHelper.shared.selectedShow)
                            }
                        }
                        CDHelper.saveSharedContext()
                        self.performFetch()
                    }
                })
            })
        title = "\(CDHelper.shared.selectedShow.name!) Seasons"
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
            let accessoryImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            accessoryImageView.image = UIImage(named: "online")
            if let airtime = episode.airtime {
                let components = airtime.componentsSeparatedByString(":")
                let hour = Int(components[0])
                if var airdate = episode.airdate {
                    let calendar = NSCalendar.currentCalendar()
                    if let _hour = hour {
                        airdate = calendar.dateByAddingUnit(.Hour, value: _hour, toDate: airdate, options: [])!
                    }
                    if airdate.timeIntervalSince1970 >= NSDate().timeIntervalSince1970{
                        accessoryImageView.image = UIImage(named: "offline")
                    }else {
                        accessoryImageView.image = UIImage(named: "online")
                    }

                }
            }

            cell.accessoryView = accessoryImageView
          cell.textLabel?.text = "Episode \(episode.episode!)"
            cell.detailTextLabel?.text = episode.name
        }else {print("ERROR getting item in \(#function)")}
    }
    
    
}
