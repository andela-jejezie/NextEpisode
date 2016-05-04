//
//  Episode+CoreDataProperties.swift
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

extension Episode {

    @NSManaged var episodeID: NSNumber?
    @NSManaged var url: String?
    @NSManaged var name: String?
    @NSManaged var season: NSNumber?
    @NSManaged var episode: NSNumber?
    @NSManaged var airdate: NSDate?
    @NSManaged var airtime: String?
    @NSManaged var runtime: NSNumber?
    @NSManaged var image: NSData?
    @NSManaged var show: Show?

}
