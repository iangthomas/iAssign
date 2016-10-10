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


class AssignmentDetailTableViewController: UITableViewController, UITextFieldDelegate {

    var assignment: Assignment?
    weak var delegate: AssignmentDetailTableViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBOutlet weak var examSwitch: UISwitch!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let item = assignment {
            title = "Edit Assignment"
            doneButton.isEnabled = false
            titleTextField.text = item.name
            notesTextField.text = item.note
            doneSwitch.isOn = item.done
            examSwitch.isOn = item.exam
            
        } else {
            title = "Add Assignment"
            doneButton.isEnabled = false
            examSwitch.isOn = false
            doneSwitch.isOn = false
            titleTextField.becomeFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        
        //editing
        if let item = assignment {
            item.name = titleTextField.text!
            item.note = notesTextField.text!
            item.done = doneSwitch.isOn
            item.exam = examSwitch.isOn
            
            
            delegate?.assignmentDetailTableViewController(self, didFinishEditing: item)
        } else {
            let newItem = Assignment()
            newItem.name = titleTextField.text!
            newItem.note = notesTextField.text!
            newItem.done = doneSwitch.isOn
            newItem.exam = examSwitch.isOn
            
            delegate?.assignmentDetailTableViewController(self, didFinishAdding: newItem)
        }
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        delegate?.assignmentDetailTableViewControllerDidCancel(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneButton.isEnabled = newText.length > 0
        
        return true
    }
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
