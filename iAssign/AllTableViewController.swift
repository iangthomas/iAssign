//
//  ViewController.swift
//  iAssign
//
//  Created by Ian Thomas on 10/10/16.
//  Copyright © 2016 KKIT Creations. All rights reserved.
//

import UIKit

class AllTableViewController: UITableViewController, AssignmentDetailTableViewControllerDelegate {
    
    var assignments: [Assignment]
    
    required init?(coder aDecoder: NSCoder){
        assignments = [Assignment]()
        super.init(coder: aDecoder)
        loadAssignments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection secion: Int) -> Int {
        return assignments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeACell(for: tableView)
        let theAssignment = assignments[indexPath.row]
        cell.textLabel!.text = theAssignment.name
        
        return cell
    }
   
    func makeACell (for tableView: UITableView) -> UITableViewCell {
        
        let cellIdentifier = "assignmentCell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let assignment = assignments[indexPath.row]
        performSegue(withIdentifier: "editAssignment", sender: assignment)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "editAssignment" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! AssignmentDetailTableViewController
            controller.delegate = self
            
         //   if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.assignment = sender as? Assignment
         //   }
            
            
            
        } else if segue.identifier == "addAssignment" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! AssignmentDetailTableViewController
            controller.delegate = self
        }
    }
    
    
    
    func assignmentDetailTableViewControllerDidCancel(_ controller: AssignmentDetailTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func assignmentDetailTableViewController(_ controller: AssignmentDetailTableViewController,
                                             didFinishAdding item: Assignment) {
        assignments.append(item)
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func assignmentDetailTableViewController(_ controller: AssignmentDetailTableViewController,
                                             didFinishEditing item: Assignment) {
        
        // when are we updatign teh data model
        if let index = assignments.index(of: item) {
            let indexPath = IndexPath (row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = item.name
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func loadAssignments () {
        let path = dataDirectory()
        if let data = try? Data (contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            assignments = unarchiver.decodeObject(forKey: "Assignments") as! [Assignment]
            unarchiver.finishDecoding()
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    func dataDirectory () -> URL {
        return documentsDirectory().appendingPathComponent("Assignments.plist")
    }
    
    

    
    func saveAssignments () {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(assignments, forKey: "Assignments")
        archiver.finishEncoding()
        data.write(to: dataDirectory(), atomically: true)
    }
    
    

}

