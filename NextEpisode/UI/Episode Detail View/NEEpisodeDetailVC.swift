//
//  NEEpisodeDetailVC.swift
//  NextEpisode
//
//  Created by Andela on 5/7/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import Kingfisher


class NEEpisodeDetailVC: UIViewController {
    
    @IBOutlet weak var aboutShowButton: UIButton!
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
    }
    
    @IBAction func onWatchNowButtonTapped(sender: UIButton) {
        var url = Constants.putlockerURL
        let showName = CDHelper.shared.selectedShow.name!.stringByReplacingOccurrencesOfString(" ", withString: "-")
        url = url.stringByReplacingOccurrencesOfString("{showName}", withString: showName).stringByReplacingOccurrencesOfString("{season}", withString: String(episode!.season!)).stringByReplacingOccurrencesOfString("{episode}", withString: String(episode!.episode!))
        print(url)
        let webStoryboard = UIStoryboard(name: "WebViewStoryboard", bundle: nil)
        let targetVC = webStoryboard.instantiateViewControllerWithIdentifier("NEWebViewVC") as? NEWebViewVC
        targetVC?.urlString = url
        self.navigationController?.pushViewController(targetVC!, animated: true)
        
    }
    @IBAction func onABoutShowTapped(sender: UIButton) {
        let showStoryboard = UIStoryboard(name: "Show", bundle:nil)
        let targetVC = showStoryboard.instantiateViewControllerWithIdentifier("NEShowDetailsVC") as? NEShowDetailsVC
        //        targetVC?.show = episode.show
        self.navigationController?.pushViewController(targetVC!, animated: true)
    }
}
