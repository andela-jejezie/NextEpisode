//
//  Character+CoreDataProperties.swift
//  NextEpisode
//
//  Created by Andela on 5/13/16.
//  Copyright © 2016 Andela. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Character {

    @NSManaged var characterID: NSNumber?
    @NSManaged var image: String?
    @NSManaged var name: String?
    @NSManaged var url: String?

}
