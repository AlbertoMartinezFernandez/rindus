//
//  MenusPresenter.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

protocol MenusDisplayLogic: class {
    func setupView()
}

protocol MenusDataStore {
//    var name: String? { get set }
}

class MenusPresenter: MenusPresenterLogic, MenusDataStore {
    weak var view: (MenusDisplayLogic & MenusRouterLogic)?

    func setupView() {
        view?.setupView()
    }
}
