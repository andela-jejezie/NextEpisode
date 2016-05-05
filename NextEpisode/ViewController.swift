//
//  ViewController.swift
//  NextEpisode
//
//  Created by Andela on 5/4/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        NETodayEpisodesAPI.getTVSeriesScheduledTodayForCountryCode("")
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Show", inManagedObjectContext: CDHelper.shared.context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try CDHelper.shared.context.executeFetchRequest(fetchRequest) as? [Show]
            for show:Show in result! {
                print("fetched result from core data \(show.network?.country?.timezone)")
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
}

