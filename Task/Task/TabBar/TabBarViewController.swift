//
//  TabBarViewController.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright © 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBar.tintColor = Tools.hexStringToUIColor(hex: AppConstants.colorMainRed)
        delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTabBarTitles()
    }
    
    func reloadTabBarTitles() {
        tabBar.items?[0].title = Language.localizedString( string: "tabbar_events_title" )
        tabBar.items?[1].title = Language.localizedString( string: "tabbar_menus_title" )
    }
}
