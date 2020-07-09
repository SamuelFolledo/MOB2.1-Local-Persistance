//
//  ArticleCell.swift
//  News
//
//  Created by Mustafa on 05/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell, ReusableView {

    static var defaultReuseIdentifier: String = String(describing: PostCell.self)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemPink
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        return stack
    }()

    var post: Post! {
        didSet {
            titleLabel.text = post.title
            titleLabel.isHidden = post.title == nil
            dateLabel.text = post.date?.readable()
            dateLabel.isHidden = post.date == nil
            imageView.image = post.thumbnail
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
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = .tertiarySystemBackground
        addSubview(imageView)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),

            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
}

extension Date {
    
    func readable(_ dateStyle: DateFormatter.Style = .short, _ timeStyle: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: self)
    }
}
