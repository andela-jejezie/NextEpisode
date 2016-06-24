//
//  NERequest.swift
//  NextEpisode
//
//  Created by Andela on 5/16/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import Foundation
import CoreData

class NERequest: NSObject {
    
    typealias showsResponse = (Bool?, NSError?)->Void
    
    class func searchForShowsWithName(name:String, completionHandler:((shows:[AnyObject]?, errorMessage:String?) -> Void)) {
        let endpoint = Constants.baseURL + "search/shows?q=\(name)"
        guard let url = NSURL(string: endpoint) else {
            print("failed to create url",#function)
            completionHandler(shows: nil, errorMessage: "Error occurred. Please check your internet connection")
            return
        }
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let responseData = data else {
                print("didn't get data", #function)
                completionHandler(shows: nil, errorMessage: "Please try again")
                return
            }
            guard error == nil else {
                print("an error occured \(error?.localizedDescription)")
                completionHandler(shows: nil, errorMessage: error?.localizedDescription)
                return
            }
            do {
                if let showJson = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [AnyObject] {
                    completionHandler(shows: showJson, errorMessage: nil)
                }
            }catch {
               
            }
        }
        task.resume()
    }
    
    class func getAllShow(completionHandler:((shows:[[String: AnyObject]]?, errorMessage:String?) -> Void)){
        let endpoint = Constants.baseURL + "shows"
        guard let url = NSURL(string: endpoint) else {
            completionHandler(shows: nil, errorMessage: "Error occurred. Please check your internet connection")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                completionHandler(shows: nil, errorMessage: "Please try again")
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                completionHandler(shows: nil, errorMessage: error?.localizedDescription)
                print("Error fetching data: \(error)")
                return
            }
            do {
                if let series = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [[String: AnyObject]] {
                    completionHandler(shows: series, errorMessage: nil)
                }
            } catch {
                completionHandler(shows: nil, errorMessage: "\(error)")
                print("Error deserializing JSON: \(error)")
            }
        }
        task.resume()
    }
    

    class func getCastsForShow(showID:String, completionHandler:((casts:[AnyObject]?, errorMessage:String?) -> Void)) {
        let endpoint = Constants.baseURL + "shows/\(showID)/cast"
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            completionHandler(casts: nil, errorMessage: "Error occurred. Please check your internet connection")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(casts: nil, errorMessage: "Please try again")
                return
            }
            guard error == nil else {
                print("Error fetching data: \(error)")
                completionHandler(casts: nil, errorMessage: error?.localizedDescription)
                return
            }
            
            do {
                if let arrayObjects = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [AnyObject] {
                    completionHandler(casts: arrayObjects, errorMessage: nil)
                }
                
            } catch {
                print("Error deserializing JSON: \(error)")
                completionHandler(casts: nil, errorMessage: "Please try again")
            }
            
        }
        task.resume()
    }
    
    class func getEpisodes(showID:String, completionHandler:((episodes:[AnyObject]?, errorMessage:String?) -> Void)) {
        let endpoint = Constants.baseURL + "shows/\(showID)/episodes"
        guard let url = NSURL(string: endpoint) else {
            print("Error: cannot create URL")
            completionHandler(episodes: nil, errorMessage: "Error occurred. Please check your internet connection")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(episodes: nil, errorMessage: "Please try again")
                return
            }
            guard error == nil else {
                print("Error fetching data: \(error)")
                completionHandler(episodes: nil, errorMessage: error?.localizedDescription)
                return
            }
            
            do {
                if let arrayObjects = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [AnyObject] {
                    completionHandler(episodes: arrayObjects, errorMessage: nil)
                }
                
            } catch {
                print("Error deserializing JSON: \(error)")
                completionHandler(episodes: nil, errorMessage: "Please try again")
            }
            
        }
        task.resume()
    }
    

}

 