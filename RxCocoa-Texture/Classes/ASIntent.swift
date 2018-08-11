import Foundation
import RxSwift
import RxCocoa
import AsyncDisplayKit

extension ObservableType {
    func render<O, R: Equatable>(to observer: O,
                                 model: Self.E?,
                                 mutation: @escaping (Self.E) throws -> R,
                                 setNeedsLayout node: ASDisplayNode? = nil)
        -> Disposable where O: ASObserverType, R == O.E {
            if let `model` = model, let ret = try? mutation(model) {
                observer.directlyBinding(ret)
            }
            return self.map(mutation)
                .distinctUntilChanged()
                .bind(to: observer, setNeedsLayout: node)
    }
    
}

public struct ASIntent<Model: ASRenderModelProtocol> {
    public let renderRelay: BehaviorRelay<Model?>
    
    enum SusbscribeScoope {
        case model(Model?)
        case id(ASRenderModelIdentifier)
    }
    
    public init(_ id: ASRenderModelIdentifier, by disposeBag: DisposeBag) {
        self.init(scope: .id(id), by: disposeBag)
    }
    
    public init(_ model: Model?, by disposeBag: DisposeBag) {
        self.init(scope: .model(model), by: disposeBag)
    }
    
    internal init(scope: SusbscribeScoope, by disposeBag: DisposeBag) {
        switch scope {
        case .id(let id):
            self.renderRelay = .init(value: nil)
            ASModelSyncronizer
                .observable(type: Model.self, id: id)
                .bind(to: renderRelay)
                .disposed(by: disposeBag)
        case .model(let model):
            ASModelSyncronizer.update(model)
            self.renderRelay = .init(value: model)
            ASModelSyncronizer
                .observable(type: Model.self, model: model)
                .bind(to: renderRelay)
                .disposed(by: disposeBag)
        }
    }
    
    public func update<O, R: Equatable>(to observer: O,
                                        mutation: @escaping (Model?) throws -> R,
                                        setNeedsLayout node: ASDisplayNode? = nil)
        -> Disposable where O: ASObserverType, R == O.E {
            return self.renderRelay.skip(1) // renderRelay doesn't need emit event at first subscribe
                .render(to: observer,
                        model: renderRelay.value,
                        mutation: mutation,
                        setNeedsLayout: node)
    }
    
    public func loadModel() -> Observable<Model?> {
        return renderRelay.asObservable()
    }
    
    public func interact<E>(from event: Observable<E>,
                            mutation: @escaping (E, Model?) -> Model?) -> Disposable {
        return event.withLatestFrom(loadModel()) { ($0, $1) }
            .map { mutation($0.0, $0.1) }
            .subscribe(onNext: { model in
                // update mutation applied mutating model
                ASModelSyncronizer.update(model)
            })
    }
}
