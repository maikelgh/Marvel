//
//  CustomRedHeaderView.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//

import UIKit

class CustomRedHeaderView: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor.red
        self.button.setImage("icon-arrowup".image, for: .normal)
        self.button.backgroundColor = UIColor.red
        self.button.tintColor = UIColor.white
        self.title.textColor = UIColor.white
    }

    func config(title: String) {
        self.title.text = title
    }
}
