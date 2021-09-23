//
//  URLMarvel.swift
//  Marvel
//
//  Created by Michael Green on 12/9/21.
//

import Foundation

struct URLMarvel {
    
    let type: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case url
    }
}

extension URLMarvel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
    }
}

extension URLMarvel: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(url, forKey: .url)
    }
}
