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
    
    var dropViewLabel: UILabel?
    var dropView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = true
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
        self.title = "All Shows"
        hideKeyboardWhenBackgroundIsTapped()
//        NETodayEpisodesAPI.getAllShow(context) 

    }
    
    func dropViewTapped(recognizer:UITapGestureRecognizer) {
        SwiftSpinner.show("Loading...")
        let searchText = self.searchController?.searchBar.text
        let formattedText = searchText?.stringByReplacingOccurrencesOfString(" ", withString: "-")
        NERequest.searchForShowsWithName(formattedText!, onCompletion: { (success, error) in
            if success == true {
               let predicate = NSPredicate(format: "name contains[cd] %@",searchText!)
               self.reloadFRC(predicate)
                 SwiftSpinner.hide()
            }
        })
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
    override func viewWillAppear(animated: Bool) {

    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.hideDropView()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.dropViewLabel?.text = "Can't find \(searchText)? Search here."
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
