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
    var favorites = [Show]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 510
        self.title = "Favorites"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.tableView.registerNib(UINib(nibName: "NEShowTableViewCell", bundle: nil), forCellReuseIdentifier: "NEShowTableViewCell")
    }
    
    func performFetch(){
        let fetchRequest = NSFetchRequest(entityName: "Show")
        fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", true)
        do {
            let results = try CDHelper.shared.context.executeFetchRequest(fetchRequest) as? [Show]
            if results?.count > 0 {
                self.favorites = results!
                self.tableView.reloadData()
            }
        }catch {
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.performFetch()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let show = self.favorites[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("NEShowTableViewCell") as? NEShowTableViewCell
        cell!.readMoreButton.tag = indexPath.row
        cell!.favoriteButton.tag = indexPath.row
        cell!.readMoreButton.addTarget(self, action: #selector(NEFavoriteShowVC.readMoreButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell!.favoriteButton.addTarget(self, action: #selector(NEFavoriteShowVC.addFavorite(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell?.configureCellForShow(show)
        return cell!
    }
    
    func addFavorite(sender:UIButton) {
        let show = self.favorites[sender.tag]
        guard let showID = show.showID else {
            return
        }
        if show.isFavorite == true {
            show.isFavorite = false
            self.favorites.removeAtIndex(sender.tag)
            let index = CDHelper.shared.arrayOfFavoriteIDs.indexOf(showID)
            if let idx = index {
                CDHelper.shared.arrayOfFavoriteIDs.removeAtIndex(idx)
                CDHelper.setFavoritesToUserDefaults()
            }
        }
        
        CDHelper.saveSharedContext()
        tableView.reloadData()
    }
    
    func readMoreButtonClicked(sender:UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let show = self.favorites[indexPath.row]
        let showStoryboard = UIStoryboard(name: "Show", bundle: nil)
        let targetVC = showStoryboard.instantiateViewControllerWithIdentifier("NEShowDetailsVC") as? NEShowDetailsVC
        targetVC?.show = show
        targetVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }
    
    
    
}
