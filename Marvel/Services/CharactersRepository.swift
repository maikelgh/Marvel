//
//  MarvelRepository.swift
//  Marvel
//
//  Created by Michael Green on 12/9/21.
//

import Foundation

protocol CharactersDelegate: AnyObject {
    func finishGetCharacters(characterData: CharacterResponse?, error: Error?)
    func finishGetCharacter(characterData: CharacterResponse?, error: Error?)
}

class CharactersRepository: API {
    
    weak var delegate: CharactersDelegate?
    
    func getCharacters(_ name: String = "", page: Int = 0, maxItems: Int = 20) {
        var queryItems: [URLQueryItem] = []
        if !name.isEmpty {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: name))
        }
        
        if page > 0 {
            queryItems.append(URLQueryItem(name: "offset", value: "\(page * maxItems)"))
        }
        
        guard let request = request(path: EndPoint.characters.rawValue, method: APIPMethod.get.rawValue, queryItems: queryItems) else {
            self.delegate?.finishGetCharacters(characterData: nil, error: nil)
            return
        }
        
        sendRequest(request) { [weak self] (response, error) in
            
            if let error = error {
                self?.delegate?.finishGetCharacters(characterData: nil, error: error)
            } else {
                
                guard let characterData = try? JSONDecoder().decode(CharacterResponse.self, from: response as! Data) else {
                    self?.delegate?.finishGetCharacters(characterData: nil, error: nil)
                    return
                }
                
                self?.delegate?.finishGetCharacters(characterData: characterData, error: nil)
            }
        }
    }
    
    func getCharacter(_ id: Int, maxItems: Int = 20) {
        guard let request = request(path: EndPoint.character.rawValue + "\(id)", method: APIPMethod.get.rawValue, queryItems: []) else {
            self.delegate?.finishGetCharacter(characterData: nil, error: nil)
            return
        }
        
        sendRequest(request) { [weak self] (response, error) in
            
            if let error = error {
                self?.delegate?.finishGetCharacter(characterData: nil, error: error)
            } else {
                
                guard let characterData = try? JSONDecoder().decode(CharacterResponse.self, from: response as! Data) else {
                    self?.delegate?.finishGetCharacter(characterData: nil, error: nil)
                    return
                }
                
                self?.delegate?.finishGetCharacter(characterData: characterData, error: nil)
            }
        }
    }
}
