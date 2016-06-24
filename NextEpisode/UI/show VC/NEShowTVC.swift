//
//  NEShowTVC.swift
//  NextEpisode
//
//  Created by Andela on 5/11/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

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
    
    var dropViewLabel: UILabel?
    var dropView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = true
        
        self.title = "All Shows"
        setUpSearcBar()
        setUpDropView()
        NERequest.getAllShow { (shows, errorMessage) in
            dispatch_async(dispatch_get_main_queue(), { 
                if let _ = shows {
                    for show in shows! {
                        Show.newInstance(show, context: CDHelper.shared.context)
                    }
                    CDHelper.saveSharedContext()
                    self.performFetch()
                }
            })
        }


    }
    
    func setUpSearcBar(){
        let navImageView = UIImageView(image: UIImage(named: "brand"))
        self.navigationItem.titleView = navImageView
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "search"), forState: .Normal)
        button.addTarget(self, action: #selector(CDTableViewController.searchButtonPressed(_:)), forControlEvents: .TouchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        self.searchButtton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = self.searchButtton
        //        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        //        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        self.searchController = UISearchController(searchResultsController:  nil)
        self.configureSearch()
        self.definesPresentationContext = true
    }
    
    func setUpDropView(){
        dropView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 44))
        dropView?.backgroundColor = UIColor.whiteColor()
        let searchImageView = UIImageView(frame: CGRect(x: 8, y: 7, width: 30, height: 30))
        searchImageView.image = UIImage(named: "searchBlue")
        dropViewLabel = UILabel(frame: CGRect(x: 42, y: 13, width: self.view.frame.size.width-45, height: 18))
        dropViewLabel?.numberOfLines = 0
        dropViewLabel?.font = UIFont.systemFontOfSize(15)
        let lineView = UIView(frame: CGRect(x: 0, y: self.dropView!.frame.size.height-1, width: self.view.frame.size.width, height: 1))
        lineView.backgroundColor = UIColor.lightGrayColor()
        dropView?.addSubview(lineView)
        dropView?.addSubview(searchImageView)
        dropView?.addSubview(dropViewLabel!)
        dropView?.alpha = 0
        let tgr = UITapGestureRecognizer(target: self, action: #selector(NEShowTVC.dropViewTapped(_:)))
        tgr.numberOfTapsRequired = 1
        dropView?.addGestureRecognizer(tgr)
        self.navigationController?.view.addSubview(dropView!)
    }
    
    func dropViewTapped(recognizer:UITapGestureRecognizer) {
        SwiftSpinner.show("Loading...")
        let searchText = self.searchController?.searchBar.text
        let formattedText = searchText?.stringByReplacingOccurrencesOfString(" ", withString: "-")
        if let text = formattedText {
            NERequest.searchForShowsWithName(text, completionHandler: { (shows, errorMessage) in
                dispatch_async(dispatch_get_main_queue(), { 
                    if let _ = shows {
                        for show in shows! {
                            if let showDictionary = show as? [String:AnyObject] {
                                if let showDict = showDictionary["show"] as? [String:AnyObject] {
                                    Show.newInstance(showDict, context: CDHelper.shared.context)
                                }
                            }
                        }
                        CDHelper.saveSharedContext()
                        let predicate = NSPredicate(format: "name contains[cd] %@",searchText!)
                        self.reloadFRC(predicate)
                        SwiftSpinner.hide()
                    }
                })
            })
        }
    }
    
    func hideKeyboard () {
        self.searchController?.searchBar.endEditing(true)
    }
    
    func hideKeyboardWhenBackgroundIsTapped () {
        let tgr = UITapGestureRecognizer(target: self, action:#selector(NEShowTVC.hideKeyboard))
        tgr.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tgr)
    }
    
    // MARK: - VIEW
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.performFetch()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.hideDropView()
    }
    
    override func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        super.searchBarCancelButtonClicked(searchBar)
        self.hideDropView()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.dropViewLabel?.text = "Can't find \(searchText)? Tap here."
        if self.dropView?.alpha == 0 {
            self.unHideDropView()
        }
        if searchText == "" {
            self.hideDropView()
        }
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isSearching == true {
            self.searchController?.searchBar.endEditing(true)
            isSearching = false
            return
        }
        let show = frc.objectAtIndexPath(indexPath) as? Show
        let showStoryboard = UIStoryboard(name: "Show", bundle: nil)
        let targetVC = showStoryboard.instantiateViewControllerWithIdentifier("NEShowDetailsVC") as? NEShowDetailsVC
        targetVC?.show = show
        targetVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }
    
    func addFavorite(sender:UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let show = frc.objectAtIndexPath(indexPath) as? Show
        guard let showID = show?.showID else {
            return
        }
        print(show!.isFavorite)
            if show?.isFavorite == true {
                show?.isFavorite = false
                let index = CDHelper.shared.arrayOfFavoriteIDs.indexOf(showID)
                if let idx = index {
                    CDHelper.shared.arrayOfFavoriteIDs.removeAtIndex(idx)
                }
            }else {
                show?.isFavorite = true
                CDHelper.shared.arrayOfFavoriteIDs.append(showID)
            }
        CDHelper.setFavoritesToUserDefaults()
        CDHelper.saveSharedContext()
        tableView.reloadData()
    }
    
    @IBAction func onDropViewTapped(sender: AnyObject) {
    }
    
    
    func unHideDropView () {
        UIView.animateWithDuration(0.3) { 
            self.dropView?.alpha = 1
            self.tableView.contentInset = UIEdgeInsetsMake(108, 0, 0, 0)
            self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
            self.tableView.layoutIfNeeded()
        }
    }
    func hideDropView() {
        UIView.animateWithDuration(0.3) {
            self.dropView?.alpha = 0
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
            self.tableView.layoutIfNeeded()
        }
    }
    
    func readMoreButtonClicked(sender:UIButton) {
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let show = frc.objectAtIndexPath(indexPath) as? Show
        let showStoryboard = UIStoryboard(name: "Show", bundle: nil)
        let targetVC = showStoryboard.instantiateViewControllerWithIdentifier("NEShowDetailsVC") as? NEShowDetailsVC
        targetVC?.show = show
        targetVC?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }
}

//        hideKeyboardWhenBackgroundIsTapped()
//let dateSinceLastUpdate = NSUserDefaults.standardUserDefaults().objectForKey("dateSinceLastUpdate") as? NSDate
//if let lastUpdate = dateSinceLastUpdate {
//    let secondsSinceUpdate = Int(NSDate().timeIntervalSinceDate(lastUpdate))
//    if secondsSinceUpdate > 259200  {
//        NERequest.getAllShow({ (success, error) in
//            if success == true {
//                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "dateSinceLastUpdate")
//            }
//        })
//    }
//}else {
//    NERequest.getAllShow({ (success, error) in
//        if success == true {
//            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "dateSinceLastUpdate")
//            NSUserDefaults.standardUserDefaults().synchronize()
//        }
//    })
//}
