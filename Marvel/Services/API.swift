//
//  MarvelAPI.swift
//  Marvel
//
//  Created by Michael Green on 12/9/21.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

struct ServerError: Error {
    var code: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}

extension ServerError: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}

struct ApiError: Error {
    var code: Int?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case status
    }
}

extension ApiError: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(Int.self, forKey: .code)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
    }
}

class API {
    func request(path: String, method: String, queryItems: [URLQueryItem]) -> URLRequest? {
        
        let timestamp = "\(Date().timeIntervalSince1970)"
        let md5 = self.MD5(string: "\(timestamp)\(APIConstants.privateKey)\(APIConstants.publicKey)")

        var components = URLComponents(string: APIConstants.serverUrl + path)!
        components.queryItems = [
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: md5.map { String(format: "%02hhx", $0) }.joined()),
            URLQueryItem(name: "apikey", value: APIConstants.publicKey)
        ]
        components.queryItems?.append(contentsOf: queryItems)
        
        var urlRequest = URLRequest(url: components.url!,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 10.0)
        urlRequest.httpMethod = method
        return urlRequest
    }
    
    func sendRequest(_ request: URLRequest, completion:((Any?, Error?) -> Void)?) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error -> Void in
            
            if let error = error {

                completion?(nil, error)
                
            } else {
                
                if let data = data, response?.getStatusCode() == APIResponseCode.Success.rawValue {
            
                    completion?(data, nil)
                } else {
                    if let responseData = data {
                        if let error = try? JSONDecoder().decode(ApiError.self, from: responseData) {
                            completion?(nil,error)
                        } else if let error = try? JSONDecoder().decode(ServerError.self, from: responseData) {
                            completion?(nil,error)
                        } else {
                            let error = ServerError(code: "", message: "Unknown error")
                            completion?(nil,error)
                        }
                    } else {
                        let error = ServerError(code: "", message: "Unknown error")
                        
                        completion?(nil,error)
                    }
                    
                }

                
            }
        })

        task.resume()
    }
    
    private func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
}
