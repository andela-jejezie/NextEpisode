//
//  Show.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Show: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    class func newInstance(dictionary: [String:AnyObject] ,
                           context: NSManagedObjectContext) -> Show {
        let show = NSEntityDescription.insertNewObjectForEntityForName("Show",
                                                                       inManagedObjectContext: context) as! Show
        if let showID = dictionary["id"] as? NSNumber {
            show.showID = showID
        }
        if let url = dictionary["url"] as? String {
            show.url = url
        }
        if let name = dictionary["name"] as? String {
            show.name = name
        }
        if let language = dictionary["language"] as? String {
            show.language = language
        }
        if let premiered = dictionary["premiered"] as? String {
            show.premiered = CDHelper.stringToDate(premiered)
        }
        
        if let genres = dictionary["genres"] as? [String] {
            show.genres = genres.joinWithSeparator(",")
        }
        if let status = dictionary["status"] as? String {
            show.status = status
        }
        if let summary = dictionary["summary"] as? String {
            show.summary = CDHelper.formatString(summary)
        }
        if let runtime = dictionary["runtime"] as? NSNumber {
            show.runtime = runtime
        }
        
        if let imageDict = dictionary["image"] as? [String:String] {
            let imageString = imageDict["original"]
            show.image = imageString
        }
        if let externals = dictionary["externals"] as? [String:AnyObject] {
            show.external = Externals.newInstance(externals, context: context)
        }
        if let network = dictionary["network"] as? [String:AnyObject] {
            show.network = Network.newInstance(network, context: context)
        }
        if let schedule = dictionary["schedule"] as? [String:AnyObject] {
            show.schedule = Schedule.newInstance(schedule, context: context)
        }
        if let rating = dictionary["rating"] as? [String:AnyObject] {
            show.rating = Rating.newInstance(rating, context: context)
        }
        if let links = dictionary["_links"] as? [String:AnyObject] {
            show.link = ShowLinks.newInstance(links, context: context)
        }

        return show
    }
    
}
