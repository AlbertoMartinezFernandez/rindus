//
//  MenuNewPresenter.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import Foundation

protocol MenuNewDisplayLogic: class {
    func setupView()
}

protocol MenuNewDataStore {
//    var name: String? { get set }
}

class MenuNewPresenter: MenuNewPresenterLogic, MenuNewDataStore {
    weak var view: (MenuNewDisplayLogic & MenuNewRouterLogic)?

    func setupView() {
        view?.setupView()
    }
    
    // MARK: - Calls to Server
    
    func callToPostNewMenu() {
        callToPostNewMenu { menus in
        }
    }
    
    func callToPostNewMenu(completion: @escaping (String) -> ()) {
        let urlString = AppConstants.baseUrl + AppConstants.resourceMenus
        if let url = URL(string: urlString) {
            let dataToUpload = "id=15?date=2020-03-09&turn=Lunch&salad=Caesar salad&first=Cannelloni&second=Focaccia&others1=Potatoes&others2=Rice&dessert=Banana&dairy=Yogurt".data(using: .utf8)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let dataTask = URLSession.shared.uploadTask(with: request, from: dataToUpload!, completionHandler: { responseData, response, error in
                DispatchQueue.main.async {
                    if let responseData = responseData,
                        let responseString = String(data: responseData, encoding: String.Encoding.utf8) {
                        completion(responseString)
                    }
                    
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            })
            dataTask.resume()
        }
    }
}
