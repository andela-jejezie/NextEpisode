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
   
    class func getTVSeriesScheduledTodayForCountryCode(var code:String) {
        if code.isEmpty {
            code = "US"
        }
        let endpoint = Constants.baseURL + "schedule?country=\(code)&date=\(currentDateInString())"
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
                }
            } catch {
                print("Error deserializing JSON: \(error)")
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
