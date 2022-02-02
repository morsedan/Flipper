import UIKit

class SettingsTableViewController: UITableViewController, UIActionSheetDelegate {
    enum Constants {
        static let choreDetailViewController = "ChoreDetailViewController"
    }
    
    var choreController: ChoreController?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/D/yyyy"
        return formatter
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func configure() {
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "People"
        default: return "Chores"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return choreController?.doers.count ?? 0
        default: return choreController?.allChores.count ?? 0
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
            let chore = choreController.allChores.sorted { $0.startDate < $1.startDate }[indexPath.item]
            content.text = "\(chore.title) (\(dateFormatter.string(from: chore.startDate)))"
        }
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let choreController = choreController else { return }

        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                choreController.doers.remove(at: indexPath.item)
            default:
                let chore = choreController.allChores.sorted { $0.startDate < $1.startDate }[indexPath.item]
                choreController.deleteChore(chore)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        default:
            break
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let choreDetailViewController = storyboard.instantiateViewController(withIdentifier: Constants.choreDetailViewController) as? ChoreDetailViewController,
              let choreController = choreController else { return }
        choreDetailViewController.chore = choreController.allChores.sorted { $0.startDate < $1.startDate }[indexPath.item]
        choreDetailViewController.choreController = choreController
        choreDetailViewController.shouldAllowStatusChange = false
        
        navigationController?.pushViewController(choreDetailViewController, animated: true)
    }
}
