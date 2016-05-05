//
//  Country.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Country: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
        context: NSManagedObjectContext) -> Country {
            let country = NSEntityDescription.insertNewObjectForEntityForName("Country",
                inManagedObjectContext: context) as! Country
            country.name = dictionary["name"] as? String
            country.code = dictionary["code"] as? String
            country.timezone = dictionary["timezone"] as? String
            return country
    }
}
