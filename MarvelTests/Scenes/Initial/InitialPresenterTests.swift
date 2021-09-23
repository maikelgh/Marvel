//
//  InitialPresenterTests.swift
//  Marvel
//
//  Created by Michael Green on 19/9/21.
//  Copyright (c) 2021 MGH. All rights reserved.
//

@testable import Marvel
import XCTest

class InitialPresenterTests: XCTestCase {
    // MARK: Subject under test
  
    var sut: InitialPresenter!
  
    // MARK: Test lifecycle
  
    override func setUp() {
        super.setUp()
        setupInitialPresenter()
    }
  
    override func tearDown() {
        super.tearDown()
    }
  
    // MARK: Test setup
  
    func setupInitialPresenter() {
        sut = InitialPresenter()
    }
  
    // MARK: Spies
  
    class InitialDisplayLogicSpy: InitialDisplayLogic, InitialRouterLogic {
        
        var setupViewCalled = false
        var refreshCardsCalled = false
        var setNoDataViewCalled = false
        var manageErrorsCalled = false
        var showNoConnectionAlertCalled = false
        
        func setupView() {
            setupViewCalled = true
        }
        
        func refreshCards(toIndex: Int) {
            refreshCardsCalled = true
        }
        
        func setNoDataView() {
            setNoDataViewCalled = true
        }
        
        func manageErrors(error: Error?) {
            manageErrorsCalled = true
        }
        
        func showNoConnectionAlert() {
            showNoConnectionAlertCalled = true
        }
        
        // MARK: Router Spy Logic
        var navigateToCharacterDetailCalled = false
        
        func navigateToCharacterDetail() {
            navigateToCharacterDetailCalled = true
        }
    }
    
    class CharactersRepositorySpy: CharactersRepository{

        var isFailure = false
        var withData = false
        var getCharactersCalled = false
        var getCharacterCalled = false
        
        var characterData: CharacterResponse {
            return CharacterResponse(code: 200, status: "", copyright: "", attributionText: "", attributionHTML: "", data: CharacterDataContainer(offset: 0, limit: 0, total: 0, count: 0, results: [getCharacterData()]), etag: "")
        }

        var characterVoid: CharacterResponse {
            return CharacterResponse(code: 0, status: "", copyright: "", attributionText: "", attributionHTML: "", data: nil, etag: "")
        }

        override func getCharacters(_ name: String = "", page: Int = 0, maxItems: Int = 20) {
            getCharactersCalled = true
            
            if isFailure {
                let error = ServerError(code: "", message: "Error")
                self.delegate?.finishGetCharacters(characterData: nil, error: error)
            } else {
                let response = withData ? characterData : characterVoid
                self.delegate?.finishGetCharacters(characterData: response, error: nil)
            }
        }
        
        override func getCharacter(_ id: Int, maxItems: Int = 20) {
            getCharacterCalled = true
            
            if isFailure {
                let error = ServerError(code: "", message: "Error")
                self.delegate?.finishGetCharacter(characterData: nil, error: error)
            } else {
                let response = withData ? characterData : characterVoid
                self.delegate?.finishGetCharacter(characterData: response, error: nil)
            }
        }
        
        func getCharacterData() -> Character {
            return Character(id: 1, name: "Prueba", description: "Prueba", modified: "Prueba", resourceURI: "Prueba", urls: [URLMarvel(type: "Prueba", url: "Prueba")], thumbnail:Image(path: "not-found-image", ext: ""), comics: ComicList(available: 1, returned: 1, collectionURI: "Prueba", items: [ComicSummary(resourceURI: "Prueba", name: "Prueba")]), series: SeriesList(available: 1, returned: 1, collectionURI: "Prueba", items: [SeriesSummary(resourceURI: "Prueba", name: "Prueba")]), stories: StoryList(available: 1, returned: 1, collectionURI: "Prueba", items: [StorySummary(resourceURI: "Prueba", name: "Prueba", type: "Prueba")]), events: EventList(available: 1, returned: 1, collectionURI: "Prueba", items: [EventSummary(resourceURI: "Prueba", name: "Prueba")]))
        }
    }
  
    // MARK: Tests
  
    func testSetupWithData() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = false
        repositorySpy.withData = true
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        for _ in 1...20 {
            sut.characters.append(getCharacterData())
        }
        sut.setupView()
        
