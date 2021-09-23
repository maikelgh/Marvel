//
//  BaseViewController.swift
//  Marvel
//
//  Created by Michael Green on 12/9/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupScene()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScene()
    }
    
    // MARK: Setup
    internal func setupScene() {}

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func ui(_ f: @escaping () -> Void) {
        DispatchQueue.main.async {
            f()
        }
    }
    
    func manageErrors(error: Error?) {
        if let error = error as? ApiError, let message = error.status, !message.isEmpty {
            showGenericAlert(title: "", msg: message)
        } else if let error = error as? ServerError, let code = error.code, let message = error.message, !message.isEmpty {
            showGenericAlert(title: code, msg: message)
        } else {
            showGenericAlert(title: "", msg: "Unknown error")
        }
        
        
    }
    
    func showGenericAlert(title: String, msg: String) {
        ui {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func showNoConnectionAlert() {
        showGenericAlert(title: "", msg: "No connection")
    }
}
