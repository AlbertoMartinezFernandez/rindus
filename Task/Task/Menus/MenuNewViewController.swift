//
//  MenuNewViewController.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

protocol MenuNewPresenterLogic {
    func setupView()
    func callToPostNewMenu()
}

class MenuNewViewController: BaseViewController {
    var presenter: MenuNewPresenterLogic?
    var dataStore: MenuNewDataStore?
  
    // MARK: Setup
  
    override func setupScene() {
        let viewController = self
        let presenter = MenuNewPresenter()
        
        presenter.view = viewController
        viewController.dataStore = presenter
        self.presenter = presenter
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
    
    @IBAction func onClickCreateMenu(_ sender: UIButton) {
        print("Create menu button pressed")
        presenter?.callToPostNewMenu()
    }
    
}

// MARK: - Display Logic

extension MenuNewViewController: MenuNewDisplayLogic {
    func setupView() {
    }
}

// MARK: - Router Logic

protocol MenuNewRouterLogic: class {

}

protocol MenuNewDataPass {
    var dataStore: MenuNewDataStore? { get }
}

extension MenuNewViewController: MenuNewRouterLogic, MenuNewDataPass {
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: MenuNewDataStore?, destination: inout SomewhereDataStore?)
    //{
    //  destination?.name = source?.name
    //}
}
