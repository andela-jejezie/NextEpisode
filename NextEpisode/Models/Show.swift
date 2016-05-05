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
            show.showID = dictionary["id"] as? NSNumber
            show.url = dictionary["url"] as? String
            show.name = dictionary["name"] as? String
            show.language = dictionary["language"] as? String
            if let genres = dictionary["genres"] as? [String] {
                show.genres = genres.joinWithSeparator(",")
            }
            show.premiered = CDHelper.stringToDate((dictionary["premiered"] as? String)!)
            show.status = dictionary["status"] as? String
            show.runtime = dictionary["runtime"] as? NSNumber
            show.summary = dictionary["summary"] as? String
        
            if let imageDict = dictionary["image"] as? [String:String] {
                let imageString = imageDict["medium"]
                show.image = CDHelper.documentsPathForFileName(imageString!)
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
