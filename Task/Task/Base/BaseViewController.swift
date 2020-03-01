//
//  BaseViewController.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright © 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: Setup
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupScene()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScene()
    }
    
    internal func setupScene() {}
    
    // MARK: User Interaction
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Language.localizedString( string: "ok" ), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
