import Foundation
import RxSwift
import RxCocoa

extension Disposable {
    func insert(_ composite: CompositeDisposable) {
        composite.insert(self)
    }
}
