//
//  Network.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Network: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
        context: NSManagedObjectContext) -> Network {
            let network = NSEntityDescription.insertNewObjectForEntityForName("Network",
                inManagedObjectContext: context) as! Network
            network.networkID = dictionary["id"] as? NSNumber
            network.name = dictionary["name"] as? String
            network.country = Country.newInstance(dictionary["country"] as! [String:AnyObject], context: context)
            return network
    }
}
