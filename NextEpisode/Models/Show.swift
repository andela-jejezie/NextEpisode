//
//  Show.swift
//  NextEpisode
//
//  Created by Andela on 6/19/16.
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
            if let tvrage = externals["tvrage"] as? NSNumber {
                show.tvrage = tvrage
            }
            if let thetvdb = externals["thetvdb"] as? NSNumber {
                show.thetvdb = thetvdb
            }
            if let imdb = externals["imdb"] as? String {
                show.imdb = imdb
            }
        }
        if let network = dictionary["network"] as? [String:AnyObject] {
            let aNetwork = NSEntityDescription.insertNewObjectForEntityForName("Network",
                                                                              inManagedObjectContext: context) as! Network
            if let networkID = network["id"] as? NSNumber {
                aNetwork.networkID = networkID
            }
            if let name = network["name"] as? String {
                aNetwork.name = name
            }
            if let dict = network["country"] as? [String:AnyObject] {
                if let name = dict["name"] as? String {
                    aNetwork.countryName = name
                }
                if let code = dict["code"] as? String {
                    aNetwork.countryCode = code
                }
                if let timezone = dict["timezone"] as? String {
                    aNetwork.timeZone = timezone
                }
            }
        }
        if let schedule = dictionary["schedule"] as? [String:AnyObject] {
            if let time = schedule["time"] as? String {
                show.scheduleTime = time
            }
            
            if let days = schedule["days"] as? [String] {
                show.scheduleDays = days.joinWithSeparator(",")
            }
        }
        if let rating = dictionary["rating"] as? [String:AnyObject] {
            if let average = rating["average"] as? NSNumber {
                show.averageRating = average
            }
        }
        if let links = dictionary["_links"] as? [String:AnyObject] {
            if let selfLink = links["self"] as? [String:String] {
                if let link = selfLink["href"] {
                    show.currentEpisodeLink = link
                }
            }
            if let previousLink = links["previousepisode"] as? [String:String] {
                if let link = previousLink["href"] {
                    show.previousEpisodeLink = link
                }
            }
            if let nextLink = links["nextepisode"] as? [String:String] {
                if let link = nextLink["href"] {
                    show.nextEpisodeLink = link
                }
            }
        }
        
        if let showID = dictionary["id"] as? NSNumber {
            show.showID = showID
            print(CDHelper.shared.arrayOfFavoriteIDs)
            if CDHelper.shared.arrayOfFavoriteIDs.count > 0 {
                if CDHelper.shared.arrayOfFavoriteIDs.contains(show.showID!) {
                    show.isFavorite = true
                }
            }
        }
        return show
    }
}
