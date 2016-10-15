//
//  AssignmentDetailTableViewController.swift
//  iAssign
//
//  Created by Ian Thomas on 10/10/16.
//  Copyright © 2016 KKIT Creations. All rights reserved.
//

import UIKit


protocol AssignmentDetailTableViewControllerDelegate: class {
    func assignmentDetailTableViewControllerDidCancel(_ controller: AssignmentDetailTableViewController)
    func assignmentDetailTableViewController(_ controller: AssignmentDetailTableViewController,
                                             didFinishAdding item: Assignment)
    func assignmentDetailTableViewController(_ controller: AssignmentDetailTableViewController,
                                             didFinishEditing item: Assignment)
}


class AssignmentDetailTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, PhotoViewControllerDelegate {

    var assignment: Assignment?
    
    var dueDate = Date()
    var datePickerVisible = false
    var showKeyboardOnAppear = false
    
    
    let editTitle = "Edit Assignment"
    
    weak var delegate: AssignmentDetailTableViewControllerDelegate?

    @IBOutlet weak var pictureThumb: UIImageView!
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBOutlet weak var examSwitch: UISwitch!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let item = assignment {
            title = editTitle
            doneButton.isEnabled = true
            titleTextField.text = item.name
            titleTextField.returnKeyType = .default
            notesTextField.text = item.note
            doneSwitch.isOn = item.done
            examSwitch.isOn = item.exam
            dueDate = item.dueDate
            updateDueDateLabel()
            
            
            showPhotoThumbnail()
            
            
        } else {
            title = "Add Assignment"
            doneButton.isEnabled = false
            examSwitch.isOn = false
            doneSwitch.isOn = false
            // if this is called here, the app scrolls too far up and the initial text field cant even been seen on a 7+!
        //    titleTextField.becomeFirstResponder()
            showKeyboardOnAppear = true
            
            titleTextField.returnKeyType = .next
            dueDateLabel.text = dueDateEmptyString()
            
            let cancelBarButton = UIBarButtonItem (title: "Cancel",
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(cancelButtonPressed))
            
            self.navigationItem.leftBarButtonItem = cancelBarButton
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if showKeyboardOnAppear {
            titleTextField.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dueDateEmptyString() -> String {
        return "Not Set Yet"
    }
    
    
    func saveAssignment () {
        
        //editing
        if let item = assignment {
            item.name = titleTextField.text!
            item.note = notesTextField.text!
            item.done = doneSwitch.isOn
            item.exam = examSwitch.isOn
            item.dueDate = dueDate
            
            delegate?.assignmentDetailTableViewController(self, didFinishEditing: item)
        } else {
            let newItem = Assignment()
            newItem.name = titleTextField.text!
            newItem.note = notesTextField.text!
            newItem.done = doneSwitch.isOn
            newItem.exam = examSwitch.isOn
            newItem.dueDate = dueDate
            assignment = newItem
            
            delegate?.assignmentDetailTableViewController(self, didFinishAdding: newItem)
        }
    }
        
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        
        saveAssignment()

        if title == editTitle {
            _ = navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func cancelButtonPressed(_ sender: AnyObject) {
        delegate?.assignmentDetailTableViewControllerDidCancel(self)
    }
    
    
    //
    // text field stuff
    //
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneButton.isEnabled = newText.length > 0
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        ifIsFirstResponderThenResign()

        if dueDateIsEmpty() {
            showDatePicker()
        }
        return true
    }
    
    func ifIsFirstResponderThenResign() {
        
        if titleTextField.isFirstResponder {
            titleTextField.resignFirstResponder()
            titleTextField.returnKeyType = .default // this handles the case for after the user presses continue when making the assigment for the first time, subsiquently it should be return
        } else if notesTextField.isFirstResponder {
            notesTextField.resignFirstResponder()
        }
    }
    
    func dueDateIsEmpty() -> Bool {
        
        if dueDateLabel.text == dueDateEmptyString() {
            return true
        } else {
            return false
        }
    }
    
    
    //
    // date stuff
    //

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func isFirstTimeShowingDatePicker() -> Bool {
    
        return true
    }
    
    
    func showDatePicker () {
        
        datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 0)
        let indexPathDateRow = IndexPath(row: 1, section: 0)
        
        dueDateLabel!.textColor = dueDateLabel!.tintColor
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()

        
        // set it a day ahead by default
        if dueDateIsEmpty() {
            let calander = Calendar.current
            let newDate = calander.date(byAdding: .day, value: 1, to: dueDate)
            
            if let date = newDate {
                datePicker.setDate(date, animated: true)
                dueDate = date
            }
        }
        
        datePicker.setDate(dueDate, animated: false)
        updateDueDateLabel()
    }
    
    func hideDatePicker () {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDatePicker = IndexPath(row: 2, section: 0)
            let indexPathDateRow = IndexPath(row: 1, section: 0)

            dueDateLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isTheDatePicker(indexPath: indexPath) {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isTheDatePicker(indexPath: indexPath) {
            return 217
        } else if isPhotoCell(indexPath: indexPath) {
            return 150
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        ifIsFirstResponderThenResign()
        
        if isTheDateLabelCell(indexPath: indexPath) {
            if datePickerVisible {
                hideDatePicker()
            } else {
                showDatePicker()
            }
        } else if isThePictureCell(indexPath: indexPath) {
            performSegue(withIdentifier: "Photo", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "Photo" {
            
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! PhotoViewController
            
            controller.delegate = self
            
            if let photoString = assignment?.photoUrlString {
                controller.photoString = photoString
            } else {
                // we need to save the assignment before going to the next page, so that the phot can be saved somewhere!
                saveAssignment()
            }
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if isTheDateLabelCell(indexPath: indexPath) {
            return indexPath
        } else if isThePictureCell(indexPath: indexPath) {
            return indexPath
        } else {
            return nil
        }
    }
    
    func isTheDateLabelCell(indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 1 {
            return true
        } else {
            return false
        }
    }
    
    func isTheDatePicker(indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 2 {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if isTheDatePicker(indexPath: indexPath) {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    //
    // end date picker stuff
    //
    
    
    //
    // photo stuff
    //
    func isThePictureCell (indexPath: IndexPath) -> Bool {
        let photoIndexPath = IndexPath(row:2, section: 2)
        
        return indexPath == photoIndexPath
    }
    
    func photoViewController(_ controller: PhotoViewController, didAddPhoto photoString: String) {
        assignment?.photoUrlString = photoString
        
        // prevent the titel from becoming first responder after adding a photo
        showKeyboardOnAppear = false

        loadNewlyAddedPhoto()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func loadNewlyAddedPhoto () {
        tableView.reloadData()
        showPhotoThumbnail()
    }
    
    
    func showPhotoThumbnail () {
        loadImage()
    }
    
    func isPhotoCell(indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 2 && indexPath.row == 2 {
            if let assignemnt = assignment {
                if assignemnt.photoUrlString.characters.count > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func loadImage () {
        
        if let photoString = assignment?.photoUrlString {
            let path = documentsDirectory().appendingPathComponent(photoString)
            if let data = try? Data (contentsOf: path) {
                let testImage = UIImage (data: data, scale: 1.0)
                pictureThumb.image = testImage
            }
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    
    
}
