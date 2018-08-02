import Foundation
import RxSwift
import RxCocoa

struct RepoProvider {
    private static let repoRelay = BehaviorRelay<[Int: (repo: Repository, count: Int, updatedAt: Date)]>(value: [:])
    private static let repoObservable = repoRelay
        .asObservable()
        .subscribeOn(SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: UUID().uuidString))
        .share(replay: 1, scope: .whileConnected)
    private static let queue = DispatchQueue(label: "RepoProvider.RxMVVMTexture.com", qos: .utility)
    
    static func addAndUpdate(_ repo: Repository) {
        queue.async {
            var repoValue = self.repoRelay.value
            if let record = repoValue[repo.id] {
                record.repo.merge(repo)
                repoValue[repo.id] = (repo: record.repo, count: record.count + 1, updatedAt: Date())
            } else {
                repoValue[repo.id] = (repo: repo, count: 1, updatedAt: Date())
            }
            self.repoRelay.accept(repoValue)
        }
    }
    
    
    static func update(_ repo: Repository) {
        queue.async {
            var repoValue = self.repoRelay.value
            if let record = repoValue[repo.id] {
                record.repo.merge(repo)
                repoValue[repo.id] = (repo: record.repo, count: record.count, updatedAt: Date())
            }
            self.repoRelay.accept(repoValue)
        }
    }
    
    static func retain(id: Int) {
        queue.async {
            var repoValue = self.repoRelay.value
            var record = repoValue[id]
            guard record != nil else { return }
            
            record?.count += 1
            repoValue[id] = record
            self.repoRelay.accept(repoValue)
        }
    }
    
    static func release(id: Int) {
        queue.async {
            var repoValue = self.repoRelay.value
            var record = repoValue[id]
            guard record != nil else { return }
            
            record?.count -= 1
            if record?.count ?? 0 < 1 {
                record = nil
            }
            repoValue[id] = record
            self.repoRelay.accept(repoValue)
        }
    }
    
    static func repo(id: Int) -> Repository? {
        var repo: Repository?
        queue.sync {
            repo = self.repoRelay.value[id]?.repo
        }
        return repo
    }
    
    static func observable(id: Int) -> Observable<Repository?> {
        return repoObservable
            .map { $0[id] }
            .distinctUntilChanged { $0?.updatedAt == $1?.updatedAt }
            .map { $0?.repo }
            .share(replay: 1, scope: .whileConnected)
    }
}
