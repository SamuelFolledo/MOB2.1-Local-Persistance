//
//  ViewController.swift
//  Day7CoreData
//
//  Created by Samuel Folledo on 6/15/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var people: [NSManagedObject] = []
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        managedContext = appDelegate.persistentContainer.viewContext
        self.title = "Friends"
        tableView.dataSource = self
        tableView.delegate = self
        loadPeople()
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Friend", message: "Add the name of your friend", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add Now", style: .default) { [unowned self] action in
              guard let textField = alert.textFields?.first, let nameToSave = textField.text else { return }
            self.save(name: nameToSave)
              self.tableView.reloadData()
          }
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
          alert.addTextField()
          alert.addAction(saveAction)
          alert.addAction(cancelAction)
          present(alert, animated: true)
    }
    
    func save(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func loadPeople() {
        let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = people[indexPath.row]
            do {
                people.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                managedContext.delete(person)
                try managedContext.save()
            } catch {
                // handle the Core Data error
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
}
