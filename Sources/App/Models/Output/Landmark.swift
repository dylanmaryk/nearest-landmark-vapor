import Vapor

struct Landmark: Content {
    let position: Position
    let distance: Int
    let title: String
}
