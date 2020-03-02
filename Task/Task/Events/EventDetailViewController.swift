//
//  EventDetailViewController.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

protocol EventDetailPresenterLogic {
    func setupView()
    func callToPutEvent(parameters: [String])
    func callToDeleteEvent()
}

class EventDetailViewController: BaseViewController {
    
    @IBOutlet weak var labelEventTypeTitle: UILabel!
    @IBOutlet weak var labelEventTypeValue: UILabel!
    @IBOutlet weak var labelDateStart: UILabel!
    @IBOutlet weak var textfieldDateStart: UITextField!
    @IBOutlet weak var labelDateEnd: UILabel!
    @IBOutlet weak var textfieldDateEnd: UITextField!
    @IBOutlet weak var labelTitleEvent: UILabel!
    @IBOutlet weak var textfieldTitleEvent: UITextField!
    @IBOutlet weak var labelPlace: UILabel!
    @IBOutlet weak var textfieldPlace: UITextField!
    @IBOutlet weak var labelParticipants: UILabel!
    @IBOutlet weak var textfieldParticipant1: UITextField!
    @IBOutlet weak var textfieldParticipant2: UITextField!
    @IBOutlet weak var textfieldParticipant3: UITextField!
    
    var presenter: EventDetailPresenterLogic?
    var dataStore: EventDetailDataStore?
  
    // MARK: Setup
  
    override func setupScene() {
        let viewController = self
        let presenter = EventDetailPresenter()
        
        presenter.view = viewController
        viewController.dataStore = presenter
        self.presenter = presenter
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
    
    @IBAction func onClickOptions(_ sender: UIButton) {
        print("Options button pressed")
        showOptionsActionSheet()
    }
    
    private func showOptionsActionSheet() {
        let alert = UIAlertController(title: Language.localizedString( string: "event_option_title" ), message: Language.localizedString( string: "event_option_subtitle" ), preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: Language.localizedString( string: "event_option_save" ), style: .default, handler: { (_) in
            print("User click Save button")
            
            if let eventType = self.labelEventTypeValue.text?.lowercased(),
                let dateStart = self.textfieldDateStart.text,
                let dateEnd = self.textfieldDateEnd.text,
                let titleEvent = self.textfieldTitleEvent.text,
                let place = self.textfieldPlace.text {
                
                let arrayParams = [titleEvent, place, dateStart, dateEnd, eventType]
                
                self.presenter?.callToPutEvent(parameters: arrayParams)
            }
        }))

        alert.addAction(UIAlertAction(title: Language.localizedString( string: "event_option_delete" ), style: .destructive, handler: { (_) in
            print("User click Delete button")
            self.showAlertWithDistructiveButton()
        }))

        alert.addAction(UIAlertAction(title: Language.localizedString( string: "cancel" ), style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true)
    }
    
    private func showAlertWithDistructiveButton() {
        let alert = UIAlertController(
            title: Language.localizedString( string: "event_option_confirm_delete_title" ),
            message: Language.localizedString( string: "event_option_confirm_delete_message" ),
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: Language.localizedString( string: "cancel" ), style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: Language.localizedString( string: "event_option_delete" ), style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
            self.presenter?.callToDeleteEvent()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Display Logic

extension EventDetailViewController: EventDetailDisplayLogic {
    func setupView(eventModel: EventDetailTableViewModel) {
        labelEventTypeValue.text = eventModel.eventType
        textfieldDateStart.text = eventModel.dateStart
        textfieldDateEnd.text = eventModel.dateEnd
        textfieldTitleEvent.text = eventModel.eventTitle
        textfieldPlace.text = eventModel.eventPlace
        let isParticipantsVisible = eventModel.eventType.lowercased() == EventType.activity.rawValue || eventModel.eventType.lowercased() == EventType.outing.rawValue
        labelParticipants.isHidden = !isParticipantsVisible
        textfieldParticipant1.isHidden = !isParticipantsVisible
        textfieldParticipant2.isHidden = !isParticipantsVisible
        textfieldParticipant3.isHidden = !isParticipantsVisible
        textfieldParticipant1.text = eventModel.participant1
        textfieldParticipant2.text = eventModel.participant2
        textfieldParticipant3.text = eventModel.participant3
    }
}

// MARK: - Router Logic

protocol EventDetailRouterLogic: class {

}

protocol EventDetailDataPass {
    var dataStore: EventDetailDataStore? { get }
}

extension EventDetailViewController: EventDetailRouterLogic, EventDetailDataPass {
}
