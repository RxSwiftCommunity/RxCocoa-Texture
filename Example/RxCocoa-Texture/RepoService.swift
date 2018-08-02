import Foundation
import RxSwift
import RxCocoa

class RepoService {
    enum Route {
        case basePath
        
        var path: String {
            let base = "https://api.github.com/repositories"
            
            switch self {
            case .basePath: return base
            }
        }
        
        enum Params {
            case since(Int?)
            
            var key: String {
                switch self {
                case .since: return "since"
                }
            }
            
            var value: Any? {
                switch self {
                case .since(let value): return value
                }
            }
        }
        
        static func parameters(_ params: [Params]?) -> [String: Any]? {
            guard let `params` = params else { return nil }
            var result: [String: Any] = [:]
            
            for param in params {
                result[param.key] = param.value
            }
            
            return result.isEmpty ? nil: result
        }
    }
}

extension RepoService {
    static func loadRepository(params: [RepoService.Route.Params]?) -> Single<[Repository]> {
        return Network.shared.get(url: Route.basePath.path,
                                  params: Route.parameters(params))
            .generateArrayModel()
    }
}
