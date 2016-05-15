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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard () {
        self.view.endEditing(true)
    }
    
    func hideKeyboardWhenBackgroundIsTapped () {
        let tgr = UITapGestureRecognizer(target: self, action:Selector("hideKeyboard"))
        self.view.addGestureRecognizer(tgr)
    }

}
