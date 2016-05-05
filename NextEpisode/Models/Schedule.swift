//
//  Schedule.swift
//  NextEpisode
//
//  Created by Andela on 5/5/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData


class Schedule: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func newInstance(dictionary: [String:AnyObject] ,
        context: NSManagedObjectContext) -> Schedule {
            let schedule = NSEntityDescription.insertNewObjectForEntityForName("Schedule",
                inManagedObjectContext: context) as! Schedule
            schedule.time = dictionary["time"] as? String
            if let days = dictionary["days"] as? [String] {
                schedule.days = days.joinWithSeparator(",")
            }
            return schedule
    }
}
