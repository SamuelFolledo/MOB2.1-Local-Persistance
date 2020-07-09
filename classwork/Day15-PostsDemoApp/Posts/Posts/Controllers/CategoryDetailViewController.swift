//
//  CategoryDetailViewController.swift
//  News
//
//  Created by Mustafa Yusuf on 14/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
import CoreData

class CategoryDetailViewController: UICollectionViewController, Cloud {
    
    let category: Category
    
    typealias ListDataSource = UICollectionViewDiffableDataSource<Int, Post>
    var dataSource: ListDataSource!
    
    lazy var fetchedResultController: NSFetchedResultsController<Post> = {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Post.date, ascending: true)
        ]
        request.predicate = NSPredicate(format: "categories contains %@", category)
        
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
    
    init(_ category: Category) {
        self.category = category
        super.init(collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = category.title
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.setCollectionViewLayout(CollectionLayout.favorite.layout(with: traitCollection), animated: false)
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
        
        fetchAllPosts(for: category, managedObjectContext: managedObjectContext)
    }
    
    @objc func refresh() {
        fetchAllPosts(for: category, managedObjectContext: managedObjectContext) { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

//MARK:-  Datasource

extension CategoryDetailViewController {
    
    func setupDataSource() {
        dataSource = ListDataSource.init(
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

extension CategoryDetailViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = dataSource.itemIdentifier(for: indexPath) else { return }
        let controller = WebController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CategoryDetailViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { [weak self] in
            self?.updateDataSource(animatingDifferences: false)
        }
    }
}
