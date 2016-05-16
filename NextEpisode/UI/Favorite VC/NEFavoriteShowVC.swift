//
//  NEFavoriteShowVC.swift
//  NextEpisode
//
//  Created by Andela on 5/14/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

class NEFavoriteShowVC: NEGenericVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 510
        self.title = "Favorites"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.registerNib(UINib(nibName: "NEShowTableViewCell", bundle: nil), forCellReuseIdentifier: "NEShowTableViewCell")
        for showID in CDHelper.shared.arrayOfFavoriteID {
            let context = CDHelper.shared.context
            let fetchRequest = NSFetchRequest(entityName: "Show")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format:"showID == %@",showID)
            do {
                let results = try context.executeFetchRequest(fetchRequest) as? [Show]
                if results?.count > 0 {
                    CDHelper.shared.favoriteShows.append(results![0])
                    self.tableView.reloadData()
                }
            }catch {
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CDHelper.shared.favoriteShows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let show = CDHelper.shared.favoriteShows[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("NEShowTableViewCell") as? NEShowTableViewCell
        cell!.readMoreButton.tag = indexPath.row
        cell!.favoriteButton.tag = indexPath.row
        cell!.readMoreButton.addTarget(self, action: #selector(NEFavoriteShowVC.readMoreButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell!.favoriteButton.addTarget(self, action: #selector(NEFavoriteShowVC.addFavorite(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell?.configureCellForShow(show)
        return cell!
    }
    
    func addFavorite(sender:UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let show = CDHelper.shared.favoriteShows[indexPath.row]
        let item = CDHelper.shared.arrayOfFavoriteID.indexOf(show.showID!)
        if (item != nil) {
            CDHelper.shared.arrayOfFavoriteID.removeAtIndex(CDHelper.shared.arrayOfFavoriteID.indexOf((show.showID!))!)
            CDHelper.shared.favoriteShows.removeAtIndex(sender.tag)
        }
        NSUserDefaults.standardUserDefaults().setObject(CDHelper.shared.arrayOfFavoriteID, forKey: "NEFavoriteShows")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.tableView.reloadData()
    }
    
    func readMoreButtonClicked(sender:UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let show = CDHelper.shared.favoriteShows[indexPath.row]
        let showStoryboard = UIStoryboard(name: "Show", bundle: nil)
        let targetVC = showStoryboard.instantiateViewControllerWithIdentifier("NEShowDetailsVC") as? NEShowDetailsVC
        targetVC?.show = show
        targetVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }
    
    

}
