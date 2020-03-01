//
//  MenusViewController.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

protocol MenusPresenterLogic {
    func setupView()
}

class MenusViewController: BaseViewController {
    var presenter: MenusPresenterLogic?
    var dataStore: MenusDataStore?
  
    // MARK: Setup
  
    override func setupScene() {
        let viewController = self
        let presenter = MenusPresenter()
        
        presenter.view = viewController
        viewController.dataStore = presenter
        self.presenter = presenter
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
}

// MARK: - Display Logic

extension MenusViewController: MenusDisplayLogic {
    func setupView() {
    }
}

// MARK: - Router Logic

protocol MenusRouterLogic: class {

}

protocol MenusDataPass {
    var dataStore: MenusDataStore? { get }
}

extension MenusViewController: MenusRouterLogic, MenusDataPass {
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: MensuDataStore?, destination: inout SomewhereDataStore?)
    //{
    //  destination?.name = source?.name
    //}
}
