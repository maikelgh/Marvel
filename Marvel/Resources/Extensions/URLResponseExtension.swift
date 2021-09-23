//
//  URLResponseExtension.swift
//  Marvel
//
//  Created by michael on 20/9/21.
//

import Foundation

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
    
    func getDescription() -> String? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.description
        }
        return nil
    }
}
