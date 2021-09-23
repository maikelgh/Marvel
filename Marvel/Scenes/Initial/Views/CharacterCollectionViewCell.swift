//
//  CharacterCollectionViewCell.swift
//  Marvel
//
//  Created by Michael Green on 12/9/21.
//

import UIKit

struct CharacterCellData {
    let title: String
    let imageURL: URL?
}

class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: ImageLoader!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let cellIdentifier = "CharacterCollectionViewCellIdentifier"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10.0
    }

    func updateUI(data: CharacterCellData) {
        title.text = data.title
        guard let url = data.imageURL else {
            return
        }
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        self.imageView.loadImage(from: url) { (_) in
            self.ui {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
}
