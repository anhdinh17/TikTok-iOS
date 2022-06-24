//
//  NotificationsViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit

class NotificationsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    lazy var noNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "No Notification"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()

    var notifications: [Notification] = []
//MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noNotificationLabel)
        view.addSubview(tableView)
        view.addSubview(spinner)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationLabel.frame = CGRect(x: 0, y:0, width: 200, height: 200)
        noNotificationLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }

//MARK: - Functions
    func fetchNotifications(){
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    func updateUI(){
        if notifications.isEmpty {
            noNotificationLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNotificationLabel.isHidden = true
            tableView.isHidden = false
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - TableView
extension NotificationsViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = notifications[indexPath.row]
//        if #available(iOS 14.0, *) {
//            var content = cell.defaultContentConfiguration()
//        } else {
//            // Fallback on earlier versions
//        }
//        cell.contentConfiguration = content
        return cell
    }
}
