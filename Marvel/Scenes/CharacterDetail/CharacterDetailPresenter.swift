//
//  CharacterDetailPresenter.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//  Copyright (c) 2021 MGH. All rights reserved.
//

import Foundation

protocol CharacterDetailDisplayLogic: AnyObject {
    func setupView(withData: Bool)
    func setup(comics: [ComicSummary])
    func setup(series: [SeriesSummary])
    func setup(stories: [StorySummary])
    func setup(events: [EventSummary])
    func setup(extraInfo: [URLMarvel])
    func refreshData(model: CharacterDetail.Model?)
}

protocol CharacterDetailDataStore {
    var character: Character? { get set }
}

class CharacterDetailPresenter: CharacterDetailPresenterLogic, CharacterDetailDataStore {
    
    weak var view: (CharacterDetailDisplayLogic & CharacterDetailRouterLogic)?
    
    var character: Character?
    var model: CharacterDetail.Model = CharacterDetail.Model()

    func setupView() {
        self.model = CharacterDetail.Model(character: self.character)
        view?.setupView(withData: !model.isEmpty())
        self.view?.setup(comics: model.comics)
        self.view?.setup(series: model.series)
        self.view?.setup(stories: model.stories)
        self.view?.setup(events: model.events)
        self.view?.setup(extraInfo: model.extraInfo)
        self.view?.refreshData(model: model)
    }
}
