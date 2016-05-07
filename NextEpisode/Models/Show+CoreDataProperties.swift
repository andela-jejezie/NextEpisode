//
//  Show+CoreDataProperties.swift
//  NextEpisode
//
//  Created by Andela on 5/7/16.
//  Copyright © 2016 Andela. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Show {

    @NSManaged var genres: String?
    @NSManaged var image: String?
    @NSManaged var language: String?
    @NSManaged var name: String?
    @NSManaged var premiered: NSDate?
    @NSManaged var runtime: NSNumber?
    @NSManaged var showID: NSNumber?
    @NSManaged var status: String?
    @NSManaged var summary: String?
    @NSManaged var url: String?
    @NSManaged var country: Country?
    @NSManaged var episodes: NSSet?
    @NSManaged var external: Externals?
    @NSManaged var link: ShowLinks?
    @NSManaged var network: Network?
    @NSManaged var rating: Rating?
    @NSManaged var schedule: Schedule?
    @NSManaged var casts: NSSet?

}
