//
//  RepositoryViewController.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

class RepositoryViewController: ASDKViewController<ASTableNode> {
    
    private var items: [RepositoryViewModel2] = []
    private var context = ASBatchContext()
    
    let disposeBag = DisposeBag()
    
    override init() {
        let tableNode = ASTableNode(style: .plain)
        tableNode.backgroundColor = .white
        tableNode.automaticallyManagesSubnodes = true
        super.init(node: tableNode)
        
        self.title = "Repository"
        
        // main thread
        self.node.onDidLoad({ node in
            guard let `node` = node as? ASTableNode else { return }
            node.view.separatorStyle = .singleLine
        })

        self.node.leadingScreensForBatching = 2.0
        self.node.dataSource = self
        self.node.delegate = self
        self.node.allowsSelectionDuringEditing = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMoreRepo(since: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadMoreRepo(since: Int?) {
        _ = RepoService.loadRepository(params: [.since(since)])
            .delay(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map { $0.map { RepositoryViewModel2(repository: $0) } }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] items in
                guard let `self` = self else { return }
                
                if since == nil {
                    self.items = items
                    self.node.reloadData()
                    self.context.completeBatchFetching(true)
                } else {
                    // appending is good at table performance
                    let updateIndexPaths = items.enumerated()
                        .map { offset, _ -> IndexPath in
                            return IndexPath(row: self.items.count - 1 + offset, section: 0)
                    }
                    
                    self.items.append(contentsOf: items)
                    self.node.insertRows(at: updateIndexPaths,
                                         with: .fade)
                    self.context.completeBatchFetching(true)
                }
            }, onError: { [weak self] error in
                guard let `self` = self else { return }
                self.context.completeBatchFetching(true)
        })
    }
}

extension RepositoryViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    /*
     Node Block Thread Safety Warning
     It is very important that node blocks be thread-safe.
     One aspect of that is ensuring that the data model is accessed outside of the node block.
     Therefore, it is unlikely that you should need to use the index inside of the block.
    */
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard self.items.count > indexPath.row else { return ASCellNode() }
            return RepositoryListCellNode(viewModel: self.items[indexPath.row])
        }
    }
    
//    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
//        guard self.items.count > indexPath.row else { return ASCellNode() }
//        return RepositoryListCellNode(viewModel: self.items[indexPath.row])
//    }
    
}

extension RepositoryViewController: ASTableDelegate {
    // block ASBatchContext active state
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return !self.context.isFetching()
    }
    
    // load more
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        self.context = context
        self.loadMoreRepo(since: self.items.last?.id)
    }
    
    // editable cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.node.performBatchUpdates({
                self.items.remove(at: indexPath.row)
                self.node.deleteRows(at: [indexPath], with: .fade)
            }, completion: nil)
        }
    }
}
