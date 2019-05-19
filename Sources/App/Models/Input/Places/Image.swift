import Vapor

struct Image: Content {
    let src: String
    let attribution: String
}
