import Foundation
import RxSwift
import RxCocoa

public struct ASModelSyncronizer {
    public typealias Model = ASRenderModelProtocol
    static private let _syncronizerLock = NSLock()
    static private let syncronizer = PublishRelay<Model?>()
    
    static public func observable<T: Model>(type: T.Type, id: ASRenderModelIdentifier?) -> Observable<T> {
        return syncronizer
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
            .filter { $0 != nil }
            .filter { $0!.renderModelIdentifier == id }
            .map { $0! as? T }
            .filter { $0 != nil }
            .map { $0! }
            .share(replay: 1, scope: .whileConnected)
    }
    
    static public func observable<T: Model>(type: T.Type, model: Model?) -> Observable<T> {
        return self.observable(type: type,
                               id: model?.renderModelIdentifier)
    }
    
    static public func update(_ model: Model?) {
        _syncronizerLock.lock()
        syncronizer.accept(model)
        _syncronizerLock.unlock()
    }
}
