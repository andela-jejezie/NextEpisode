//
//  CDHelper.swift
//  NextEpisode
//
//  Created by Andela on 5/4/16.
//  Copyright © 2016 Andela. All rights reserved.
//

//
//  CDHelper.swift
//  Groceries
//
//  Created by Tim Roadley on 29/09/2015.
//  Copyright © 2015 Tim Roadley. All rights reserved.
//

import Foundation
import CoreData

private let _sharedCDHelper = CDHelper()
class CDHelper : NSObject  {
    
    // MARK: - SHARED INSTANCE
    class var shared : CDHelper {
        return _sharedCDHelper
    }
    
    // MARK: - PATHS
    lazy var storesDirectory: NSURL? = {
        let fm = NSFileManager.defaultManager()
        let urls = fm.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    lazy var localStoreURL: NSURL? = {
        if let url = self.storesDirectory?.URLByAppendingPathComponent("LocalStore.sqlite") {
            print("localStoreURL = \(url)")
            return url
        }
        return nil
    }()
    lazy var modelURL: NSURL = {
        let bundle = NSBundle.mainBundle()
        if let url = bundle.URLForResource("TVSeries", withExtension: "momd") {
            return url
        }
        print("CRITICAL - Managed Object Model file not found")
        abort()
    }()
    
    // MARK: - CONTEXT
    lazy var context: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType:.MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.coordinator
        return moc
    }()
    
    // MARK: - MODEL
    lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL:self.modelURL)!
    }()
    
    // MARK: - COORDINATOR
    lazy var coordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel:self.model)
    }()
    
    // MARK: - STORE
    lazy var localStore: NSPersistentStore? = {
        let options:[NSObject:AnyObject] = [NSSQLitePragmasOption:["journal_mode":"DELETE"],
            NSMigratePersistentStoresAutomaticallyOption:1,
            NSInferMappingModelAutomaticallyOption:1]
        var _localStore:NSPersistentStore?
        do {
            _localStore = try self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.localStoreURL, options: options)
            return _localStore
        } catch {
            return nil
        }
    }()
    
    // MARK: - SETUP
    required override init() {
        super.init()
        self.setupCoreData()
    }
    func setupCoreData() {
        
        /* // Model Migration
        if let _localStoreURL = self.localStoreURL {
        CDMigration.shared.migrateStoreIfNecessary(_localStoreURL, destinationModel: self.model)
        } */
        
        // Load Local Store
        _ = self.localStore
    }
    
    // MARK: - SAVING
    class func save(moc:NSManagedObjectContext) {
        
        moc.performBlockAndWait {
            
            if moc.hasChanges {
                
                do {
                    try moc.save()
                    print("SAVED context \(moc.description)")
                } catch {
                    print("ERROR saving context \(moc.description) - \(error)")
                }
            } else {
                print("SKIPPED saving context \(moc.description) because there are no changes")
            }
            if let parentContext = moc.parentContext {
                save(parentContext)
            }
        }
    }
    class func saveSharedContext() {
        save(shared.context)
    }
    
    class func stringToDate(date:String)->NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.dateFromString(date)!
    }
    class func documentsPathForFileName(name:String)->String {
        let data = NSData(contentsOfURL: NSURL(string: name)!)
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentPath = path[0]
        let filePath = documentPath.stringByAppendingString(name)
        data?.writeToFile(filePath, atomically: true)
        return filePath
    }
}
