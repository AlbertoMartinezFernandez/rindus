//
//  EventsPresenter.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

protocol EventsDisplayLogic: class {
    func setupView()
    func reloadData()
}

protocol EventsDataStore {
    var eventsList: EventList? { get set }
    var eventSelected: BaseEvent? { get set }
}

class EventsPresenter: EventsPresenterLogic, EventsDataStore {
    
    /* Vars */
    weak var view: (EventsDisplayLogic & EventsRouterLogic)?
    var sectionTitles: [String] = []
    var trainings: [BaseEvent] = []
    var doctorAppointments: [BaseEvent] = []
    var activities: [EventWithParticipants] = []
    var outings: [EventWithParticipants] = []
    
    /* DataStore */
    var eventsList: EventList?
    var eventSelected: BaseEvent?

    func setupView() {
        view?.setupView()
    }
    
    func getRowHeight() -> CGFloat {
        return EventTableViewCell.cellHeight
    }
    
    func getNumberOfRows(inSection: Int) -> Int {
        var rows = 0
        switch inSection {
        case 0: rows = eventsList?.trainings.count ?? 0
        case 1: rows = eventsList?.doctorAppointments.count ?? 0
        case 2: rows = eventsList?.activities.count ?? 0
        case 3: rows = eventsList?.outings.count ?? 0
        default: rows = 0
        }
        return rows
    }
    
    func getNumberOfSections() -> Int {
        return sectionTitles.count
    }
    
    func getSectionTitle(section: Int) -> String? {
        var sectionTitle: String?
        switch section {
        case 0: sectionTitle = eventsList?.trainings.count ?? 0 > 0 ? sectionTitles[section] : nil
        case 1: sectionTitle = eventsList?.doctorAppointments.count ?? 0 > 0 ? sectionTitles[section] : nil
        case 2: sectionTitle = eventsList?.activities.count ?? 0 > 0 ? sectionTitles[section] : nil
        case 3: sectionTitle = eventsList?.outings.count ?? 0 > 0 ? sectionTitles[section] : nil
        default: sectionTitle = nil
        }
        return sectionTitle
    }
    
    func getEventTableViewModel(indexPath: IndexPath) -> EventTableViewModel? {
        let eventModel = getEvent(indexPath: indexPath)
        let (dateStart, hourStart) = Tools.parseDateAndHour(fromString: eventModel?.dateStart ?? "")
        let (_, hourEnd) = Tools.parseDateAndHour(fromString: eventModel?.dateEnd ?? "")
        let dictInfoDate = Tools.getDateInfoFromStringDate(stringDate: dateStart, options: [.weekday, .month, .day, .year])
        let month = dictInfoDate["month"]!
        let dayMonth = dictInfoDate["day"]!
        let dayWeek = String(dictInfoDate["weekday"]!.uppercased().prefix(3))
        
        let model = EventTableViewModel(
            month: String(Tools.parseMonth(monthNumber: Int(month)!).uppercased().prefix(3)),
            dayMonth: dayMonth,
            hourStart: hourStart,
            hourEnd: hourEnd,
            dayWeek: dayWeek,
            colorLineSeparator: indexPath.section % 2 == 0 ? UIColor.systemBlue : UIColor.systemGray,
            eventType: eventModel?.eventType.uppercased() ?? "",
            eventTitle: eventModel?.description ?? "",
            eventLocation: eventModel?.place ?? ""
        )
        
        return model
    }
    
    private func getEvent(indexPath: IndexPath) -> BaseEvent? {
        guard let events = eventsList else { return nil }
        
        var eventModel: BaseEvent?
        switch indexPath.section {
        case 0: eventModel = events.trainings[indexPath.row]
        case 1: eventModel = events.doctorAppointments[indexPath.row]
        case 2: eventModel = events.activities[indexPath.row]
        case 3: eventModel = events.outings[indexPath.row]
        default: break
        }
        
        return eventModel
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        eventSelected = getEvent(indexPath: indexPath)
        view?.navigateToEventDetail()
    }
    
    // MARK: - Calls to server
    
    private func initSectionTitles() {
        if let trainings = eventsList?.trainings.count, trainings > 0 {
            sectionTitles.append(Language.localizedString(string: "event_trainings"))
        }
        if let doctorAppt = eventsList?.doctorAppointments.count, doctorAppt > 0 {
            sectionTitles.append(Language.localizedString(string: "event_doctor_appointments"))
        }
        if let activities = eventsList?.activities.count, activities > 0 {
            sectionTitles.append(Language.localizedString(string: "event_activities"))
        }
        if let outings = eventsList?.outings.count, outings > 0 {
            sectionTitles.append(Language.localizedString(string: "event_outings"))
        }
    }
    
    func callToGetEvents() {
        let eventsGroup = CustomDispatchGroup()
        callToGetBaseEvent(group: eventsGroup, resource: AppConstants.resourceTrainings)
        callToGetBaseEvent(group: eventsGroup, resource: AppConstants.resourceDoctor)
        callToGetEventWithParticipants(group: eventsGroup, resource: AppConstants.resourceActivities)
        callToGetEventWithParticipants(group: eventsGroup, resource: AppConstants.resourceOutings)

        eventsGroup.notify(queue: .main) { [weak self] in
            self?.eventsList = EventList(trainings: self?.trainings ?? [], doctorAppointments: self?.doctorAppointments ?? [], activities: self?.activities ?? [], outings: self?.outings ?? [])
            self?.sectionTitles.removeAll()
            self?.initSectionTitles()
            self?.view?.reloadData()
        }
    }
    
    private func callToGetBaseEvent(group: CustomDispatchGroup, resource: String) {
        group.enter()
        callToGetBaseEvent(resource: resource, completion: { baseEvents in
            switch resource {
            case AppConstants.resourceTrainings: self.trainings = baseEvents
            case AppConstants.resourceDoctor: self.doctorAppointments = baseEvents
            default: break
            }
            print(baseEvents)
            group.leave()
        })
    }
    
    private func callToGetBaseEvent(resource: String, completion: @escaping ([BaseEvent]) -> ()) {
        let urlString = AppConstants.baseUrl + resource
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, res, err in
                DispatchQueue.main.async {
                    if let data = data {
                        let decoder = JSONDecoder()
                        if let json = try? decoder.decode([BaseEvent].self, from: data) {
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
    
    private func callToGetEventWithParticipants(group: CustomDispatchGroup, resource: String) {
        group.enter()
        callToGetEventWithParticipants(resource: resource, completion: { eventsWithParticipants in
            switch resource {
            case AppConstants.resourceActivities: self.activities = eventsWithParticipants
            case AppConstants.resourceOutings: self.outings = eventsWithParticipants
            default: break
            }
            print(eventsWithParticipants)
            group.leave()
        })
    }
    
    private func callToGetEventWithParticipants(resource: String, completion: @escaping ([EventWithParticipants]) -> ()) {
        let urlString = AppConstants.baseUrl + resource
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, res, err in
                DispatchQueue.main.async {
                    if let data = data {
                        let decoder = JSONDecoder()
                        if let json = try? decoder.decode([EventWithParticipants].self, from: data) {
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
