import Foundation
class Picture: Codable {
    var id: String
    var title: String
    var pathToPicture: String
    var description: String
    var datePublished: Date
    var likes: Int
    var flagged: Bool
    var location: [Int]
    var author: User
    var hasBeenLiked: Bool {
        return RestService.shared.user!.likes.filter {
            $0 == self.id
        }.count > 0
    }
    
    init(from url: String, title: String, id: String, author: User) {
        self.pathToPicture = url
        self.title = title
        self.author = author
        self.datePublished = Date()
        self.likes = 0
        self.flagged = false
        self.location = [0,0]
        self.id = id
        self.description = ""
    }
}
