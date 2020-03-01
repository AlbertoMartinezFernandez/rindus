//
//  MenuNewViewController.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

protocol MenuNewPresenterLogic {
    func setupView()
    func callToPostNewMenu(parameters: [String])
}

class MenuNewViewController: BaseViewController {
    
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
    
    var presenter: MenuNewPresenterLogic?
    var dataStore: MenuNewDataStore?
  
    // MARK: Setup
  
    override func setupScene() {
        let viewController = self
        let presenter = MenuNewPresenter()
        
        presenter.view = viewController
        viewController.dataStore = presenter
        self.presenter = presenter
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
    
    @IBAction func onClickCreateMenu(_ sender: UIButton) {
        print("Create menu button pressed")
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
        presenter?.callToPostNewMenu(parameters: arrayParams)
        }
    }
    
}

// MARK: - Display Logic

extension MenuNewViewController: MenuNewDisplayLogic {
    func setupView() {
    }
}

// MARK: - Router Logic

protocol MenuNewRouterLogic: class {

}

protocol MenuNewDataPass {
    var dataStore: MenuNewDataStore? { get }
}

extension MenuNewViewController: MenuNewRouterLogic, MenuNewDataPass {
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: MenuNewDataStore?, destination: inout SomewhereDataStore?)
    //{
    //  destination?.name = source?.name
    //}
}
