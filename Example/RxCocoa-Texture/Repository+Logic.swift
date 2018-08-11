import Foundation
import RxSwift
import RxCocoa

struct RepositoryLogic {
    
    static var status: (Repository?) -> String? = {
        var statusArray: [String] = []
        if let isForked = $0?.isForked, isForked {
            statusArray.append("Forked")
        }
        
        if let isPrivate = $0?.isPrivate, isPrivate {
            statusArray.append("Private")
        }
        return statusArray.isEmpty ? nil: statusArray.joined(separator: " · ")
    }
    
    static var descUpdate: (Void, Repository?) -> (Repository?) = { _, repo in
        repo?.desc = "Description Updated"
        return repo
    }
}

