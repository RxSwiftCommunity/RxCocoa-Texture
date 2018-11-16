//
//  RepositoryViewModel2.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RepositoryViewModel2 {
    
    // @INPUT
    let updateRepository = PublishRelay<Repository>()
    let updateUsername = PublishRelay<String?>()
    let updateDescription = PublishRelay<String?>()
    let updateProfileImage = PublishRelay<URL?>()
    
    // @OUTPUT
    var username = BehaviorRelay<String?>(value: nil)
    var profileURL = BehaviorRelay<URL?>(value: nil)
    var desc = BehaviorRelay<String?>(value: nil)
    var status = BehaviorRelay<String?>(value: nil)
    
    let id: Int
    let disposeBag = DisposeBag()
    
    deinit {
        RepoProvider.release(id: id)
    }
    
    init(repository: Repository) {
        self.id = repository.id
        
        RepoProvider.addAndUpdate(repository)
        
        let repoObserver = RepoProvider.observable(id: id)
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        repoObserver
            .map { $0?.user?.username }
            .bind(to: username)
            .disposed(by: disposeBag)
        
        repoObserver
            .map { $0?.user?.profileURL }
            .bind(to: profileURL)
            .disposed(by: disposeBag)
        
        repoObserver
            .map { $0?.desc }
            .bind(to: desc)
            .disposed(by: disposeBag)
        
        repoObserver
            .map { item -> String? in
                var statusArray: [String] = []
                if let isForked = item?.isForked, isForked {
                    statusArray.append("Forked")
                }
                
                if let isPrivate = item?.isPrivate, isPrivate {
                    statusArray.append("Private")
                }
                
                return statusArray.isEmpty ? nil: statusArray.joined(separator: " · ")
            }.bind(to: status)
            .disposed(by: disposeBag)
        
        self.updateRepository.subscribe(onNext: { newRepo in
            RepoProvider.update(newRepo)
        }).disposed(by: disposeBag)
        
        updateUsername.withLatestFrom(repoObserver) { ($0, $1) }
            .subscribe(onNext: { text, repo in
                guard let repo = repo else { return }
                repo.user?.username = text ?? ""
                RepoProvider.update(repo)
            }).disposed(by: disposeBag)
        
        updateDescription.withLatestFrom(repoObserver) { ($0, $1) }
            .subscribe(onNext: { text, repo in
                guard let repo = repo else { return }
                repo.desc = text
                RepoProvider.update(repo)
            }).disposed(by: disposeBag)
        
        updateProfileImage.withLatestFrom(repoObserver) { ($0, $1) }
            .subscribe(onNext: { url, repo in
                guard let repo = repo else { return }
                repo.user?.profileURL = url
                RepoProvider.update(repo)
            }).disposed(by: disposeBag)
        
    }
}
