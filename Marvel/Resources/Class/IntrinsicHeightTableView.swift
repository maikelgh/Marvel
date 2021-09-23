//
//  IntrinsicHeightTableView.swift
//  Marvel
//
//  Created by Michael Green on 18/9/21.
//

import UIKit
import Foundation

class IntrinsicHeightTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ReloadDataIntrinsicHeightTableView: UITableView {
    var contentSizeBool = true

    override var contentSize: CGSize {
        didSet {
            if contentSizeBool {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ReloadDataIntrinsicHeightWithBottomMargin16TableView: UITableView {
    var contentSizeBool = true

    override var contentSize: CGSize {
        didSet {
            if contentSizeBool {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + 16)
    }
}

class ReloadDataIntrinsicHeightCollectionView: UICollectionView {
    var contentSizeBool = true

    override var contentSize: CGSize {
        didSet {
            if contentSizeBool {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

public extension UITableView {
    func register<T: UITableViewCell> (_ type: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.nibName)
    }
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.nibName) as? T else {
            fatalError("\(T.nibName) could not be dequeued as \(T.self)")
        }

        return cell
    }
}

public extension UITableViewCell {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

public extension UICollectionView {
    func register<T: UICollectionViewCell> (_ type: T.Type) {
        register(T.nib, forCellWithReuseIdentifier: T.nibName)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(_ index: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.nibName, for: index) as? T else {
            fatalError("\(T.nibName) could not be dequeued as \(T.self)")
        }
        
        return cell
    }
}

public extension UICollectionViewCell {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
