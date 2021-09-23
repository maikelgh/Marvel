//
//  CharacterDetailModels.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//  Copyright (c) 2021 MGH. All rights reserved.
//

import Foundation

enum CharacterDetail {
    
    struct Model {
        var name: String = ""
        var description: String = ""
        var imageUrl: URL?
        var comics: [ComicSummary] = []
        var series: [SeriesSummary] = []
        var stories: [StorySummary] = []
        var events: [EventSummary] = []
        var extraInfo: [URLMarvel] = []
        
        init() {}
        
        init(character: Character?) {
            
            self.name = character?.name ?? ""
            self.description = character?.description ?? ""
            if let url = character?.thumbnail?.url {
                self.imageUrl = url
            }
            self.comics = character?.comics?.items ?? []
            self.series = character?.series?.items ?? []
            self.stories = character?.stories?.items ?? []
            self.events = character?.events?.items ?? []
            self.extraInfo = character?.urls ?? []
        }
        
        func isEmpty() -> Bool {
            
            if self.name == "" &&
                self.description == "" &&
                self.imageUrl == nil &&
                self.comics.count == 0 &&
                self.series.count == 0 &&
                self.stories.count == 0 &&
                self.events.count == 0 &&
                self.extraInfo.count == 0{
                return true
            }
            return false
        }
    }
}
