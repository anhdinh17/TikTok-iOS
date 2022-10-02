//
//  SettingsViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit
import SafariServices

struct SettingsSection {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let handler: (()->Void)
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var sections = [SettingsSection]()
   
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        sections = [
            SettingsSection(title: "Information",
                            options: [
                                SettingsOption(title: "Terms of Service",
                                               handler: { [weak self] in
                                                   DispatchQueue.main.async {
                                                       guard let url = URL(string: "https://www.tiktok.com/legal/terms-of-service") else {
                                                           return
                                                       }
                                                       let vc = SFSafariViewController(url: url)
                                                       self?.present(vc, animated: true)
                                                   }
                                               }),
                                SettingsOption(title: "Policy",
                                               handler: { [weak self] in
                                                   DispatchQueue.main.async {
                                                       guard let url = URL(string: "https://www.tiktok.com/legal/privacy-policy") else {
                                                           return
                                                       }
                                                       let vc = SFSafariViewController(url: url)
                                                       self?.present(vc, animated: true)
                                                       
                                                   }
                                               })
                            ])
        ]
        
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        createFooter()
    }
    
    func createFooter(){
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100))
        let button = UIButton(frame: CGRect(x: (view.width - 100)/2, y: 25, width: 100, height: 50))
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        footer.addSubview(button)
        tableView.tableFooterView = footer
    }
    
    @objc func didTapSignOut(){
        let alert = UIAlertController(title: "Sign Out",
                                      message: "Are you sure you want to sign out?",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            DispatchQueue.main.async {
                AuthManager.shared.signOut { success in
                    if success {
                        // set values in UserDefaults to be nil before signing out
                        UserDefaults.standard.setValue(nil, forKey: "username")
                        UserDefaults.standard.setValue(nil, forKey: "profile_picture_url")
                        
                        // navigate to SignInVC
                        let vc = SignInViewController()
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                        
                        // switch tab bar to default setting which is first tab (home tab)
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                        
                    } else {
                        let alert = UIAlertController(title: "Sorry", message: "Unable to sign out, please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert,animated: true)
                    }
                }
            }
        })
        present(alert, animated: true)
    }
    
}

//MARK: - TableView
extension SettingsViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get the model for each row
        // because we have sections for this tableView, we have to get into each section
        // then get into cells in that section
        // options[indexPath.row] = 1 SettingsOption instance
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        // call this handler to trigger the completion in each model
        model.handler()
    }
    
    // title for section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
