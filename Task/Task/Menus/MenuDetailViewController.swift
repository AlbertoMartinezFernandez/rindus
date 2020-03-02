//
//  MenuDetailViewController.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

protocol MenuDetailPresenterLogic {
    func setupView()
    func callToPostNewMenu(parameters: [String])
    func callToPutMenu(parameters: [String])
}

class MenuDetailViewController: BaseViewController {
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textfieldDate: UITextField!
    @IBOutlet weak var labelTurn: UILabel!
    @IBOutlet weak var textfieldTurn: UITextField!
    @IBOutlet weak var labelSalad: UILabel!
    @IBOutlet weak var textfieldSalad: UITextField!
    @IBOutlet weak var labelFirst: UILabel!
    @IBOutlet weak var textfieldFirst: UITextField!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var textfieldSecond: UITextField!
    @IBOutlet weak var labelOthers: UILabel!
    @IBOutlet weak var textfieldOthers1: UITextField!
    @IBOutlet weak var textfieldOthers2: UITextField!
    @IBOutlet weak var labelDessert: UILabel!
    @IBOutlet weak var textfieldDessert: UITextField!
    @IBOutlet weak var labelDairy: UILabel!
    @IBOutlet weak var textfieldDairy: UITextField!
    @IBOutlet weak var buttonModify: UIButton!
    
    var presenter: MenuDetailPresenterLogic?
    var dataStore: MenuDetailDataStore?
  
    // MARK: Setup
  
    override func setupScene() {
        let viewController = self
        let presenter = MenuDetailPresenter()
        
        presenter.view = viewController
        viewController.dataStore = presenter
        self.presenter = presenter
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
    
    @IBAction func onClickModifyMenu(_ sender: UIButton) {
        print("Modify menu button pressed")
        if let date = textfieldDate.text,
        let turn = textfieldTurn.text,
        let salad = textfieldSalad.text,
        let first = textfieldFirst.text,
        let second = textfieldSecond.text,
        let others1 = textfieldOthers1.text,
        let others2 = textfieldOthers2.text,
        let dessert = textfieldDessert.text,
        let dairy = textfieldDairy.text {
            let arrayParams = [date, turn, salad, first, second, others1, others2, dessert, dairy]
            
            if let isEditing = dataStore?.isEditing, isEditing {
                presenter?.callToPutMenu(parameters: arrayParams)
            } else {
                presenter?.callToPostNewMenu(parameters: arrayParams)
            }
        }
    }
}

// MARK: - Display Logic

extension MenuDetailViewController: MenuDetailDisplayLogic {
    func setupView(menu: Menu?) {
        textfieldDate.text = menu?.date ?? ""
        textfieldTurn.text = menu?.turn ?? ""
        textfieldSalad.text = menu?.salad ?? ""
        textfieldFirst.text = menu?.first ?? ""
        textfieldSecond.text = menu?.second ?? ""
        textfieldOthers1.text = menu?.others1 ?? ""
        textfieldOthers2.text = menu?.others2 ?? ""
        textfieldDessert.text = menu?.dessert ?? ""
        textfieldDairy.text = menu?.dairy ?? ""
        
        buttonModify.setTitle(dataStore?.isEditing ?? false ? Language.localizedString( string: "menu_update_button" ).uppercased() : Language.localizedString( string: "menu_create_button" ).uppercased(), for: .normal)
    }
}

// MARK: - Router Logic

protocol MenuDetailRouterLogic: class {

}

protocol MenuDetailDataPass {
    var dataStore: MenuDetailDataStore? { get }
}

extension MenuDetailViewController: MenuDetailRouterLogic, MenuDetailDataPass {
}
