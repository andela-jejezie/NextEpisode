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
        if let networkID = dictionary["id"] as? NSNumber {
            network.networkID = networkID
        }
        if let name = dictionary["name"] as? String {
            network.name = name
        }
        if let dict = dictionary["country"] as? [String:AnyObject] {
            network.country = Country.newInstance(dict, context: context)
        }
        return network
    }
}
