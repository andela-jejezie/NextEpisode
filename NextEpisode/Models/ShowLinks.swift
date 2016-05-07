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
            if let link = selfLink["href"] {
                showlinks.showLink = link
            }
        }
        if let previousLink = dictionary["previousepisode"] as? [String:String] {
            if let link = previousLink["href"] {
                showlinks.previousEpisodeLink = link
            }
        }
        if let nextLink = dictionary["nextepisode"] as? [String:String] {
            if let link = nextLink["href"] {
                showlinks.showLink = link
            }
        }
        return showlinks
    }
}
