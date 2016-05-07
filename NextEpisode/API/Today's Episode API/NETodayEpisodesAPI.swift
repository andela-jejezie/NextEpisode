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
   
    class func getTVSeriesScheduledTodayForCountryCode(code:String) {
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
            let context = CDHelper.shared.context
            
            do {
                if let series = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [[String: AnyObject]] {
                    for tvseries in series {
                        Episode.newInstance(tvseries, context: context)
                    }
                    CDHelper.saveSharedContext()
                    NETodayEpisodesAPI.getCastForAllShows()
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }

        }
        task.resume()
    }
    
    class func getCastForShowWithID(showID:String, onCompletion:ServiceResponse) {
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
    
    class func getCastForAllShows() {
        let fetchRequest = NSFetchRequest(entityName: "Show")
        let context = CDHelper.shared.context
        do {
            let result = try context.executeFetchRequest(fetchRequest) as? [Show]
            for show in result! {
               let showIDString = String(show.showID!)
                let plentyCast = NSMutableSet()
                NETodayEpisodesAPI.getCastForShowWithID(showIDString) { (casts, error) in
                    for hbjkd in casts! {
                        if let castArray:[String:AnyObject] = hbjkd as? [String : AnyObject] {
                            let cast = Cast.newInstance(castArray, context: context) as Cast
                            plentyCast.addObject(cast)
                        }
                    }
                    show.casts = plentyCast.mutableCopy() as? NSSet
                    CDHelper.saveSharedContext()
                    print("cast saved")
                }
            }
        }catch {
            
        }
        

    }
    
    
    class func currentDateInString()->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.stringFromDate(NSDate())
    }
    
}
