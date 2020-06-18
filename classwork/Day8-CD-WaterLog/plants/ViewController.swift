//
//  ViewController.swift
//  plants
//
//  Created by Adriana González Martínez on 4/21/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var dates: [Date] = []
    var managedContext: NSManagedObjectContext!
    var mainPlant : Plant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Water log"
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //we will look for Cactus for this example. We'll go over how to query in future lessons.

        let plantSpecies = "Cactus"
        let plantSearch: NSFetchRequest<Plant> = Plant.fetchRequest()
        plantSearch.predicate = NSPredicate(format: "%K == %@", #keyPath(Plant.species), plantSpecies)

        do {
          let results = try managedContext.fetch(plantSearch)
          if results.count > 0 {
            // cactus found
            mainPlant = results.first
          } else {
            // not found, create cactus
            mainPlant = Plant(context: managedContext)
            mainPlant?.species = plantSpecies
            try managedContext.save()
          }
        } catch let error as NSError {
          print("Error: \(error) description: \(error.userInfo)")
        }
        
    }

    @IBAction func addLog(_ sender: Any) {
        //new water date entity
        let waterDate = WaterDate(context: managedContext)
        waterDate.date = NSDate() as Date
        
        //add it to the Plant's dates set
        
        if let plant = mainPlant, let dates = plant.waterDates?.mutableCopy() as? NSMutableOrderedSet {
            dates.add(waterDate)
            plant.waterDates = dates
        }
        
        //save the managed object context
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error: \(error), description: \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPlant!.waterDates!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let waterDate = mainPlant!.waterDates![indexPath.row] as? WaterDate else { return UITableViewCell() }
        guard let date = waterDate.date else { return UITableViewCell() }
        cell.textLabel?.text = dateFormatter.string(from: date)
        return cell
    }
}

