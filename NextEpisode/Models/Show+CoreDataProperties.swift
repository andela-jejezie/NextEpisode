//
//  Show+CoreDataProperties.swift
//  NextEpisode
//
//  Created by Andela on 6/24/16.
//  Copyright © 2016 Andela. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Show {

    @NSManaged var averageRating: NSNumber?
    @NSManaged var currentEpisodeLink: String?
    @NSManaged var genres: String?
    @NSManaged var image: String?
    @NSManaged var imdb: String?
    @NSManaged var language: String?
    @NSManaged var name: String?
    @NSManaged var nextEpisodeLink: String?
    @NSManaged var premiered: NSDate?
    @NSManaged var previousEpisodeLink: String?
    @NSManaged var runtime: NSNumber?
    @NSManaged var scheduleDays: String?
    @NSManaged var scheduleTime: String?
    @NSManaged var showID: NSNumber?
    @NSManaged var status: String?
    @NSManaged var summary: String?
    @NSManaged var thetvdb: NSNumber?
    @NSManaged var tvrage: NSNumber?
    @NSManaged var url: String?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var casts: NSSet?
    @NSManaged var episodes: NSSet?
    @NSManaged var network: Network?

}
