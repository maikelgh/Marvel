//
//  StringExtension.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//

import Foundation
import UIKit

extension String {

    var image: UIImage {
        return UIImage(named: self) ?? UIImage()
    }
}
