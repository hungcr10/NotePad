//
//  NoteTableViewController.swift
//  NotePad
//
//  Created by Duc Pham on 3/31/20.
//  Copyright © 2020 Duc Pham. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
class NoteTableViewController: UITableViewController {
    var noteArray : Results<Note>?
  let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
loadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = noteArray?[indexPath.row].noteName ?? "nothing"
        cell.delegate = self
        return cell
    }
    
    //MARK: - Table View Delegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    //MARK: - Add Button
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "add new note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            let newNote = Note()
            newNote.noteName = textFiled.text!
            self.saveData(note: newNote)
        }
        alert.addTextField { (textFiledd) in
            textFiled = textFiledd
            textFiled.placeholder = "create Note"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Data Realm Methods
    func saveData(note : Note){
        do {
            try realm.write{
                realm.add(note)
            }
        }catch{
            print("Save Data With Error")
        }
        tableView.reloadData()
    }
    func loadData(){
        noteArray = realm.objects(Note.self)
        tableView.reloadData()
    }
}
extension NoteTableViewController : SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            guard let noteItem = self.noteArray?[indexPath.row] else {
                return
            }
            
            do {
                try self.realm.write{
                    self.realm.delete(noteItem)
                }
            }catch{
                print(error)
            }
    
    }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
       // options.transitionStyle = .border
        return options
    }
    
    
    
}
