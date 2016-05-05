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
            cast.person = Person.newInstance(dictionary["person"] as! [String:AnyObject], context: context)
            cast.character = Character.newInstance(dictionary["character"] as! [String:AnyObject], context: context)
            return cast
    }
}
