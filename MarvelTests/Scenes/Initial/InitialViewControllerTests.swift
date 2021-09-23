//
//  InitialViewControllerTests.swift
//  Marvel
//
//  Created by Michael Green on 19/9/21.
//  Copyright (c) 2021 MGH. All rights reserved.
//

@testable import Marvel
import XCTest

class InitialViewControllerTests: XCTestCase {
    // MARK: Subject under test
  
    var sut: InitialViewController!
    var window: UIWindow!
  
    // MARK: Test lifecycle
  
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupInitialViewController()
    }
  
    override func tearDown() {
        window = nil
        super.tearDown()
    }
  
    // MARK: Test setup
  
    func setupInitialViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Initial", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as? InitialViewController
    }
  
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
  
    // MARK: Spies
  
    class InitialPresenterLogicSpy: InitialPresenterLogic {
        
        var setupViewCalled = false
        var numberOfCellItemsCalled = false
        var getCellItemCalled = false
        var didSelectCellAtCalled = false
        var searchCharactersCalled = false
        var loadNextPageCalled = false
        var setFalseLoadingPageCalled = false
        var numCells = 5

        func setupView() {
            setupViewCalled = true
        }
        
        func numberOfCellItems() -> Int {
            numberOfCellItemsCalled = true
            return numCells
        }
        
        func getCellItem(index: Int) -> CharacterCellData? {
            getCellItemCalled = true
            return CharacterCellData(title: "", imageURL: URL(string: ""))
        }
        
        func didSelectCellAt(index: Int) {
            didSelectCellAtCalled = true
        }
        
        func searchCharacters(textSearch: String?) {
            searchCharactersCalled = true
        }
        
        func loadNextPage() {
            loadNextPageCalled = true
        }
        
        func setFalseLoadingPage() {
            setFalseLoadingPageCalled = true
        }
    }
  
  // MARK: Tests
  
    func testShouldSetupViewWhenViewIsLoaded() {
        // Given
        let spy = InitialPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()

        // Then
        XCTAssertTrue(spy.setupViewCalled, "viewDidLoad() should ask the presenter to setupView()")
    }
    
    func testShouldSetupView() {
        // Given
        let spy = InitialPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()
        sut.setupView()

        // Then
        XCTAssertTrue(sut.searchBar.delegate != nil, "setupView() should setup searchBar delegate")
        XCTAssertTrue(sut.collectionView.delegate != nil, "setupView() should setup collectionView delegate")
        XCTAssertTrue(sut.collectionView.dataSource != nil, "setupView() should setup collectionView dataSource")
        XCTAssertEqual(sut.title, "MARVEL", "setupView() should set title")
    }
    
    func testRefreshCards() {
        // Given
        let spy = InitialPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()
        sut.refreshCards(toIndex: 0)
        waitUI()

        // Then
        XCTAssertTrue(spy.setFalseLoadingPageCalled, "refreshCards() should ask the presenter to setFalseLoadingPage()")
    }
    
    func testSetNoDataView() {
        // Given
        let spy = InitialPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()
        sut.setNoDataView()
        waitUI()

        // Then
        XCTAssertTrue(sut.collectionView.backgroundView != nil, "setNoDataView() should setup backgroundView to collectionView")
    }
    
    func testNavigateToCharacterDetail() {
        // Given
        let nvc = UINavigationController(rootViewController: UIViewController())
        window.rootViewController = nvc
        nvc.show(sut, sender: nil)

        let spy = InitialPresenterLogicSpy()
        sut.presenter = spy
        loadView()

        // When
        sut.navigateToCharacterDetail()
        waitUI()

        // Then
        XCTAssertFalse(nvc.topViewController is InitialViewController, "navigateToCharacterDetail() should navigate to CharacterDetailViewController")
        XCTAssertTrue(nvc.topViewController is CharacterDetailViewController, "navigateToCharacterDetail() should navigate to CharacterDetailViewController")
    }
    
    func testPassDataToPlanDetails() {
        // Given
        let spy = InitialPresenterLogicSpy()
        sut.presenter = spy
        loadView()

        // When
        sut.dataStore?.character = getCharacterData()
        let destination = CharacterDetailViewController()
        sut.passDataToCharacterDetail(source: sut.dataStore, destination: &destination.dataStore)

        // Then
        XCTAssertEqual(destination.dataStore?.character?.name, sut.dataStore?.character?.name)
        XCTAssertEqual(destination.dataStore?.character?.description, sut.dataStore?.character?.description)
        XCTAssertEqual(destination.dataStore?.character?.modified, sut.dataStore?.character?.modified)
        XCTAssertEqual(destination.dataStore?.character?.resourceURI, sut.dataStore?.character?.resourceURI)
        XCTAssertEqual(destination.dataStore?.character?.comics?.available, sut.dataStore?.character?.comics?.available)
        XCTAssertEqual(destination.dataStore?.character?.comics?.items?.count, sut.dataStore?.character?.comics?.items?.count)
        XCTAssertEqual(destination.dataStore?.character?.series?.available, sut.dataStore?.character?.series?.available)
        XCTAssertEqual(destination.dataStore?.character?.series?.items?.count, sut.dataStore?.character?.series?.items?.count)
        XCTAssertEqual(destination.dataStore?.character?.stories?.available, sut.dataStore?.character?.stories?.available)
        XCTAssertEqual(destination.dataStore?.character?.stories?.items?.count, sut.dataStore?.character?.stories?.items?.count)
        XCTAssertEqual(destination.dataStore?.character?.events?.available, sut.dataStore?.character?.events?.available)
        XCTAssertEqual(destination.dataStore?.character?.events?.items?.count, sut.dataStore?.character?.events?.items?.count)
        XCTAssertEqual(destination.dataStore?.character?.urls?.count, sut.dataStore?.character?.urls?.count)
    }
    
    func testSearchBar() {
        // Given
        let spy = InitialPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()
        sut.searchBar(sut.searchBar, textDidChange: "prueba")

        // Then
        XCTAssertTrue(spy.searchCharactersCalled, "searchBar() should ask the presenter to searchCharacters()")
    }
    
    func testNumberOfItemsInSection() {
        // Given
        let spy = InitialPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()
        let num = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)

        // Then
        XCTAssertTrue(spy.numberOfCellItemsCalled, "numberOfItemsInSection() should ask the presenter to numberOfCellItems()")
        XCTAssertEqual(num, spy.numCells)
    }
    
    func testDidSelectItemAt() {
        // Given
        let spy = InitialPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()
        sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))

        // Then
        XCTAssertTrue(spy.didSelectCellAtCalled, "didSelectItemAt() should ask the presenter to didSelectCellAt()")
    }
}
