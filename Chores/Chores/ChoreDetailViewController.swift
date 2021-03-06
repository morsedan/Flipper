import UIKit

class ChoreDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum Constants {
        static let reuseIdentifier = "reuseIdentifier"
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var choreController: ChoreController?
    var chore: Chore?
    var shouldAllowStatusChange: Bool = true
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureStatusLabel()
        updateUI()
    }
    
    private func configureStatusLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(statusLabelTapped))
        statusLabel.isUserInteractionEnabled = true
        if shouldAllowStatusChange {
            statusLabel.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func statusLabelTapped() {
        guard let chore = chore else { return }
        switch chore.status {
        case .unclaimed: showUserAlert()
        case .claimed(_):
            showStatusAlert()
        case .done(_): break
        }
    }
    
    private func showUserAlert() {
        guard let chore = chore,
              let choreController = choreController,
              choreController.doers.count >= 1 else { return }
        let userAlert = UIAlertController(title: "Claim \(chore.title)?", message: "Select your name below to claim this chore.", preferredStyle: .actionSheet)
        for doer in choreController.doers {
            let button = UIAlertAction(title: doer.name, style: .default) { _ in
                let updatedChore = choreController.claimChore(chore, forChoreID: doer.choreDoerID)
                self.chore = updatedChore
                self.updateUI()
            }
            userAlert.addAction(button)
        }
        
        if let popoverController = userAlert.popoverPresentationController {
            popoverController.sourceView = statusLabel
            popoverController.sourceRect = statusLabel.bounds
        }
        
        navigationController?.present(userAlert, animated: true, completion: nil)
    }
    
    private func showStatusAlert() {
        guard let chore = chore else { return }
        let updatedChore = choreController?.completeChore(chore)
        self.chore = updatedChore
        if let gestureRecognizer = statusLabel.gestureRecognizers?.first {
            statusLabel.removeGestureRecognizer(gestureRecognizer)
        }
        updateUI()
        guard let updatedChore = updatedChore,
              let occurrence = updatedChore.history.last else { return }
        statusLabel.text = "Status: \(occurrence.status.string)"
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
    }
    
    private func updateUI() {
        guard let chore = chore else { return }
        nameLabel.text = chore.title
        statusLabel.text = "Status: \(chore.status.string)"
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let chore = chore else { return 0 }
        return chore.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        guard let chore = chore else { return UITableViewCell() }
        let choreOccurrence = chore.history.reversed()[indexPath.item]
        
        content.text = "\(dateFormatter.string(from: choreOccurrence.date)), \(choreOccurrence.status.string)"
        cell.contentConfiguration = content
        return cell
    }
}
