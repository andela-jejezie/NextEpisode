//
//  Network+CoreDataProperties.swift
//  NextEpisode
//
//  Created by Andela on 6/19/16.
//  Copyright © 2016 Andela. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Network {

    @NSManaged var name: String?
    @NSManaged var networkID: NSNumber?
    @NSManaged var countryName: String?
    @NSManaged var countryCode: String?
    @NSManaged var timeZone: String?
    @NSManaged var show: Show?

}
