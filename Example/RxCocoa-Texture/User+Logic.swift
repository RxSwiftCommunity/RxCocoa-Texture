import Foundation
import RxSwift
import RxCocoa

struct UserLogic {

    static var downloadImage: (Observable<Void>) -> Observable<URL?> = {
        return $0.flatMap({ ImageDownloader.download() })
    }
    
    static var updateUserProfile: (URL?, User?) -> (User?) = { url, user -> User? in
        user?.profileURL = url
        return user
    }
}

