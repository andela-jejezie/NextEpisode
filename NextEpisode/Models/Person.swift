//
//  Person.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
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
            person.personID = dictionary["id"] as? NSNumber
            person.name = dictionary["name"] as? String
            person.url = dictionary["url"] as? String
            if let imageDict = dictionary["image"] as? [String:String] {
                let imageString = imageDict["medium"]
                person.image = CDHelper.documentsPathForFileName(imageString!)
            }
            return person
    }
}
