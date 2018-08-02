import Foundation

class Repository: Decodable {
    var id: Int = -1
    var user: User?
    var repositoryName: String?
    var desc: String?
    var isPrivate: Bool = false
    var isForked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user = "owner"
        case repositoryName = "full_name"
        case desc = "description"
        case isPrivate = "private"
        case isForked = "fork"
    }
    
    func merge(_ repo: Repository?) {
        guard let repo = repo else { return }
        user?.merge(repo.user)
        repositoryName = repo.repositoryName
        desc = repo.desc
        isPrivate = repo.isPrivate
        isForked = repo.isForked
    }
}
