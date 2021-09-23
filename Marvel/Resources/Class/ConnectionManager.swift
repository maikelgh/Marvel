//
//  ConnectionManager.swift
//  Marvel
//
//  Created by Michael Green on 19/9/21.
//

import Foundation

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var status:Bool = false

        guard let url = URL(string: "https://google.com") else { return false }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0

        var response:URLResponse?

        do {
            let _ = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        return status
   }
}
