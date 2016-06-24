//
//  CDTableViewController.swift
//  NextEpisode
//
//  Created by Andela on 5/4/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

class CDTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var searchButtton: UIBarButtonItem!
    var isSearching:Bool?
    // MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }    

    // MARK: - CELL CONFIGURATION
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
    
        // Use self.frc.objectAtIndexPath(indexPath) to get an object specific to a cell in the subclasses
        print("Please override configureCell in \(#function)!")
    }
    
    //MARK: - Configure search
    func configureSearch() {
        self.searchController = UISearchController(searchResultsController: nil)
        if let _searchController = self.searchController {
            _searchController.delegate = self
            _searchController.searchResultsUpdater = self
            _searchController.hidesNavigationBarDuringPresentation = false
            _searchController.dimsBackgroundDuringPresentation = false
            _searchController.searchBar.delegate = self
            _searchController.searchBar.sizeToFit()
            _searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
            searchBarButtonItem = navigationItem.rightBarButtonItem
        }else {
            print("error configuring _searchcontroller in %@", #function)
        }
    }
    
    // Override
    var entity = "MyEntity"
    var sort = [NSSortDescriptor(key: "myAttribute", ascending: true)]
    
    // Optionally Override
    var context = CDHelper.shared.context
    var filter:NSPredicate? = nil
    var cacheName:String? = nil
    var sectionNameKeyPath:String? = nil
    var fetchBatchSize = 0 // 0 = No Limit
    var cellIdentifier = "Cell"
    var isEpisode = true
    
    var searchController:UISearchController? = nil
    let episcodeCellIdentifier = "NEEpisodeTableViewCell"
    let showCellIdentifier = "NEShowTableViewCell"
    
    // MARK: - FETCHED RESULTS CONTROLLER
    lazy var frc: NSFetchedResultsController = {
        let request = NSFetchRequest(entityName:self.entity)
        request.sortDescriptors = self.sort
        request.fetchBatchSize  = self.fetchBatchSize
        if let _filter = self.filter {request.predicate = _filter}
        
        let newFRC = NSFetchedResultsController(
                            fetchRequest: request,
                    managedObjectContext: self.context,
                      sectionNameKeyPath: self.sectionNameKeyPath,
                               cacheName: self.cacheName)
        newFRC.delegate = self
        return newFRC
    }()
    
    //MARK: - RELOADFRC
    func reloadFRC (predicate:NSPredicate?) {
        self.filter = predicate
        self.frc.fetchRequest.predicate = predicate
        self.performFetch()
    }
    // MARK: - FETCHING
    func performFetch () {
        self.frc.managedObjectContext.performBlock ({
            do {
                try self.frc.performFetch()
            } catch {
                print("\(#function) FAILED : \(error)")
            }
            SwiftSpinner.hide()
            self.tableView.reloadData()
        })
    }

    // MARK: - VIEW
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        SwiftSpinner.show("Loading...")
        self.isSearching = false
        // Force fetch when notified of significant data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDTableViewController.performFetch), name: "SomethingChanged", object: nil)
        self.tableView.registerNib(UINib(nibName: "NEEpisodeTableViewCell", bundle: nil), forCellReuseIdentifier: self.episcodeCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "NEShowTableViewCell", bundle: nil), forCellReuseIdentifier: self.showCellIdentifier)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    
    // MARK: - DEALLOCATION
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "performFetch", object: nil)
    }
    
    // MARK: - DATA SOURCE: UITableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.frc.sections?.count ?? 0
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.frc.sections![section].numberOfObjects ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isEpisode {
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCellWithIdentifier("NESeasonEpisodeCell")
            self.configureCell(cell!, atIndexPath: indexPath)
            return cell!
        }else {
            var cell:NEShowTableViewCell?
            cell = (tableView.dequeueReusableCellWithIdentifier(self.showCellIdentifier) as? NEShowTableViewCell)!
            if cell == nil {
                tableView.registerNib(UINib(nibName: "NEShowTableViewCell", bundle: nil), forCellReuseIdentifier: self.showCellIdentifier)
                cell = tableView.dequeueReusableCellWithIdentifier(self.showCellIdentifier) as? NEShowTableViewCell
            }
            self.configureCell(cell!, atIndexPath: indexPath)
            return cell!
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.frc.sectionForSectionIndexTitle(title, atIndex: index)
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isEpisode {
            return "Season \(self.frc.sections![section].name) "
        }
        return self.frc.sections![section].name ?? ""
    }
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.frc.sectionIndexTitles
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isEpisode {
            return 44
        }
        return 510
    }
    
    // MARK: -  DELEGATE: UISearchController
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchBarText = searchController.searchBar.text {
            var predicate:NSPredicate?
            if searchBarText != "" {
                if self.isEpisode {
                    predicate = NSPredicate(format: "show.name contains[cd] %@",searchBarText)

                }else {
                    predicate = NSPredicate(format: "name contains[cd] %@",searchBarText)
                }
                self.reloadFRC(predicate)
            }
        }
    }
    
    // MARK: - DELEGATE: NSFetchedResultsController
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
        return
        }
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        isSearching = true
        showSearchBar()

    }
    
    
    func showSearchBar() {
        searchController?.searchBar.alpha = 0
        navigationItem.titleView = searchController?.searchBar
        navigationItem.setRightBarButtonItem(nil, animated: true)
        UIView.animateWithDuration(0.5, animations: {
            self.searchController?.searchBar.alpha = 1
            }, completion: { finished in
                self.searchController?.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        isSearching = false
        navigationItem.setRightBarButtonItem(searchBarButtonItem, animated: true)
        UIView.animateWithDuration(0.3, animations: {
            let navImageView = UIImageView(image: UIImage(named: "brand"))
            self.navigationItem.titleView = navImageView
            }, completion: { finished in
                
        })
    }
    
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        isSearching = false
        self.reloadFRC(nil)
        hideSearchBar()
        UIView.animateWithDuration(0.3) {
        }
    }
    var searchBarButtonItem: UIBarButtonItem?
    var logoImageView   : UIImageView!
     
}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(.TraitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(.TraitItalic)
    }
    
    func boldItalic() -> UIFont {
        return withTraits(.TraitBold, .TraitItalic)
    }
    
}
