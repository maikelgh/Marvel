//
//  UIViewExtension.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//

import Foundation
import UIKit

public extension UIView {

    func xibSetup() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))

        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return view
        }
        return UIView()
    }

    func allSubviews<T>(of type: T.Type) -> [T] {
        var views = [T]()

        for subview in self.subviews {

            views += subview.allSubviews(of: type) as [T]

            if let subview = subview as? T {
                views.append(subview)
            }
        }
        return views
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func ui(_ f: @escaping () -> Void) {
        DispatchQueue.main.async {
            f()
        }
    }
    
    func background(_ f: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            f()
        }
    }
}
