//
//  Constants.swift
//  NextEpisode
//
//  Created by Andela on 5/4/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation

class Constants {
    private struct baseURLStruct { static var kbaseURL: String = "http://api.tvmaze.com/" }
    
    class var baseURL: String
        {
        get { return baseURLStruct.kbaseURL }
    }
}
