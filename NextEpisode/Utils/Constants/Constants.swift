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
    private struct putlockerURLStruct { static var kputlockerURL: String = "http://putlocker.is/watch-{showName}-tvshow-season-{season}-episode-{episode}-online-free-putlocker.html"}
    class var baseURL: String
        {
        get { return baseURLStruct.kbaseURL }
    }
    class var putlockerURL: String {
        get {return putlockerURLStruct.kputlockerURL}
    }
}
