//
//  Show+CoreDataProperties.swift
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

extension Show {

    @NSManaged var showID: NSNumber?
    @NSManaged var url: String?
    @NSManaged var name: String?
    @NSManaged var language: String?
    @NSManaged var genres: String?
    @NSManaged var runtime: NSNumber?
    @NSManaged var premiered: NSDate?
    @NSManaged var schedule: NSManagedObject?
    @NSManaged var rating: NSManagedObject?
    @NSManaged var network: Network?
    @NSManaged var external: NSManagedObject?
    @NSManaged var country: NSManagedObject?
    @NSManaged var link: ShowLinks?
    @NSManaged var episodes: NSSet?

}
