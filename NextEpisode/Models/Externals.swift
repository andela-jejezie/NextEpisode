//
//  Externals.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Externals: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
        context: NSManagedObjectContext) -> Externals {
            let externals = NSEntityDescription.insertNewObjectForEntityForName("Externals",
                inManagedObjectContext: context) as! Externals
            if let tvrage = dictionary["tvrage"] as? NSNumber {
                externals.tvrage = tvrage
            }
            if let thetvdb = dictionary["thetvdb"] as? NSNumber {
               externals.thetvdb = thetvdb
            }
            if let imdb = dictionary["imdb"] as? String {
                externals.imdb = imdb
            }
            return externals
    }
}
