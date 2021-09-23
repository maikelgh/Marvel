//
//  APIConstants.swift
//  Marvel
//
//  Created by michael on 20/9/21.
//

import Foundation

struct APIConstants {
    static let serverUrl = "https://gateway.marvel.com/"
    static let publicKey = "959c39f81eb6317f61e342f286981feb"
    static let privateKey = "ae55fd17ffd35121d4545469154c2a3196e61dbe"
}

enum EndPoint: String {
    case characters = "v1/public/characters"
    case character = "v1/public/characters/"
}

enum APIPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum APIResponseCode: Int {
    case Success = 200
    case ServerError = 400
    case NotFound = 404
    case Unauthorized = 401
    case Forbidden = 403
}
