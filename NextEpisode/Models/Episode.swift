//
//  Episode.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Episode: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
        context: NSManagedObjectContext) -> Episode {
            let episode = NSEntityDescription.insertNewObjectForEntityForName("Episode",
                inManagedObjectContext: context) as! Episode
            episode.episode = dictionary["number"] as? NSNumber
            episode.episodeID = dictionary["id"] as? NSNumber
            episode.name = dictionary["name"] as? String
            episode.season = dictionary["season"] as? NSNumber
            episode.airdate = CDHelper.stringToDate((dictionary["airdate"] as? String)!)
            episode.airtime = dictionary["airtime"] as? String
            episode.runtime = dictionary["runtime"] as? NSNumber
            if let imageDict = dictionary["image"] as? [String:String] {
                let imageString = imageDict["medium"]
                episode.image = CDHelper.documentsPathForFileName(imageString!)
            }
            episode.url = dictionary["url"] as? String
            episode.summary = dictionary["summary"] as? String
            episode.show = Show.newInstance((dictionary["show"] as? [String:AnyObject])!, context: context)
            return episode
    }

}
