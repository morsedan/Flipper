import UIKit

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    enum Constants {
        static let chorePlaceholder = "Chore Title"
        static let namePlaceholder = "Person's Name"
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let frequencies = ["Daily", "Weekly", "Monthly", "Quarterly", "Yearly"]
    var delegate: ChoreController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.placeholder = Constants.chorePlaceholder
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        frequencies.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencies[row]
    }
    
    @IBAction func didChangeItemToAdd(_ sender: UISegmentedControl) {
        textField.text = ""
        UIView.animate(withDuration: 0.275) {
            switch sender.selectedSegmentIndex {
            case 1:
                self.pickerView.isHidden = true
                self.datePicker.isHidden = true
                self.frequencyLabel.isHidden = true
                self.dateLabel.isHidden = true
                self.textField.placeholder = Constants.namePlaceholder
            default:
                self.pickerView.isHidden = false
                self.datePicker.isHidden = false
                self.frequencyLabel.isHidden = false
                self.dateLabel.isHidden = false
                self.textField.placeholder = Constants.chorePlaceholder
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let text = textField.text,
              !text.isEmpty else { return }
        if segmentedControl.selectedSegmentIndex == 0 {
            let index = pickerView.selectedRow(inComponent: 0)
            let frequency = getFrequency(forIndex: index)
            delegate?.addChore(text, frequency: frequency, startDate: datePicker.date)
        } else {
            delegate?.addDoer(text)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func getFrequency(forIndex index: Int) -> ChoreFrequency {
        switch index {
        case 0: return .daily
        case 1: return .weekly
        case 2: return .monthly
        case 3: return .quarterly
        default: return .yearly
        }
    }
}

extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            addButtonTapped(textField)
        default:
            break
        }
        return false
    }
}
