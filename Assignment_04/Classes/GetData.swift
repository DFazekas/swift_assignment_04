//
//  GetData.swift
//  Assignment_04
//
//  Interacts with Database.
//
//  Created by Devon on 2018-12-03.
//  Copyright © 2018 PROG31975. All rights reserved.
//

import UIKit

class GetData: NSObject {
    var dbData : [NSDictionary]?
    let myUrl = "https://fazekade.dev.fast.sheridanc.on.ca/assignment04/sqlToJson.php" as String
    
    enum JSONError : String, Error {
        case NoData = "Error: No Data"
        case ConversionFailed = "Error: Conversion from JSON failed"
    }
    
    func jsonParser() {
        guard let endpoint = URL(string: myUrl) else {
            print("Error creating connection")
            return
        }
        
        let request = URLRequest(url: endpoint)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                // Verify something was received.
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString!)
                
                // Verify that something.
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                // Parse data into JSON.
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else {
                    throw JSONError.ConversionFailed
                }
                
                print(json)
                
                // Store JSON data into object.
                self.dbData = json
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }.resume()
    }
}
