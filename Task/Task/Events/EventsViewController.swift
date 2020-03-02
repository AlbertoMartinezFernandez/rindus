//
//  EventsViewController.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

protocol EventsPresenterLogic {
    func setupView()
    func callToGetEvents()
    func getRowHeight() -> CGFloat
    func getNumberOfSections() -> Int
    func getSectionTitle(section: Int) -> String?
    func getNumberOfRows(inSection: Int) -> Int
    func getEventTableViewModel(indexPath: IndexPath) -> EventTableViewModel?
    func didSelectRowAt(indexPath: IndexPath)
}

class EventsViewController: BaseViewController {
    
    @IBOutlet weak var tableEvents: UITableView!
    
    var presenter: EventsPresenterLogic?
    var dataStore: EventsDataStore?
  
    // MARK: Setup
  
    override func setupScene() {
        let viewController = self
        let presenter = EventsPresenter()
        
        presenter.view = viewController
        viewController.dataStore = presenter
        self.presenter = presenter
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
        configureNavigationTitle(title: Language.localizedString(string: "tabbar_events_title"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.callToGetEvents()
    }
}

// MARK: - Display Logic

extension EventsViewController: EventsDisplayLogic {
    func setupView() {
        tableEvents.register(UINib(nibName: EventTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: EventTableViewCell.cellIdentifier)
        tableEvents.delegate = self
        tableEvents.dataSource = self
        tableEvents.alwaysBounceVertical = false
        tableEvents.tableFooterView = UIView(frame: CGRect.zero)
        tableEvents.sectionFooterHeight = 0.0
    }
    
    func reloadData() {
        tableEvents.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getRowHeight() ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.getNumberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRows(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return presenter?.getSectionTitle(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let headerLabel = UILabel(frame: CGRect(x: 8, y: 15, width:tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont.systemFont(ofSize: 9)
        headerLabel.text = self.tableView(self.tableEvents, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.cellIdentifier) as? EventTableViewCell, let eventTableViewModel = presenter?.getEventTableViewModel(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.updateUI(eventTableViewModel: eventTableViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath: indexPath)
    }
}

// MARK: - Router Logic

protocol EventsRouterLogic: class {
    func navigateToEventDetail()
}

protocol EventsDataPass {
    var dataStore: EventsDataStore? { get }
}

extension EventsViewController: EventsRouterLogic, EventsDataPass {
    
    func navigateToEventDetail() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Events", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController {
            vc.dataStore?.eventSelected = dataStore?.eventSelected
            self.navigationController?.show(vc, sender: nil)
        }
    }
}
