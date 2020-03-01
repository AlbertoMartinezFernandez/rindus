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
    func callToPutEvent()
    func callToDeleteEvent()
}

class EventDetailViewController: BaseViewController {
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
            self.presenter?.callToPutEvent()
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
    func setupView() {
    }
}

// MARK: - Router Logic

protocol EventDetailRouterLogic: class {

}

protocol EventDetailDataPass {
    var dataStore: EventDetailDataStore? { get }
}

extension EventDetailViewController: EventDetailRouterLogic, EventDetailDataPass {
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: EventDetailDataStore?, destination: inout SomewhereDataStore?)
    //{
    //  destination?.name = source?.name
    //}
}
