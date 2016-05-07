//
//  Rating.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Rating: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
                           context: NSManagedObjectContext) -> Rating {
        let rating = NSEntityDescription.insertNewObjectForEntityForName("Rating",
                                                                         inManagedObjectContext: context) as! Rating
        if let average = dictionary["average"] as? NSNumber {
            rating.average = average
        }
        return rating
    }
}
