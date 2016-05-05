//
//  Character.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Character: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
        context: NSManagedObjectContext) -> Character {
            let character = NSEntityDescription.insertNewObjectForEntityForName("Character",
                inManagedObjectContext: context) as! Character
            character.characterID = dictionary["id"] as? NSNumber
            character.name = dictionary["name"] as? String
            character.url = dictionary["url"] as? String
            if let imageDict = dictionary["image"] as? [String:String] {
                let imageString = imageDict["medium"]
                character.image = CDHelper.documentsPathForFileName(imageString!)
            }
            return character
    }
}
