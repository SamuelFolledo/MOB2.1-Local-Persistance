//
//  HomeViewController.swift
//  News
//
//  Created by Mustafa on 05/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UICollectionViewController, Cloud {
    
    lazy var fetchedResultController: NSFetchedResultsController<Category> = {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Category.order, ascending: true)
        ]
        request.predicate = NSPredicate(format: "posts.@count > 0")
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
    
    typealias HomeDataSource = UICollectionViewDiffableDataSource<Category, Post>
    var dataSource: HomeDataSource!
    
    init() {
        super.init(collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Posts"
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.setCollectionViewLayout(CollectionLayout.home.layout(with: traitCollection), animated: false)
        collectionView.register(PostCell.self)
        collectionView.register(CategoryHeaderCell.self)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(refresh),
            for: .valueChanged
        )
        collectionView.refreshControl = refreshControl
        
        setupDataSource()
        fetchCategories(nil, managedObjectContext: managedObjectContext)
        //        parseAndSaveJSON()
    }
    
    @objc func refresh() {
        fetchCategories(nil, managedObjectContext: managedObjectContext) {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.refreshControl?.endRefreshing()
                self?.updateDataSource(animatingDifferences: false)
            }
        }
    }
}

//MARK:-  Datasource

extension HomeViewController {
    
    func setupDataSource() {
        dataSource = HomeDataSource.init(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, post in
                let cell = collectionView.dequeueCell(PostCell.self, indexPath)
                cell.post = post
                return cell
        })
        
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            let supplementaryView = collectionView.dequeueCell(CategoryHeaderCell.self, indexPath)
            if let dataSource = (collectionView.dataSource as? HomeDataSource) {
                let category = dataSource.snapshot().sectionIdentifiers[indexPath.section]
                supplementaryView.category = category
                supplementaryView.delegate = self
            }
            return supplementaryView
        }
        updateDataSource()
    }
    
    func updateDataSource(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Category, Post>()
        let categories = fetchedResultController.fetchedObjects ?? []
        snapshot.appendSections(categories)
        categories.forEach {
            snapshot.appendItems($0.getRecentPosts(4), toSection: $0)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension HomeViewController {
    
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
            
            let likeAction = UIAction(
                title: post.isFavorite ? "Unfavorite" : "Favorite",
                image: UIImage(systemName: post.isFavorite ? "heart.slash.fill" : "heart.fill")!
            ) { [weak self] _ in
                post.isSynced = false
                post.isFavorite.toggle()
                
                self?.managedObjectContext.perform { [weak self] in
                    if let self = self {
                        self.syncFavorites(managedObjectContext: self.managedObjectContext)
                    }
                }
            }
            
            return UIMenu(title: "", image: nil, options: .displayInline, children: [likeAction])
        }
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.refreshControl?.endRefreshing()
            self?.updateDataSource(animatingDifferences: false)
        }
    }
}

extension HomeViewController: CategoryHeaderDelegate {
    
    func categoryHeaderViewAll(_ category: Category) {
        let controller = CategoryDetailViewController(category)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//extension HomeViewController {
//
//    func parseAndSaveJSON() {
//        guard let path = Bundle.main.path(forResource: "Data", ofType: "json"),
//            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
//                fatalError()
//        }
//        do {
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            let dump = try decoder.decode(DataDump.self, from: data)
//            dump.createCoreDataObject(managedObjectContext)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//}

