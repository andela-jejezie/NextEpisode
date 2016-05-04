//
//  Externals+CoreDataProperties.swift
//  NextEpisode
//
//  Created by Andela on 5/4/16.
//  Copyright © 2016 Andela. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Externals {

    @NSManaged var tvrage: NSNumber?
    @NSManaged var thetvdb: NSNumber?
    @NSManaged var imdb: String?

}
