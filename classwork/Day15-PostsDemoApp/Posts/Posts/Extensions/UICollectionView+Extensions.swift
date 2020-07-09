//
//  UICollectionView+Extensions.swift
//  News
//
//  Created by Mustafa on 05/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit.UICollectionView

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(_: T.Type) where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: T.defaultReuseIdentifier, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(_: T.Type, _ indexPath: IndexPath) -> T where T: ReusableView {
        return dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueCell<T: UICollectionReusableView>(_: T.Type, _ indexPath: IndexPath) -> T where T: ReusableView {
        return dequeueReusableSupplementaryView(ofKind: T.defaultReuseIdentifier, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
}
