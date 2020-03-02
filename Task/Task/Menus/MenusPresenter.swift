//
//  MenusPresenter.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

protocol MenusDisplayLogic: class {
    func setupView()
    func reloadData()
}

protocol MenusDataStore {
    var menusList: [Menu]? { get set }
    var menuSelected: Menu? { get set }
    var isEditing: Bool { get set }
}

class MenusPresenter: MenusPresenterLogic, MenusDataStore {
    
    /* Vars */
    weak var view: (MenusDisplayLogic & MenusRouterLogic)?
    
    /* DataStore */
    var menusList: [Menu]?
    var menuSelected: Menu?
    var isEditing: Bool = false

    func setupView() {
        view?.setupView()
    }
    
    func getRowHeight() -> CGFloat {
        return MenuTableViewCell.cellHeight
    }
    
    func getNumberOfRows() -> Int {
        return menusList?.count ?? 0
    }
    
    func getMenuModel(indexPath: IndexPath) -> MenuTableViewModel? {
        guard let menus = menusList else { return nil }
        let menu = menus[indexPath.row]
        
        let dictInfoDate = Tools.getDateInfoFromStringDate(stringDate: menu.date, options: [.weekday, .month, .day, .year])
        let month = dictInfoDate["month"]!
        let dayMonth = dictInfoDate["day"]!
        let dayWeek = String(dictInfoDate["weekday"]!.uppercased().prefix(3))
        
        let menuModel = MenuTableViewModel(
            month: String(Tools.parseMonth(monthNumber: Int(month)!).uppercased().prefix(3)),
            dayMonth: dayMonth,
            dayWeek: dayWeek,
            colorLineSeparator: indexPath.row % 2 == 0 ? UIColor.systemBlue : UIColor.systemGray,
            turn: menu.turn,
            first: menu.first,
            second: menu.second,
            dessert: menu.dessert
        )
        
        return menuModel
    }
    
    func manageNewMenuButton() {
        isEditing = false
        view?.navigateToMenuDetail()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        guard let menus = menusList else { return }
        menuSelected = menus[indexPath.row]
        isEditing = true
        view?.navigateToMenuDetail()
    }
    
    // MARK: - Calls to Server
    func callToGetMenus() {
        callToGetMenus(filter: "")
    }
    
    func callToGetMenus(filter: String) {
        callToGetMenus(filter: filter, completion: { menus in
            print(menus)
            self.menusList = menus
            self.view?.reloadData()
        })
    }
    
    func callToGetMenus(filter: String, completion: @escaping ([Menu]) -> ()) {
        let urlString = AppConstants.baseUrl + AppConstants.resourceMenus + filter
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, res, err in
                DispatchQueue.main.async {
                    if let data = data {
                        let decoder = JSONDecoder()
                        if let json = try? decoder.decode([Menu].self, from: data) {
                            completion(json)
                        }
                    }
                    
                    if let error = err {
                        print(error.localizedDescription)
                    }
                }
                
            }.resume()
        }
    }
}
