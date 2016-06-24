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


class NEEpisodeDetailVC: NEGenericVC {
    
    //    @IBOutlet weak var aboutShowButton: UIButton!
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var airtimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var seeMoreButtonHeight: NSLayoutConstraint!


    
    var episode: Episode!
    var show: Show!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seeMoreButtonHeight.constant = 94
        summaryLabel.numberOfLines = 0
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.hidesBottomBarWhenPushed = true
        if let showName = show.name, showSeason = episode.season, episodeNumber = episode.episode {
            title = showName + " S\(showSeason)" + " E\(episodeNumber)"
        }
        if let imageString = show?.image {
            UIImageView().kf_setImageWithURL(NSURL(string: imageString)!, placeholderImage: UIImage(named: "images"), optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                if let personImage = image {
                    self.imageView.image = CDHelper.resizeImage(personImage, newWidth: self.imageView.frame.size.width)
                }else {
                    self.imageView.image = UIImage(named: "images")
                }
            })
        }else {
            imageView.image = UIImage(named: "images")
        }
        if let summary = episode.summary {
            summaryLabel.text = CDHelper.formatString(summary)
        }else {
            summaryLabel.text = "Synopsis not available"
        }
        if let runtime = episode.runtime {
           durationLabel.text = "Duration: \(runtime)mins"
        }else {
            durationLabel.text = "Duration: not available"
        }
        
        if let genre = show.genres {
            let genreString = genre.stringByReplacingOccurrencesOfString(",", withString: ", ")
            genreLabel.text = "Genres: \(genreString)"
        }
        if let rating = show.averageRating {
           ratingLabel.text = "Rating: \(rating)/10"
        }
        
        if let airtime = episode.airtime {
           airtimeLabel.text = airtime == "" ?  "Airtime: Not available" : "Airtime: \(airtime)" 
        }
        
        
        if let airdate = episode.airdate {
            airDateLabel.text = "Airdate: \(CDHelper.dateToString(airdate))"
        }
        if let airtime = episode.airtime {
            let components = airtime.componentsSeparatedByString(":")
            let hour = Int(components[0])
            if var airdate = episode.airdate {
                let calendar = NSCalendar.currentCalendar()
                if let _hour = hour {
                    airdate = calendar.dateByAddingUnit(.Hour, value: _hour, toDate: airdate, options: [])!
                }
                if airdate.timeIntervalSince1970 >= NSDate().timeIntervalSince1970{
                    watchButton.setTitle("Add To Calendar", forState: .Normal)
                }
            }
        }
    }
    
    @IBAction func onSeeMoreTapped(sender: AnyObject) {
        if seeMoreButtonHeight.constant == 54 {
            self.seeMoreButton.setTitle("See less", forState: .Normal)
            let maximumLabelSize = CGSizeMake(summaryLabel.frame.size.width, 800);
            let expectedSize = summaryLabel.sizeThatFits(maximumLabelSize)
            UIView.animateWithDuration(0.5, animations: {
                self.seeMoreButtonHeight.constant = expectedSize.height
                self.view.layoutIfNeeded()
            })
        }else {
            self.seeMoreButton.setTitle("See more", forState: .Normal)
            UIView.animateWithDuration(0.5, animations: {
                self.seeMoreButtonHeight.constant = 94
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    
    
    @IBAction func onWatchNowButtonTapped(sender: UIButton) {
        if let airtime = episode.airtime {
            let components = airtime.componentsSeparatedByString(":")
            let hour = Int(components[0])
            if var airdate = episode.airdate {
                let calendar = NSCalendar.currentCalendar()
                if let _hour = hour {
                    airdate = calendar.dateByAddingUnit(.Hour, value: _hour, toDate: airdate, options: [])!
                    
                }
                if airdate.timeIntervalSince1970 >= NSDate().timeIntervalSince1970{
                    let eventStore = EKEventStore()
                    eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
                        dispatch_async(dispatch_get_main_queue(), {
                            if (error != nil) {
                                
                            }else if !granted {
                                
                            }else {
                                let event = EKEvent(eventStore: eventStore)
                                event.title = "TV Series Reminder"
                                event.startDate = self.episode.airdate!
                                event.endDate = self.episode.airdate!
                                event.calendar = eventStore.defaultCalendarForNewEvents
                                do {
                                    try eventStore.saveEvent(event, span: .ThisEvent)
                                    let alertView = UIAlertController(title: "Success", message: "Episode air date added to your calendar", preferredStyle: .Alert)
                                    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) in
                                        alertView.dismissViewControllerAnimated(true, completion: nil)
                                    })
                                    alertView.addAction(cancelAction)
                                    self.presentViewController(alertView, animated: true, completion: nil)
                                }catch {
                                    print("error saving to calendar \(error) ",#function)
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
                    targetVC?.displayTitle = title
                    self.navigationController?.pushViewController(targetVC!, animated: true)
                    
                }
            }
        }
    }
}
