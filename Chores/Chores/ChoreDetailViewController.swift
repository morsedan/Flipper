//
//  ChoreDetailViewController.swift
//  Chores
//
//  Created by danmorse on 1/7/22.
//

import UIKit

class ChoreDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum Constants {
        static let reuseIdentifier = "reuseIdentifier"
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var chore: Chore?
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-DD"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureStatusLabel()
        updateUI()
    }
    
    func configureStatusLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(statusLabelTapped))
        statusLabel.isUserInteractionEnabled = true
        statusLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func statusLabelTapped(sender: UITapGestureRecognizer) {
        guard let sender = sender.view as? UILabel,
              let text = sender.text else { return }
        
        print(text)
    }
    
    func showUserAlert() {
        
    }
    
    func showStatusAlert() {
        
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
    }
    
    func updateUI() {
        guard let chore = chore else { return }
        nameLabel.text = chore.title
//        var doer = chore.claimedBy?.name ?? ""
        statusLabel.text = "Status: \(chore.status.string)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let chore = chore else { return 0 }
        return chore.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        guard let chore = chore else { return UITableViewCell() }
        let choreOccurrence = chore.history[indexPath.item]
        
        content.text = "\(dateFormatter.string(from: choreOccurrence.date)), \(choreOccurrence.status.string)"
        cell.contentConfiguration = content
        return cell
    }
}
