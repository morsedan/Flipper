//
//  SettingsTableViewController.swift
//  Chores
//
//  Created by danmorse on 1/2/22.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    var choreController: ChoreController?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func configure() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addItem() {
        guard let addItemViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemViewController") as? AddItemViewController else { return }
        guard let choreController = choreController else { return }
        addItemViewController.delegate = choreController
        
        navigationController?.pushViewController(addItemViewController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "People"
        default: return "Chores"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: return choreController?.doers.count ?? 0
        default: return choreController?.chores.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        guard let choreController = choreController else {
            return UITableViewCell()
        }
        var content = cell.defaultContentConfiguration()

        switch indexPath.section {
        case 0:
            let doer = choreController.doers[indexPath.item]
            content.text = doer.name
        default:
            let chore = choreController.chores[indexPath.item]
            content.text = chore.title
        }
        cell.contentConfiguration = content

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let choreController = choreController else { return }

        if editingStyle == .delete {
            // Delete the row from the data source
            switch indexPath.section {
            case 0:
                choreController.doers.remove(at: indexPath.item)
            default:
                choreController.chores.remove(at: indexPath.item)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
