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
}

class MenusPresenter: MenusPresenterLogic, MenusDataStore {
    
    /* Vars */
    weak var view: (MenusDisplayLogic & MenusRouterLogic)?
    
    /* DataStore */
    var menusList: [Menu]?

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
        view?.navigateToMenuNew()
    }
    
    // MARK: - Calls to Server
    
    func callToGetMenus() {
        callToGetMenus { menus in
            print(menus)
            self.menusList = menus
            self.view?.reloadData()
        }
    }
    
    func callToGetMenus(completion: @escaping ([Menu]) -> ()) {
        let urlString = AppConstants.baseUrl + AppConstants.resourceMenus
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
