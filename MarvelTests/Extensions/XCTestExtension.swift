//
//  XCTestExtension.swift
//  Marvel
//
//  Created by Michael Green on 19/9/21.
//

@testable import Marvel
import XCTest

extension XCTestCase {

    func waitUI(withDelay: Double = 0) {
        let uiExpectation = expectation(description: "UI Waiting")
        DispatchQueue.main.asyncAfter(deadline: .now() + withDelay + 0.2) {
            uiExpectation.fulfill()
        }
        waitForExpectations(timeout: withDelay + 50, handler: nil)
    }
    
    func getCharacterData() -> Character {
        return Character(id: 1, name: "Prueba", description: "Prueba", modified: "Prueba", resourceURI: "Prueba", urls: [URLMarvel(type: "Prueba", url: "Prueba")], thumbnail:Image(path: "not-found-image", ext: ""), comics: ComicList(available: 1, returned: 1, collectionURI: "Prueba", items: [ComicSummary(resourceURI: "Prueba", name: "Prueba")]), series: SeriesList(available: 1, returned: 1, collectionURI: "Prueba", items: [SeriesSummary(resourceURI: "Prueba", name: "Prueba")]), stories: StoryList(available: 1, returned: 1, collectionURI: "Prueba", items: [StorySummary(resourceURI: "Prueba", name: "Prueba", type: "Prueba")]), events: EventList(available: 1, returned: 1, collectionURI: "Prueba", items: [EventSummary(resourceURI: "Prueba", name: "Prueba")]))
    }
}
