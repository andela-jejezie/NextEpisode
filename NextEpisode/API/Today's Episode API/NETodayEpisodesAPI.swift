//
//  NETodayEpisodesAPI.swift
//  NextEpisode
//
//  Created by Andela on 5/4/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData

class NETodayEpisodesAPI: NSObject {
    
    typealias ServiceResponse = ([AnyObject]?, NSError?) -> Void
    typealias completionBlock = (Bool?)->Void
   
    class func getTVSeriesScheduledTodayForCountryCode(code:String, context:NSManagedObjectContext) {
        var codeString = code
        if codeString.isEmpty {
            codeString = "US"
        }
        let endpoint = Constants.baseURL + "schedule?country=\(codeString)&date=\(currentDateInString())"
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("Error fetching data: \(error)")
                return
            }
            do {
                if let series = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [[String: AnyObject]] {
                    for tvseries in series {
                        Episode.newInstance(tvseries, context: context, showID: "")
                    }
                    CDHelper.saveSharedContext()
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }

        }
        task.resume()
    }
    
    class func getAllShow(context:NSManagedObjectContext){
        let endpoint = Constants.baseURL + "shows"
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("Error fetching data: \(error)")
                return
            }
            do {
                if let series = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [[String: AnyObject]] {
                    for tvseries in series {
                        Show.newInstance(tvseries, context: context)
                    }
                    CDHelper.saveSharedContext()
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        task.resume()
    }

    
    class func getEpisodesForShowWithID(showID:String, onCompletion:completionBlock) {
        let fetchRequest = NSFetchRequest(entityName: "Show")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "showID == %@", showID)
        let context = CDHelper.shared.context
        var show:Show?
        do {
            let result = try context.executeFetchRequest(fetchRequest) as? [Show]
            print(result?.count)
            show = result![0]
            let showEpisodes = show?.episodes?.mutableCopy() as? NSMutableSet
           NETodayEpisodesAPI.episodes(showID, onCompletion: { (object, error) in
            for episodeDict in object! {
                if let dict = episodeDict as? [String:AnyObject] {
                    let episode = Episode.newInstance(dict, context: context, showID: showID)
                    showEpisodes?.addObject(episode)
                }
            }
            show?.episodes = showEpisodes?.mutableCopy() as? NSSet
            CDHelper.saveSharedContext()
            onCompletion(true)
           })
            
            }catch {
            
            }
    }
    class func episodes(showID:String, onCompletion:ServiceResponse) {
        let endpoint = Constants.baseURL + "shows/\(showID)/episodes"
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            return onCompletion(nil, nil)
        }
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("Error fetching data: \(error)")
                onCompletion(nil, error)
                return
            }
            
            do {
                if let arrayObjects = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [AnyObject] {
                    onCompletion(arrayObjects, nil)
                }
                
            } catch {
                print("Error deserializing JSON: \(error)")
                onCompletion(nil, nil)
            }
            
        }
        task.resume()
    }
    
    class func getCastForShow(showID:String, onCompletion:ServiceResponse) {
        let fetchRequest = NSFetchRequest(entityName: "Show")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "showID == %@", showID)
        let context = CDHelper.shared.context
        var show:Show?
        do {
            let result = try context.executeFetchRequest(fetchRequest) as? [Show]
            print(result?.count)
            show = result![0]
            let showCasts = show?.casts?.mutableCopy() as? NSMutableSet
            NETodayEpisodesAPI.casts(showID, onCompletion: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        if let dict = object as? [String:AnyObject] {
                            let cast = Cast.newInstance(dict, context: context)
                            showCasts?.addObject(cast)
                        }
                    }
                    show?.casts = showCasts?.mutableCopy() as? NSSet
                    CDHelper.saveSharedContext()
                    onCompletion([], error)
                }
            })
        }catch {
            
        }
    }
    class func casts(showID:String, onCompletion:ServiceResponse) {
        let endpoint = Constants.baseURL + "shows/\(showID)/cast"
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            return onCompletion(nil, nil)
        }
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("Error fetching data: \(error)")
                onCompletion(nil, error)
                return
            }
            
            do {
                if let arrayObjects = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [AnyObject] {
                    onCompletion(arrayObjects, nil)
                }
                
            } catch {
                print("Error deserializing JSON: \(error)")
                onCompletion(nil, nil)
            }
            
        }
        task.resume()
    }
    
    
    class func currentDateInString()->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.stringFromDate(NSDate())
    }
    
}
