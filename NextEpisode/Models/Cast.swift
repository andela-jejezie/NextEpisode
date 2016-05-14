//
//  Cast.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Cast: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
                           context: NSManagedObjectContext) -> Cast {
        let cast = NSEntityDescription.insertNewObjectForEntityForName("Cast",
                                                                       inManagedObjectContext: context) as! Cast
        if let person = dictionary["person"] as? [String:AnyObject] {
            cast.person = Person.newInstance(person, context: context)
        }
        if let character = dictionary["character"] as? [String:AnyObject] {
            cast.character = Character.newInstance(character, context: context)
        }
        return cast
    }
}
