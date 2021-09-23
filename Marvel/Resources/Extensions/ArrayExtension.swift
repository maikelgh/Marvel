//
//  ArrayExtension.swift
//  Marvel
//
//  Created by Michael Green on 12/9/21.
//

import Foundation

extension Array {

    func getElement(_ index: Int) -> Element? {
        guard index >= 0, index < self.count else {
            return nil
        }
        return self[index]
    }
    
}
