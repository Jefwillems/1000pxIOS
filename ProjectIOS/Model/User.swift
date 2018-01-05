class User: Codable {
    var username: String
    var email: String
    // List with id's of liked pictures
    var likes: [String] = []
    // List with uploaded pictures
    var pictures: [String] = []
    
    init(username: String, email: String) {
        self.email = email
        self.username = username
    }
}
