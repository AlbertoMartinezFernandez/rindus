//
//  EventsModels.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

//enum EventType: String {
//    case training
//    case doctor
//    case activity
//    case outing
//}

struct Participant: Codable {
    let name: String
    let surname: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case surname
    }
}

class BaseEvent: Codable {
    let id: String
    let eventType: String
    let description: String
    let dateStart: String
    let dateEnd: String
    let place: String
}

class Training: BaseEvent {
}

class DoctorAppointment: BaseEvent {
}

class Activity: BaseEvent {
    let participants: [Participant]
    
    private enum CodingKeys: String, CodingKey {
        case participants
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        participants = try container.decode([Participant].self, forKey: .participants)
        try super.init(from: decoder)
    }
}

class Outing: BaseEvent {
    let participants: [Participant]
    
    private enum CodingKeys: String, CodingKey {
        case participants
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        participants = try container.decode([Participant].self, forKey: .participants)
        try super.init(from: decoder)
    }
}

class EventList: Codable {
    let trainings: [Training]
    let doctorAppointments: [DoctorAppointment]
    let activities: [Activity]
    let outings: [Outing]
}

struct EventTableViewModel {
     var month: String
     var dayMonth: String
     var hourStart: String
     var hourEnd: String
     var dayWeek: String
     var colorLineSeparator: UIColor
     var eventType: String
     var eventTitle: String
     var eventLocation: String
}
