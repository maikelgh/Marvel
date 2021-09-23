//
//  CharacterDetailViewControllerTests.swift
//  Marvel
//
//  Created by Michael Green on 19/9/21.
//  Copyright (c) 2021 MGH. All rights reserved.
//

@testable import Marvel
import XCTest

class CharacterDetailViewControllerTests: XCTestCase {
    // MARK: Subject under test
  
    var sut: CharacterDetailViewController!
    var window: UIWindow!
  
    // MARK: Test lifecycle
  
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupCharacterDetailViewController()
    }
  
    override func tearDown() {
        window = nil
        super.tearDown()
    }
  
    // MARK: Test setup
  
    func setupCharacterDetailViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "CharacterDetail", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "CharacterDetailViewController") as? CharacterDetailViewController
    }
  
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
  
    // MARK: Spies
  
    class CharacterDetailPresenterLogicSpy: CharacterDetailPresenterLogic {
        
        var setupViewCalled = false
        var numberOfItemsCalled = false
        var getItemCalled = false

        func setupView() {
            setupViewCalled = true
        }
        
        func numberOfItems() -> Int {
            numberOfItemsCalled = true
            return 0
        }
        
        func getItem(index: Int) -> String {
            getItemCalled = true
            return ""
        }
        
    }
  
  // MARK: Tests
  
    func testShouldSetupViewWhenViewIsLoaded() {
        // Given
        let spy = CharacterDetailPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()

        // Then
        XCTAssertTrue(spy.setupViewCalled, "viewDidLoad() should ask the presenter to setupView()")
    }
    
    func testShouldHideContainerViewWithEmptyData() {
        // Given
        let spy = CharacterDetailPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()
        sut.setup(comics: [])
        sut.setup(series: [])
        sut.setup(stories: [])
        sut.setup(events: [])
        sut.setup(extraInfo: [])
        waitUI()

        // Then
        XCTAssertTrue(sut.containerComics.isHidden, "setup(comics) with empty data should hide containerComics")
        XCTAssertTrue(sut.containerSeries.isHidden, "setup(series) with empty data should hide containerSeries")
        XCTAssertTrue(sut.containerStories.isHidden, "setup(stories) with empty data should hide containerStories")
        XCTAssertTrue(sut.containerEvents.isHidden, "setup(events) with empty data should hide containerEvents")
        XCTAssertTrue(sut.containerMoreInfo.isHidden, "setup(extraInfo) with empty data should hide containerMoreInfo")
    }
    
    func testShouldShowContainerViewWithData() {
        // Given
        let spy = CharacterDetailPresenterLogicSpy()
        sut.presenter = spy

        // When
        loadView()
        
        sut.setup(comics: [ComicSummary(resourceURI: "", name: "")])
        sut.setup(series: [SeriesSummary(resourceURI: "", name: "")])
        sut.setup(stories: [StorySummary(resourceURI: "", name: "", type: "")])
        sut.setup(events: [EventSummary(resourceURI: "", name: "")])
        sut.setup(extraInfo: [URLMarvel(type: "", url: "")])
        waitUI()

        // Then
        XCTAssertFalse(sut.containerComics.isHidden, "setup(comics) with data should show containerComics")
        XCTAssertFalse(sut.containerSeries.isHidden, "setup(series) with data should show containerSeries")
        XCTAssertFalse(sut.containerStories.isHidden, "setup(stories) with data should show containerStories")
        XCTAssertFalse(sut.containerEvents.isHidden, "setup(events) with data should show containerEvents")
        XCTAssertFalse(sut.containerMoreInfo.isHidden, "setup(extraInfo) with data should show containerMoreInfo")
        XCTAssertTrue(sut.viewMoreInfo.delegate != nil, "setup(extraInfo) with data should setup viewMoreInfo.delegate")
    }
}
