import Foundation
import RxCocoa_Texture

class User: Decodable {
    var username: String = ""
    var profileURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case profileURL = "avatar_url"
    }
    
    func merge(_ user: User?) {
        guard let user = user else { return }
        self.username = user.username
        self.profileURL = user.profileURL
    }
}

extension User: ASRenderModelProtocol  {
    var renderModelIdentifier: ASRenderModelIdentifier {
        return .init(username, type: type(of: self))
    }
}
