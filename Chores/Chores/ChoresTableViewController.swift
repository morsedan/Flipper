//
//  ChoresTableViewController.swift
//  Chores
//
//  Created by danmorse on 1/2/22.
//

import UIKit

class ChoresTableViewController: UITableViewController {
    enum Constants {
        static let choreCellIndentifier = "ChoreCell"
        static let title = "Today's Chores"
        static let choreDetailViewController = "ChoreDetailViewController"
    }
    let choreController = ChoreController()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func configure() {
        choreController.addChore("Sweep", frequency: .daily, startDate: Date())
        let dave = ChoreDoer(name: "Dave")
        let bill = ChoreDoer(name: "Bill")
        choreController.chores[0].history = [
            ChoreOccurence(date: Date(), doer: dave, status: .claimed(doer: dave)),
            ChoreOccurence(date: Date(), doer: bill, status: .done(doer: bill))
            ]
        choreController.chores[0].status = .claimed(doer: bill)
        choreController.addChore("Vacuum", frequency: .weekly, startDate: Date())
        choreController.chores[1].status = .done(doer: dave)
        choreController.addChore("Wipe Table", frequency: .monthly, startDate: Date())
        
        title = Constants.title
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openSettings))
        navigationItem.leftBarButtonItem = settingsButton
    }
    
    @objc func openSettings() {
        print("tapped")
        let settingsTableViewController = SettingsTableViewController()
        settingsTableViewController.choreController = choreController
        navigationController?.pushViewController(settingsTableViewController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choreController.chores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.choreCellIndentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let chore = choreController.chores[indexPath.item]
        content.text = chore.title
        cell.backgroundColor = {
            switch chore.status {
            case .unclaimed: return .red
            case .claimed: return .yellow
            case .done: return .green
            }
        }()
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let choreDetailViewController = storyboard?.instantiateViewController(withIdentifier: Constants.choreDetailViewController) as? ChoreDetailViewController else { return }
        choreDetailViewController.chore = choreController.chores[indexPath.item]
        
        navigationController?.pushViewController(choreDetailViewController, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