        // Then
        XCTAssertTrue(spy.setupViewCalled, "setupView() should ask the view controller to setupView()")
        XCTAssertTrue(sut.repository.delegate != nil, "setupView() should setup repository delegate")
        XCTAssertTrue(sut.isLoadingPage, "setupView() should set isLoadingPage to true")
        XCTAssertTrue(repositorySpy.getCharactersCalled, "setupView() should ask the repository to getCharacters()")
        XCTAssertTrue(spy.refreshCardsCalled, "setupView() should ask the view controller to refreshCards()")
        XCTAssertFalse(spy.manageErrorsCalled, "setupView() shouldn´t ask the view controller to manageErrors()")
        XCTAssertFalse(spy.setNoDataViewCalled, "setupView() shouldn´t ask the view controller to setNoDataView()")
    }
    
    func testSetupWithEmptyData() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = false
        repositorySpy.withData = false
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        sut.setupView()
        
        // Then
        XCTAssertTrue(spy.setupViewCalled, "setupView() should ask the view controller to setupView()")
        XCTAssertTrue(sut.repository.delegate != nil, "setupView() should setup repository delegate")
        XCTAssertTrue(sut.isLoadingPage, "setupView() should set isLoadingPage to true")
        XCTAssertTrue(repositorySpy.getCharactersCalled, "setupView() should ask the repository to getCharacters()")
        XCTAssertFalse(spy.manageErrorsCalled, "setupView() shouldn´t ask the view controller to manageErrors()")
        XCTAssertTrue(spy.setNoDataViewCalled, "setupView() should ask the view controller to setNoDataView()")
        XCTAssertFalse(spy.refreshCardsCalled, "setupView() shouldn´t ask the view controller to refreshCards()")
    }
    
    func testSetupWithError() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = true
        repositorySpy.withData = false
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        sut.setupView()
        
        // Then
        XCTAssertTrue(spy.setupViewCalled, "setupView() should ask the view controller to setupView()")
        XCTAssertTrue(sut.repository.delegate != nil, "setupView() should setup repository delegate")
        XCTAssertTrue(sut.isLoadingPage, "setupView() should set isLoadingPage to true")
        XCTAssertTrue(repositorySpy.getCharactersCalled, "setupView() should ask the repository to getCharacters()")
        XCTAssertTrue(spy.manageErrorsCalled, "setupView() should ask the view controller to manageErrors()")
        XCTAssertFalse(spy.setNoDataViewCalled, "setupView() shouldn´t ask the view controller to setNoDataView()")
        XCTAssertFalse(spy.refreshCardsCalled, "setupView() shouldn´t ask the view controller to refreshCards()")
    }
    
    func testLoadNextPageWithData() {
        // Given
        let spy = InitialDisplayLogicSpy()
        
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = false
        repositorySpy.withData = true
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        
        sut.view = spy
        
        // When
        for _ in 1...20 {
            sut.characters.append(getCharacterData())
        }
        let previusPage = sut.page
        sut.loadNextPage()
        
        // Then
        XCTAssertTrue(repositorySpy.getCharactersCalled, "loadNextPage() should ask the repository to getCharacters()")
        XCTAssertEqual(previusPage+1, sut.page, "loadNextPage() should increase 1 page")
        XCTAssertTrue(spy.refreshCardsCalled, "loadNextPage() should ask the view controller to refreshCards()")
        XCTAssertFalse(spy.manageErrorsCalled, "loadNextPage() shouldn´t ask the view controller to manageErrors()")
        XCTAssertFalse(spy.setNoDataViewCalled, "loadNextPage() shouldn´t ask the view controller to setNoDataView()")
    }
    
    func testLoadNextPageWithEmptyData() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = false
        repositorySpy.withData = false
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        for _ in 1...20 {
            sut.characters.append(getCharacterData())
        }
        sut.loadNextPage()
        
        // Then
        XCTAssertTrue(repositorySpy.getCharactersCalled, "loadNextPage() should ask the repository to getCharacters()")
        XCTAssertFalse(spy.manageErrorsCalled, "loadNextPage() shouldn´t ask the view controller to manageErrors()")
        XCTAssertFalse(spy.setNoDataViewCalled, "loadNextPage() shouldn´t ask the view controller to setNoDataView()")
        XCTAssertFalse(spy.refreshCardsCalled, "loadNextPage() shouldn´t ask the view controller to refreshCards()")
    }
    
    func testLoadNextPageWithError() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = true
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        sut.loadNextPage()
        
        // Then
        XCTAssertTrue(repositorySpy.getCharactersCalled, "loadNextPage() should ask the repository to getCharacters()")
        XCTAssertTrue(spy.manageErrorsCalled, "loadNextPage() should ask the view controller to manageErrors()")
        XCTAssertFalse(spy.setNoDataViewCalled, "loadNextPage() shouldn´t ask the view controller to setNoDataView()")
        XCTAssertFalse(spy.refreshCardsCalled, "loadNextPage() shouldn´t ask the view controller to refreshCards()")
    }
    
    func testSearchCharactersWithData() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = false
        repositorySpy.withData = true
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        for _ in 1...20 {
            sut.characters.append(getCharacterData())
        }
        sut.searchCharacters(textSearch: "A")
        
        // Then
        XCTAssertTrue(repositorySpy.getCharactersCalled, "searchCharacters() should ask the repository to getCharacters()")
        XCTAssertEqual(0, sut.page, "searchCharacters() should set page to 0")
        XCTAssertTrue(spy.refreshCardsCalled, "searchCharacters() should ask the view controller to refreshCards()")
        XCTAssertFalse(spy.manageErrorsCalled, "searchCharacters() shouldn´t ask the view controller to manageErrors()")
        XCTAssertFalse(spy.setNoDataViewCalled, "searchCharacters() shouldn´t ask the view controller to setNoDataView()")
    }
    
    func testSearchCharactersWithEmptyData() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = false
        repositorySpy.withData = false
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        for _ in 1...20 {
            sut.characters.append(getCharacterData())
        }
        sut.searchCharacters(textSearch: "A")
        
        // Then
        XCTAssertTrue(repositorySpy.getCharactersCalled, "searchCharacters() should ask the repository to getCharacters()")
        XCTAssertEqual(0, sut.page, "searchCharacters() should set page to 0")
        XCTAssertTrue(spy.setNoDataViewCalled, "searchCharacters() should ask the view controller to setNoDataView()")
        XCTAssertFalse(spy.refreshCardsCalled, "searchCharacters() shouldn´t ask the view controller to refreshCards()")
        XCTAssertFalse(spy.manageErrorsCalled, "searchCharacters() shouldn´t ask the view controller to manageErrors()")
    }
    
    func testSearchCharactersWithError() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = true
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        for _ in 1...20 {
            sut.characters.append(getCharacterData())
        }
        sut.searchCharacters(textSearch: "A")
        
        // Then
        XCTAssertTrue(repositorySpy.getCharactersCalled, "searchCharacters() should ask the repository to getCharacters()")
        XCTAssertTrue(spy.manageErrorsCalled, "searchCharacters() should ask the view controller to manageErrors()")
        XCTAssertEqual(0, sut.page, "searchCharacters() should set page to 0")
        XCTAssertFalse(spy.refreshCardsCalled, "searchCharacters() shouldn´t ask the view controller to refreshCards()")
        XCTAssertFalse(spy.setNoDataViewCalled, "searchCharacters() shouldn´t ask the view controller to setNoDataView()")
    }
    
    func testNumberOfCellItems() {
        // Given
        let spy = InitialDisplayLogicSpy()
        sut.view = spy
        
        // When
        for _ in 1...3 {
            sut.characters.append(getCharacterData())
        }
        
        // Then
        XCTAssertEqual(sut.numberOfCellItems(), sut.characters.count, "numberOfCellItems() should return characters elements")
    }
    
    func testSetFalseLoadingPage() {
        // Given
        let spy = InitialDisplayLogicSpy()
        sut.view = spy
        
        // When
        sut.setFalseLoadingPage()
        
        
        // Then
        XCTAssertFalse(sut.isLoadingPage, "setFalseLoadingPage() should set isLoadingPage to false")
    }
    
    func testDidSelectCellAtWithData() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = false
        repositorySpy.withData = true
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        sut.characters = [getCharacterData()]
        sut.didSelectCellAt(index: 0)
        
        
        // Then
        XCTAssertTrue(repositorySpy.getCharacterCalled, "didSelectCellAt() should ask the repository to getCharacters()")
        XCTAssertTrue(spy.navigateToCharacterDetailCalled, "didSelectCellAt() should ask the repository to navigateToCharacterDetail()")
        XCTAssertFalse(spy.manageErrorsCalled, "didSelectCellAt() shouldn´t ask the repository to manageErrors()")
    }
    
    func testDidSelectCellAtWithEmptyData() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = false
        repositorySpy.withData = false
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        for _ in 1...20 {
            sut.characters.append(getCharacterData())
        }
        sut.didSelectCellAt(index: 0)
        
        
        // Then
        XCTAssertTrue(repositorySpy.getCharacterCalled, "didSelectCellAt() should ask the repository to getCharacters()")
        XCTAssertTrue(spy.manageErrorsCalled, "didSelectCellAt() should ask the repository to manageErrors()")
        XCTAssertFalse(spy.navigateToCharacterDetailCalled, "didSelectCellAt() shouldn´t ask the repository to navigateToCharacterDetail()")
    }
    
    func testDidSelectCellAtWithError() {
        // Given
        let spy = InitialDisplayLogicSpy()
        let repositorySpy = CharactersRepositorySpy()
        repositorySpy.isFailure = true
        repositorySpy.delegate = sut
        sut.repository = repositorySpy
        sut.view = spy
        
        // When
        for _ in 1...20 {
            sut.characters.append(getCharacterData())
        }
        sut.didSelectCellAt(index: 0)
        
        
        // Then
        XCTAssertTrue(repositorySpy.getCharacterCalled, "didSelectCellAt() should ask the repository to getCharacters()")
        XCTAssertTrue(spy.manageErrorsCalled, "didSelectCellAt() should ask the repository to manageErrors()")
        XCTAssertFalse(spy.navigateToCharacterDetailCalled, "didSelectCellAt() shouldn´t ask the repository to navigateToCharacterDetail()")
    }
}
