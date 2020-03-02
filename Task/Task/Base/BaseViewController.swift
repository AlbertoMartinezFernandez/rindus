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
    
    func configureNavigationTitle(title: String) {
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x: 0, y: navigationBar.frame.height/2 - CGFloat(13), width: navigationBar.frame.width, height: navigationBar.frame.height/2)
            let labelNavigationBar = Tools.createLabelForNavigationBar(frame: firstFrame, font: UIFont.boldSystemFont(ofSize: CGFloat(13)), color: UIColor.black, text: title)
            navigationBar.addSubview(labelNavigationBar)
        }
    }
    
    func initBarButtonItem(iconName: String, selector:Selector) -> UIBarButtonItem {
        let button = Tools.createButtonForNavigationBar(iconName: iconName)
        button.addTarget(self, action:selector, for:.touchUpInside)
        
        return UIBarButtonItem.init(customView: button)
    }
    
    // MARK: User Interaction
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Language.localizedString( string: "ok" ), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
