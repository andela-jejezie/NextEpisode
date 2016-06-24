//
//  Episode.swift
//  NextEpisode
//
//  Created by Andela on 6/19/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Episode: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
                           context: NSManagedObjectContext, show:Show) -> Episode {
        let episode = NSEntityDescription.insertNewObjectForEntityForName("Episode",
                                                                          inManagedObjectContext: context) as! Episode
        if let episdeNumber = dictionary["number"] as? NSNumber {
            episode.episode = episdeNumber
        }
        if let episdeID = dictionary["id"] as? NSNumber {
            episode.episodeID = episdeID
        }
        if let name = dictionary["name"] as? String {
            episode.name = name
        }
        if let season = dictionary["season"] as? NSNumber {
            episode.season = season
        }
        if let airdate = dictionary["airdate"] as? String {
            episode.airdate = CDHelper.stringToDate(airdate)
            
        }
        if let airtime = dictionary["airtime"] as? String {
            episode.airtime = airtime
        }
        if let runtime  = dictionary["runtime"] as? NSNumber {
            episode.runtime = runtime
        }
        if let imageDict = dictionary["image"] as? [String:String] {
            let imageString = imageDict["medium"]
            episode.image = imageString
        }
        if let url = dictionary["url"] as? String {
            episode.url = url
        }
        if let summary = dictionary["summary"] as? String {
            episode.summary = CDHelper.formatString(summary)
        }
        episode.show = show
        return episode
    }
}
