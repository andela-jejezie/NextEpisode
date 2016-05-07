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
        if let characterID = dictionary["id"] as? NSNumber {
            character.characterID = characterID
        }
        if let name = dictionary["name"] as? String {
            character.name = name
        }
        if let url = dictionary["url"] as? String {
            character.url = url
        }
        
        if let imageDict = dictionary["image"] as? [String:String] {
            let imageString = imageDict["medium"]
            character.image = imageString
        }
        return character
    }
}
