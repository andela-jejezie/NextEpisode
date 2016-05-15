//
//  NEEpisodeDetailVC.swift
//  NextEpisode
//
//  Created by Andela on 5/7/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import Kingfisher
import EventKit


class NEEpisodeDetailVC: UIViewController {
    
//    @IBOutlet weak var aboutShowButton: UIButton!
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var airtimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var smmaryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var episode: Episode!
    var show: Show!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = (show?.name)! + " S\(episode.season!)" + " E\(episode.episode!)"
        if let path = show?.image {
            imageView.kf_setImageWithURL(NSURL(string: path)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        smmaryLabel.text = episode.summary?.stringByReplacingOccurrencesOfString("<p>", withString: "").stringByReplacingOccurrencesOfString("</p>", withString: "")
        durationLabel.text = "Duration: \(episode.runtime!)mins"
        genreLabel.text = "Genres: \(show!.genres!)"
        ratingLabel.text = "Rating: \(show!.rating!.average!)/10"
        airtimeLabel.text = "Airtime: \(episode.airtime!)"
        airDateLabel.text = "Airdate: \(CDHelper.dateToString(episode.airdate!))"
        if let airtime = episode.airtime {
            let components = airtime.componentsSeparatedByString(":")
            let hour = Int(components[0])
            if let airdate = episode.airdate {
                let calendar = NSCalendar.currentCalendar()
                let date = calendar.dateByAddingUnit(.Hour, value: hour!, toDate: airdate, options: [])
                if date!.timeIntervalSince1970 >= NSDate().timeIntervalSince1970{
                     watchButton.setTitle("Add To Calendar", forState: .Normal)
                }
            }
        }
    }
    
    @IBAction func onWatchNowButtonTapped(sender: UIButton) {
        if let airtime = episode.airtime {
            let components = airtime.componentsSeparatedByString(":")
            let hour = Int(components[0])
            if let airdate = episode.airdate {
                let calendar = NSCalendar.currentCalendar()
                let date = calendar.dateByAddingUnit(.Hour, value: hour!, toDate: airdate, options: [])
                if date!.timeIntervalSince1970 >= NSDate().timeIntervalSince1970{
                    let eventStore = EKEventStore()
                    eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
                        dispatch_async(dispatch_get_main_queue(), {
                            if (error != nil) {
                                
                            }else if !granted {
                                
                            }else {
                                let event = EKEvent(eventStore: eventStore)
                                event.title = "TV Series Reminder"
                                event.startDate = self.episode.airdate!
                                event.calendar = eventStore.defaultCalendarForNewEvents
                                do {
                                    try eventStore.saveEvent(event, span: .ThisEvent)
                                }catch {
                                    print("error saving to calendar",#function)
                                }
                                
                            }
                        })
                    })
                }else {
                    var url = Constants.putlockerURL
                    let showName = CDHelper.shared.selectedShow.name!.stringByReplacingOccurrencesOfString(" ", withString: "-")
                    url = url.stringByReplacingOccurrencesOfString("{showName}", withString: showName).stringByReplacingOccurrencesOfString("{season}", withString: String(episode!.season!)).stringByReplacingOccurrencesOfString("{episode}", withString: String(episode!.episode!))
                    let webStoryboard = UIStoryboard(name: "WebViewStoryboard", bundle: nil)
                    let targetVC = webStoryboard.instantiateViewControllerWithIdentifier("NEWebViewVC") as? NEWebViewVC
                    targetVC?.urlString = url
                    self.navigationController?.pushViewController(targetVC!, animated: true)

                }
            }
        }

        
    }
//    @IBAction func onABoutShowTapped(sender: UIButton) {
//        let showStoryboard = UIStoryboard(name: "Show", bundle:nil)
//        let targetVC = showStoryboard.instantiateViewControllerWithIdentifier("NEShowDetailsVC") as? NEShowDetailsVC
//        //        targetVC?.show = episode.show
//        self.navigationController?.pushViewController(targetVC!, animated: true)
//    }
}
