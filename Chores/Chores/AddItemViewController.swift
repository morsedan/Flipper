//
//  AddItemViewController.swift
//  Chores
//
//  Created by danmorse on 1/2/22.
//

import UIKit

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
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
        switch sender.selectedSegmentIndex {
        case 1:
            pickerView.isHidden = true
            datePicker.isHidden = true
            frequencyLabel.isHidden = true
            dateLabel.isHidden = true
        default:
            pickerView.isHidden = false
            datePicker.isHidden = false
            frequencyLabel.isHidden = false
            dateLabel.isHidden = false
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let text = textField.text else { return }
        if segmentedControl.selectedSegmentIndex == 0 {
            let index = pickerView.selectedRow(inComponent: 0)
            let frequency = getFrequency(forIndex: index)
            delegate?.addChore(text, frequency: frequency, startDate: datePicker.date)
        } else {
            delegate?.addDoer(text)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func getFrequency(forIndex index: Int) -> ChoreFrequency {
        switch index {
        case 0: return .daily
        case 1: return .weekly
        case 2: return .monthly
        case 3: return .quarterly
        default: return .yearly
        }
    }
}
