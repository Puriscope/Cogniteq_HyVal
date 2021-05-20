//
//  Result.swift
//  HyVal
//
//  Created by Egor Syrtcov on 5/7/21.
//

import UIKit

class Result: UIViewController {
    
    // MARK: - Properties
    var presenter: ResultViewPresenterProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        presenter.setTitleFromRealm()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(ResultCell.nib(), forCellReuseIdentifier: ResultCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
    }
    
    //MARK: Action
    
    @IBAction func sendActionButton(_ sender: UIButton) {
        presenter.shared()
    }
    
    @IBAction func restartActionButton(_ sender: UIButton) {
        presenter.showWelcomeScreen()
    }
    
    deinit {
        print("Bye: \(self) ")
    }
}

extension Result: ResultViewProtocol {
    func setTitle(location: LocationModel) {
        title = "\(location.location): \(location.sampleName)"
    }
    
    func openSharedScreen(activityViewController: UIActivityViewController) {
        present(activityViewController, animated: true, completion: nil)
    }
}

extension Result: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier,
                                                       for: indexPath) as? ResultCell else { return UITableViewCell() }
        let location = presenter.getLocation(index: indexPath)
        cell.setupLocation(location: location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (contextualAction, view, boolValue) in
            
            self?.presenter.deleteLocation(index: indexPath)
            tableView.reloadData()
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
}
