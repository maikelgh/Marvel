//
//  CharacterDetailPresenterTests.swift
//  Marvel
//
//  Created by Michael Green on 19/9/21.
//  Copyright (c) 2021 MGH. All rights reserved.
//

@testable import Marvel
import XCTest

class CharacterDetailPresenterTests: XCTestCase {
    // MARK: Subject under test
  
    var sut: CharacterDetailPresenter!
  
    // MARK: Test lifecycle
  
    override func setUp() {
        super.setUp()
        setupCharacterDetailPresenter()
    }
  
    override func tearDown() {
        super.tearDown()
    }
  
    // MARK: Test setup
  
    func setupCharacterDetailPresenter() {
        sut = CharacterDetailPresenter()
    }
  
    // MARK: Spies
  
    class CharacterDetailDisplayLogicSpy: CharacterDetailDisplayLogic, CharacterDetailRouterLogic {
        
        var setupViewCalled = false
        var setupComicsCalled = false
        var setupSeriesCalled = false
        var setupStoriesCalled = false
        var setupEventsCalled = false
        var setupExtraInfoCalled = false
        var refreshDataCalled = false
        
        func setupView(withData: Bool) {
            setupViewCalled = true
        }
        
        func setup(comics: [ComicSummary]) {
            setupComicsCalled = true
        }
        
        func setup(series: [SeriesSummary]) {
            setupSeriesCalled = true
        }
        
        func setup(stories: [StorySummary]) {
            setupStoriesCalled = true
        }
        
        func setup(events: [EventSummary]) {
            setupEventsCalled = true
        }
        
        func setup(extraInfo: [URLMarvel]) {
            setupExtraInfoCalled = true
        }
        
        func refreshData(model: CharacterDetail.Model?) {
            refreshDataCalled = true
        }
        
        // MARK: Router Spy Logic
    }
  
    // MARK: Tests
    
    func testSetupWithEmptyData() {
        // Given
        let spy = CharacterDetailDisplayLogicSpy()
        sut.view = spy
        
        // When
        sut.setupView()
        
        // Then
        XCTAssertTrue(spy.setupViewCalled, "setupView() should ask the view controller to setupView()")
        XCTAssertTrue(spy.setupComicsCalled, "setupView() should ask the view controller to setup(comics)")
        XCTAssertTrue(spy.setupSeriesCalled, "setupView() should ask the view controller to setup(series)")
        XCTAssertTrue(spy.setupStoriesCalled, "setupView() should ask the view controller to setup(stories)")
        XCTAssertTrue(spy.setupEventsCalled, "setupView() should ask the view controller to setup(events)")
        XCTAssertTrue(spy.setupExtraInfoCalled, "setupView() should ask the view controller to setup(extraInfo)")
        XCTAssertTrue(spy.refreshDataCalled, "setupView() should ask the view controller to refreshData()")
        XCTAssertTrue(sut.model.isEmpty())
    }
    
    func testSetupWithData() {
        // Given
        let spy = CharacterDetailDisplayLogicSpy()
        sut.view = spy
        
        // When
        sut.character = getCharacterData()
        sut.setupView()
        
        // Then
        XCTAssertTrue(spy.setupViewCalled, "setupView() should ask the view controller to setupView()")
        XCTAssertTrue(spy.setupComicsCalled, "setupView() should ask the view controller to setup(comics)")
        XCTAssertTrue(spy.setupSeriesCalled, "setupView() should ask the view controller to setup(series)")
        XCTAssertTrue(spy.setupStoriesCalled, "setupView() should ask the view controller to setup(stories)")
        XCTAssertTrue(spy.setupEventsCalled, "setupView() should ask the view controller to setup(events)")
        XCTAssertTrue(spy.setupExtraInfoCalled, "setupView() should ask the view controller to setup(extraInfo)")
        XCTAssertTrue(spy.refreshDataCalled, "setupView() should ask the view controller to refreshData()")
        XCTAssertFalse(sut.model.isEmpty())
    }
}
