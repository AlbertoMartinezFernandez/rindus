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
    func callToGetMenus(filter: String)
    func getRowHeight() -> CGFloat
    func getNumberOfRows() -> Int
    func getMenuModel(indexPath: IndexPath) -> MenuTableViewModel?
    func manageNewMenuButton()
    func didSelectRowAt(indexPath: IndexPath)
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
        configureNavigationTitle(title: Language.localizedString(string: "tabbar_menus_title"))
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
        self.navigationItem.rightBarButtonItem = initBarButtonItem(iconName: "filter", selector: #selector(onClickFilter))
        
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
    
    @objc func onClickFilter() {
        print("onClickFilter selected")
        showOptionsActionSheet()
    }
    
    private func showOptionsActionSheet() {
        let alert = UIAlertController(title: Language.localizedString( string: "menu_filter_options_title" ), message: Language.localizedString( string: "menu_filter_options_subtitle" ), preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: Language.localizedString( string: "menu_filter_by_turn_lunch" ), style: .default, handler: { (_) in
            print("User filter by lunch")
            self.presenter?.callToGetMenus(filter: "?turn=Lunch")
        }))

        alert.addAction(UIAlertAction(title: Language.localizedString( string: "menu_filter_by_dessert_banana" ), style: .default, handler: { (_) in
            print("User filter by dessert banana")
            self.presenter?.callToGetMenus(filter: "?dessert=Banana")
        }))
        
        alert.addAction(UIAlertAction(title: Language.localizedString( string: "menu_filter_by_combination" ), style: .default, handler: { (_) in
            print("User filter by a combination")
            self.presenter?.callToGetMenus(filter: "?others1=Potatoes&others2=Rice")
        }))

        alert.addAction(UIAlertAction(title: Language.localizedString( string: "menu_filter_reset" ), style: .cancel, handler: { (_) in
            print("User resets filters")
            self.presenter?.callToGetMenus()
        }))
        
        self.present(alert, animated: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath: indexPath)
    }
}

// MARK: - Router Logic

protocol MenusRouterLogic: class {
    func navigateToMenuDetail()
}

protocol MenusDataPass {
    var dataStore: MenusDataStore? { get }
}

extension MenusViewController: MenusRouterLogic, MenusDataPass {
    
    func navigateToMenuDetail() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Menus", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "MenuDetailViewController") as? MenuDetailViewController {
            vc.dataStore?.menuSelected = dataStore?.menuSelected
            vc.dataStore?.isEditing = dataStore?.isEditing ?? false
            self.navigationController?.show(vc, sender: nil)
        }
    }
}
