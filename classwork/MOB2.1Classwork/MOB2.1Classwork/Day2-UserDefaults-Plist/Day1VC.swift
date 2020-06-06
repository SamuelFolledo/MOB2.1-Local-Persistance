//
//  Day1VC.swift
//  MOB2.1Classwork
//
//  Created by Macbook Pro 15 on 6/3/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit

class Day1VC: UIViewController {
    
    var plistScoreDic: [[String: String]] = [[:]]
    
    @IBOutlet weak var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        setupTableView()
        readPlist()
//        writeToPlist()
        day2()
    }
    
    fileprivate func day2() {
        Defaults.preferredLanguage = "EN"
        print(Defaults.preferredLanguage ?? "")
        Defaults.preferredLanguage = nil
        print(Defaults.preferredLanguage ?? "")
        
        //NSCoding Encoding
        let person = NSCodingPerson(name: "Kobe", favoriteColor: .yellow)
        if let personData = try? JSONEncoder().encode(person) {
            UserDefaults.standard.set(personData, forKey: "person")
        }
        
        //NSCoding Decoding
        if let savedPersonData = UserDefaults.standard.object(forKey: "person") as? Data {
            if let loadedPerson = try? JSONDecoder().decode(NSCodingPerson.self, from: savedPersonData) {
                print(loadedPerson.name)
                print(loadedPerson.favoriteColor)
            }
        }
    }
    
    fileprivate func readPlist() {
        plistScoreDic.removeAll()
        let plist = Plist(name: "Custom")
        let plistResult = plist?.getMutablePlistFile()
        plistScoreDic = plistResult!["Scores"] as! [[String: String]]
        table.reloadData()
    }
    
    fileprivate func writeToPlist() {
        plistScoreDic.append(["Name": "Kobe", "Score": "24"])
        let plist = Plist(name: "Custom")
        do  {
            try plist?.addValuesToPlistFile(dictionary: ["Scores": plistScoreDic])
        } catch { print(error) }
        //after adding the values, read again
        readPlist()
    }
    
    fileprivate func setupTableView(){
        table.delegate = self
        table.dataSource = self
    }

}

//MARK: Extensions
extension Day1VC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Highest Scores 🚀"
    }
}

extension Day1VC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plistScoreDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = plistScoreDic[indexPath.row]
        let title = "\(row["Score"]!) \(row["Name"]!)"
        cell.textLabel?.text = title
        return cell
    }
}
