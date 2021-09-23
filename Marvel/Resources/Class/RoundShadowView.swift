//
//  RoundShadowView.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//

import UIKit

class RoundShadowView: UIView {

    private var shadowLayer: CAShapeLayer!

    @IBInspectable var back: UIColor? {
        didSet {}
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        ui {
            if let layer = self.shadowLayer {
                layer.removeFromSuperlayer()
            }
            
            self.shadowLayer = CAShapeLayer()
            
            self.shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8.0).cgPath
            self.shadowLayer.fillColor = self.back?.cgColor
            
            self.shadowLayer.shadowColor = UIColor.black.cgColor
            self.shadowLayer.shadowPath = self.shadowLayer.path
            self.shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.shadowLayer.shadowOpacity = 0.5
            self.shadowLayer.shadowRadius = 2
            
            self.layer.insertSublayer(self.shadowLayer, at: 0)

        }
    }
    
}
