//
//  InitialViewController.swift
//  Marvel
//
//  Created by Michael Green on 12/9/21.
//  Copyright (c) 2021 MGH. All rights reserved.
//

import UIKit

protocol InitialPresenterLogic {
    func setupView()
    func numberOfCellItems() -> Int
    func getCellItem(index: Int) -> CharacterCellData?
    func didSelectCellAt(index: Int)
    func searchCharacters(textSearch: String?)
    func loadNextPage()
    func setFalseLoadingPage()
}

class InitialViewController: BaseViewController {
    var presenter: InitialPresenterLogic?
    var dataStore: InitialDataStore?
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Setup
  
    override func setupScene() {
        let viewController = self
        let presenter = InitialPresenter()
        
        presenter.view = viewController
        viewController.dataStore = presenter
        self.presenter = presenter
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
}

// MARK: - Display Logic

extension InitialViewController: InitialDisplayLogic {
    
    func setupView() {
        self.title = "MARVEL"
        configSearchBar()
        configCollectionView()
    }
    
    private func configSearchBar() {
        searchBar.delegate = self
    }
    
    private func configCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier)
    }
    
    func refreshCards(toIndex: Int) {
        ui {
            self.collectionView.restore()
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(row: toIndex, section: 0), at: .bottom, animated: false)
            self.view.setNeedsLayout()
            self.presenter?.setFalseLoadingPage()
        }
    }
    
    func setNoDataView() {
        ui {
            self.collectionView.setEmptyMessage("Nothing to show")
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Delegates

extension InitialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 2
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfCellItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier, for: indexPath) as? CharacterCollectionViewCell, let data = presenter?.getCellItem(index: indexPath.row) else {
            return UICollectionViewCell()
        }

        cell.updateUI(data: data)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectCellAt(index: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            presenter?.loadNextPage()
        }
    }
}

extension InitialViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let search = searchBar.text else {
            return
        }
        
        presenter?.searchCharacters(textSearch: search.lowercased())
    }
}

// MARK: - Router Logic

protocol InitialRouterLogic: AnyObject {
    func navigateToCharacterDetail()
}

protocol InitialDataPass {
    var dataStore: InitialDataStore? { get }
}

extension InitialViewController: InitialRouterLogic, InitialDataPass {
    func navigateToCharacterDetail() {
        ui {
            let storyBoard = UIStoryboard(name: "CharacterDetail", bundle: nil)
            if let viewController: CharacterDetailViewController = storyBoard.instantiateInitialViewController() as? CharacterDetailViewController {
                self.passDataToCharacterDetail(source: self.dataStore, destination: &viewController.dataStore)
                self.navigationController?.show(viewController, sender: nil)
            }
        }
    }
    
    // MARK: Passing data
    
    func passDataToCharacterDetail(source: InitialDataStore?, destination: inout CharacterDetailDataStore?) {
        destination?.character = source?.character
    }
}
