//
//  InitialPresenter.swift
//  Marvel
//
//  Created by Michael Green on 12/9/21.
//  Copyright (c) 2021 MGH. All rights reserved.
//

import UIKit

protocol InitialDisplayLogic: AnyObject {
    func setupView()
    func refreshCards(toIndex: Int)
    func setNoDataView()
    func manageErrors(error: Error?)
    func showNoConnectionAlert()
}

protocol InitialDataStore {
    var character: Character? { get set }
}

class InitialPresenter: InitialPresenterLogic, InitialDataStore {
    
    weak var view: (InitialDisplayLogic & InitialRouterLogic)?
    
    private var characterData: CharacterResponse? {
        didSet { self.didUpdateCharacterData() }
    }
    
    var characters: [Character] = []
    let maxItems = 20
    var page: Int = 0
    var searchText: String = ""
    var isLoadingPage: Bool = false
    var character: Character?
    var toIndex: Int {
        return self.maxItems*self.page
    }
    
    var repository: CharactersRepository = CharactersRepository()

    func setupView() {
        view?.setupView()
        repository.delegate = self
        
        loadCharacters()
    }
    
    private func loadCharacters() {
        guard Reachability.isConnectedToNetwork() else {
            view?.showNoConnectionAlert()
            return
        }
        
        isLoadingPage = true
        repository.getCharacters(searchText, page: page, maxItems: maxItems)

    }
    
    func searchCharacters(textSearch: String?) {
        searchText = textSearch ?? ""
        page = 0
        loadCharacters()
    }
    
    func setFalseLoadingPage() {
        isLoadingPage = false
    }
    
    func loadNextPage() {
        if !isLoadingPage {
            page += 1
            loadCharacters()
        }
    }
    
    private func didUpdateCharacterData() {
        
        if page >= 1 {
            characters.append(contentsOf: characterData?.data?.results ?? [])
        } else {
            characters = characterData?.data?.results ?? []
        }
        
    }
    
    func numberOfCellItems() -> Int {
        return characters.count
    }
    
    func getCellItem(index: Int) -> CharacterCellData? {
        let character = characters.getElement(index)
        
        return CharacterCellData(title: character?.name ?? "", imageURL: character?.thumbnail?.url)
    }
    
    func didSelectCellAt(index: Int) {
        guard Reachability.isConnectedToNetwork() else {
            view?.showNoConnectionAlert()
            return
        }
        
        guard let character = characters.getElement(index) else {
            return
        }
        
        repository.getCharacter(character.id ?? 0)
    }
}

extension InitialPresenter: CharactersDelegate {
    
    func finishGetCharacters(characterData: CharacterResponse?, error: Error?) {
        if error != nil {
            self.view?.manageErrors(error: error)
        } else {
            self.characterData = characterData

            if (self.characters.isEmpty && (self.page == 0)) {
                self.view?.setNoDataView()
            }
            
            if toIndex < self.numberOfCellItems() {
                self.view?.refreshCards(toIndex: toIndex)
            }
        }
    }
    
    func finishGetCharacter(characterData: CharacterResponse?, error: Error?) {
        if error != nil {
            self.view?.manageErrors(error: error)
        } else {
            if characterData?.data?.results?.count ?? 0 > 0 {
                self.character = characterData?.data?.results?.getElement(0)
                view?.navigateToCharacterDetail()
            } else {
                self.view?.manageErrors(error: ServerError(code: "", message: "No data"))
            }
        }
    }
}


