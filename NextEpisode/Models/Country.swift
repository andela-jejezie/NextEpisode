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
        if let name = dictionary["name"] as? String {
            country.name = name
        }
        if let code = dictionary["code"] as? String {
            country.code = code
        }
        if let timezone = dictionary["timezone"] as? String {
            country.timezone = timezone
        }
        return country
    }
}
