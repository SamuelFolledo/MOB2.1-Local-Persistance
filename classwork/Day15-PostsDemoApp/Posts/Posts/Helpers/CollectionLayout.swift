//
//  CollectionLayout.swift
//  News
//
//  Created by Mustafa Yusuf on 14/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit

enum CollectionLayout {
    
    case home
    case favorite
    
    func layout(with traitCollection: UITraitCollection) -> UICollectionViewCompositionalLayout {
        switch self {
        case .home:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let fractionWidth: CGFloat = traitCollection.horizontalSizeClass == .regular ? 0.3 : 0.55
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(fractionWidth),
                heightDimension: .estimated(200)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.interItemSpacing = .fixed(16)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(40)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: CategoryHeaderCell.defaultReuseIdentifier,
                alignment: .topLeading
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = [sectionHeader]
            
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.interSectionSpacing = 16
            config.scrollDirection = .vertical
            
            let layout = UICollectionViewCompositionalLayout(
                section: section,
                configuration: config
            )
            return layout
        case .favorite:
            let columns: Int
                = traitCollection.horizontalSizeClass == .regular ? 4 : 2
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(300)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(200)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: columns
            )
            group.interItemSpacing = .fixed(16)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
            
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.interSectionSpacing = 16
            config.scrollDirection = .vertical
            
            let layout = UICollectionViewCompositionalLayout(
                section: section,
                configuration: config
            )
            return layout
        }
    }
}
