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
    func callToGetMenus()
    func getRowHeight() -> CGFloat
    func getNumberOfRows() -> Int
    func getMenuModel(indexPath: IndexPath) -> MenuTableViewModel?
    func manageNewMenuButton()
}

class MenusViewController: BaseViewController {
    @IBOutlet weak var tableMenus: UITableView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.callToGetMenus()
    }
    
    @IBAction func onClickNewMenu(_ sender: UIButton) {
        print("New Menu button pressed")
        presenter?.manageNewMenuButton()
    }
    
}

// MARK: - Display Logic

extension MenusViewController: MenusDisplayLogic {
    func setupView() {
        tableMenus.register(UINib(nibName: MenuTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: MenuTableViewCell.cellIdentifier)
        tableMenus.delegate = self
        tableMenus.dataSource = self
        tableMenus.alwaysBounceVertical = false
        tableMenus.tableFooterView = UIView(frame: CGRect.zero)
        tableMenus.sectionFooterHeight = 0.0
    }
    
    func reloadData() {
        tableMenus.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension MenusViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getRowHeight() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.cellIdentifier) as? MenuTableViewCell, let menuModel = presenter?.getMenuModel(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.updateUI(menuModel: menuModel)
        
        return cell
    }
}

// MARK: - Router Logic

protocol MenusRouterLogic: class {
    func navigateToMenuNew()
}

protocol MenusDataPass {
    var dataStore: MenusDataStore? { get }
}

extension MenusViewController: MenusRouterLogic, MenusDataPass {
    
    func navigateToMenuNew() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Menus", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "MenuNewViewController") as? MenuNewViewController {
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: MensuDataStore?, destination: inout SomewhereDataStore?)
    //{
    //  destination?.name = source?.name
    //}
}
