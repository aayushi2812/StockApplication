//
//  Service.swift
//  StockApplication
//
//  Created by user265285 on 11/27/24.
//

import Foundation
class Service{
    private init(){}
    static var shared = Service()
    
    func getData(fromURL sURL : String, completion: @escaping (Data) -> ()){
        let headers = [
            "x-rapidapi-key": "72c3bf0585msh554dad757b4e8b6p1528d2jsn24a095060f7f",
            "x-rapidapi-host": "ms-finance.p.rapidapi.com"
        ]
        

        let request = NSMutableURLRequest(url: NSURL(string: sURL)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if let data = data{
                    completion(data)
                }
            }
        })

        dataTask.resume()
    }
    
    func getRealtimeData(fromURL performanceId : String, completion: @escaping (Data) -> ()){
        let headers = [
            "x-rapidapi-key": "72c3bf0585msh554dad757b4e8b6p1528d2jsn24a095060f7f",
            "x-rapidapi-host": "ms-finance.p.rapidapi.com"
        ]
        

        let request = NSMutableURLRequest(url: NSURL(string: performanceId)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if let data = data{
                    completion(data)
                }
            }
        })

        dataTask.resume()
    }
}
