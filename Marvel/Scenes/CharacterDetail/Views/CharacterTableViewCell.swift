//
//  CharacterTableViewCell.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "CharacterTableViewCellIdentifier"
    @IBOutlet weak var label: UILabel!
    var url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
