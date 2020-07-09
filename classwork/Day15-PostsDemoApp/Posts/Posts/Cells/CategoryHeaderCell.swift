//
//  HeaderView.swift
//  News
//
//  Created by Mustafa on 05/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit

protocol CategoryHeaderDelegate: class {
    func categoryHeaderViewAll(_ category: Category)
}

class CategoryHeaderCell: UICollectionViewCell, ReusableView {
    
    static var defaultReuseIdentifier: String = String(describing: CategoryHeaderCell.self)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View all", for: .normal)
        button.tintColor = .systemPink
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(viewAllButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, UIView(), button])
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        return stack
    }()
    
    weak var delegate: CategoryHeaderDelegate?
    
    var category: Category! {
        didSet {
            titleLabel.text = category.title
            button.isHidden = !(category.posts?.count ?? 0 > 4)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
//        addSubview(stackView)
        addSubview(titleLabel)
        addSubview(button)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
//            button.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
//            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    
    @objc func viewAllButtonTapped(_ sender: Any) {
        delegate?.categoryHeaderViewAll(category)
    }
}
