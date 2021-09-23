//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//  Copyright (c) 2021 MGH. All rights reserved.
//

import UIKit

protocol CharacterDetailPresenterLogic {
    func setupView()
}

class CharacterDetailViewController: BaseViewController {
    var presenter: CharacterDetailPresenterLogic?
    var dataStore: CharacterDetailDataStore?
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var imageView: ImageLoader!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var containerSeries: UIView!
    @IBOutlet weak var viewSeries: ExpandableView!
    @IBOutlet weak var containerComics: UIView!
    @IBOutlet weak var viewComics: ExpandableView!
    @IBOutlet weak var containerStories: UIView!
    @IBOutlet weak var viewStories: ExpandableView!
    @IBOutlet weak var containerEvents: UIView!
    @IBOutlet weak var viewEvents: ExpandableView!
    @IBOutlet weak var containerMoreInfo: UIView!
    @IBOutlet weak var viewMoreInfo: ExpandableView!
    @IBOutlet weak var viewLabel: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Setup
  
    override func setupScene() {
        let viewController = self
        let presenter = CharacterDetailPresenter()
        
        presenter.view = viewController
        viewController.dataStore = presenter
        self.presenter = presenter
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.isHidden = true
        self.activityIndicator.isHidden = true
        self.viewLabel.isHidden = true
        presenter?.setupView()
    }
}

// MARK: - Display Logic

extension CharacterDetailViewController: CharacterDetailDisplayLogic {

    func setupView(withData: Bool) {
        ui{
            self.imageView.isHidden = !withData
            self.activityIndicator.isHidden = !withData
            self.viewLabel.isHidden = !withData
        }
    }
    
    func refreshData(model: CharacterDetail.Model?) {
        ui {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            if let url = model?.imageUrl {
                self.imageView.loadImage(from: url) { (_) in
                    self.ui {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                }
            }
        
            self.labelName.text = model?.name
            self.labelDescription.text = model?.description
        }
    }
    
    func setup(comics: [ComicSummary]) {

        var comicModel = ExpandableViewModel()
        comicModel.title = String(format: "Comics (%d)", comics.count)
        comicModel.fixed = [
            
        ]
        comicModel.expandables = comics
        comicModel.isExpanded = false
        comicModel.type = .comic

        ui {
            self.viewComics.config(model: comicModel)
            self.containerComics.isHidden = comics.isEmpty
            self.stackView.layoutIfNeeded()
        }
    }
    
    func setup(series: [SeriesSummary]) {
        var serieModel = ExpandableViewModel()
        serieModel.title = String(format: "Series (%d)", series.count)
        serieModel.fixed = [
            
        ]
        serieModel.expandables = series
        serieModel.isExpanded = false
        serieModel.type = .serie

        ui {
            self.viewSeries.config(model: serieModel)
            self.containerSeries.isHidden = series.isEmpty
            self.stackView.layoutIfNeeded()
        }
    }
    
    func setup(stories: [StorySummary]) {
        var storyModel = ExpandableViewModel()
        storyModel.title = String(format: "Stories (%d)", stories.count)
        storyModel.fixed = [
            
        ]
        storyModel.expandables = stories
        storyModel.isExpanded = false
        storyModel.type = .story

        ui {
            self.viewStories.config(model: storyModel)
            self.containerStories.isHidden = stories.isEmpty
            self.stackView.layoutIfNeeded()
        }
    }
    
    func setup(events: [EventSummary]) {
        var eventModel = ExpandableViewModel()
        eventModel.title = String(format: "Events (%d)", events.count)
        eventModel.fixed = [
            
        ]
        eventModel.expandables = events
        eventModel.isExpanded = false
        eventModel.type = .event

        ui {
            self.viewEvents.config(model: eventModel)
            self.containerEvents.isHidden = events.isEmpty
            self.stackView.layoutIfNeeded()
        }
    }
    
    func setup(extraInfo: [URLMarvel]) {
        var extraInfoModel = ExpandableViewModel()
        extraInfoModel.title = String(format: "Other Info (%d)", extraInfo.count)
        extraInfoModel.fixed = [
            
        ]
        extraInfoModel.expandables = extraInfo
        extraInfoModel.isExpanded = false
        extraInfoModel.type = .url
        viewMoreInfo.delegate = self

        ui {
            self.viewMoreInfo.config(model: extraInfoModel)
            self.containerMoreInfo.isHidden = extraInfo.isEmpty
            self.stackView.layoutIfNeeded()
        }
    }
}

// MARK: - Delegates

extension CharacterDetailViewController: ExpandableViewDelegate {
    func didSelectItem(urlString: String) {
        guard let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
}

// MARK: - Router Logic

protocol CharacterDetailRouterLogic: AnyObject {

}

protocol CharacterDetailDataPass {
    var dataStore: CharacterDetailDataStore? { get }
}

extension CharacterDetailViewController: CharacterDetailRouterLogic, CharacterDetailDataPass {
    

}
