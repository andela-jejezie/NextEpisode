//
//  Person.swift
//  NextEpisode
//
//  Created by Andela on 6/19/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Person: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
                           context: NSManagedObjectContext) -> Person {
        let person = NSEntityDescription.insertNewObjectForEntityForName("Person",
                                                                         inManagedObjectContext: context) as! Person
        if let personID = dictionary["id"] as? NSNumber {
            person.personID = personID
        }
        if let name = dictionary["name"] as? String {
            person.name = name
        }
        if let url = dictionary["url"] as? String {
            person.url = url
        }
        
        if let imageDict = dictionary["image"] as? [String:String] {
            let imageString = imageDict["medium"]
            person.image = imageString
        }
        return person
    }
}
