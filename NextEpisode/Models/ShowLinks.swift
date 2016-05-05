//
//  ShowLinks.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class ShowLinks: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
        context: NSManagedObjectContext) -> ShowLinks {
            let showlinks = NSEntityDescription.insertNewObjectForEntityForName("ShowLinks",
                inManagedObjectContext: context) as! ShowLinks
            if let selfLink = dictionary["self"] as? [String:String] {
               showlinks.showLink = selfLink["href"]
            }
            if let previousLink = dictionary["previousepisode"] as? [String:String] {
                showlinks.previousEpisodeLink = previousLink["href"]
            }
            if let nextLink = dictionary["nextepisode"] as? [String:String] {
                showlinks.showLink = nextLink["href"]
            }
            return showlinks
    }
}
