//
//  KeychainDetailVC.swift
//  MOB2.1Classwork
//
//  Created by Samuel Folledo on 6/10/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit
import SnapKit

class KeychainDetailVC: UIViewController {
    
    var decryptedMessage: String?
    
    private lazy var encrytedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "Hidden message"
        label.numberOfLines = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constraintEncryptedLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let message = decryptedMessage {
            encrytedLabel.text = message
        } else {
            encrytedLabel.text = "No message has been saved"
        }
    }
    
    fileprivate func constraintEncryptedLabel() {
        view.addSubview(encrytedLabel)
        encrytedLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
    }
}
