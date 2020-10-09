//
//  Models.swift
//  MyAppStore
//
//  Created by Armin Spahic on 27/09/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class DetailedAppPresent: NSObject {
    
    static var imagesArray = Screenshots()
    var appInfoArray = [AppInformation]()
    
    static func fetchDetailedAppById(id: Int, completionHandler: @escaping (Screenshots) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as AnyObject
                if let images = json["Screenshots"] as? [String] {
                    var appInfoArray = [AppInformation]()
                    self.imagesArray.screenshots = images
                    
                    let description = json["description"] as? String
                    self.imagesArray.desc = description
                    
                    for appInformation in json["appInformation"] as! [[String:Any]] {
                        let appInfo = AppInformation()
                        appInfo.name = appInformation["Name"] as? String
                        appInfo.value = appInformation["Value"] as? String
                        appInfoArray.append(appInfo)
                    }
                    self.imagesArray.appInformation = appInfoArray
                    //test
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(imagesArray)
                })
                
                
            } catch let err {
                print(err)
            }
            }.resume()
    }
    
}

class AppCategory: NSObject {
    var name: String?
    var apps: [App]?
    

    static func fetchFeaturedApps(completionHandler: @escaping ([AppCategory], [AppCategory]) -> ()) {
        let url = URL(string: "https://api.letsbuildthatapp.com/appstore/featured")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as AnyObject
                // FETCH HEADER IMAGES
                var featuredApps = [AppCategory]()
                var featuredAppsCategory = [AppCategory]()
               if let dict = json["bannerCategory"] as? [String: Any] {
                    let featuredAppCategory = AppCategory()
                    var featuredAppsArray = [App]()
                    for image in dict["apps"] as! [[String: Any]] {
                        let app = App()
                        app.imageName = image["ImageName"] as? String
                        featuredAppsArray.append(app)
                    }
                    featuredAppCategory.apps = featuredAppsArray
                    featuredApps.append(featuredAppCategory)
                }
                // FETCH OTHER ITEMS
                for dict in json["categories"] as! [[String: Any]] {
                    let appCategory = AppCategory()
                    var appsArray = [App]()
                    appCategory.name = dict["name"] as? String
                    for applic in dict["apps"] as! [[String: Any]] {
                        let app = App()
                        app.id = applic["Id"] as? NSNumber
                        app.name = applic["Name"] as? String
                        app.category = applic["Category"] as? String
                        app.price = applic["Price"] as? NSNumber
                        app.imageName = applic["ImageName"] as? String
                        appsArray.append(app)
                       // print(appsArray[0].name)
                        
                    }
                    appCategory.apps = appsArray
                    featuredAppsCategory.append(appCategory)
                }
                DispatchQueue.main.async {
                    completionHandler(featuredAppsCategory, featuredApps)
                }
                
               // print(appCategories)
            } catch let err {
                print(err)
            }
            }.resume()
    }
    
    static func sampleAppCategories() -> [AppCategory] {
    
        let bestNewAppCategory = AppCategory()
        bestNewAppCategory.name = "Best New Apps"
        var bestNewApps = [App]()
        let frozenApp = App()
        
        frozenApp.name = "Disney Build It: Frozen"
        frozenApp.category = "Entertainment"
        frozenApp.imageName = "frozen"
        frozenApp.price = NSNumber(floatLiteral: 3.99)
        bestNewApps.append(frozenApp)
        bestNewAppCategory.apps = bestNewApps
        
        let bestNewGameCategory = AppCategory()
        bestNewGameCategory.name = "Best New Games"
        var bestNewGamesApps = [App]()
        let telepaintGame = App()
        telepaintGame.name = "Telepaint"
        telepaintGame.category = "Game"
        telepaintGame.imageName = "telepaint"
        telepaintGame.price = NSNumber(floatLiteral: 4.99)
        bestNewGamesApps.append(telepaintGame)
        bestNewGameCategory.apps = bestNewGamesApps
        
        return [bestNewAppCategory, bestNewGameCategory]
        
    }
}

class App: NSObject {
    
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
}

class Screenshots: NSObject {
    var screenshots: [String]?
    var appInformation: [AppInformation]?
    var desc: String?    
}

class AppInformation: NSObject {
    var name: String?
    var value: String?
}
