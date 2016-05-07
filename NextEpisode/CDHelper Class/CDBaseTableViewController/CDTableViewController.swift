//
//  CDTableViewController.swift
//  Groceries
//
//  Created by Tim Roadley on 2/10/2015.
//  Copyright © 2015 Tim Roadley. All rights reserved.
//

import UIKit
import CoreData

class CDTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - INITIALIZATION
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }    

    // MARK: - CELL CONFIGURATION
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
    
        // Use self.frc.objectAtIndexPath(indexPath) to get an object specific to a cell in the subclasses
        print("Please override configureCell in \(#function)!")
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
    
    let episcodeCellIdentifier = "NEEpisodeTableViewCell"
    
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
    
    // MARK: - FETCHING
    func performFetch () {
        self.frc.managedObjectContext.performBlock ({

            do {
                try self.frc.performFetch()
            } catch {
                print("\(#function) FAILED : \(error)")
            }
            self.tableView.reloadData()
        })
    }

    // MARK: - VIEW
    override func viewDidLoad() {
        super.viewDidLoad()
//        NETodayEpisodesAPI.getTVSeriesScheduledTodayForCountryCode("")
        // Force fetch when notified of significant data changes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDTableViewController.performFetch), name: "SomethingChanged", object: nil)
        self.tableView.registerNib(UINib(nibName: "NEEpisodeTableViewCell", bundle: nil), forCellReuseIdentifier: self.episcodeCellIdentifier)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        var cell:NEEpisodeTableViewCell?
        if isEpisode {
            cell = (tableView.dequeueReusableCellWithIdentifier(self.episcodeCellIdentifier) as? NEEpisodeTableViewCell)!
            if cell == nil {
                tableView.registerNib(UINib(nibName: "NEEpisodeTableViewCell", bundle: nil), forCellReuseIdentifier: self.episcodeCellIdentifier)
                cell = tableView.dequeueReusableCellWithIdentifier(self.episcodeCellIdentifier) as? NEEpisodeTableViewCell
            }

        }
        
        self.configureCell(cell!, atIndexPath: indexPath)
        return cell!
    }
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.frc.sectionForSectionIndexTitle(title, atIndex: index)
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.frc.sections![section].name ?? ""
    }
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.frc.sectionIndexTitles
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 510
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
    
}