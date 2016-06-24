//
//  Cast.swift
//  NextEpisode
//
//  Created by Andela on 6/19/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Cast: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
                           context: NSManagedObjectContext, forShow show:Show) -> Cast {
        let cast = NSEntityDescription.insertNewObjectForEntityForName("Cast",
                                                                       inManagedObjectContext: context) as! Cast
        if let person = dictionary["person"] as? [String:AnyObject] {
            cast.person = Person.newInstance(person, context: context)
        }
        if let character = dictionary["character"] as? [String:AnyObject] {
            cast.character = Character.newInstance(character, context: context)
        }
        cast.show = show
        return cast
    }
}
