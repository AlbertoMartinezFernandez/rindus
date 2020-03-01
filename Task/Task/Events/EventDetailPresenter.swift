//
//  EventDetailPresenter.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import Foundation

protocol EventDetailDisplayLogic: class {
    func setupView()
    func showAlert(title: String, message: String)
}

protocol EventDetailDataStore {
//    var name: String? { get set }
}

class EventDetailPresenter: EventDetailPresenterLogic, EventDetailDataStore {
    weak var view: (EventDetailDisplayLogic & EventDetailRouterLogic)?

    func setupView() {
        view?.setupView()
    }
    
    // MARK: - Calls to server
    
    func callToPutEvent() {
        callToPutEvent { jsonString in
            print(jsonString)
            self.view?.showAlert(title: Language.localizedString( string: "info" ), message: Language.localizedString( string: "event_option_save_success" ))
        }
    }
    
    func callToDeleteEvent() {
        callToDeleteEvent { jsonString in
            print(jsonString)
            self.view?.showAlert(title: Language.localizedString( string: "info" ), message: Language.localizedString( string: "event_option_delete_success" ))
        }
    }
    
    func callToPutEvent(completion: @escaping (String) -> ()) {
        let urlString = AppConstants.baseUrl + "trainings/1"
        if let url = URL(string: urlString) {
            let dataToUpload = "description=Baloncesto&place=CiudadJardin&dateStart=2020-05-15T07:15:00+0100&dateEnd=2020-05-15T09:17:00+0100&eventType=training".data(using: .utf8)
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
    
    func callToDeleteEvent(completion: @escaping (String) -> ()) {
        let firstTodoEndpoint: String = AppConstants.baseUrl + "trainings/1"
        var firstTodoUrlRequest = URLRequest(url: URL(string: firstTodoEndpoint)!)
        firstTodoUrlRequest.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: firstTodoUrlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let responseData = data else {
                    print("error calling DELETE")
                    return
                }
                if let responseString = String(data: responseData, encoding: String.Encoding.utf8) {
                    completion(responseString)
                }
            }
        }
        task.resume()
    }
}
