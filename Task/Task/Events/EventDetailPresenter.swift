//
//  EventDetailPresenter.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import Foundation

protocol EventDetailDisplayLogic: class {
    func setupView(eventModel: EventDetailTableViewModel)
    func showAlert(title: String, message: String)
}

protocol EventDetailDataStore {
    var eventSelected: BaseEvent? { get set }
}

class EventDetailPresenter: EventDetailPresenterLogic, EventDetailDataStore {
    
    /* Vars */
    weak var view: (EventDetailDisplayLogic & EventDetailRouterLogic)?
    
    /* DataStore */
    var eventSelected: BaseEvent?

    func setupView() {
        var participants: [Participant] = []
        if let event = eventSelected {
            if event is EventWithParticipants { participants = (event as? EventWithParticipants)?.participants ?? [] }
        }
        let (dateStart, hourStart) = Tools.parseDateAndHour(fromString: eventSelected?.dateStart ?? "")
        let (dateEnd, hourEnd) = Tools.parseDateAndHour(fromString: eventSelected?.dateEnd ?? "")
        let eventModel = EventDetailTableViewModel(
            eventType: eventSelected?.eventType.uppercased() ?? "",
            dateStart: dateStart + " " + hourStart,
            dateEnd: dateEnd + " " + hourEnd,
            eventTitle: eventSelected?.description ?? "",
            eventPlace: eventSelected?.place ?? "",
            participant1: participants.count > 0 ? participants[0].name + " " + participants[0].surname : "",
            participant2: participants.count > 1 ? participants[1].name + " " + participants[1].surname : "",
            participant3: participants.count > 2 ? participants[2].name + " " + participants[2].surname : ""
        )
        view?.setupView(eventModel: eventModel)
    }
    
    // MARK: - Calls to server
    
    func callToPutEvent(parameters: [String]) {
        callToPutEvent(parameters: parameters, completion: { jsonString in
            print(jsonString)
            self.view?.showAlert(title: Language.localizedString( string: "info" ), message: Language.localizedString( string: "event_option_save_success" ))
        })
    }
    
    func callToDeleteEvent() {
        callToDeleteEvent { jsonString in
            print(jsonString)
            self.view?.showAlert(title: Language.localizedString( string: "info" ), message: Language.localizedString( string: "event_option_delete_success" ))
        }
    }
    
    func callToPutEvent(parameters: [String], completion: @escaping (String) -> ()) {
        let urlString = AppConstants.baseUrl + "trainings/1"
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
    
    private func getStringParameters(parameters: [String]) -> String {
        let dataToUpload = "description=\(parameters[0])&place=\(parameters[1])&dateStart=\(parameters[2])&dateEnd=\(parameters[3])&eventType=\(parameters[4])"
        
        return dataToUpload
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
