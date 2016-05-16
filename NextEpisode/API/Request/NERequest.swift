//
//  NERequest.swift
//  NextEpisode
//
//  Created by Andela on 5/16/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData

class NERequest: NSObject {
    
    typealias showsResponse = (Bool?, NSError?)->Void
    class func searchForShowsWithName(name:String, onCompletion:showsResponse) {
        let endpoint = Constants.baseURL + "search/shows?q=\(name)"
        guard let url = NSURL(string: endpoint) else {
            print("failed to create url",#function)
            return
        }
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let responseData = data else {
                print("didn't get data", #function)
                return
            }
            guard error == nil else {
                print("an error occured \(error?.localizedDescription)")
                return
            }
            let context = CDHelper.shared.context
            do {
                if let showJson = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [AnyObject] {
                    for showObject in showJson {
                        if let showDictionary = showObject as? [String:AnyObject] {
                            if let showDict = showDictionary["show"] as? [String:AnyObject] {
                                deleteIfAlreadyExist(String(showDict["id"]!), context: context)
                              Show.newInstance(showDict, context: context)
                            }
                        }
                    }
                    CDHelper.saveSharedContext()
                    onCompletion(true, error)
                }
            }catch {
               
            }
            onCompletion(true, error)
        }
        task.resume()
    }
    
    class func deleteIfAlreadyExist(showID:String, context:NSManagedObjectContext){
        let fetchRequest = NSFetchRequest(entityName: "Show")
        fetchRequest.predicate = NSPredicate(format:"showID == %@",showID)
        do {
            let shows = try context.executeFetchRequest(fetchRequest) as? [Show]
            if shows?.count>0 {
                context.deleteObject(shows![0] as Show)
                CDHelper.saveSharedContext()
            }
        }catch {
            
        }
    }
}

 