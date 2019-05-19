import Vapor

struct Media: Content {
    let images: Images
    let editorials: Editorials?
}
