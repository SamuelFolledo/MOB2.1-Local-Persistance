//
//  Day4VC.swift
//  MOB2.1Classwork
//
//  Created by Macbook Pro 15 on 6/8/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit

class Day4VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        
    }
    
    func writeToFileSystem() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)

        if let documentDirectory: URL = urls.first {
            let documentURL = documentDirectory.appendingPathComponent("txtFile.txt")
            // data you want to write to file
            let data: Data? = "Hello World".data(using: .utf8)
            do{
              try data!.write(to: documentURL, options: .atomic) //either write if no error, or dont do it at all
            }catch{
                // some error
            }
        }
    }
    
    func accessFileInFileSystem() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentDirectory: URL = urls.first {
            let documentURL = documentDirectory.appendingPathComponent("txtFile.txt")
            do {
                print(documentURL)
                let content = try String(contentsOf: documentURL, encoding: .utf8)
                print(content)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
