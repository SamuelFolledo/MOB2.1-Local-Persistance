//
//  Day5VC.swift
//  MOB2.1Classwork
//
//  Created by Samuel Folledo on 6/10/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit
import KeychainAccess

class Day5VC: UIViewController {
    
    let keychain = Keychain(service: "Mobile2.1App")
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Keychain Access"
    }
    
    func save(key: String = "message", text: String) {
        keychain[key] = text
    }
    
    func reveal(key: String = "message") -> String? {
        return keychain[key]
    }
    
    func delete(key: String = "message") {
        do {
            try keychain.remove(key)
        } catch let error {
            print("error: \(error)")
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let text = textField.text, text != "" {
            save(text: text)
        } else {
            print("no text to save")
        }
    }
    
    @IBAction func revealTapped(_ sender: Any) {
        let vc = KeychainDetailVC()
        vc.decryptedMessage = reveal()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        delete()
    }
}
