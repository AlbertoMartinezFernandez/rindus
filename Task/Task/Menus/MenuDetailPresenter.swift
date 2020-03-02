//
//  MenuDetailPresenter.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import Foundation

protocol MenuDetailDisplayLogic: class {
    func setupView(menu: Menu?)
    func showAlert(title: String, message: String)
}

protocol MenuDetailDataStore {
    var menuSelected: Menu? { get set }
    var isEditing: Bool { get set }
}

class MenuDetailPresenter: MenuDetailPresenterLogic, MenuDetailDataStore {
    
    /* Vars */
    weak var view: (MenuDetailDisplayLogic & MenuDetailRouterLogic)?
    
    /* DataStore */
    var menuSelected: Menu?
    var isEditing: Bool = false

    func setupView() {
        view?.setupView(menu: menuSelected)
    }
    
    // MARK: - Calls to Server
    
    private func areValidParameters(parameters: [String]) -> Bool {
        var areValid = false
        
        areValid = isValidDateFormat(stringDate: parameters[0]) && parameters[1] != "" && parameters[3] != "" && parameters[4] != "" && parameters[7] != ""
        
        return areValid
    }
    
    private func isValidDateFormat(stringDate: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        return dateFormatterGet.date(from: stringDate) != nil
    }
    
    func callToPostNewMenu(parameters: [String]) {
        if areValidParameters(parameters: parameters) {
            callToPostNewMenu (parameters: parameters, completion: { responseString in
                print(responseString)
                self.view?.showAlert(title: Language.localizedString( string: "info" ), message: Language.localizedString( string: "menu_new_created_success" ))
            })
        } else {
            view?.showAlert(title: Language.localizedString( string: "info" ), message: Language.localizedString( string: "menu_new_invalid_parameters" ))
        }
    }
    
    func callToPutMenu(parameters: [String]) {
        if areValidParameters(parameters: parameters) {
            callToPutMenu(parameters: parameters, completion: { jsonString in
                print(jsonString)
                self.view?.showAlert(title: Language.localizedString( string: "info" ), message: Language.localizedString( string: "menu_update_success" ))
            })
        } else {
            view?.showAlert(title: Language.localizedString( string: "info" ), message: Language.localizedString( string: "menu_new_invalid_parameters" ))
        }
    }
    
    func callToPostNewMenu(parameters: [String], completion: @escaping (String) -> ()) {
        let urlString = AppConstants.baseUrl + AppConstants.resourceMenus
        if let url = URL(string: urlString) {
            let stringToUpload = getStringParameters(parameters: parameters)
            let dataToUpload = stringToUpload.data(using: .utf8)
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
    
    private func getStringParameters(parameters: [String]) -> String {
        let dataToUpload = "id=15&date=\(parameters[0])&turn=\(parameters[1])&salad=\(parameters[2])&first=\(parameters[3])&second=\(parameters[4])&others1=\(parameters[5])&others2=\(parameters[6])&dessert=\(parameters[7])&dairy=\(parameters[8])"
        
        return dataToUpload
    }
    
    func callToPutMenu(parameters: [String], completion: @escaping (String) -> ()) {
        let urlString = AppConstants.baseUrl + AppConstants.resourceMenus + "/1"
        if let url = URL(string: urlString) {
            let stringToUpload = getStringParameters(parameters: parameters)
            let dataToUpload = stringToUpload.data(using: .utf8)
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
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
