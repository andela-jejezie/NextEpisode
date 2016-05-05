//
//  Episode+CoreDataProperties.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Episode {

    @NSManaged var airdate: NSDate?
    @NSManaged var airtime: String?
    @NSManaged var episode: NSNumber?
    @NSManaged var episodeID: NSNumber?
    @NSManaged var image: String?
    @NSManaged var name: String?
    @NSManaged var runtime: NSNumber?
    @NSManaged var season: NSNumber?
    @NSManaged var url: String?
    @NSManaged var summary: String?
    @NSManaged var show: Show?

}
