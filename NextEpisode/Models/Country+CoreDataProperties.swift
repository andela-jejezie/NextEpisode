//
//  Country+CoreDataProperties.swift
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

extension Country {

    @NSManaged var code: String?
    @NSManaged var name: String?
    @NSManaged var timezone: String?

}
