//
//  FavoritesController.swift
//  News
//
//  Created by Mustafa on 05/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
import CoreData

class FavoritesController: UICollectionViewController, Cloud {
    
    lazy var fetchedResultController: NSFetchedResultsController<Post> = {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Post.date, ascending: true)
        ]
        request.predicate = NSPredicate(format: "%K == true", "isFavorite")
        
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
    typealias FavoriteDataSource = UICollectionViewDiffableDataSource<Int, Post>
    var dataSource: FavoriteDataSource!
    
    init() {
        super.init(collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.setCollectionViewLayout(CollectionLayout.favorite.layout(with: traitCollection), animated: false)
        collectionView.register(PostCell.self)
        collectionView.register(CategoryHeaderCell.self)
        setupDataSource()
    }
}

//MARK:-  Datasource

extension FavoritesController {
    
    func setupDataSource() {
        dataSource = FavoriteDataSource.init(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, post in
                let cell = collectionView.dequeueCell(PostCell.self, indexPath)
                cell.post = post
                return cell
        })
        updateDataSource()
    }
    
    func updateDataSource(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
        let posts = fetchedResultController.fetchedObjects ?? []
        snapshot.appendSections([0])
        snapshot.appendItems(posts, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension FavoritesController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = dataSource.itemIdentifier(for: indexPath) else { return }
        let controller = WebController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let post = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let unlikeAction = UIAction(title: "Unfavorite", image: UIImage(systemName: "heart.slash.fill")!) { [weak self] _ in
                post.isSynced = false
                post.isFavorite = false
                
                self?.managedObjectContext.perform { [weak self] in
                    if let self = self {
                        self.syncFavorites(managedObjectContext: self.managedObjectContext)
                    }
                }
            }
            
            return UIMenu(title: "", image: nil, options: .displayInline, children: [unlikeAction])
        }
    }
}

extension FavoritesController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { [weak self] in
            self?.updateDataSource(animatingDifferences: true)
        }
    }
}
