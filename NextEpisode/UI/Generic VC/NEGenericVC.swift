//
//  NEGenericVC.swift
//  NextEpisode
//
//  Created by Andela on 5/6/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit

class NEGenericVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Savoye LET", size: 30)!]
    }

}
